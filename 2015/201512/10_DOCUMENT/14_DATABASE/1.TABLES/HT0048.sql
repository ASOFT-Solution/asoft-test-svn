-- <Summary>
---- 
-- <History>
---- Create on 27/12/2013 by Lê Thị Thu Hiền
---- Modified on 27/12/2013 by Le Thi Thu Hien: Do fix đã chép trước đó sai cột nên add lại cột và delete cột cũ
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0048]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0048]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [TitleID] VARCHAR(50) NOT NULL,
      [SalaryLevel] VARCHAR(50) NOT NULL,
      [SalaryCoefficient] DECIMAL(28,8) DEFAULT (0) NULL,
      [DetailNotes] NVARCHAR(1000) NULL
    CONSTRAINT [PK_HT0048] PRIMARY KEY CLUSTERED
      (
      [TitleID],
      [SalaryLevel]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0048' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0048'  and col.name = 'DetailNotes')
           Alter Table  HT0048 Add DetailNotes nvarchar(1000) Null
End 
---- Drop Columns
If Exists (Select * From sysobjects Where name = 'HT0048' and xtype ='U') 
BEGIN
IF EXISTS (SELECT * FROM SYSCOLUMNS COL INNER JOIN SYSOBJECTS TAB 
ON col.id = tab.id where tab.name =   'HT0048'  and col.name = 'Notes')
ALTER TABLE HT0048 DROP COLUMN Notes
END