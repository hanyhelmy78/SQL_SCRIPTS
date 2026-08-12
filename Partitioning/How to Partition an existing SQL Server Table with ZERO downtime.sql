/* How to Partition an existing SQL Server Table: https://www.db-berater.de/2026/08/partition-a-big-table-with-zero-downtime/
The original source table did NOT have a clustered index that include the requested partition column!

1- A partition function and partition scheme must be created so the new table can distribute data across the defined boundaries.
2- Create a new table: [demo].[orders]
3- Rename the original table [dbo].[orders] to [dbo].[orders_source]
4- Create a view named [dbo].[orders] to allow the application to access the object
5- The view includes both [demo].[orders] and [dbo].[orders_source] so the application can continue reading from a unified structure while data is being moved.
6- Create a trigger on the [dbo].[orders] view for IUD (Insert, Update, Delete) operations
7- Create a stored procedure to delete data from [dbo].[orders_source] based on a specified time range
8- PowerShell script for the parallel execution of the stored procedure using different time ranges
*/

/*
    Let's create the partition function on a yearly interval
*/
CREATE PARTITION FUNCTION pf_o_orderdate (DATE)
AS RANGE RIGHT FOR VALUES
(
    '2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020',
    '2021', '2022', '2023', '2024', '2025'
);
GO
 
CREATE PARTITION SCHEME ps_o_orderdate
AS PARTITION pf_o_orderdate
ALL TO ([PRIMARY]);
GO

/* Creation of the new partitioned table [demo].[orders] */
CREATE TABLE demo.orders
(
    o_orderdate     DATE    NOT NULL,
    o_orderkey      BIGINT  NOT NULL,
    o_custkey       BIGINT  NOT NULL,
    o_orderpriority CHAR(15)    NULL,
    o_shippriority  INT         NULL,
    o_clerk         CHAR(15)    NULL,
    o_orderstatus   CHAR(1)     NULL,
    o_totalprice    MONEY       NULL,
    o_comment       VARCHAR(79) NULL,
    o_storekey      BIGINT      NOT NULL,
 
    CONSTRAINT PK_demo_orders PRIMARY KEY CLUSTERED
    (
        o_orderdate,
        o_orderkey
    )
    WITH
    (
        DATA_COMPRESSION = PAGE
    )
)
ON ps_o_orderdate (o_orderdate);
GO
 
/* Prevent Lock Escalation on Table Level but only HOBt-Level */
ALTER TABLE demo.orders SET (LOCK_ESCALATION = AUTO);
GO

/* a brief downtime of approximately 2 minutes is required, but you might need to disable the app login and stop app itself from connecting to the database!*/
BEGIN TRANSACTION
    /* rename the original table */
    EXEC sp_rename @objname = N'dbo.orders', @newname = N'orders_source', @objtype = N'OBJECT';
    GO
 
/* create a view with the name of the original table which covers the data from both tables */
    CREATE OR ALTER VIEW dbo.orders
    AS
        SELECT  *
        FROM    dbo.orders_source
 
        UNION ALL
 
        SELECT  *
        FROM    demo.orders;
    GO
COMMIT TRANSACTION
GO

/* INSTEAD_OF-Trigger for [dbo].[orders] (VIEW) */
CREATE OR ALTER TRIGGER trg_orders_ins_upd_del
ON dbo.orders
INSTEAD OF
    INSERT,
    UPDATE,
    DELETE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
 
    /*
        An INSERT does not have rows in deleted
        An UPDATE does have rows in inserted and deleted
        An DELETE does have rows in inserted
    */
 
    /* Covering INSERT */
    IF NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        /* Write new data into the partitioned table */
        INSERT INTO demo.orders
        SELECT * FROM inserted;
    END
 
    /* Covering DELETE */
    IF NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        /* Delete data from old and new table */
        DELETE  os
        FROM    dbo.orders_source AS os
                INNER JOIN deleted AS d
                ON (os.o_orderkey = d.o_orderkey)
 
        DELETE  os
        FROM    demo.orders AS os
                INNER JOIN deleted AS d
                ON (os.o_orderkey = d.o_orderkey)
    END
 
    /* Otherwise it must be an UPDATE */
    BEGIN
        WITH s
        AS
        (
            SELECT * FROM Inserted
            EXCEPT
            SELECT * FROM Deleted
        )
        MERGE dbo.orders_source WITH (HOLDLOCK) AS os
        USING s ON (os.o_orderkey = s.o_orderkey)
        WHEN MATCHED THEN
            UPDATE
            SET os.o_orderdate = s.o_orderdate,
                os.o_custkey = s.o_custkey,
                os.o_orderpriority = s.o_orderpriority;
                /* and all other columns */
 
        /* Same with new table but shortend for this blog post! */
END
GO

/* Stored Procedure [dbo].[move_data] to transfer the data*/
CREATE OR ALTER PROC dbo.move_data
    @start_date     DATE,
    @finish_date    DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
 
    DECLARE @rc INT = 1;
 
    WHILE @rc > 0
    BEGIN
        DELETE  TOP (3000)
                dbo.orders_source
 
        OUTPUT  deleted.*
        INTO    demo.orders
 
        WHERE   o_orderdate >= @start_date
                AND o_orderdate <= @finish_date;
 
        SET @rc = @@ROWCOUNT;
    END
END
GO

/* Final steps */
/* Drop the existing view [dbo].[orders] */
DROP VIEW IF EXISTS dbo.orders;
 
/* Move [demo].[orders] into the schema [dbo] */
ALTER SCHEMA dbo TRANSFER demo.orders;
 
/* Drop the EMPTY source table [dbo].[orders_source] */
DROP TABLE IF EXISTS dbo.orders_source;
