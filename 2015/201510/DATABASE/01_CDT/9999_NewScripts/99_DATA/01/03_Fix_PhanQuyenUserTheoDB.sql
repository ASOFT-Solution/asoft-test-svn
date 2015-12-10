use [CDT]
declare @sysFieldID as int
declare @sysTableID as int
-- Tạo trường dbName trong bảng sysTable
select @sysTableID =  sysTableID from sysTable where TableName = 'sysUser'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'DbName'
				and sysTableID = @sysTableID
				
IF NOT EXISTS (SELECT TOP 1 1
               FROM   sysField
               WHERE  sysFieldID = @sysFieldID) 
Begin
INSERT INTO [CDT].[dbo].[sysField]
            ([sysTableID], [FieldName],[AllowNull],[RefField],[RefTable],
             [DisplayMember],[RefCriteria],[Type],[LabelName],[LabelName2],
             [TabIndex],[Formula],[FormulaDetail],[MaxValue],[MinValue],
             [DefaultValue],[Tip],[TipE],[Visible],[IsBottom],
             [IsFixCol],[IsGroupCol],[SmartView],[RefName], [DefaultName],
             [EditMask],[IsUnique],[DynCriteria])
VALUES      (@sysTableID, 'DbName', 0, NULL, NULL,
             NULL,NULL, 2, 'Tên database','DatabaseName',
             4, NULL,NULL,NULL,NULL,
             NULL,NULL,NULL,0,0,
             0,0,0,NULL,NULL,
             NULL,0,NULL)
End
             
--Update extraSQL trong các bảng sau
---Danh sách user
UPDATE [dbo].[sysMenu]
   SET [ExtraSql] = 'DbName = @@DbName'
 WHERE MenuName = N'Quản lý người dùng'
 
---Phân quyền sử dụng đơn vị
UPDATE[dbo].[sysMenu]
   SET [ExtraSql] = 'sysUserID in (select sysUserID from sysUser where DbName = @@DbName)'
 WHERE MenuName = N'Phân quyền sử dụng đơn vị'
 
 UPDATE [CDT].[dbo].[sysField]
   SET [RefCriteria] = 'sysUserID in (select sysUserID from sysUser where DbName = @@DbName)'
 WHERE sysTableID = (select sysTableID from sysTable where TableName = 'sysUserSite') AND FieldName = 'sysUserID'
 
 ---Phân quyền thực thi chức năng
  UPDATE [CDT].[dbo].[sysMenu]
   SET [ExtraSql] = 'IsAdmin = 0 and sysUserID in (select sysUserID from sysUser where DbName = @@DbName)'
 WHERE MenuName = N'Phân quyền thực thi dữ liệu'

 ---Phân quyền sử dụng dữ liệu
UPDATE sysField
SET    Visible = 0
WHERE  sysTableID = (SELECT sysTableID
                     FROM   [sysTable]
                     WHERE  TableName = N'sysUserTable')
       AND FieldName = N'sysUserSiteID' 
 
 --- Phân quyền sử dụng trường dữ liệu
 UPDATE [CDT].[dbo].[sysMenu]
   SET [ExtraSql] = 'IsAdmin = 0 and sysUserID in (select sysUserID from sysUser where DbName = @@DbName)'
 WHERE MenuName = N'Phân quyền sử dụng trường dữ liệu'
 --- Theo dõi quá trình sử dụng
 UPDATE [CDT].[dbo].[sysReport]
   SET [Query] = N'select u.UserName, m.MenuName,  h.*   from sysHistory h, sysUser u, sysMenu m  where  u.sysUserID =* h.sysUserID    and h.sysMenuID *= m.sysMenuID and h.DbName = @@DbName And @@ps  order by h.hDateTime'
 WHERE ReportName = N'Xem thông tin lưu vết người dùng'
 
 UPDATE sysField
 SET    RefCriteria = N' sysUserID in (select sysUserID from sysUser where DbName = @@DbName)'
 WHERE  sysFieldID IN
        (SELECT sysFieldID
         FROM   sysReportFilter
         WHERE  sysReportID = (SELECT sysReportID
                               FROM   [dbo].[sysMenu]
                               WHERE  MenuName = N'Theo dõi quá trình sử dụng'))
        AND FieldName = N'sysUserID' 
        AND sysTableID = (select sysTableID from sysTable where TableName = 'sysHistory')
 
