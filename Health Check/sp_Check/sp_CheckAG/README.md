# sp_CheckAG
Hello, and welcome to the GitHub repository for sp_CheckAG! This is a free tool from [Straight Path Solutions](https://straightpathsql.com/) for SQL Server Database Administrators (or people who play DBA at their organization) to check their SQL Server high availability. It is used to display current information about an availability group and detect vulnerabilities and potential issues with maintaining the availability and performance of SQL Server databases.

# Why would you use sp_CheckAG?

Here at Straight Path Solutions, we're big fans of community tools like [sp_WhoIsActive](https://github.com/amachanic/sp_whoisactive/releases), [Brent Ozar's First Responder's Kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/releases), and [Erik Darling's suite of helpful stored procedures](https://github.com/erikdarlingdata/DarlingData). As database administrators who are constantly looking at new clients and new servers, we wished there was a tool to quickly give an overview of any potential availability group issues. We didn't find one, so we made one.

# What does sp_CheckAG do?

This tool will allow you to review your SQL Server availability groups and their databases quickly and easily, and to also identify potential issues with these availability groups like misconfigured settings, high latency, and more.<p>

This tool has several modes that present different sets of data, depending on what you want to examine.<p>

**@Mode = 0:** the potential issues we could find related to your availability groups.<br>
**@Mode = 1:** an overview, including result sets for the instance. the cluster, cluster members, endpoints, availability groups, listeners, replicas, and databases.<br>
**@Mode = 2:** result set showing recent events in the availability group.<p>

Using each of these Modes, you should be able to quickly identify issues with your availability groups and focus on facts about them to help you resolve any issue.<p>

# How do I use it?
 
Execute the script to create sp_CheckAG in the database of your choice, although we would recommend the master so you can call it from the context of any database.<p>

Executing it without using parameters will return two results sets:<br>
• The results of Mode 1, ordered by name corresponding to the result set<br>
• The results of Mode 0, ordered by Importance<p>

Although you can simply execute it as is, there are currently five parameters.<p>

**@Help** – the default is 0, but setting this to 1 will return some helpful information about sp_CheckAG and its usage in case you aren’t able to read this web page.<p>

**@Mode** – see the previous few paragraphs to decide which Mode you want to use.<p>

**@AGName** – for reducing results to focus on a particular availability group.<p>

**@LocalOnly** – for reducing results to focus only on the local replicas and databases.<p>

**@VersionCheck** – to check the version number and version date of this tool.<p>

# What do the Importance Levels in Mode 0 mean?

**1 - High**. This is stuff that prevents availability, including offline items.<p>

**2 - Medium**. This is the stuff that can complicate availability that we recommend you review.<p>

**3 – Low**. This is the stuff you may have enabled that you may or may not need.<p>

# What are the requirements to use sp_CheckAG?

There are two requirements.<p>

**1. You need to be in the sysadmin role**. This tool is designed to be used by administrators only, as they are the only ones who can address many of the vulnerabilities and discrepancies that could be found. If you aren't in the sysadmin role, this isn't the stored procedure you're looking for.<p>

**2. Your SQL Server instance needs to be using SQL Server 2016 or higher**. If you are using an earlier version, execution of the stored procedure will be aborted because some of the DMVs used don't exist in earlier versions.
<p></p>

