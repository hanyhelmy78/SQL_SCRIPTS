DECLARE @max_age int
SET @max_age = 900
SELECT name Login_Name,
is_policy_checked,
--is_expiration_checked,
LOGINPROPERTY(name, 'IsExpired') AS is_expired,
LOGINPROPERTY(name, 'IsLocked') AS is_locked,
--LOGINPROPERTY(name, 'IsMustChange') AS is_mustchange,
--LOGINPROPERTY(name, 'HistoryLength') AS history_length,
--LOGINPROPERTY(name, 'BadPasswordCount') AS bad_password_count,
DATEDIFF(day, GETDATE(), DATEADD(day, @max_age,
CAST(LOGINPROPERTY(name, 'PasswordLastSetTime')
AS datetime))) AS days_until_expiration,
LOGINPROPERTY(name, 'PasswordLastSetTime') AS
password_last_set_time
--LOGINPROPERTY(name, 'BadPasswordTime') AS bad_password_time,
--LOGINPROPERTY(name, 'LockoutTime') AS lockout_time
FROM sys.sql_logins
WHERE name NOT LIKE '##%'