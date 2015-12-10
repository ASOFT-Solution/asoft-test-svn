USE [CDT]

IF NOT EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'ListType'
                  AND xtype = 'U')
BEGIN

CREATE TABLE [dbo].[ListType](
	[ListTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ListType] [nvarchar](512) NOT NULL,
	[ListType2] [nvarchar](512) NULL,
 CONSTRAINT [PK_ListType] PRIMARY KEY CLUSTERED 
(
	[ListTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
