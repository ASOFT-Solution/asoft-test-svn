IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1409]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1409]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Kiem tra quyen
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/08/2007 by Dang Le Bao Quynh
---- Modified on 02/04/2009 by Dang Le Bao Quynh: Bo sung phan quyen gia ban cho Asoftt va OP
---- Modified on 29/07/2010 by Việt Khánh
---- Modified on 07/09/2011 by Nguyễn Bình Minh	: Sửa phần lấy nhóm user, nếu @GroupID = '' thì lấy hết các nhóm mà user thuộc về
---- Modified on 11/11/2011 by Huynh Tan Phu	: Tăng kích thước biến BeginChar từ 100-> 4000. Fix bug id 0013006
---- Modified on 13/11/2012 by Lê Thị Thu Hiền	: Bổ sung kiểm tra trong bảng AT1412 Thiết lập phân quyền dữ liệu
---- Modified on 13/08/2013 by Lê Thị Thu Hiền	: Bổ sung thêm biến để in hay không in dữ liệu
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP1409] 
    @DivisionID NVARCHAR(50), 
    @ModuleID NVARCHAR(50), 
    @DataID NVARCHAR(50), 
    @DataType char(2), 
    @UserID NVARCHAR(50), 
   	@GroupID as nvarchar(50) = '',
    @Permission INT = 0 OUTPUT, 
    @Condition NVARCHAR(4000) = '%' OUTPUT ,
    @IsPrint AS TINYINT = 0
AS

DECLARE 
    @BeginChar NVARCHAR(4000), 
    @BeginCharRep NVARCHAR(4000), 
    @InsCondition NVARCHAR(4000),
   	@CountPermission as int,
	@CountRecord as INT,
	@GroupIDList AS NVARCHAR (4000)

SET @BeginChar = '' 
SET @Permission = 0
SET @Condition = '%'
SET @GroupIDList = ''

SET NOCOUNT ON
SELECT	GroupID
INTO	#GroupList 
FROM	AT1402
WHERE	UserID = @UserID 
		AND DivisionID = @DivisionID 
		AND GroupID = CASE WHEN @GroupID = '' THEN GroupID ELSE @GroupID END
 
SELECT	@GroupIDList = CASE WHEN @GroupIDList = '' THEN '' ELSE ',' END + '''' + GroupID + '''' 
FROM	#GroupList
  
--if @GroupID = '' SELECT TOP 1 @GroupID = GroupID FROM AT1402 WHERE UserID = @UserID and DivisionID = @DivisionID

