/*******When My SQL login Password last reset********/
SELECT LOGINPROPERTY('SQL user', 'PasswordLastSetTime');
SELECT LOGINPROPERTY('sa', 'PasswordLastSetTime');
--Note: This will only return detail for SQL user not windows user