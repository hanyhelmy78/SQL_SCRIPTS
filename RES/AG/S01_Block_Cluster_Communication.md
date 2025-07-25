/* 
When communication between the cluster nodes was suddenly interrupted, first, you need to check port 3343, which all nodes in the cluster use to communicate with each other. Please follow the steps below on all cluster nodes.

Open Powershell session as Admin and run below commands in order:

Get-Service -name ClusSvc

Status   Name               DisplayName                           
------   ----               -----------                           
Start... ClusSvc            Cluster Service                       
# service is down!

netstat -ano | findstr "3343"

  TCP    0.0.0.0:3343           0.0.0.0:0              LISTENING       8776

tasklist /v /fi "pid eq 8776"

Image Name                     PID Session Name        Session#    Mem Usage Status          User Name                                            
  CPU Time Window Title                                                            
========================= ======== ================ =========== ============ =============== =====================
wsmprovhost.exe               8776 Services                   0     78,240 K Unknown         TEST\ad_Administrator                                
   0:00:00 N/A                                                                     
# this process should not be listening to the cluster port! kill it!

taskkill /pid 8776 /F

SUCCESS: The process with PID 8776 has been terminated.

# Confirm no process is listening on cluster port 3343!
netstat -ano | findstr "3343"

# Then start the cluster service:
Start-Service -Name ClusSvc

# Confirm!
Get-Service -name ClusSvc

Status   Name               DisplayName                           
------   ----               -----------                           
Running  ClusSvc            Cluster Service

# Repeate above steps in all other nodes in the cluster to bring the service up!
*/
