/****** Object:  Table [dbo].[sysTypeInput]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysTypeInput]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysTypeInput](
	[InputID] [int] IDENTITY(1,1) NOT NULL,
	[InputName] [nvarchar](100) NULL,
	[TypeInputID] [varchar](50) NULL
) ON [PRIMARY]
END