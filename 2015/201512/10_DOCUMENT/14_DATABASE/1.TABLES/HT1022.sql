-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1022]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1022](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[RestrictID] [nvarchar](50) NOT NULL,
	[RestrictName] [nvarchar](250) NULL,
	[LateBeginPermit] [int] NULL,
	[EarlyEndPermit] [int] NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1022] PRIMARY KEY NONCLUSTERED 
(
	[RestrictID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1022_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1022] ADD  CONSTRAINT [DF_HT1022_Disabled]  DEFAULT ((0)) FOR [Disabled]
END

--- Modify on 03/12/2015 by Bảo Anh: Bổ sung thời gian hiệu lực quy định (IPL)
If Exists (Select * From sysobjects Where name = 'HT1022' and xtype ='U') 
Begin
	If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name = 'HT1022'  and col.name = 'FromDate')
        Alter Table HT1022 Add FromDate Datetime Null Default ('01/01/1900')

	If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name = 'HT1022'  and col.name = 'ToDate')
        Alter Table HT1022 Add ToDate Datetime Null
End