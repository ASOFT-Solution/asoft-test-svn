USE [CDT]
GO

IF EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'sysDatabase'
                  AND xtype = 'U')
  BEGIN
      IF NOT EXISTS (SELECT *
                     FROM   syscolumns col
                            INNER JOIN sysobjects tab
                              ON col.id = tab.id
                     WHERE  tab.name = 'sysDatabase'
                            AND col.name = 'CK')
        ALTER TABLE sysDatabase
          ADD CK VARCHAR (200) NULL
  END
