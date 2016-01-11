-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BT0011]') AND type in (N'U')) 		
BEGIN		
CREATE TABLE [dbo].[BT0011](		
	[ColumnID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_ColumnID] DEFAULT (''),	
	[ColumnCaption] nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_ColumnCaption] DEFAULT (''),	
	[ColumnType] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_ColumnType] DEFAULT (''),	
	[IsOriginal] int NOT NULL CONSTRAINT [DF_BT0011_IsOriginal] DEFAULT (0),	
	[Source] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Source] DEFAULT (''),	
	[FromAccountID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_FromAccountID] DEFAULT (''),	
	[ToAccountID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_ToAccountID] DEFAULT (''),	
	[FromCorAccountID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_FromCorAccountID] DEFAULT (''),	
	[ToCorAccountID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_ToCorAccountID] DEFAULT (''),	
	[Color] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Color] DEFAULT (''),	
	[Sign1] int NOT NULL CONSTRAINT [DF_BT0011_Sign1] DEFAULT (0),	
	[Sign2] int NOT NULL CONSTRAINT [DF_BT0011_Sign2] DEFAULT (0),	
	[Sign3] int NOT NULL CONSTRAINT [DF_BT0011_Sign3] DEFAULT (0),	
	[Sign4] int NOT NULL CONSTRAINT [DF_BT0011_Sign4] DEFAULT (0),	
	[Column01ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Column01ID] DEFAULT (''),	
	[Column02ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Column02ID] DEFAULT (''),	
	[Column03ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Column03ID] DEFAULT (''),	
	[Column04ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Column04ID] DEFAULT (''),	
	[Column05ID] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BT0011_Column05ID] DEFAULT ('')	
)
END