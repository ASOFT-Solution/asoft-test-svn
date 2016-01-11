IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1411]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1411]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Modified on 13/11/2012 by : Le Thi Thu Hien : Bo sung AT1412

CREATE PROCEDURE [dbo].[AP1411]
	@DivisionID NVARCHAR(50), 
	@Period NVARCHAR(250) = N'Kỳ kế toán '
AS

--INSERT vao bang AT1407

INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT AT1303.DivisionID, ModuleID, WareHouseID, WareHouseName, 'WA' AS DataType, GETDATE(), 'ASOFTADMIN'
FROM AT1303 CROSS JOIN AT1409
WHERE AT1303.DivisionID + ModuleID + 'WA' + WareHouseID NOT IN 
(SELECT DISTINCT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'WA')

--Ke toan
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT AV9999.DivisionID, 'ASOFTT', MonthYear, @Period + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM AV9999 WHERE DivisionID + 'ASOFTT' + 'PE' + AV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTT')AND AV9999.DivisionID<>'%'

--Gia Thanh
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT MV9999.DivisionID, 'ASOFTM', MonthYear, @Period + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM MV9999 WHERE DivisionID + 'ASOFTM' + 'PE' + MV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTM')AND MV9999.DivisionID<>'%'

--Don Hang
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT OV9999.DivisionID, 'ASOFTOP', MonthYear, @Period + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM OV9999 WHERE DivisionID + 'ASOFTOP' + 'PE' + OV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTOP')AND OV9999.DivisionID<>'%'

--Kho
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT WV9999.DivisionID, 'ASOFTWM', MonthYear, @Period + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM WV9999 WHERE DivisionID + 'ASOFTWM' + 'PE' + WV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTWM')AND WV9999.DivisionID<>'%'

--HRM
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT HV9999.DivisionID, 'ASOFTHRM', MonthYear, @Period + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM HV9999 WHERE DivisionID + 'ASOFTHRM' + 'PE' + HV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTHRM')AND HV9999.DivisionID<>'%'
--FA
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT FV9999.DivisionID, 'ASOFTFA', MonthYear, @Period + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM FV9999 WHERE DivisionID + 'ASOFTFA' + 'PE' + FV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTFA')AND FV9999.DivisionID<>'%'

-- MODULE CS
INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID)
SELECT DISTINCT CSV9999.DivisionID, 'ASOFTCS', MonthYear, @Period  + MonthYear AS DataName, 'PE'AS DataType, GETDATE(), 'ASOFTADMIN' 
FROM CSV9999 WHERE DivisionID + 'ASOFTCS' + 'PE' + CSV9999.MonthYear NOT IN 
(SELECT DivisionID + ModuleID + DataType + DataID FROM AT1407 WHERE DataType = 'PE' AND ModuleID = 'ASOFTCS')AND CSV9999.DivisionID<>'%'


INSERT INTO AT1406 (DivisionID, ModuleID, GroupID, DataID, DataType, Permission, CreateDate, CreateUserID)
SELECT DISTINCT AT1407.DivisionID, AT1407.ModuleID, AT1401.GroupID, AT1407.DataID, AT1407.DataType, 1 AS Expr1, GETDATE() AS Expr2, 'ASOFTADMIN' AS Expr3 
FROM AT1407 CROSS JOIN AT1401
WHERE AT1407.DivisionID + ModuleID + GroupID + DataType + DataID NOT IN (SELECT DivisionID + ModuleID + GroupID + DataType + DataID FROM AT1406)
				
--INSERT vao bang AT1406
DECLARE 
    @cur0 CURSOR, 
    @cur1 CURSOR, 
    @cur2 CURSOR, 
    @cur3 CURSOR, 
    @GroupID AS NVARCHAR(50), 
    @ModuleID AS NVARCHAR(50), 
    @DataID AS NVARCHAR(50), 
    @DataName AS NVARCHAR(500), 
    @GroupCount AS INT, 
    @sSQL NVARCHAR(4000)

SET @GroupCount = 0

SELECT * INTO #AT1406 FROM AT1406
SELECT * INTO #AT1407 FROM AT1407

DELETE FROM #AT1406 
DELETE FROM #AT1407

SET @cur0 = CURSOR STATIC FOR
SELECT DISTINCT GroupID FROM AT1401 WHERE Disabled = 0

SET @cur1 = CURSOR STATIC FOR
SELECT DivisionID FROM AT1101 WHERE DivisionID = @DivisionID

SET @cur2 = CURSOR STATIC FOR
SELECT DISTINCT ModuleID FROM AT1409

