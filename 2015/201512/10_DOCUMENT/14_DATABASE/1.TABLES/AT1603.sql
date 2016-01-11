-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on 15/01/2014 by Khánh Vân
---- Modified on 10/07/2012 by Bao Anh: Gan gia tri cho VoucherID của AT1603 khi VoucherID = NULL
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1603]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1603](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ToolID] [nvarchar](50) NOT NULL,
	[ToolName] [nvarchar](250) NULL,
	[SerialNo] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[ApportionRate] [decimal](28, 8) NULL,
	[MethodID] [tinyint] NOT NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[Periods] [int] NULL,
	[UseStatus] [tinyint] NOT NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[BeginMonth] [int] NULL,
	[BeginYear] [int] NULL,
	[Description] [nvarchar](250) NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1603] PRIMARY KEY NONCLUSTERED 
(
	[ToolID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1603_MethodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1603] ADD  CONSTRAINT [DF_AT1603_MethodID]  DEFAULT ((0)) FOR [MethodID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1603_UseStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1603] ADD  CONSTRAINT [DF_AT1603_UseStatus]  DEFAULT ((0)) FOR [UseStatus]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1603_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1603] ADD  CONSTRAINT [DF_AT1603_IsUsed]  DEFAULT ((0)) FOR [IsUsed]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'AT1603' AND xtype ='U') 
BEGIN
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'ApportionAmount')
    ALTER TABLE AT1603 ADD ApportionAmount Decimal(28,8) NULL
		IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter01')
    ALTER TABLE AT1603 ADD Parameter01 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter02')
    ALTER TABLE AT1603 ADD Parameter02 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter03')
    ALTER TABLE AT1603 ADD Parameter03 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter04')
    ALTER TABLE AT1603 ADD Parameter04 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter05')
    ALTER TABLE AT1603 ADD Parameter05 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter06')
    ALTER TABLE AT1603 ADD Parameter06 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter07')
    ALTER TABLE AT1603 ADD Parameter07 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter08')
    ALTER TABLE AT1603 ADD Parameter08 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter09')
    ALTER TABLE AT1603 ADD Parameter09 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter10')
    ALTER TABLE AT1603 ADD Parameter10 NVARCHAR(50) NULL    
		IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'DepPeriod')
    ALTER TABLE AT1603 ADD DepPeriod int null 
    	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'EstablishDate')
    ALTER TABLE AT1603 ADD EstablishDate datetime NULL
            IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'ParentVoucherID')
    ALTER TABLE AT1603 ADD ParentVoucherID NVARCHAR(50) NULL    
		IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter11')
    ALTER TABLE AT1603 ADD Parameter11 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter12')
    ALTER TABLE AT1603 ADD Parameter12 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter13')
    ALTER TABLE AT1603 ADD Parameter13 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter14')
    ALTER TABLE AT1603 ADD Parameter14 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter15')
    ALTER TABLE AT1603 ADD Parameter15 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter16')
    ALTER TABLE AT1603 ADD Parameter16 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter17')
    ALTER TABLE AT1603 ADD Parameter17 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter18')
    ALTER TABLE AT1603 ADD Parameter18 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter19')
    ALTER TABLE AT1603 ADD Parameter19 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1603' AND col.name = 'Parameter20')
    ALTER TABLE AT1603 ADD Parameter20 NVARCHAR(50) NULL
END 
If Exists (Select * From sysobjects Where name = 'AT1603' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT1603'  and col.name = 'Ana06ID')
Alter Table  AT1603 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null;
End
---- Add Primary key
DECLARE @ID AS NVARCHAR(50),
 	@Year AS INT,
 	@ToolID AS NVARCHAR(50),
	@Cur AS CURSOR	
SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT BeginYear,ToolID FROM AT1603 WHERE ISNULL(VoucherID,'') = '' ORDER BY BeginYear, BeginMonth
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Year,@ToolID
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC AP0000 '', @ID OUTPUT,'AT1603','EU',@Year,'',16,3,0,''
	UPDATE AT1603 SET VoucherID = @ID WHERE ToolID = @ToolID
	UPDATE AT1602 SET ReVoucherID = @ID WHERE ToolID = @ToolID
	UPDATE AT1604 SET ReVoucherID = @ID WHERE ToolID = @ToolID
	UPDATE AT1606 SET ReVoucherID = @ID WHERE ToolID = @ToolID	
	FETCH NEXT FROM @Cur INTO @Year,@ToolID
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1603' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1603' AND col.name='VoucherID')
		ALTER TABLE AT1603 ALTER COLUMN VoucherID NVARCHAR(50) NOT NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1603' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1603' AND col.name='DivisionID')
		ALTER TABLE AT1603 ALTER COLUMN DivisionID NVARCHAR(50) NOT NULL 
	END
CLOSE @Cur
Declare @PKName varchar(200)If Exists (Select * From sysobjects Where name = 'AT1603' and xtype ='U') 
Begin
           Select @PKName = pk.name From sysobjects pk inner join sysobjects tab
                   On pk.parent_obj = tab.id where pk.xtype = 'PK' and tab.name = 'AT1603'
           If @PKName is not null 
           Execute( 'Alter Table AT1603 Drop Constraint ' + @PKName) 
END
ALTER TABLE AT1603 ADD CONSTRAINT [PK_AT1603] PRIMARY KEY (DivisionID, VoucherID)