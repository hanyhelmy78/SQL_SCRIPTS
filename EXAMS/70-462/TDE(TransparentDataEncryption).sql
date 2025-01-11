use master;
go
-- 1st step on master db to create the master key
create master key encryption by password = 'MasterKeyPassword'; 
-- second step to create the certificate in the master database only
create certificate ServerCertificate with subject = 'Server Certificate';
use Dental4U;
go
-- then third step on the required db to create database encryption key (DEK)
create database encryption key 
with algorithm = AES_128
encryption by server certificate ServerCertificate;
use master 
go
-- fourth step to backup the certificate and the private key
backup certificate ServerCertificate to file = 'D:\hany\learning\MCSA\Queries\70-462' 
with private key (file = 'D:\hany\learning\MCSA\Queries\70-462', encryption by password = 'P@SSw0rd'); 
-- and finally to alter the database for encryption
alter database Test set encryption on;