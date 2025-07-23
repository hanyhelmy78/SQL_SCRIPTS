In SQL Server, the **Model** database is a system database that serves as the template for all new databases created on the instance. Here are some of its key uses and characteristics:

1. **Template for New Databases**: When you create a new database in SQL Server, the new database is essentially a copy of the Model database. This means that any objects (such as tables, views, stored procedures) or settings (like collation, recovery model) present in the Model database will be copied to the new database.

2. **Default Size and Configuration**: The size and configuration of the Model database determine the default size and configuration of all new databases. For example, if you set a specific initial size for the Model database, all new databases will inherit this initial size.

3. **Database Options**: Any database options set in the Model database, such as auto-growth settings, will be applied to all new databases. This allows for consistent configuration of new databases across your SQL Server instance.

4. **Custom Objects**: You can customize the Model database by adding objects like tables, views, stored procedures, etc. These objects will automatically be included in all new databases created on the instance.

5. **Backup and Recovery Settings**: The recovery model and backup settings of the Model database will be inherited by new databases. For example, if the Model database is set to use the Full recovery model, new databases will also use the Full recovery model by default.

Here's an example of creating a new database, which will use the Model database as its template:
```sql
CREATE DATABASE MyNewDatabase;
```
