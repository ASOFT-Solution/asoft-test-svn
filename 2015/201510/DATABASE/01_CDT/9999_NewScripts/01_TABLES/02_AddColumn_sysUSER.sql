USE [CDT]

GO

-- Thêm cột DbName vào bảng sysUser
IF EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'sysUser'
                  AND xtype = 'U')
  BEGIN
      IF NOT EXISTS (SELECT *
                     FROM   syscolumns col
                            INNER JOIN sysobjects tab
                              ON col.id = tab.id
                     WHERE  tab.name = 'sysUser'
                            AND col.name = 'DbName')
        ALTER TABLE sysUser
          ADD DbName VARCHAR (50) NOT NULL DEFAULT('CDT')
  END

GO
-- Modify delete cascade in foreign key in sysUser
 