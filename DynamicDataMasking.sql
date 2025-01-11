/* https://learn.microsoft.com/en-us/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver16
Query for masked columns
*/
SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function
FROM sys.masked_columns AS c
JOIN sys.tables AS tbl
    ON c.[object_id] = tbl.[object_id]
WHERE is_masked = 1;
--***********************************************************************************
-- table with masked columns
CREATE TABLE Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL);
--***********************************************************************************
-- Add or Drop a mask on an existing column
ALTER TABLE Membership
ALTER COLUMN LastName VARCHAR(100) MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Membership
ALTER COLUMN LastName DROP MASKED;
--***********************************************************************************
--Grant permissions to view unmasked data
GRANT UNMASK TO MaskingTestUser;

EXECUTE AS USER = 'MaskingTestUser';
REVERT;
  
-- Removing the UNMASK permission
REVOKE UNMASK TO MaskingTestUser;