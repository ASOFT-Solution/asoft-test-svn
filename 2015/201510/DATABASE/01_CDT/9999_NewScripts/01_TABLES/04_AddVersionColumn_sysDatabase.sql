USE [CDT]
GO

IF EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'sysSite'
                  AND xtype = 'U')
  BEGIN
      IF NOT EXISTS (SELECT *
                     FROM   syscolumns col
                            INNER JOIN sysobjects tab
                              ON col.id = tab.id
                     WHERE  tab.name = 'sysSite'
                            AND col.name = 'DBVersion')
        ALTER TABLE sysSite
          ADD DBVersion VARCHAR (200) NULL
  END
