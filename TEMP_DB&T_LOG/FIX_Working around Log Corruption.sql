/*
1.	Stop all user activity in the database
2.	Switch to the SIMPLE recovery model (breaking the log backup chain) --> THEN SHRINK THE LOG FILE*
3.	Perform a manual checkpoint of the database (which should remove the requirement that the damaged portion of log must be backed up)
4.	Switch back to the FULL recovery model
5.	Take a full database backup (thus starting a new log backup chain)
6.	Start taking log backups
*/