-- <Summary>
---- 
-- <History>
---- Create on 24/12/2013 by Lưu Khánh Vân
---- Modified on 27/12/2013 by Lưu Khánh Vân
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0337]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0337](
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[MethodID] [nvarchar](50) NOT NULL,
	[InComeID] [nvarchar](50) NOT NULL,
	[IsUsed] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT0337] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[MethodID] ASC,
	[InComeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0337_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0337] ADD  CONSTRAINT [DF_HT0337_APK]  DEFAULT (newid()) FOR [APK]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0337' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0337'  and col.name = 'Coefficient')
           Alter Table  HT0337 Add Coefficient decimal(28,8) NULL
          
End