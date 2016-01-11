-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1305]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1305](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[FileID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[FileDate] [datetime] NULL,
	[ObjectID] [nvarchar](50) NULL,
	[FileType] [int] NULL,
	[Type] [int] NULL,
	[EndDate] [datetime] NULL,
	[RegisNo] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[ProductID] [nvarchar](50) NULL,
	[PUnitID] [nvarchar](50) NULL,
	[MaterialID] [nvarchar](50) NULL,
	[Material01ID] [nvarchar](50) NULL,
	[Material02ID] [nvarchar](50) NULL,
	[Material03ID] [nvarchar](50) NULL,
	[MUnitID] [nvarchar](50) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[Var01] [nvarchar](100) NULL,
	[Var02] [nvarchar](100) NULL,
	[Var03] [nvarchar](100) NULL,
	[Var04] [nvarchar](100) NULL,
	[Var05] [nvarchar](100) NULL,
	[Var06] [nvarchar](100) NULL,
	[Var07] [nvarchar](100) NULL,
	[Var08] [nvarchar](100) NULL,
	[Var09] [nvarchar](100) NULL,
	[Var10] [nvarchar](100) NULL,
	[Date01] [datetime] NULL,
	[Num01] [decimal](28, 8) NULL,
	[Num02] [decimal](28, 8) NULL,
	[Num03] [decimal](28, 8) NULL,
	[Num04] [decimal](28, 8) NULL,
	[Num05] [decimal](28, 8) NULL,
	[Num06] [decimal](28, 8) NULL,
	[Num07] [decimal](28, 8) NULL,
	[Num08] [decimal](28, 8) NULL,
	[Num09] [decimal](28, 8) NULL,
	[Num10] [decimal](28, 8) NULL,
	[Num11] [decimal](28, 8) NULL,
	[Num12] [decimal](28, 8) NULL,
	[Num13] [decimal](28, 8) NULL,
	[Num14] [decimal](28, 8) NULL,
	[Num15] [decimal](28, 8) NULL,
	[Orders] [int] NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[ProductName] [nvarchar](250) NULL,
	[AccountID] [nvarchar](50) NULL,
	[MethodID] [tinyint] NULL,
	[ProductTypeID] [nvarchar](50) NULL,
	[FileNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_OT1305] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1305_Disabled_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1305] ADD  CONSTRAINT [DF_OT1305_Disabled_1]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
-- Thêm cột UnitPrice01 vào bảng OT1305
IF(ISNULL(COL_LENGTH('OT1305', 'UnitPrice01'), 0) <= 0)
ALTER TABLE OT1305 ADD UnitPrice01 money NULL 
-- Thêm cột UnitPrice02 vào bảng OT1305
IF(ISNULL(COL_LENGTH('OT1305', 'UnitPrice02'), 0) <= 0)
ALTER TABLE OT1305 ADD UnitPrice02 money NULL
-- Thêm cột UnitPrice03 vào bảng OT1305
IF(ISNULL(COL_LENGTH('OT1305', 'UnitPrice03'), 0) <= 0)
ALTER TABLE OT1305 ADD UnitPrice03 money NULL
-- Thêm cột UnitPrice04 vào bảng OT1305
IF(ISNULL(COL_LENGTH('OT1305', 'UnitPrice04'), 0) <= 0)
ALTER TABLE OT1305 ADD UnitPrice04 money NULL
-- Thêm cột UnitPrice05 vào bảng OT1305
IF(ISNULL(COL_LENGTH('OT1305', 'UnitPrice05'), 0) <= 0)
ALTER TABLE OT1305 ADD UnitPrice05 money NULL