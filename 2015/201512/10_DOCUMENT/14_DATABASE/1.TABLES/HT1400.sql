-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 23/12/2013 by Bảo Anh
---- Modified on 26/03/2015 by Thanh Sơn: bổ sung trường NoResident: không cư trú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1400]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1400](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[Orders] [nvarchar](50) NOT NULL,	
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[FirstName] [nvarchar](50) NULL,
	[ShortName] [nvarchar](50) NULL,
	[Alias] [nvarchar](50) NULL,
	[Birthday] [nvarchar](100) NULL,
	[BornPlace] [nvarchar](250) NULL,
	[IsMale] [tinyint] NULL,
	[NativeCountry] [nvarchar](250) NULL,
	[PermanentAddress] [nvarchar](250) NULL,
	[TemporaryAddress] [nvarchar](250) NULL,
	[PassportNo] [nvarchar](50) NULL,
	[PassportDate] [datetime] NULL,
	[PassportEnd] [datetime] NULL,
	[IdentifyCardNo] [nvarchar](50) NULL,
	[IdentifyDate] [datetime] NULL,
	[IdentifyPlace] [nvarchar](250) NULL,
	[IsSingle] [tinyint] NOT NULL,
	[ImageID] [image] NULL,
	[CountryID] [nvarchar](50) NULL,
	[CityID] [nvarchar](50) NULL,
	[DistrictID] [nvarchar](50) NULL,
	[EthnicID] [nvarchar](50) NULL,
	[ReligionID] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[HealthStatus] [nvarchar](250) NULL,
	[HomePhone] [nvarchar](100) NULL,
	[HomeFax] [nvarchar](100) NULL,
	[MobiPhone] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[EmployeeStatus] [tinyint] NULL,
	[IsForeigner] [tinyint] NULL,
	[RecruitTimeID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1400] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1400_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1400] ADD  CONSTRAINT [DF_HT1400_Orders]  DEFAULT ((0)) FOR [Orders]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1400_IsMale]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1400] ADD  CONSTRAINT [DF_HT1400_IsMale]  DEFAULT ((0)) FOR [IsMale]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1400_IsSingle]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1400] ADD  CONSTRAINT [DF_HT1400_IsSingle]  DEFAULT ((0)) FOR [IsSingle]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1400__IsForeig__52BF8A23]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1400] ADD  CONSTRAINT [DF__HT1400__IsForeig__52BF8A23]  DEFAULT ((0)) FOR [IsForeigner]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1400' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='IdentifyCityID')
	ALTER TABLE HT1400 ADD IdentifyCityID nvarchar(50) NULL
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1400' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT1400' AND col.name = 'NoResident')
		ALTER TABLE HT1400 ADD NoResident TINYINT NULL
	END


IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1400' AND xtype = 'U')
	BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT1400' AND col.name = 'IdentifyEnd')
		ALTER TABLE HT1400 ADD IdentifyEnd datetime  NULL
	END


IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1400' AND xtype = 'U')
	BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT1400' AND col.name = 'DrivingLicenceNo')
		ALTER TABLE HT1400 ADD DrivingLicenceNo nvarchar(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1400' AND xtype = 'U')
	BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT1400' AND col.name = 'DrivingLicenceDate')
		ALTER TABLE HT1400 ADD DrivingLicenceDate datetime  NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1400' AND xtype = 'U')
	BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT1400' AND col.name = 'DrivingLicenceEnd')
		ALTER TABLE HT1400 ADD DrivingLicenceEnd datetime  NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1400' AND xtype = 'U')
	BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT1400' AND col.name = 'DrivingLicencePlace')
		ALTER TABLE HT1400 ADD DrivingLicencePlace nvarchar(50) NULL
	END

---- Alter Columns
Declare @DefaultName nvarchar(200), 
@DefaultText nvarchar(200),
 @AllowNull nvarchar(50), @SQL nvarchar(500),
 @data_type nvarchar(50)
 
If Exists (Select * From sysobjects Where name = 'HT1400' and xtype ='U')
Begin
SELECT @data_type = data_type
FROM information_schema.columns
WHERE table_name = 'HT1400' and column_name = 'Birthday'
	if('datetime' != @data_type)
	begin
		update HT1400 set Birthday = null
		Select @AllowNull = Case When col.isnullable = 1 Then 'NULL' Else 'NOT NULL' End
		From syscolumns col inner join sysobjects tab
		On col.id = tab.id where tab.name = 'HT1400' and col.name = 'Birthday'
		If @AllowNull Is Not Null Begin
		Select @DefaultName = def.name, @DefaultText = cmm.text from sysobjects def inner join syscomments cmm
		on def.id = cmm.id inner join syscolumns col on col.cdefault = def.id
		inner join sysobjects tab on col.id = tab.id
		where tab.name = 'HT1400' and col.name = 'Birthday'
		--drop constraint
		if @DefaultName Is Not Null Execute ('Alter Table HT1400 Drop Constraint ' + @DefaultName)
		--change column type
		Set @SQL = 'Alter Table HT1400 Alter Column Birthday datetime ' + @AllowNull
		Execute(@SQL)
		--restore constraint
		if @DefaultName Is Not Null
		Execute( 'Alter Table HT1400 Add Constraint ' + @DefaultName + ' Default (' + @DefaultText + ') For Birthday')
		End
	End
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1400' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='DrivingLicenceNo')
	ALTER TABLE HT1400 ADD DrivingLicenceNo nvarchar(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='DrivingLicenceDate')
	ALTER TABLE HT1400 ADD DrivingLicenceDate DATETIME NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='DrivingLicenceEnd')
	ALTER TABLE HT1400 ADD DrivingLicenceEnd DATETIME NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='DrivingLicencePlace')
	ALTER TABLE HT1400 ADD DrivingLicencePlace nvarchar(250) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana01ID')
	ALTER TABLE HT1400 ADD Ana01ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana02ID')
	ALTER TABLE HT1400 ADD Ana02ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana03ID')
	ALTER TABLE HT1400 ADD Ana03ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana04ID')
	ALTER TABLE HT1400 ADD Ana04ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana05ID')
	ALTER TABLE HT1400 ADD Ana05ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana06ID')
	ALTER TABLE HT1400 ADD Ana06ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana07ID')
	ALTER TABLE HT1400 ADD Ana07ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana08ID')
	ALTER TABLE HT1400 ADD Ana08ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana09ID')
	ALTER TABLE HT1400 ADD Ana09ID NVARCHAR(50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1400' AND col.name='Ana10ID')
	ALTER TABLE HT1400 ADD Ana10ID NVARCHAR(50) NULL	
END