USE [DBA]
GO
/****** Object:  Table [dbo].[BlitzResults]    Script Date: 09/11/2022 12:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BlitzResults](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](50) NULL,
	[CheckDate] [nvarchar](100) NULL,
	[Priority] [tinyint] NULL,
	[FindingsGroup] [nvarchar](50) NULL,
	[Finding] [nvarchar](100) NULL,
	[DatabaseName] [nvarchar](50) NULL,
	[URL] [nvarchar](100) NULL,
	[Details] [nvarchar](max) NULL,
	[QueryPlan] [xml] NULL,
	[QueryPlanFiltered] [xml] NULL,
	[CheckID] [smallint] NULL,
 CONSTRAINT [PK_BlitzResults] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO