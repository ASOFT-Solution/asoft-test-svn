-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5000]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Formular] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[CurrencyID] [nvarchar](50) NOT NULL,
	[IsTax] [tinyint] NULL,
 CONSTRAINT [PK_HT5000] PRIMARY KEY NONCLUSTERED 
(
	[PayrollMethodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5000__Currency__5D3D1896]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5000] ADD  CONSTRAINT [DF__HT5000__Currency__5D3D1896]  DEFAULT ('VND') FOR [CurrencyID]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT5000' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT5000'  and col.name = 'PeriodID')
           Alter Table HT5000 Add PeriodID nvarchar(50) NULL
End