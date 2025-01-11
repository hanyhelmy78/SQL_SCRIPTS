alter database AdventureWorks2008R2 set enable_broker

create queue DeadlockNotificationQueue;

create service DeadlockNotificationService
on queue DeadlockNotificationQueue;
go

create route DeadlockNotificationRoute
with service_name = 'DeadlockNotificationService',
address = 'Local';

create event notification DeadlockNotification
on server
with fan_in
for deadlock_graph
to service 'DeadlockNotificationService', 'Current database'
go