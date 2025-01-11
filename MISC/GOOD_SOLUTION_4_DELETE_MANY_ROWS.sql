USE <DB_NAME>
GO
DECLARE @done bit = 0;
WHILE (@done = 0)
BEGIN
    DELETE TOP(1000) -- ROWS 2 DELETE
    FROM LogMessages -- <TABLE_NAME>
    WHERE LogDate < '20020102';
    IF @@ROWCOUNT < 1000 SET @done = 1;
END;