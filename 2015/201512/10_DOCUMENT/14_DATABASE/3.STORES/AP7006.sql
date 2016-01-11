/****** Object:  StoredProcedure [dbo].[AP7006]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by Nguyen Van Nhan
---Date 17/03/2005
---Purpose: xu ly dieu kien cac cot in bao cao phan tich ton kho, duoc goi boi AP7007
---- Edit by : Dang Le Bao Quynh; Date 22/07/2008
---- Purpose: Cho phep xu ly dieu kien like
---- Edit by : Dang Le Bao Quynh; Date 28/07/2008
---- Purpose: Bo sung them so du dau ky
---- Edit by : Dang Le Bao Quynh; Date 31/01/2013
---- Purpose: Viet gon lai va sua so du dau ky cua thanh tien
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7006] 
	@AmountType NVARCHAR(2), 
	@CaculatedType NVARCHAR(2), 
	@ColumnAmount NVARCHAR(4000) output, 
	@ConditionType NVARCHAR(20), 
	@ConditionFrom NVARCHAR(50), 
	@ConditionTo NVARCHAR(50), 
	@FromMonth INT, 
	@FromYear INT, 
	@ToMonth INT, 
	@ToYear INT, 
	@FromDate DATETIME, 
	@ToDate DATETIME, 
	@IsDate TINYINT, 
	@DivisionID NVARCHAR(50), 
	@FilterType INT, 
	@Condition NVARCHAR(50)
AS

DECLARE 
	@strCondition NVARCHAR(4000), 
	@FieldName NVARCHAR(50), 
	@QuantityOrAmount NVARCHAR(50), 
	@FromMonthYearText NVARCHAR(20), 
	@ToMonthYearText NVARCHAR(20), 
	@FromDateText NVARCHAR(20), 
	@ToDateText NVARCHAR(20)

SET @FromMonthYearText = LTRIM(RTRIM(STR(@FromMonth + @FromYear * 100)))
SET @ToMonthYearText = LTRIM(RTRIM(STR(@ToMonth + @ToYear * 100)))
SET @FromDateText = LTRIM(RTRIM(CONVERT(NVARCHAR(20), @FromDate, 101)))
SET @ToDateText = LTRIM(RTRIM(CONVERT(NVARCHAR(20), @ToDate, 101))) + ' 23:59:59'

SET @FieldName = (CASE ISNULL(@ConditionType, '') WHEN 'WA' THEN 'WareHouseID' WHEN 'MO' THEN 'MonthYear' WHEN 'VT' THEN 'VoucherTypeID' ELSE '' END)

IF ISNULL(@ConditionType, '') <> ''
	BEGIN
		IF @FilterType = 0
			SET @strCondition = ' V7.' + @FieldName + ' BETWEEN N''' + @ConditionFrom + ''' AND N''' + @ConditionTo + ''' '
		ELSE
			SET @strCondition = ' V7.' + @FieldName + ' LIKE N''' + @Condition + ''' '
		END 
	ELSE
		SET @strCondition = ''

------- Xu ly tinh toan
IF @AmountType ='AQ' --- theo so luong
	BEGIN
		IF @CaculatedType IN ('PD', 'PC') SET @QuantityOrAmount = 'ActualQuantity'
		IF @CaculatedType IN ('PE', 'PB') SET @QuantityOrAmount = 'SignQuantity' 
	END	
ELSE
	BEGIN	
		IF @CaculatedType IN ('PD', 'PC') SET @QuantityOrAmount = 'ConvertedAmount'
		IF @CaculatedType IN ('PB', 'PE') SET @QuantityOrAmount = 'SignAmount' 
	END	

-- Số phát sinh
IF @CaculatedType = 'PD' AND @IsDate = 0 
	SET @ColumnAmount = ' SUM(CASE WHEN D_C = ''D'' AND (TranMonth + 100 * TranYear BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ') '
IF @CaculatedType = 'PD' AND @IsDate = 1 
	SET @ColumnAmount = ' SUM(CASE WHEN D_C = ''D'' AND (V7.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''') '

-- Số phát sinh
IF @CaculatedType = 'PC' AND @IsDate = 0 
	SET @ColumnAmount = ' SUM(CASE WHEN D_C = ''C'' AND (TranMonth + 100 * TranYear BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ') '
IF @CaculatedType = 'PC' AND @IsDate = 1 
	SET @ColumnAmount = ' SUM(CASE WHEN D_C = ''C'' AND (V7.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''') '

-- Số dư cuối kỳ
IF @CaculatedType = 'PE' AND @IsDate = 0 
	SET @ColumnAmount = ' SUM(CASE WHEN D_C IN (''D'', ''BD'', ''C'') AND (TranMonth + 100 * TranYear <= ' + @ToMonthYearText + ') '
IF @CaculatedType = 'PE' AND @IsDate = 1 
	SET @ColumnAmount = ' SUM(CASE WHEN D_C IN (''D'', ''BD'', ''C'') AND (V7.VoucherDate <= ''' + @ToDateText + ''') '

-- Số dư đầu kỳ
IF @CaculatedType = 'PB' AND @IsDate = 0 
	SET @ColumnAmount = ' SUM(CASE WHEN ((D_C IN (''D'', ''BD'', ''C'') AND (TranMonth + 100 * TranYear < ' + @FromMonthYearText + ')) OR (D_C IN (''BD'') AND (TranMonth + 100 * TranYear = ' + @FromMonthYearText + '))) '
IF @CaculatedType = 'PB' AND @IsDate = 1 
	SET @ColumnAmount = ' SUM(CASE WHEN ((D_C IN (''D'', ''BD'', ''C'') AND (V7.VoucherDate < ''' + @FromDateText + ''')) OR (D_C IN (''BD'') AND (V7.VoucherDate = ''' + @FromDateText + '''))) '

IF @strCondition <> ''
	SET @ColumnAmount = @ColumnAmount + ' AND ' + @strCondition + ' THEN ' + @QuantityOrAmount + ' ELSE 0 END) ' 
ELSE
	SET @ColumnAmount = @ColumnAmount + ' THEN ' + @QuantityOrAmount + ' ELSE 0 END) ' 

-- PRINT @ColumnAmount
GO
