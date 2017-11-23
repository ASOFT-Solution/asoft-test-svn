/****** Object:  Table [dbo].[sysReturnResult]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysReturnResult]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysReturnResult](
	[sysReturnResultID] [int] IDENTITY(1,1) NOT NULL,
	[ReturnResultID] [int] NOT NULL,
	[ReturnResult] [varchar](1000) NULL,
	[Condition] [varchar](500) NOT NULL,
 CONSTRAINT [PK_sysReturnResult] PRIMARY KEY CLUSTERED 
(
	[ReturnResultID] ASC,
	[Condition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END