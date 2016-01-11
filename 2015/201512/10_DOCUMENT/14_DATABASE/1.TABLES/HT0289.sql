-- <Summary>
---- 
-- <History>
---- Create on 12/09/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0289]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0289](
	[APK] [uniqueidentifier] DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[TimesID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[TrackingDate] [datetime]NULL,
	[ShiftID][NVARCHAR](50)NULL,
	[AllocationID][uniqueidentifier] NOT NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[OriginalQuantity] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL	
 CONSTRAINT [PK_HT0289] PRIMARY KEY CLUSTERED 
(
	APK ASC	
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
