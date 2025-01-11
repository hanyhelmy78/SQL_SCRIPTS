// Here is the entire program.  A plain text file that compiles into a single exe executable.
// 2 labels, 6 buttons, a Combobox, and a gridview.
// Note: Put your server names (instance name too if named) in the ComboBox area ...the AAA area

    using System;  
    using System.Drawing; 
    using System.Windows.Forms;

    using System.Data;
    using System.Data.SqlClient;

    class MyForm : System.Windows.Forms.Form  
    {  
        Label label1;  
        Label label2;  
        //TextBox txtbx1;
        ComboBox comboBoxServ1;  
        Button btn1;  Button btn2;  Button btn3; Button btn4; Button btn5;  
        Button exit;  

        DataGridView dataGridView1 = new DataGridView();
        BindingSource bindingSource1 = new BindingSource();
        SqlDataAdapter dataAdapter = new SqlDataAdapter();

        public MyForm()  
        {           
            label1 = new Label();  
            label2 = new Label();  
           // txtbx1 = new TextBox();  
            comboBoxServ1 = new ComboBox();
            btn1 = new Button();  btn2 = new Button();  btn3 = new Button();  btn4 = new Button();  btn5 = new Button();  
            exit = new Button(); 
 
            label1.UseMnemonic = true;  
            label1.Text = "Enter Server:";  
            label1.Location = new Point(20, 15); 
            label1.BackColor = System.Drawing.Color.Transparent; 
            //label1.BackColor = Color.LightGray;  
            label1.ForeColor = Color.Maroon;  
            label1.Size = new Size(70, 15);  
 
            comboBoxServ1.Text = "";  
            comboBoxServ1.Location = new Point(100, 15);  
            comboBoxServ1.BackColor = Color.LightGray;  
            comboBoxServ1.ForeColor = Color.Maroon;  
            comboBoxServ1.Size = new Size(280, 20); 
///AAA
            comboBoxServ1.Items.Add("RUH1SFADB"); 
            comboBoxServ1.Items.Add("RUH1ABCDB"); 
            comboBoxServ1.Items.Add("RUH1SFASTG"); 

            btn1.Text = "DB Info";  
            btn1.Location = new Point(20 , 50);  
            btn1.Size = new Size(70, 20);  

            btn2.Text = "Processes";  
            btn2.Location = new Point(110 , 50);  
            btn2.Size = new Size(70, 20);  

            btn3.Text = "Sp_Who";  
            btn3.Location = new Point(200 , 50);  
            btn3.Size = new Size(70, 20);  
 
            btn4.Text = "Job History";  
            btn4.Location = new Point(290 , 50);  
            btn4.Size = new Size(70, 20);  

            btn5.Text = "Waits";  
            btn5.Location = new Point(380 , 50);  
            btn5.Size = new Size(70, 20);  
 
            label2.UseMnemonic = true;  
            label2.Text = "                                                                               ";  
            label2.Location = new Point(500, 15);  
            label2.BackColor = Color.LightGray;  
            label2.ForeColor = Color.Maroon;  
            label2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;  
            label2.Size = new Size(600,20);
            label2.AutoSize = true;

            exit.Text = "Exit";  
            exit.Location = new Point(415 , 15);  
            exit.Size = new Size(50, 20);  
            exit.BackColor = Color.Maroon;  
            exit.ForeColor = Color.White;

            dataGridView1.Location = new Point(15, 80);
            dataGridView1.Size = new Size(1200,800);
            dataGridView1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;  
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells;

            //Text to be Displayed in the Caption-Title Bar  
            this.Text = "CSharp TOOLKIT Form for SQL Server";  
            this.StartPosition = FormStartPosition.CenterScreen;  
            this.AutoScaleBaseSize = new Size(5, 13);  
            this.ClientSize = new Size(1100, 600); //Size except the Title Bar-CaptionHeight  
            this.AutoScroll = true;  
            this.MaximizeBox = false;  
            this.Controls.Add(label1);
            this.Controls.Add(comboBoxServ1);  
            this.Controls.Add(btn1);  
            this.Controls.Add(btn2);  
            this.Controls.Add(btn3);  
            this.Controls.Add(btn4);  
            this.Controls.Add(btn5);  
            this.Controls.Add(exit); 
            this.Controls.Add(label2);  
            this.Controls.Add(dataGridView1); 
 
            btn1.Click += new EventHandler(Btn1_Clicked);  
            btn2.Click += new EventHandler(Btn2_Clicked); 
            btn3.Click += new EventHandler(Btn3_Clicked); 
            btn4.Click += new EventHandler(Btn4_Clicked); 
            btn5.Click += new EventHandler(Btn5_Clicked); 
            exit.Click += new EventHandler(Ext_Clicked);   

        }  // end MyForm

//// Next parts are when one of the 5 Buttons is clicked.
/// Button 1 : DB info
        public void Btn1_Clicked(object ob, EventArgs e)  
        { 
         if (string.IsNullOrEmpty(comboBoxServ1.Text))
            {
                MessageBox.Show("PLEASE ENTER A SERVER ", "ERROR");
            }
            else
            {   string connectionString = "Data Source=" + comboBoxServ1.Text + ";Initial Catalog=msdb;Integrated Security=True";

                using (SqlConnection SqlCon = new SqlConnection(connectionString))
                {
                    try
                    {
                        SqlCon.Open();
                    }
                    catch
                    {
                        MessageBox.Show("Cant connect to the server. Check your spelling. ", "Connect ERROR");
                    }

                    //  string sql = "select top 20 server_name, backup_finish_date, database_name from backupset where database_name = ''msdb'';";

                    string sql = @"
						Create Table #dbInfo (dId smallint, tgroupID smallint NULL, dbName sysname,  segName varchar(256) NULL, 
							filName varchar(520) NULL, sizeMg decimal(10,2) null, 
							usedMg decimal(10,2) null,  
							pcntUsed decimal(10,2) null, backup_finish_date Datetime null, recov_type char(15) NULL ) 
						Declare @sSql varchar(1000) 
						Set @sSql = 'Use [?]; 
						Insert #dbInfo (dId, tgroupID, dbName, segName, filName, sizeMg, usedMg, recov_type) 
						Select db_id(), groupid, db_name(),  rtrim(name), filename, Cast(size/128.0 As Decimal(10,2)), 
						Cast(Fileproperty(name, ''SpaceUsed'')/128.0 As Decimal(10,2)), CAST(DATABASEPROPERTYEX(db_name(),  ''RECOVERY''  ) as CHAR(15)) 
						From dbo.sysfiles Order By groupId Desc; ' 

						Exec sp_MSforeachdb @sSql 
						Update #dbInfo Set 
						pcntUsed = (usedMg/sizeMg)*100 

						Update db  
						Set db.backup_finish_date = T2.backup_finish_date  
						From msdb.dbo.backupset T2 
						Inner Join #dbInfo db on (db.dbName =T2.database_name) 
						where db.dbName = T2.database_name 
						and T2.type = 'D' 
						and db.tgroupID > 0 
						 and T2.backup_finish_date =   
						(select MAX(backup_finish_date) from msdb.dbo.backupset T3 inner join msdb.dbo.backupmediafamily bmf on (T3.media_set_id = bmf.media_set_id) 
						 where T3.database_name = T2.database_name and T3.type='D'  AND LEFT(bmf.physical_device_name,1) <> '{') 

						Update db 
						Set db.backup_finish_date = T2.backup_finish_date 
						From msdb.dbo.backupset T2 
						Inner Join #dbInfo db on (db.dbName =T2.database_name) 
						where db.dbName = T2.database_name  
						and T2.type = 'L' 
						 and db.tgroupID = 0 
						 and T2.backup_finish_date =  (select MAX(backup_finish_date) from msdb.dbo.backupset T3 where T3.database_name = T2.database_name and T3.type='L' ) 

						select dbName, segName as 'FileGroup', sizeMg as 'DB Size MB',  pcntUsed as '% Used', recov_type as 'Recovery Type', backup_finish_date as 'Backup Date', filName as 'File' from #dbInfo 
						drop table #dbInfo 
						";

                    try
                    {
/// Next lines fill a data table and bind to the gridview.
                        SqlDataAdapter sqlDa = new SqlDataAdapter(sql, SqlCon);
                        DataTable dtb1 = new DataTable();
                        sqlDa.Fill(dtb1);
                        dataGridView1.DataSource = dtb1;
/// Next lines setup version info.  There are linefeeds in @@version hence the LEFT.
                        SqlCommand sqlcmd1 = new SqlCommand("Select LEFT(@@version,charindex(char(10),@@version)-1);", SqlCon);
                        SqlDataReader da = sqlcmd1.ExecuteReader();
                        while (da.Read())
                        {
                            label2.Text = da.GetValue(0).ToString();
                        }
                    }
                    catch
                    {
                     // Next line used to debug if you try new/changed query
                     //  MessageBox.Show("query= " + sql, "ERROR");
                    }

                } //end using connection
            }  //end blank server  
        } //end button 1 