IF @DataType IN ('PE')
    BEGIN
        SELECT @Permission = MAX(Permission) 
        FROM AT1406
        WHERE DivisionID = @DivisionID
            AND ModuleID = @ModuleID
            AND DataType = @DataType 
            AND GroupID IN (SELECT GroupID FROM #GroupList)
            AND DataID = @DataID
    END 

IF @DataType IN ('WA', 'AC')
    BEGIN
        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT DataID FROM AT1406 
        WHERE DivisionID = ''' + @DivisionID + ''' 
        AND ModuleID = ''' + @ModuleID + ''' 
        AND DataType = ''' + @DataType + ''' 
        AND GroupID IN (' + @GroupIDList + ')
        AND Permission = 1)'

        SELECT	@Permission = MAX(Permission) 
        FROM	AT1406
        WHERE	DivisionID = @DivisionID
				AND ModuleID = @ModuleID
				AND DataType = @DataType 
				AND GroupID IN (SELECT GroupID FROM #GroupList)
				AND DataID = @DataID
    END

IF @DataType IN ('VT')
    BEGIN
        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT DataID FROM AT1406 
        WHERE DivisionID = ''' + @DivisionID + ''' 
        AND ModuleID = ''' + @ModuleID + ''' 
        AND DataType = ''' + @DataType + ''' 
        AND GroupID IN (' + @GroupIDList + ')
        AND Permission = 1)'

        SELECT @Permission = Permission FROM AT1406
        WHERE DivisionID = @DivisionID
        AND ModuleID = @ModuleID
        AND DataType = @DataType 
        AND GroupID IN (SELECT GroupID FROM #GroupList)
        AND DataID = @DataID
    END

IF @DataType IN ('OB')
    BEGIN
        SELECT @BeginChar = BeginChar, @Permission = Permission FROM AT1406 
        WHERE DivisionID = @DivisionID
        AND ModuleID = @ModuleID
        AND DataType = @DataType 
        AND GroupID IN (SELECT GroupID FROM #GroupList)
        AND DataID = @DataID
        
        IF len(@BeginChar)>0
            BEGIN
                IF @Permission = 1
                    BEGIN
                        SET @BeginCharRep = ' LIKE ''' + replace(@BeginChar, ';', '%'' OR ObjectID LIKE ''') + '%'''
                   SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT ObjectID FROM AT1202 WHERE DivisionID = ''' + @DivisionID + ''' AND ObjectID ' + @BeginCharRep + ') '
						        
     END
                ELSE
                    BEGIN
                        SET @BeginCharRep = ' NOT LIKE ''' + replace(@BeginChar, ';', '%'' AND ObjectID NOT LIKE ''') + '%'''
                        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT ObjectID FROM AT1202 WHERE DivisionID = ''' + @DivisionID + ''' AND ObjectID ' + @BeginCharRep + ') '
                    END
            END
            ELSE
                BEGIN
                    IF @Permission = 1
                        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT ObjectID FROM AT1202 WHERE DivisionID = ''' + @DivisionID + ''') '
                    ELSE
                        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID) '
                END
/* 
IF len(@BeginChar)>0
BEGIN

IF @Permission = 1
BEGIN
SET @BeginCharRep = ' LIKE ''' + replace(@BeginChar, ';', '%'' OR ObjectID LIKE ''') + '%'''
Delete AT1222 WHERE PID = @@SPID AND DataType = 'OB'
SET @InsCondition = 'INSERT INTO AT1222 SELECT @@SPID, ''OB'', ObjectID FROM AT1202 WHERE ObjectID ' + @BeginCharRep + ' UNION ALL SELECT @@SPID, ''OB'', '''' AS ObjectID'
EXEC (@InsCondition)
SET @Condition = ' (SELECT TOP 100 Percent DataID FROM AT1222 WHERE PID = @@SPID AND DataType = ''OB'' ORDER BY DataID)'
END
ELSE
BEGIN
SET @BeginCharRep = ' NOT LIKE ''' + replace(@BeginChar, ';', '%'' AND ObjectID NOT LIKE ''') + '%'''
Delete AT1222 WHERE PID = @@SPID AND DataType = 'OB'
SET @InsCondition = 'INSERT INTO AT1222 SELECT @@SPID, ''OB'', ObjectID FROM AT1202 WHERE ObjectID ' + @BeginCharRep + ' UNION ALL SELECT @@SPID, ''OB'', '''' AS ObjectID'
EXEC (@InsCondition)
SET @Condition = ' (SELECT TOP 100 Percent DataID FROM AT1222 WHERE PID = @@SPID AND DataType = ''OB'' ORDER BY DataID)'
END
END
ELSE
BEGIN
IF @Permission = 1
BEGIN
Delete AT1222 WHERE PID = @@SPID AND DataType = 'OB'
SET @InsCondition = 'INSERT INTO AT1222 SELECT @@SPID, ''OB'', ObjectID FROM AT1202 UNION ALL SELECT @@SPID, ''OB'', '''' AS ObjectID'
EXEC (@InsCondition)
SET @Condition = ' (SELECT TOP 100 Percent DataID FROM AT1222 WHERE PID = @@SPID AND DataType = ''OB'' ORDER BY DataID)'
END
ELSE
SET @Condition = ' (SELECT ''#'' AS ObjectID) '
END
*/
    END 

