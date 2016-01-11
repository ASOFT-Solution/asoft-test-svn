-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0005]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[SubID] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](250) NULL,
	[SubName] [nvarchar](250) NULL,
	[Caption] [nvarchar](100) NULL,
	[IsTranfer] [tinyint] NULL,
	[IsUsed] [tinyint] NOT NULL,
	[SourceFieldName] [nvarchar](250) NULL,
	[SourceTableName] [nvarchar](250) NULL,
	[IsTax] [tinyint] NULL,
	[CaptionE] [nvarchar](250) NULL,
 CONSTRAINT [PK_HT0005] PRIMARY KEY NONCLUSTERED 
(
	[SubID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0005_IsTranfer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0005] ADD  CONSTRAINT [DF_HT0005_IsTranfer]  DEFAULT ((0)) FOR [IsTranfer]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0005_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0005] ADD  CONSTRAINT [DF_HT0005_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0005_IsTax]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0005] ADD  CONSTRAINT [DF_HT0005_IsTax]  DEFAULT ((0)) FOR [IsTax]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0005' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0005'  and col.name = 'IsCalculateNetIncome')
           Alter Table  HT0005 Add IsCalculateNetIncome tinyint NULL
End
-- Thêm cột SubNameE vào bảng HT0005
IF(ISNULL(COL_LENGTH('HT0005', 'SubNameE'), 0) <= 0)
ALTER TABLE HT0005 ADD SubNameE NVARCHAR(50) NULL