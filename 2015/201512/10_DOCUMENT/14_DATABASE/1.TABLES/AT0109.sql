-- <Summary>
---- 
-- <History>
---- Create on 11/08/2014 by Lê Thị Thu Hiền
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0109]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0109](
	[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[PromoteID] [nvarchar](50) NOT NULL,
	[PromoteName] [nvarchar](250) NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[Description] [nvarchar](250) NULL,
	[IsCommon] [tinyint] NULL,
	[Disabled] [tinyint] NOT NULL,	
	[OrderNo] [int] NOT NULL,
	[FromValues] [decimal](28, 8) NULL,
	[ToValues] [decimal](28, 8) NULL,
	[DiscountPercent] [decimal](28, 8) NULL,
	[DiscountAmount] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,	
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,		
 CONSTRAINT [PK_AT0109] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[PromoteID] ASC,
	[APK] ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END