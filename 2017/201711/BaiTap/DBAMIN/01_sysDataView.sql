/****** Object:  Table [dbo].[sysDataView]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysDataView]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysDataView](
	[sysDataViewID] [int] IDENTITY(1,1) NOT NULL,
	[sysDataViewName] [nvarchar](20) NULL,
	[DataViewID] [varchar](50) NULL,
 CONSTRAINT [PK_sysDataView] PRIMARY KEY CLUSTERED 
(
	[sysDataViewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END