--- Tổng hợp nhật ký in hóa đơn
 UPDATE [CDT].[dbo].[sysReport]
   SET [Query] = N'SELECT u.UserName AS N''Người in'', m.MenuName AS N''Tên menu'', h.PkValue AS N''Số chứng từ'', COUNT(sysHistoryID) AS N''Số lần in'' FROM sysHistory h INNER JOIN sysUser u ON u.sysUserID = h.sysUserID INNER JOIN sysMenu m ON m.sysMenuID = h.sysMenuID WHERE Action = ''In'' And h.DbName = @@DBNAME GROUP BY u.UserName, m.MenuName, h.PkValue ORDER BY u.UserName, m.MenuName, h.PkValue '
 WHERE ReportName = N'Tổng hợp nhật ký in hóa đơn' 
 
 UPDATE sysField
 SET    RefCriteria = N' sysUserID in (select sysUserID from sysUser where DbName = @@DbName)'
 WHERE  sysFieldID IN
        (SELECT sysFieldID
         FROM   sysReportFilter
         WHERE  sysReportID = (SELECT sysReportID
                               FROM   [dbo].[sysMenu]
                               WHERE  MenuName = N'Tổng hợp nhật ký in hóa đơn'))
        AND FieldName = N'sysUserID' 
        AND sysTableID = (select sysTableID from sysTable where TableName = 'sysHistory')
 
 
-- Copy user hiện tại ra cho các database --
---B1. Copy user theo DBName có sẳn trong hệ thống
DECLARE @sysUserID int, @sysSiteID int , @DbName nvarchar(50),@cur cursor
declare @UserName nvarchar(128)

SET @cur = CURSOR FOR SELECT
                          sysSiteID,DbName 
                      FROM
                          sysDatabase
                      WHERE
                          dbName <> N'CDT'
OPEN @cur
FETCH NEXT FROM @cur INTO @sysUserID, @DbName
WHILE @@FETCH_STATUS = 0
  BEGIN
    ---- Nếu chưa update database
	IF NOT EXISTS (SELECT TOP 1 1  FROM  sysUser WHERE  DbName = @DbName)
	BEGIN
	---- Copy user
      INSERT INTO sysUser (UserName, FullName, [Password], CoreAdmin, DbName )
		SELECT  s2.UserName, s2.FullName, s2.[Password], s2.CoreAdmin,@DbName
		FROM    sysUser s2
		WHERE   dbName =N'CDT'
    END
     FETCH NEXT FROM @cur INTO @sysUserID, @DbName
  END
Close @cur

---B2. Insert vào bảng phân quyền đơn vị
SET @cur = CURSOR FOR SELECT p.sysUserID, p.DbName , p.UserName
						FROM   sysUser p 
						WHERE  p.UserName in (SELECT u.UserName
                                              FROM   sysUser u
                                                     INNER JOIN sysUserSite s
                                                       ON ( u.sysUserID = s.sysUserID ))
                        AND p.DbName <> N'CDT'
                                               

OPEN @cur
FETCH NEXT FROM @cur INTO @sysUserID, @DbName , @UserName

WHILE @@FETCH_STATUS = 0
  BEGIN
	 ---- Nếu chưa update database
      IF NOT EXISTS (SELECT TOP 1 1
                     FROM   sysUserSite
                     WHERE  sysUserID = @sysUserID)
        BEGIN
	---- Tạo Phân quyền sử dụng đơn vị
            INSERT INTO sysUserSite
                        (sysUserID,
                         [sysSiteID],
                         [IsAdmin])
            SELECT @sysUserID,
                   s2.[sysSiteID],
                   s2.[IsAdmin]
            FROM   sysUserSite s2
            WHERE  sysUserID = (SELECT sysUserID
                                FROM   sysUser
                                WHERE  UserName =@UserName
                                       AND dbName = N'CDT')
        END

      FETCH NEXT FROM @cur INTO @sysUserID, @DbName, @UserName
  END

