-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1023]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1023](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[RestrictID] [nvarchar](50) NOT NULL,
	[LevelID] [int] NOT NULL,
	[FromMinute] [int] NULL,
	[ToMinute] [int] NULL,
	[SubMinute] [int] NULL,
	[Coefficient] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1023] PRIMARY KEY NONCLUSTERED 
(
	[RestrictID] ASC,
	[LevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


--- Modify on 02/12/2015 by Bảo Anh: Bổ sung hệ số phạt khi không được duyệt và mức tiền phạt đi trễ/về sớm (IPL)
If Exists (Select * From sysobjects Where name = 'HT1023' and xtype ='U') 
Begin
	If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name = 'HT1023'  and col.name = 'NotConfirmCo')
        Alter Table HT1023 Add NotConfirmCo DECIMAL(28,8) Null

	If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name = 'HT1023'  and col.name = 'Amount')
        Alter Table HT1023 Add Amount DECIMAL(28,8) Null
End