
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NewVoucherAuto]') AND type in (N'U'))
BEGIN
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[NewVoucherAuto](
	[NewVoucherAutoID] [int] IDENTITY(1,1) NOT NULL,
	[MaCT] [nvarchar](512)   NOT NULL,
	[Prefix] [nvarchar](512) NULL,
	[BeginValue] [nchar](10) NULL,
	[LengthOfValue] [int] NOT NULL
) ON [PRIMARY]
END