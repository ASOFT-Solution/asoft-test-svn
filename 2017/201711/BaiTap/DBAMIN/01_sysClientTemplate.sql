/****** Object:  Table [dbo].[sysClientTemplate]    Script Date: 1/21/2016 1:57:41 PM ******/

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysClientTemplate]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysClientTemplate](
	[sysClientTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[functionClientTemplate] [nvarchar](300) NULL,
	[ClientTemplateID] [varchar](50) NULL,
 CONSTRAINT [PK_sysClientTemplate] PRIMARY KEY CLUSTERED 
(
	[sysClientTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END