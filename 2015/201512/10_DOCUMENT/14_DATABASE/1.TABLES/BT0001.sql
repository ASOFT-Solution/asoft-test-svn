-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BT0001]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BT0001](	
	[Type] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CustomizeSchedule_Type] DEFAULT (''),
	[ReportCode1] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CustomizeSchedule_ReportCode1] DEFAULT (''),
	[ReportCode2] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CustomizeSchedule_ReportCode2] DEFAULT (''),
	[ReportCode3] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CustomizeSchedule_ReportCode3] DEFAULT (''),
	[ReportCode4] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CustomizeSchedule_ReportCode4] DEFAULT (''),
	[ReportCode5] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CustomizeSchedule_ReportCode5] DEFAULT ('')
)
END