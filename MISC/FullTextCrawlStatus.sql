SELECT * FROM sys.fulltext_catalogs

SELECT database_id, FULLTEXTCATALOGPROPERTY('your_catalog_name', 'PopulateStatus') AS CrawlStatus
FROM sys.databases
WHERE is_fulltext_enabled = 1;