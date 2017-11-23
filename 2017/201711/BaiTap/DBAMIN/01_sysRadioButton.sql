/****** Object:  Table [dbo].[sysFieldType]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysRadioButton]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysRadioButton](
	[sysRadioButtonID] [int] IDENTITY(1,1) NOT NULL,
	[StoreName] [varchar](20) NULL,
	[StoreParameter] [varchar](500) NULL,
	[SQLQuery] [nvarchar](1000) NULL,
	[RadioButtonID] [varchar](50) NULL,
 CONSTRAINT [PK_sysRadioButton] PRIMARY KEY CLUSTERED 
(
	[sysRadioButtonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END