-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on 21/08/2013 by Bảo Anh: Bổ sung cột IsFromAsoftM để nhận biết dữ liệu có phải được lấy từ KQSX của Asoft-M (Thuận Lợi)
---- Modified on 21/08/2013 by Thanh Thịnh: Thay đổi primary key là APK
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2403]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2403](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TimesID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[UnitID] [nvarchar](50) NULL,
	[OriginalQuantity] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT2403] PRIMARY KEY NONCLUSTERED 
(
	[TimesID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC,
	[EmployeeID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT2403' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT2403'  and col.name = 'IsFromAsoftM')
           Alter Table  HT2403 Add IsFromAsoftM tinyint Null
END
If Exists (Select * From sysobjects Where name = 'HT2403' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT2403'  and col.name = 'TrackingDate')
           Alter Table  HT2403 Add TrackingDate datetime NULL
End
-- ALTER APK PRIMARY
IF EXISTS (SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TB
				WHERE TB.CONSTRAINT_NAME ='PK_HT2403')
		BEGIN
			ALTER TABLE [dbo].[HT2403]
			DROP CONSTRAINT [PK_HT2403]
		END

ALTER TABLE [dbo].[HT2403] 
	ALTER COLUMN [APK] UNIQUEIDENTIFIER NOT NULL

ALTER TABLE [dbo].[HT2403]
ADD CONSTRAINT [PK_HT2403] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
