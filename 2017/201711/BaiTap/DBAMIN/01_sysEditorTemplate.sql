/****** Object:  Table [dbo].[sysEditorTemplate]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysEditorTemplate]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysEditorTemplate](
	[sysEditorTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[EditorTemplateName] [nvarchar](50) NULL,
	[EditorTemplateID] [varchar](50) NULL,
 CONSTRAINT [PK_EventTemplate] PRIMARY KEY CLUSTERED 
(
	[sysEditorTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END