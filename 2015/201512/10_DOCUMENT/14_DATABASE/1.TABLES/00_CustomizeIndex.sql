IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CustomerIndex]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[CustomerIndex]
     (
      [CustomerName] INT NOT NULL,
      [ImportExcel] INT NULL
    CONSTRAINT [PK_CustomerIndex] PRIMARY KEY CLUSTERED
      (
      [CustomerName]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END