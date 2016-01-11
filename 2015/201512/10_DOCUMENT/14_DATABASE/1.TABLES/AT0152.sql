-- <Summary>
---- 
-- <History>
---- Create on 04/01/2016 by Bảo Anh: Danh mục khuôn
---- Modified on ... by ...

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0152]') AND type in (N'U'))
CREATE TABLE [dbo].[AT0152](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[BlockID] [nvarchar](50) NOT NULL,
	[BlockName] [nvarchar](250) NULL,
	[Model] [nvarchar](250) NULL,
	[Year] [int] NULL,
	[StartDate] [datetime] NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL DEFAULT(0),
	[Value01] [nvarchar](50) NULL,
	[Value02] [nvarchar](50) NULL,
	[Value03] [nvarchar](50) NULL,
	[Value04] [nvarchar](50) NULL,
	[Value05] [nvarchar](50) NULL,
	[Value06] [nvarchar](50) NULL,
	[Value07] [nvarchar](50) NULL,
	[Value08] [nvarchar](50) NULL,
	[Value09] [nvarchar](50) NULL,
	[Value10] [nvarchar](50) NULL,
	[Value11] [nvarchar](50) NULL,
	[Value12] [nvarchar](50) NULL,
	[Value13] [nvarchar](50) NULL,
	[Value14] [nvarchar](50) NULL,
	[Value15] [nvarchar](50) NULL,
	[Value16] [nvarchar](50) NULL,
	[Value17] [nvarchar](50) NULL,
	[Value18] [nvarchar](50) NULL,
	[Value19] [nvarchar](50) NULL,
	[Value20] [nvarchar](50) NULL,
	[Value21] [nvarchar](50) NULL,
	[Value22] [nvarchar](50) NULL,
	[Value23] [nvarchar](50) NULL,
	[Value24] [nvarchar](50) NULL,
	[Value25] [nvarchar](50) NULL,
	[Value26] [nvarchar](50) NULL,
	[Value27] [nvarchar](50) NULL,
	[Value28] [nvarchar](50) NULL,
	[Value29] [nvarchar](50) NULL,
	[Value30] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT0152] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[BlockID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]