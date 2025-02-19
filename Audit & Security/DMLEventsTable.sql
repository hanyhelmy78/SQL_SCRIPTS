SET ANSI_NULLS On
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING On
GO

CREATE TABLE [dbo].[DMLEvents](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EventDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[EventType] [nvarchar](64) NULL,
	[EventDML] [nvarchar](max) NULL,
	[EventXML] [xml] NULL,
	[DatabaseName] [nvarchar](255) NULL,
	[SchemaName] [nvarchar](255) NULL,
	[ObjectName] [nvarchar](255) NULL,
	[HostName] [varchar](64) NULL,
	[IPAddress] [varchar](32) NULL,
	[ProgramName] [nvarchar](255) NULL,
	[LoginName] [nvarchar](255) NULL,
	[MovedtoLive] [bit] NULL,
 CONSTRAINT [PK_DMLEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DMLEvents] ADD CONSTRAINT [DF_DMLEvents_MovedtoLive] DEFAULT ((0)) FOR [MovedtoLive]
GO