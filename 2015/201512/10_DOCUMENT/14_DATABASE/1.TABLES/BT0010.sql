-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BT0010]') AND type in (N'U')) 	
BEGIN	
CREATE TABLE [dbo].[BT0010](	
	[ReportCode] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ReportCode] DEFAULT (''),
	[ReportName] nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ReportName] DEFAULT (''),
	[ChartType] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ChartType] DEFAULT (''),
	[IsGeneral] int NOT NULL CONSTRAINT [DF_BT0010_IsGeneral] DEFAULT (0),
	[Selection01ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_Selection01ID] DEFAULT (''),
	[Selection02ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_Selection02ID] DEFAULT (''),
	[Selection03ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_Selection03ID] DEFAULT (''),
	[Selection04ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_Selection04ID] DEFAULT (''),
	[Selection05ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_Selection05ID] DEFAULT (''),
	[FromSelection01ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_FromSelection01ID] DEFAULT (''),
	[FromSelection02ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_FromSelection02ID] DEFAULT (''),
	[FromSelection03ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_FromSelection03ID] DEFAULT (''),
	[FromSelection04ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_FromSelection04ID] DEFAULT (''),
	[FromSelection05ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_FromSelection05ID] DEFAULT (''),
	[ToSelection01ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ToSelection01ID] DEFAULT (''),
	[ToSelection02ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ToSelection02ID] DEFAULT (''),
	[ToSelection03ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ToSelection03ID] DEFAULT (''),
	[ToSelection04ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ToSelection04ID] DEFAULT (''),
	[ToSelection05ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0010_ToSelection05ID] DEFAULT ('')
)
END