///Button 2 - Processes running
      public void Btn2_Clicked(object ob, EventArgs e)  
        { 
         if (string.IsNullOrEmpty(comboBoxServ1.Text))
            { MessageBox.Show("PLEASE ENTER A SERVER Button 2 ", "ERROR");  }
            else
            { // string connectionString = "Data Source=" + txtbx1.Text + ";Initial Catalog=msdb;Integrated Security=True";
           // Next line if you try to use a drop-down
                string connectionString = "Data Source=" + comboBoxServ1.Text + ";Initial Catalog=msdb;Integrated Security=True";

                using (SqlConnection SqlCon = new SqlConnection(connectionString))
                {
                    try
                    { SqlCon.Open(); }
                    catch
                    { MessageBox.Show("Cant connect to the server. Check your spelling. ", "Connect ERROR"); }

                    string sql = @"
						SELECT CASE WHEN req.session_id = @@SPID THEN 'YOURSELF' ELSE 'OTHER' END as 'WHO' 
						, CAST(req.session_id as  CHAR(10) ) as 'Session ID' 
						, left(req.status,12) as 'Req Staus', left(req.command,10) as 'Command Type' 
						, CAST(req.total_elapsed_time as CHAR(12) ) as 'Elapsed MS'  
						, CAST(req.blocking_session_id as CHAR(9) ) as 'Blocking Session ID', CAST(sess.host_name as  CHAR(20) ) as 'Host' 
						, cast(LEFT(sqltext.TEXT,200) as char(200)) as 'Command'  
						FROM sys.dm_exec_requests req 
						 inner join sys.dm_exec_sessions sess on (sess.session_id = req.session_id) 
						 CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext  
						 --WHERE req.session_id <> @@SPID 
						";
                   
                    try
                    {
/// Next lines fill a data table and bind to the gridview.
                        SqlDataAdapter sqlDa = new SqlDataAdapter(sql, SqlCon);
                        DataTable dtb1 = new DataTable();
                        sqlDa.Fill(dtb1);
                        dataGridView1.DataSource = dtb1;
/// Next lines setup version info.  There are linefeeds in @@version hence the LEFT.
                        SqlCommand sqlcmd1 = new SqlCommand("Select LEFT(@@version,charindex(char(10),@@version)-1);", SqlCon);
                        SqlDataReader da = sqlcmd1.ExecuteReader();
                        while (da.Read())
                        {
                            label2.Text = da.GetValue(0).ToString();
                        }
                    }
                    catch
                    {
                     // Next line used to debug if you try new/changed query
                     //  MessageBox.Show("query= " + sql, "ERROR");
                    }

                } // end using sqlconnection
            }  //end blank server 

         
         } // end button 2

