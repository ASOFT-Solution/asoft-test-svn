-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 26/07/2013 by Bao Anh
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1026]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1026](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranYear] [int] NOT NULL,
	[Holiday] [datetime] NOT NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1026] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[TranYear] ASC,
	[Holiday] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1026_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1026] ADD  CONSTRAINT [DF_HT1026_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1026_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1026] ADD  CONSTRAINT [DF_HT1026_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT1026' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1026'  and col.name = 'IsTimeOff')
           Alter Table  HT1026 Add IsTimeOff tinyint NOT NULL Default(0)
End