--Lap 0
OPEN @cur0
FETCH NEXT FROM @cur0 INTO @GroupID
WHILE @@Fetch_Status = 0
    BEGIN
        SET @GroupCount = @GroupCount + 1

        --Lap 1
        OPEN @cur1
        FETCH NEXT FROM @cur1 INTO @DivisionID
        WHILE @@Fetch_Status = 0
            BEGIN

                --Lap 2
                OPEN @cur2
                FETCH NEXT FROM @cur2 INTO @ModuleID
                WHILE @@Fetch_Status = 0
                    BEGIN
                        --Phan quyen loai chung tu                        
                        INSERT INTO #AT1406 (DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                        SELECT distinct @DivisionID AS DivisionID, 
                            @ModuleID AS ModuleID, 
                            @GroupID AS GroupID, 
                            VoucherTypeID AS DataID, 
                            'VT' AS DataType, 
                            NULL AS BeginChar, 
                            1 AS Permission, 
                            GETDATE() AS CreateDate, 
                            'ASOFTADMIN' AS CreateUserID,
                            'ASOFTADMIN' AS LastModifyUserID, 
                            GETDATE() AS LastModifyDate
                        FROM AT1007
                        WHERE VoucherTypeID NOT IN 
                            (
                                SELECT DataID FROM AT1406 
                                WHERE DivisionID = @DivisionID
                                    AND ModuleID = @ModuleID
                                    AND GroupID = @GroupID
                                    AND DataType = 'VT'
                            ) and DivisionID = @DivisionID

                        --Phan quyen tai khoan
                        INSERT INTO #AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                        SELECT distinct @DivisionID AS DivisionID, 
                            @ModuleID AS ModuleID, 
                            @GroupID AS GroupID, 
                            AccountID AS DataID, 
                            'AC' AS DataType, 
                            NULL AS BeginChar, 
                            1 AS Permission, 
                            GETDATE() AS CreateDate, 
                            'ASOFTADMIN' AS CreateUserID, 
                            'ASOFTADMIN' AS LastModifyUserID, 
                            GETDATE() AS LastModifyDate
                        FROM AT1005
                        WHERE AccountID NOT IN 
                            (
                                SELECT DataID FROM AT1406 
                                WHERE DivisionID = @DivisionID
                                    AND ModuleID = @ModuleID
                                    AND GroupID = @GroupID
                                    AND DataType = 'AC'
                            ) and DivisionID = @DivisionID
     
                        --Phan quyen doi tuong
                        IF NOT EXISTS (SELECT TOP 1 1 FROM At1406 WHERE DivisionID = @DivisionID AND ModuleID = @ModuleID AND GroupID = @GroupID AND DataType = 'OB')
                        INSERT INTO #AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                        SELECT distinct @DivisionID AS DivisionID, 
                            @ModuleID AS ModuleID, 
                            @GroupID AS GroupID, 
                            'OB' AS DataID, 
                            'OB' AS DataType, 
                            NULL AS BeginChar, 
                            1 AS Permission, 
                            GETDATE() AS CreateDate, 
                            'ASOFTADMIN' AS CreateUserID, 
                            'ASOFTADMIN' AS LastModifyUserID, 
                            GETDATE() AS LastModifyDate

                        --Phan quyen mat hang
                        IF NOT EXISTS (SELECT TOP 1 1 FROM At1406 WHERE DivisionID = @DivisionID AND ModuleID = @ModuleID AND GroupID = @GroupID AND DataType = 'IV' and DataID = 'IV')
                        INSERT INTO #AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                        SELECT distinct @DivisionID AS DivisionID, 
                            @ModuleID AS ModuleID, 
                            @GroupID AS GroupID, 
                            'IV' AS DataID, 
                            'IV' AS DataType, 
                            NULL AS BeginChar, 
                            1 AS Permission, 
                            GETDATE() AS CreateDate, 
                            'ASOFTADMIN' AS CreateUserID, 
                            'ASOFTADMIN' AS LastModifyUserID, 
                            GETDATE() AS LastModifyDate

						-- Phan quyen gia ban
						IF NOT EXISTS (SELECT TOP 1 1 FROM At1406 WHERE DivisionID = @DivisionID AND ModuleID = 'ASOFTOP' AND GroupID = 'ADMIN' AND DataType = 'IV' and DataID = 'LP')
							insert into #AT1406([DivisionID],[ModuleID],[GroupID],[DataID],[DataType],[BeginChar],[Permission],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
									values (@DivisionID,'ASOFTOP', 'ADMIN','LP','IV', N'Sửa giá bán /Price Edit','1',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
									
						IF NOT EXISTS (SELECT TOP 1 1 FROM At1406 WHERE DivisionID = @DivisionID AND ModuleID = 'ASOFTT' AND GroupID = 'ADMIN' AND DataType = 'IV' and DataID = 'LP')
							insert into #AT1406([DivisionID],[ModuleID],[GroupID],[DataID],[DataType],[BeginChar],[Permission],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
									values (@DivisionID,'ASOFTT', 'ADMIN','LP','IV',N'Sửa giá bán /Price Edit','1',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
                        IF @GroupCount = 1
                            BEGIN
                                --Phan quyen tai khoan
                                INSERT INTO #AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                                SELECT distinct @DivisionID AS DivisionID, 
                                    @ModuleID AS ModuleID, 
                                    VoucherTypeID AS DataID, 
                                    VoucherTypeName AS DataName, 
                                    'VT' AS DataType, 
                                    GETDATE() AS CreateDate, 
                                    'ASOFTADMIN' AS CreateUserID, 
                                    'ASOFTADMIN' AS LastModifyUserID, 
                                    GETDATE() AS LastModifyDate
                                FROM AT1007
                                WHERE VoucherTypeID NOT IN 
           (
                                        SELECT DataID FROM AT1407 
                                        WHERE DivisionID = @DivisionID
                                            AND ModuleID = @ModuleID
                                            AND DataType = 'VT'
                                    ) and DivisionID = @DivisionID

                                --Phan quyen tai khoan
                                INSERT INTO #AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                                SELECT distinct @DivisionID AS DivisionID, 
                                    @ModuleID AS ModuleID, 
                                    AccountID AS DataID, 
                                    AccountName AS DataName, 
                                    'AC' AS DataType, 
                                    GETDATE() AS CreateDate, 
                                    'ASOFTADMIN' AS CreateUserID, 
                                    'ASOFTADMIN' AS LastModifyUserID, 
                                    GETDATE() AS LastModifyDate
                                FROM AT1005
                                WHERE AccountID NOT IN 
                                    (
                                        SELECT DataID FROM AT1407 
                                        WHERE DivisionID = @DivisionID
                                            AND ModuleID = @ModuleID
                                            AND DataType = 'AC'
                                    ) and DivisionID = @DivisionID

                                --Phan quyen doi tuong
                                IF NOT EXISTS (SELECT TOP 1 1 FROM At1407 WHERE DivisionID = @DivisionID AND ModuleID = @ModuleID AND DataType = 'OB')
                                INSERT INTO #AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                                SELECT distinct @DivisionID AS DivisionID, 
                                    @ModuleID AS ModuleID, 
                                    'OB' AS DataID, 
                                    NULL AS DataName, 
                                    'OB' AS DataType, 
                                    GETDATE() AS CreateDate, 
                                    'ASOFTADMIN' AS CreateUserID, 
                                    'ASOFTADMIN' AS LastModifyUserID, 
                                    GETDATE() AS LastModifyDate

                                --Phan quyen mat hang
                                IF NOT EXISTS (SELECT TOP 1 1 FROM At1407 WHERE DivisionID = @DivisionID AND ModuleID = @ModuleID AND DataType = 'IV')
                                INSERT INTO #AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
                                SELECT distinct @DivisionID AS DivisionID, 
                                    @ModuleID AS ModuleID, 
                                    'IV' AS DataID, 
                                    NULL AS DataName, 
                                    'IV' AS DataType, 
                                    GETDATE() AS CreateDate, 
                                    'ASOFTADMIN' AS CreateUserID, 
                                    'ASOFTADMIN' AS LastModifyUserID, 
                                    GETDATE() AS LastModifyDate
                                    
                                 -- Phan quyen gia ban
                                 IF NOT EXISTS (SELECT TOP 1 1 FROM At1407 WHERE DivisionID = @DivisionID AND ModuleID = 'ASOFTOP' AND DataType = 'IV')
									insert into #AT1407([DivisionID],[ModuleID],[DataID],[DataName],[DataType],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
													values (@DivisionID,'ASOFTOP','LP',N'Sửa giá bán /Price Edit','IV',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
													
								 IF NOT EXISTS (SELECT TOP 1 1 FROM At1407 WHERE DivisionID = @DivisionID AND ModuleID = 'ASOFTT' AND DataType = 'IV')
									insert into #AT1407([DivisionID],[ModuleID],[DataID],[DataName],[DataType],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
													values (@DivisionID,'ASOFTT','LP',N'Sửa giá bán /Price Edit','IV',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
									
							  --Phan quyen phong ban
								Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
								Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
									DepartmentID As DataID, DepartmentName As DataName, 'DE' as DataType,
									getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
									'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
									From AT1102
								Where DepartmentID Not In (Select DataID From AT1407 
											Where DivisionID = @DivisionID
											And ModuleID = @ModuleID
											And DataType = 'DE')
								--Hiển thị Ngày chứng từ		
								IF NOT EXISTS (SELECT TOP 1 1 FROM AT1407 WHERE DataType = 'VD' AND DivisionID = @DivisionID AND ModuleID = @ModuleID)
									INSERT INTO #AT1407	(	DivisionID,	ModuleID,DataID,DataName, DataType, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
									VALUES	(	@DivisionID,	@ModuleID,	 'VD', N'Ngày phiếu', 'VD',  GETDATE(),'ADMIN', 'ADMIN',GETDATE())
								IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'VD' AND DivisionID = @DivisionID AND GroupID = @GroupID AND ModuleID = @ModuleID)
										INSERT INTO #AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
										VALUES	(	@DivisionID,	@ModuleID,	@GroupID, 'VD', 'VD', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())
								--Hiển thị Giá vốn
								IF NOT EXISTS (SELECT TOP 1 1 FROM AT1407 WHERE DataType = 'PR' AND DivisionID = @DivisionID AND ModuleID = @ModuleID)
									INSERT INTO #AT1407	(	DivisionID,	ModuleID,DataID,DataName, DataType, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
										VALUES	(	@DivisionID,	@ModuleID,	 'PR', N'Hiển thị Giá vốn', 'PR',  GETDATE(),'ADMIN', 'ADMIN',GETDATE())
								IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'PR' AND DivisionID = @DivisionID AND GroupID = @GroupID AND ModuleID = @ModuleID)
									INSERT INTO #AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
										VALUES	(	@DivisionID,	@ModuleID,	@GroupID, 'PR', 'PR', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())
								--Hiển thị Thành tiền
								IF NOT EXISTS (SELECT TOP 1 1 FROM AT1407 WHERE DataType = 'AM' AND DivisionID = @DivisionID AND ModuleID = @ModuleID)
									INSERT INTO #AT1407	(	DivisionID,	ModuleID,DataID,DataName, DataType, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
										VALUES	(	@DivisionID,	@ModuleID,	 'AM', N'Hiển thị Thành tiền', 'AM',  GETDATE(),'ADMIN', 'ADMIN',GETDATE())
								IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'AM' AND DivisionID = @DivisionID AND GroupID = @GroupID AND ModuleID = @ModuleID)
									INSERT INTO #AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
										VALUES	(	@DivisionID,	@ModuleID,	@GroupID, 'AM', 'AM', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())
                            END
                        FETCH NEXT FROM @cur2 INTO @ModuleID
                    END
                CLOSE @cur2

                FETCH NEXT FROM @cur1 INTO @DivisionID
            END
        CLOSE @cur1

        FETCH NEXT FROM @cur0 INTO @GroupID
        
    END

DEALLOCATE @cur2
DEALLOCATE @cur1
DEALLOCATE @cur0

INSERT INTO At1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate) 
		   SELECT DISTINCT DivisionID, ModuleID, DataID, DataName, DataType, GETDATE(), 'ASOFTADMIN', 'ASOFTADMIN', GETDATE()
		   FROM #AT1407 WHERE DivisionID = @DivisionID
		   ORDER BY divisionid, moduleid, Datatype, dataID