/////Button 3 - sp_who2
   public void Btn3_Clicked(object ob, EventArgs e)  
        { 
            if (string.IsNullOrEmpty(comboBoxServ1.Text))
            { MessageBox.Show("PLEASE ENTER A SERVER Button 2 ", "ERROR");  }
            else
            {   string connectionString = "Data Source=" + comboBoxServ1.Text + ";Initial Catalog=msdb;Integrated Security=True";

                using (SqlConnection SqlCon = new SqlConnection(connectionString))
                {
                    try
                    { SqlCon.Open(); }
                    catch
                    { MessageBox.Show("Cant connect to the server. Check your spelling. ", "Connect ERROR"); }
                    
                  string sql = @"
                       IF OBJECT_ID(N'tempdb..##temp_sp_who2') IS NOT NULL BEGIN DROP TABLE ##temp_sp_who2 END 
                       CREATE TABLE ##temp_sp_who2  ( SPID INT, Status VARCHAR(1000) NULL, Login SYSNAME NULL, 
                       HostName SYSNAME NULL, BlkBy SYSNAME NULL, DBName SYSNAME NULL, 
                       Command VARCHAR(1000) NULL, CPUTime INT NULL,  DiskIO BIGINT NULL, 
                       LastBatch VARCHAR(1000) NULL, ProgramName VARCHAR(1000) NULL, SPID2 INT, RequestId INT NULL ) 
                       INSERT INTO ##temp_sp_who2 EXEC sp_who2 
                       SELECT * FROM ##temp_sp_who2 ORDER BY DBName, SPID 
					   ";
         
                    try
                    {
/// Next lines fill a data table and bind to the gridview.
                        SqlDataAdapter sqlDa = new SqlDataAdapter(sql, SqlCon);
                        DataTable dtb1 = new DataTable();
                        sqlDa.Fill(dtb1);
                        dataGridView1.DataSource = dtb1;
/// Next lines setup version info.  There are linefeeds in @@version hence the LEFT.
                        SqlCommand sqlcmd1 = new SqlCommand("Select LEFT(@@version,charindex(char(10),@@version)-1);", SqlCon);
                        SqlDataReader da = sqlcmd1.ExecuteReader();
                        while (da.Read())
                        {
                            label2.Text = da.GetValue(0).ToString();
                        }
                    }
                    catch
                    {// Next line used to debug if you try new/changed query
                     //  MessageBox.Show("query= " + sql, "ERROR");
                    }
                } // end using sqlconnection
            }  //end blank server 
        } // end button 3 click

