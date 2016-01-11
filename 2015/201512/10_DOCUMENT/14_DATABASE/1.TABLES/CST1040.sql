-- <Summary>
---- 
-- <History>
---- Create on 27/09/2013 by Thanh Sơn
---- Modified on 07/08/2013 by Le Thi Thu Hien
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CST1040]') AND type in (N'U')) 
BEGIN
	CREATE TABLE [dbo].[CST1040](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[DeviceID] [nvarchar](50) NOT NULL,
		[DeviceName] [nvarchar](250) NULL,
		[DeviceGroupID] [nvarchar] (50) NULL,
		[CheckTypeID] [nvarchar] (50) NULL,
		[RateByTon] [decimal](28,8) NULL,
		[RateByHour] [decimal](28,8) NULL,
		[RateByTrip] [decimal](28,8) NULL,
		[ManufactureYear] [int] NULL,
		[UseDate] [datetime] NULL,
		[RegistrationDate] [datetime] NULL,
		[RegistrationLimit] [datetime] NULL,
		[LiftCapacity] [nvarchar](50) NULL,
		[Load] [nvarchar](50) NULL,
		[LiftSpeed] [nvarchar](50) NULL,
		[Size] [nvarchar](50) NULL,
		[FrameNumber] [nvarchar](50) NULL,
		[EngineNumber] [nvarchar](50) NULL,
		[MoveSpeed] [nvarchar](50) NULL,
		[LiftHours] [int] NULL,
		[Model] [nvarchar](50) NULL,
		[AssetID] [nvarchar](50) NULL,
		[DeviceNumber] [nvarchar](50) NULL,
		[BeginHours] [int] NULL,
		[DeleteFlag] [tinyint] default(0) NOT NULL,
		[Disabled] [tinyint] default(0) NOT NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[CreateDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
	 CONSTRAINT [PK_CST1040] PRIMARY KEY CLUSTERED 
	(
		[DivisionID] ASC,
 		[DeviceID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'CST1040' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'CST1040'  and col.name = 'DeviceTypeID')
           Alter Table  CST1040 Add DeviceTypeID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'CST1040' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'CST1040'  and col.name = 'RateByKm')
           Alter Table  CST1040 Add RateByKm decimal(28,8) Null
End 