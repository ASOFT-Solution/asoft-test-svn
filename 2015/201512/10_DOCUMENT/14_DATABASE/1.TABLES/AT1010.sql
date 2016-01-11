-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on 05/11/2015 by Phương Thảo : Bổ sung các cột liên quan đến thuế nhà thầu
-- <Example>

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1010]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1010](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VATGroupID] [nvarchar](50) NOT NULL,
	[VATRate] [decimal](28, 8) NULL,
	[VATGroupName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1010] PRIMARY KEY NONCLUSTERED 
(
	[VATGroupID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


-------------------------------------------------- ADD COLUMN --------------------------------------------------------------------
--- Su dung thue nha thau
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1010' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1010' AND col.name = 'IsWithhodingTax')
        ALTER TABLE AT1010 ADD IsWithhodingTax TINYINT NULL
    END