///buton 4 - Job History
   public void Btn4_Clicked(object ob, EventArgs e)  
        { 
  if (string.IsNullOrEmpty(comboBoxServ1.Text))
            { MessageBox.Show("PLEASE ENTER A SERVER Button 4 ", "ERROR");  }
            else
            {  string connectionString = "Data Source=" + comboBoxServ1.Text + ";Initial Catalog=msdb;Integrated Security=True";

                using (SqlConnection SqlCon = new SqlConnection(connectionString))
                {
                    try
                    { SqlCon.Open(); }
                    catch
                    { MessageBox.Show("Cant connect to the server. Check your spelling. ", "Connect ERROR"); }
               string sql = @"
					  WITH CTE_JOB_HIST (JOB_ID, RUN_DATE ) AS  
					   ( select job_id,  MAX(run_date)  
					   from msdb.dbo.sysjobhistory h where step_id = 0 group by job_id ), 
					   CTE_JOB_HIST2 (JOB_ID, RUN_DATE , RUN_TIME) AS 
					  ( select h.job_id,  h.run_date, MAX(h.run_time) from msdb.dbo.sysjobhistory h 
					   inner join CTE_JOB_HIST on (CTE_JOB_HIST.job_id = h.job_id) 
					   where h.step_id = 0 and  CTE_JOB_HIST.RUN_DATE=h.run_date group by h.job_id, h.run_date ) 
					   select j.name as 'Job Name', 
					   SUBSTRING( cast( h.run_date as char(8) ), 5, 2) + '/' + RIGHT(cast( h.run_date as char(8) ), 2) + '/' + LEFT(cast( h.run_date as char(8) ),4) AS 'Run Dt', 
						 CASE when h.run_time/100 > 999 then LEFT( cast( h.run_time/100 as char(4) ), 2) + ':' + RIGHT( cast( h.run_time/100 as char(4) ), 2) 
						 when h.run_time/100 > 99 then  LEFT( cast( h.run_time/100 as char(3) ), 1) + ':' + RIGHT( cast( h.run_time/100 as char(3) ), 2) 
						 when h.run_time/100 > 9 then  '0:'  + LEFT( cast( h.run_time/100 as char(2) ), 2) ELSE '0:0'  +  cast( h.run_time/100 as char(1) ) END as 'Run Time', 
					   CASE h.run_status WHEN 1 THEN 'Completed' ELSE 'Failed' END as 'Status', h.run_duration as 'Duration MS' 
					   from msdb.dbo.sysjobhistory h  inner join CTE_JOB_HIST2 CTEJ2 on (CTEJ2.JOB_ID = h.job_id) 
					   inner join msdb.dbo.sysjobs j on (CTEJ2.JOB_ID =j.job_id) 
					   where h.run_date=CTEJ2.RUN_DATE and h.run_time=CTEJ2.RUN_TIME and h.step_id = 0 
					   ";
                 try
                    {
/// Next lines fill a data table and bind to the gridview.
                        SqlDataAdapter sqlDa = new SqlDataAdapter(sql, SqlCon);
                        DataTable dtb1 = new DataTable();
                        sqlDa.Fill(dtb1);
                        dataGridView1.DataSource = dtb1;
/// Next lines setup version info.  There are linefeeds in @@version hence the LEFT.
                        SqlCommand sqlcmd1 = new SqlCommand("Select LEFT(@@version,charindex(char(10),@@version)-1);", SqlCon);
                        SqlDataReader da = sqlcmd1.ExecuteReader();
                        while (da.Read())
                        {
                            label2.Text = da.GetValue(0).ToString();
                        }
                    }
                    catch
                    {// Next line used to debug if you try new/changed query
                       MessageBox.Show("query= " + sql, "ERROR");
                    }
                } // end using sqlconnection
            }  //end blank server 
 
        } // end button 4 click