INSERT INTO At1406(DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
		   SELECT DISTINCT DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, GETDATE(), 'ASOFTADMIN', 'ASOFTADMIN', GETDATE()
		   FROM #AT1406 WHERE DivisionID = @DivisionID
		   ORDER BY divisionid, moduleid, groupid, DataType, dataID



DROP TABLE #AT1406
DROP TABLE #AT1407
---------------Thiet lap phan quyen du lieu
INSERT INTO AT1412 (DivisionID, ModuleID, GroupID, DataTypeID, Permission, CreateDate, CreateUserID)			
	SELECT	DISTINCT AT1101.DivisionID, A00004.ModuleID, @GroupID, DataTypeID, 1 AS Expr1, GETDATE() AS Expr2, 'ASOFTADMIN' AS Expr3 
	FROM	AT1101
	LEFT JOIN AT1408 ON AT1408.DivisionID = AT1101.DivisionID
	LEFT JOIN A00004 ON A00004.DivisionID = AT1408.DivisionID
	WHERE	NOT EXISTS(	SELECT TOP 1 1 FROM AT1412
						WHERE	AT1412.DivisionID = @DivisionID
								AND AT1412.DivisionID = AT1408.DivisionID
								AND AT1412.ModuleID = A00004.ModuleID
								AND AT1412.DataTypeID = AT1408.DataTypeID
								AND AT1412.GroupID = @GroupID
								)
			AND AT1101.DivisionID = @DivisionID
			AND AT1408.DataTypeID IN ('AC', 'DE', 'IV', 'OB', 'VT', 'WA')			

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

