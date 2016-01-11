-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0002]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[IncomeID] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](250) NULL,
	[IncomeName] [nvarchar](250) NULL,
	[Caption] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[IsTax] [tinyint] NOT NULL,
	[CaptionE] [nvarchar](250) NULL,
 CONSTRAINT [PK_HT0002] PRIMARY KEY NONCLUSTERED 
(
	[IncomeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0002_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0002] ADD  CONSTRAINT [DF_HT0002_IsUsed]  DEFAULT ((0)) FOR [IsUsed]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0002_IsTax]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0002] ADD  CONSTRAINT [DF_HT0002_IsTax]  DEFAULT ((0)) FOR [IsTax]
END
---- Add Columns
-- Thêm cột IncomeNameE vào bảng HT0002
IF(ISNULL(COL_LENGTH('HT0002', 'IncomeNameE'), 0) <= 0)
ALTER TABLE HT0002 ADD IncomeNameE NVARCHAR(50) NULL
If Exists (Select * From sysobjects Where name = 'HT0002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0002'  and col.name = 'IsCalculateNetIncome')
           Alter Table  HT0002 Add IsCalculateNetIncome tinyint NULL
End
