-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 26/07/2013 by Bao Anh
---- Modified on 09/12/2015 by Phương Thảo: Bổ sung các TK chi phí quản lý, TK phải trả, TK thuế TNCN
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1102]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1102](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[DepartmentName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1102] PRIMARY KEY NONCLUSTERED 
(
	[DepartmentID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1102_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1102] ADD  CONSTRAINT [DF_AT1102_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1102'  and col.name = 'AccountID')
           Alter Table  AT1102 Add AccountID nvarchar(50) NULL
End


--- Modified on 09/12/2015 by Phương Thảo: Bổ sung các TK chi phí quản lý, TK phải trả, TK thuế TNCN
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1102' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1102' AND col.name = 'PayableAccountID')
        ALTER TABLE AT1102 ADD PayableAccountID NVARCHAR(50) NULL
    END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1102' AND xtype = 'U')
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT1102' AND col.name = 'PITAccountID')
    ALTER TABLE AT1102 ADD PITAccountID NVARCHAR(50) NULL
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1102' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1102' AND col.name = 'ManagerExpAccountID')
        ALTER TABLE AT1102 ADD ManagerExpAccountID NVARCHAR(50) NULL
    END