CLOSE @cur 



---B3. Insert vào bảng phân quyền
----sử dụng chức năng
----thực thi dữ liệu
----sử dụng trường dữ liệu
 
declare @sysUserSiteID int

SET @cur = CURSOR FOR  SELECT p.sysUSerSiteID, USerName
                         FROM   sysUserSite p
                                INNER JOIN sysUser
                                  ON p.sysUserID = sysUser.sysUSerID 
						 WHERE  EXISTS (SELECT [sysUserID]
                                      FROM   [CDT].[dbo].[sysUser]
                                      WHERE  USerName IN
                                             (SELECT u.UserName
                                              FROM   sysUser u
                                                     INNER JOIN sysUserSite s
                                                       ON ( u.sysUserID = s.sysUserID )
                                                     INNER JOIN sysUserMenu m
                                                       ON ( s.sysUserSiteID = m.sysUserSiteID ))
                                             AND sysUserID = p.sysUserID
                                             AND dbName <> 'CDT') 
                       
							
OPEN @cur
FETCH NEXT FROM @cur INTO  @sysUserSiteID, @UserName
WHILE @@FETCH_STATUS = 0
  BEGIN
    ---- 3.1 Phân quyền sử dụng chức năng---------
	IF NOT EXISTS (	SELECT TOP 1 1 FROM   sysUserMenu t
						WHERE t.sysUserSiteID  = @sysUserSiteID)  
	BEGIN
      INSERT INTO sysUserMenu (sysMenuID, [Executable], sysUserSiteID, sysMenuParentID)
	      SELECT DISTINCT m.sysMenuID, m.Executable,@sysUserSiteID,m.sysMenuParentID
	      FROM   sysUserSite s
				   INNER JOIN sysUser u
					 ON s.sysUserID = u.sysUserID
				   INNER JOIN sysUserMenu m
					 ON s.sysUserSiteID = m.sysUserSiteID
		  WHERE u.DBName = 'CDT' and u.UserName = @UserName     
    END
    ---- 3.2 Tạo Phân quyền sử dụng Thực thi dữ liệu ---------
	IF NOT EXISTS (	SELECT TOP 1 1 FROM   sysUserTable t
						WHERE t.sysUserSiteID  = @sysUserSiteID)  
	BEGIN
     INSERT INTO sysUserTable (sysTableID, sSelect, sInsert,sUpdate, sysUserSiteID)
	      SELECT DISTINCT t.systableID, t.sSelect, t.sInsert, t.sUpdate, @sysUserSiteID
	      FROM   sysUserSite s
				   INNER JOIN sysUser u
					 ON s.sysUserID = u.sysUserID
				   INNER JOIN sysUserTable t
					 ON s.sysUserSiteID = t.sysUserSiteID
		  WHERE u.DBName = 'CDT' and u.UserName = @UserName 
    END
    ---- 3.3 Tạo phân quyền sử dụng trường dữ liệu -----
	IF NOT EXISTS (	SELECT TOP 1 1 FROM   sysUserField t
						WHERE t.sysUserSiteID  = @sysUserSiteID)  
	BEGIN
     INSERT INTO sysUserField (sysFieldID, Viewable, Editable,sysUserSiteID)
	      SELECT DISTINCT f.sysFieldID,f.Viewable,f.Editable ,@sysUserSiteID
	      FROM   sysUserSite s
				   INNER JOIN sysUser u
					 ON s.sysUserID = u.sysUserID
				   INNER JOIN sysUserField f
					 ON s.sysUserSiteID = f.sysUserSiteID
		  WHERE u.DBName = 'CDT' and u.UserName = @UserName 
    END
     FETCH NEXT FROM @cur INTO @sysUserSiteID,@UserName
  END
Close @cur

GO
