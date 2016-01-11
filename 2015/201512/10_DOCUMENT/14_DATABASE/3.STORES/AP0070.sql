IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0070]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0070]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







-- <Summary>
---- Load dữ liệu lên màn hình thiết kế Customize Report
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/11/2011 by 
---- Modify by Lê Thị Hạnh on 02/10/2014: Bổ sung OID, IID - Báo cáo theo dõi chiết kháu cho Sài Gòn Petro - CUstomoze Index: 36
---- 
---- Modified on 03/07/2013 by Lê Thị Thu Hiền : Bổ sung khoản mục ICode
---- Modified on 02/10/2014 by Lê Thị Thu Hiền : Bổ sung thêm Trạng thái quyết toán (BOURBON)
-- <Example>
---- EXEC AP0070 'AP', 'ASOFTADMIN', 'VN-vi', 'OID', 'ASOF-OP'
CREATE PROCEDURE [DBO].[AP0070]
(
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@Language AS NVARCHAR(50),
	@Type AS NVARCHAR(50),
	@ModuleID AS NVARCHAR(50)
) 
AS

SET NOCOUNT ON
DECLARE @sSQL AS NVARCHAR(4000)
CREATE TABLE #Data (Code NVARCHAR(50), Name NVARCHAR(250), Filter NVARCHAR(250))
IF @Type = 'ACC'	
		INSERT INTO #Data (Code, Name, Filter)
			SELECT AccountID, AccountName, @Type FROM AT1005
			WHERE DivisionID = @DivisionID AND [Disabled] = 0

IF @Type = 'OBJ'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT ObjectID, ObjectName, @Type FROM AT1202
		WHERE DivisionID = @DivisionID AND [Disabled] = 0

IF @Type = 'CUR'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT CurrencyID, CurrencyName, @Type FROM AT1004
		WHERE DivisionID = @DivisionID AND [Disabled] = 0

IF @Type = 'WH'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT WareHouseID, WareHouseName, @Type FROM AT1303
		WHERE DivisionID = @DivisionID AND [Disabled] = 0

IF @Type = 'VT'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT WareHouseID, WareHouseName, @Type FROM AT1303
		WHERE DivisionID = @DivisionID AND [Disabled] = 0
		
IF @Type = 'INV'
	INSERT INTO #Data (Code, Name, Filter)
		--SELECT VoucherTypeID, VoucherTypeName, @Type FROM AT1007
		SELECT InventoryId, InventoryName, @Type FROM AT1302
		WHERE DivisionID = @DivisionID AND [Disabled] = 0

IF @Type = 'EMP'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT EmployeeID, FullName, @Type FROM AT1103
		WHERE DivisionID = @DivisionID AND [Disabled] = 0		
		
IF @Type = 'EMPHV1400'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT EmployeeID, 
		Ltrim(RTrim(isnull(LastName,''))) 
		+ ' ' + LTrim(RTrim(isnull(MiddleName,''))) 
		+ ' ' + LTrim(RTrim(Isnull(FirstName,''))) AS FullName, @Type FROM HT1400
		WHERE DivisionID = @DivisionID							
		
IF @Type = 'DEV'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT DepartmentID,DepartmentName, @Type FROM AT1102
		WHERE DivisionID = @DivisionID AND [Disabled] = 0	
		
IF @Type = 'YEAR'
IF @ModuleID = 'OP'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT DISTINCT TranYear, DivisionID, @Type FROM OT9999
        WHERE DivisionID = @DivisionID ORDER BY TranYear
		
IF @Type LIKE 'A%'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT AnaID, AnaName, @Type FROM AT1011
		WHERE DivisionID = @DivisionID AND [Disabled] = 0 AND AnaTypeID = @Type
		
IF @Type LIKE 'I[0-9][0-9]'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT AnaID, AnaName, @Type FROM AT1015
		WHERE DivisionID = @DivisionID AND [Disabled] = 0 AND AnaTypeID = @Type		
		
IF @Type LIKE 'DEVICEGROUP'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT DeviceGroupID, DeviceGroupName, @Type FROM CST1030
		WHERE DivisionID = @DivisionID AND [Disabled] = 0
		
