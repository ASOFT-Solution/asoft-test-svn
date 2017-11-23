/****** Object:  Table [dbo].[sysCategoryBusiness]    Script Date: 1/21/2016 1:57:41 PM ******/

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysCategoryBusiness]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysCategoryBusiness](
	[sysCategoryBusiness] [int] IDENTITY(1,1) NOT NULL,
	[sysNameCategoryBusiness] [nvarchar](50) NULL,
	[CategoryBusinessID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_sysCategoryBusiness] PRIMARY KEY CLUSTERED 
(
	[sysCategoryBusiness] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END