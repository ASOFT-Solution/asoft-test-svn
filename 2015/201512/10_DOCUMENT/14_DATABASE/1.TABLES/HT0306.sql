-- <Summary>
---- 
-- <History>
---- Create on 29/10/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0306]') AND type in (N'U'))
BEGIN

	CREATE TABLE [dbo].[HT0306](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[ID] [nvarchar](50) NOT NULL,
		[Description] [nvarchar](250) NULL,
		[FromDate] datetime NULL,
		[ToDate] datetime NULL,
		[ConditionTypeID] [nvarchar](3) NOT NULL,
		[InYearsFrom] int NULL,
		[InYearsTo] int NULL,
		[WorkConditionTypeID] [nvarchar](3) NULL,
		[MaxLeaveDays] int NULL,
		[ConditionCode] [nvarchar](4000) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT0306] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
