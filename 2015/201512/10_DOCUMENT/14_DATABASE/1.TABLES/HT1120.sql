-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 14/01/2013 by Bao Anh: Xoa cac field Ky han tinh luong, Trang thai
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1120]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1120](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ProjectID] [nvarchar](50) NOT NULL,
	[ProjectName] [nvarchar](250) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[EndTranMonth] [int] NULL,
	[EndTranYear] [int] NULL,
	[Status] [tinyint] NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastmodifyUserID] [nvarchar](50) NULL,	
 CONSTRAINT [PK_HT1120] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1120_Disable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1120] ADD  CONSTRAINT [DF_HT1120_Disable]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1120_DivisionID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1120] ADD  CONSTRAINT [DF_HT1120_DivisionID]  DEFAULT ('ASOFT') FOR [DivisionID]
END
---- Drop Columns
If Exists (Select * From sysobjects Where name = 'HT1120' and xtype ='U') 
Begin
        If exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'HT1120'  and col.name = 'EndTranMonth')
			Alter table HT1120 drop column EndTranMonth			
		If exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'HT1120'  and col.name = 'EndTranYear')
			Alter table HT1120 drop column EndTranYear			
		If exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'HT1120'  and col.name = 'Status')
			Alter table HT1120 drop column [Status]
End