////////.........Button 5 Wait Stats.
   public void Btn5_Clicked(object ob, EventArgs e)  
        { 
  if (string.IsNullOrEmpty(comboBoxServ1.Text))
            { MessageBox.Show("PLEASE ENTER A SERVER Button 2 ", "ERROR");  }
            else
            {
// string connectionString = "Data Source=" + txtbx1.Text + ";Initial Catalog=msdb;Integrated Security=True";
           // Next line if you try to use a drop-down
                string connectionString = "Data Source=" + comboBoxServ1.Text + ";Initial Catalog=msdb;Integrated Security=True";

                using (SqlConnection SqlCon = new SqlConnection(connectionString))
                {
                    try
                    { SqlCon.Open(); }
                    catch
                    { MessageBox.Show("Cant connect to the server. Check your spelling. ", "Connect ERROR"); }

                    
                  string sql = @"
                    WITH [Waits] AS   (SELECT [wait_type], [wait_time_ms] / 1000.0 AS [WaitS], 
                    ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS], 
					[signal_wait_time_ms] / 1000.0 AS [SignalS], 
					[waiting_tasks_count] AS [WaitCount], 
					100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage], 
					ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum] 
					FROM sys.dm_os_wait_stats ) 
					SELECT 
					MAX ([W1].[wait_type]) AS [WaitType], 
					CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) AS [Wait_S], 
					CAST (MAX ([W1].[ResourceS]) AS DECIMAL (16,2)) AS [Resource_S], 
					CAST (MAX ([W1].[SignalS]) AS DECIMAL (16,2)) AS [Signal_S], 
					MAX ([W1].[WaitCount]) AS [WaitCount], 
					CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2)) AS [Percentage], 
					CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S], 
					CAST ((MAX ([W1].[ResourceS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgRes_S], 
					CAST ((MAX ([W1].[SignalS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgSig_S] 
					FROM [Waits] AS [W1] 
					INNER JOIN [Waits] AS [W2] ON [W2].[RowNum] <= [W1].[RowNum] 
					GROUP BY [W1].[RowNum] 
					HAVING SUM ([W2].[Percentage]) - MAX( [W1].[Percentage] ) < 95; -- percentage threshold 					
					";
         
                    try
                    {
/// Next lines fill a data table and bind to the gridview.
                        SqlDataAdapter sqlDa = new SqlDataAdapter(sql, SqlCon);
                        DataTable dtb1 = new DataTable();
                        sqlDa.Fill(dtb1);
                        dataGridView1.DataSource = dtb1;
/// Next lines setup version info.  There are linefeeds in @@version hence the LEFT.
                        SqlCommand sqlcmd1 = new SqlCommand("Select LEFT(@@version,charindex(char(10),@@version)-1);", SqlCon);
                        SqlDataReader da = sqlcmd1.ExecuteReader();
                        while (da.Read())
                        {
                            label2.Text = da.GetValue(0).ToString();
                        }
                    }
                    catch
                    {// Next line used to debug if you try new/changed query
                       MessageBox.Show("query= " + sql, "ERROR");
                    }
                } // end using sqlconnection
            }  //end blank server 
        } // end button 5 click
     

   public void Ext_Clicked(object ob, EventArgs e)  
        {  
            Application.Exit();  
            MessageBox.Show("Successfully Closed", "EXIT");//not Shown! Do you know Why?  
        }   

 public static void Main()  
        {  
            Application.Run(new MyForm());  
        }  
    }  
   

 

