-- <Summary>
---- 
-- <History>
---- Create on 27/09/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CST1070]') AND type in (N'U')) 
BEGIN
	CREATE TABLE [dbo].[CST1070](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[DeviceTypeID] [nvarchar](50) NOT NULL,
		[DeviceTypeName] [nvarchar](250) NULL,
		[DeviceGroupID] [nvarchar](50) NOT NULL,
		[CheckTypeID] [nvarchar] (50) NOT NULL,
		[RateByTon] [int] NULL,
		[RateByHour] [int] NULL,
		[RateByTrip] [int] NULL,
		[RateByKm] [int] NULL,
		[DeleteFlag] [tinyint] default(0) NOT NULL,
		[Disabled] [tinyint] default(0) NOT NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[CreateDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
	 CONSTRAINT [PK_CST1070] PRIMARY KEY CLUSTERED 
	(
		[DivisionID] ASC,
 		[DeviceTypeID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