IF @Type LIKE 'DEVICE'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT DeviceID, DeviceName, @Type FROM CST1040
		WHERE DivisionID = @DivisionID AND [Disabled] = 0
IF @Type LIKE 'DEVICETYPE'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT DeviceTypeID, DeviceTypeName, @Type FROM CST1070
		WHERE DivisionID = @DivisionID AND [Disabled] = 0
IF @Type LIKE 'TYPE'
	INSERT INTO #Data (Code, Name, Filter)
		SELECT Code AS TypeID, [Name] AS  DeviceName, @Type FROM CSV2010
		WHERE ID='DeviceType'
IF @Type LIKE 'IID'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT AT15.AnaID AS IID, AT15.AnaName AS IName, @Type
		FROM OT0000 OT00
		INNER JOIN AT1015 AT15 ON AT15.DivisionID = OT00.DivisionID AND AT15.AnaTypeID = OT00.ITypeID
		WHERE OT00.DivisionID = @DivisionID AND AT15.[Disabled] = 0
IF @Type LIKE 'OID'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT AT15.AnaID AS OID, AT15.AnaName AS OName, @Type
		FROM OT0000 OT00
		INNER JOIN AT1015 AT15 ON AT15.DivisionID = OT00.DivisionID AND AT15.AnaTypeID = OT00.OTypeID
		WHERE OT00.DivisionID = @DivisionID AND AT15.[Disabled] = 0
		
IF @Type LIKE 'SEST' 
    INSERT INTO #Data (Code,Name,Filter)
        SELECT '0' AS Code, N'Tất cả' AS Name, @Type AS Filter
        UNION ALL
		SELECT '1' AS Code, N'Chưa quyết toán' AS Name, @Type AS Filter
		UNION ALL
		SELECT '2' AS Code, N'Đã quyết toán' AS Name, @Type AS Filter

IF @Type LIKE 'SOrderID'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT OT01.SOrderID SOrderID, OT01.SOrderID AS Name, @Type
		FROM OT2001 OT01
		WHERE OT01.DivisionID = @DivisionID AND OT01.VoucherTypeID = 'DV'
	
IF @Type LIKE 'PERIODID'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT HT66.PeriodID, HT66.PeriodName AS Name, @Type
		FROM HT6666 HT66
		WHERE HT66.DivisionID = @DivisionID

IF @Type LIKE 'PROJECTID'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT HT20.ProjectID, HT20.ProjectName AS Name, @Type
		FROM HT1120 HT20
		WHERE HT20.DivisionID = @DivisionID

IF @Type LIKE 'SHIFTCODE'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT HT10.ShiftID, HT10.ShiftName AS Name, @Type
		FROM HT1020 HT10
		WHERE HT10.DivisionID = @DivisionID

IF @Type LIKE 'PERIODHRM'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT 
			HV99.TranYear * 100 + HV99.TranMonth, 
			HV99.MonthYear AS Name, @Type
		FROM HV9999 HV99
		WHERE HV99.DivisionID = @DivisionID
		ORDER BY HV99.TranYear, HV99.TranMonth DESC

IF @Type LIKE 'I01ID-SECOIN'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT 
			AnaID, 
			AnaName AS Name, @Type
		FROM AT1015
		WHERE DivisionID = @DivisionID and AnaTypeID = 'I01' and AnaID like N'GACH%'
		ORDER BY AnaID
IF @Type LIKE 'TEAM'
    INSERT INTO #Data (Code, Name, Filter)
        SELECT 
			TeamID, 
			TeamName AS Name, @Type
		FROM HT1101
		WHERE DivisionID = @DivisionID
		ORDER BY TeamID



SET @sSQL = N'SELECT * FROM #Data ' + CASE WHEN ISNULL(@Type, '') <> '' THEN 'WHERE Filter = ''' + @Type + '''' ELSE '' END + ' ORDER BY Code'

--PRINT @sSQL

EXEC(@sSQL)

DROP TABLE #Data







GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
