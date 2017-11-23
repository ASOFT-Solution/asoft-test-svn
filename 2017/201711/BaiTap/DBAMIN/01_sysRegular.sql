/****** Object:  Table [dbo].[sysRegular]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysRegular]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysRegular](
	[sysRegularID] [int] IDENTITY(1,1) NOT NULL,
	[Pattern] [varchar](100) NULL,
	[Message] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[RegularID] [varchar](50) NULL,
 CONSTRAINT [PK_sysRegular] PRIMARY KEY CLUSTERED 
(
	[sysRegularID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END