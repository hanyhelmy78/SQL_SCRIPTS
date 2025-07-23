If you remove an old certificate but it still appears in the registry key, SQL Server will try to start with that certificate.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/WrongTLSCertificateThumbprint.png)

### To solve this issue:

1. Remove the old `Thumbprint` value from the registry.
2. Startup SQL Server normally.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/WrongTLSCertificateThumbprint_01.png)