IF @DataType IN ('IV') AND @DataID <> 'LP'
    BEGIN
        SELECT @BeginChar = BeginChar, @Permission = Permission FROM AT1406 
        WHERE DivisionID = @DivisionID
        AND ModuleID = @ModuleID
        AND DataType = @DataType 
        AND GroupID IN (SELECT GroupID FROM #GroupList)
        AND DataID = @DataID
        
        IF len(@BeginChar)>0
            BEGIN
                IF @Permission = 1
                    BEGIN
                        SET @BeginCharRep = ' LIKE ''' + replace(@BeginChar, ';', '%'' OR InventoryID LIKE ''') + '%'''
                        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT InventoryID FROM AT1302 WHERE DivisionID = ''' + @DivisionID + ''' AND InventoryID ' + @BeginCharRep + ') '
                    END
                ELSE
                    BEGIN
                        SET @BeginCharRep = ' NOT LIKE ''' + replace(@BeginChar, ';', '%'' AND InventoryID NOT LIKE ''') + '%'''
                        SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT InventoryID FROM AT1302 WHERE DivisionID = ''' + @DivisionID + ''' AND InventoryID ' + @BeginCharRep + ') '
                    END
            END
        ELSE
        BEGIN
            IF @Permission = 1
                SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID UNION ALL SELECT InventoryID FROM AT1302 WHERE DivisionID = ''' + @DivisionID + ''') '
            ELSE
                SET @Condition = ' (SELECT '''' AS DataID UNION ALL SELECT ''#'' AS DataID) '
        END
    END

--Phan quyen gia ban
IF @DataType IN ('IV') AND @DataID = 'LP'
    BEGIN
        SELECT @Permission = Permission FROM AT1406
        WHERE DivisionID = @DivisionID
        AND ModuleID = @ModuleID
        AND DataType = @DataType 
        AND GroupID IN (SELECT GroupID FROM #GroupList)
        AND DataID = @DataID
    END

-- Phân quyền phòng ban nhân viên
If @DataType In ('DE')
Begin
	Select @CountPermission = count(*) From AT1406 
	Where DivisionID = @DivisionID 
		And ModuleID = @ModuleID
		And DataType = @DataType
		And GroupID IN (SELECT GroupID FROM #GroupList)
		And Permission = 1
		
	Select @CountRecord = count(*) from AT1102 Where DivisionID = @DivisionID and Disabled=0
	
	Set @Condition = ' (Select '''' As DataID Union All Select ''#'' As DataID '
	
	If @CountPermission = @CountRecord
	Begin
		Set @Condition = @Condition + 'Union All Select ''%'' as DataID '
	End
	
	Set @Condition = @Condition + 'Union All Select DataID From AT1406 
				Where DivisionID = ''' + @DivisionID + ''' 
				And ModuleID = ''' + @ModuleID + ''' 
				And DataType = ''' + @DataType + ''' 
				And GroupID IN (' + @GroupIDList + ')
				And Permission = 1 )'
	
	Select @Permission = Permission From AT1406
	Where 	DivisionID = @DivisionID
		And ModuleID = @ModuleID
		And DataType = @DataType 
		And GroupID IN (SELECT GroupID FROM #GroupList)
		And DataID = @DataID
End
------------- Thiết lập phân quyền dữ liệu 
IF EXISTS( SELECT TOP 1 1 FROM AT1412 WHERE	DivisionID = @DivisionID 
									AND DataTypeID = @DataType 
									AND ModuleID = @ModuleID
									AND GroupID = @GroupID
									AND (ISNULL(Permission,0) = 0 OR GroupID = 'ADMIN')
									AND DataTypeID IN ('AC', 'DE', 'IV', 'OB', 'VT', 'WA')	
			)
BEGIN
	SET @Condition = ''
END

IF @IsPrint = 0
SELECT @Permission AS Permission, @Condition AS Condition



SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

