IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7301]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7301]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Bảng cân đối số phát sinh
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/08/2003 by Nguyen Van Nhan
---- 
------- Edited BY Nguyen Thi Ngoc Minh, 
------- Date 07/04/2004
------- Edited BY Nguyen Quoc Huy, 
------- Date 28/09/2005
------- In bang can doi phat sinh
---- Last Edit by Thiên Huỳnh  on 21/06/2012: Gán lại theo @AmountUnit
---- Modified on 19/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified on 02/10/2015 by Phương Thảo : Chỉnh sửa in chi tiết số dư Nợ/Có cho các TK công nợ theo dõi theo đối tượng
-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP7301]
    @DivisionID AS NVARCHAR(50), 
    @TranMonthFrom AS INT, 
    @TranYearFrom AS INT, 
    @TranMonthTo AS INT, 
    @TranYearTo AS INT, 
    @GROUP AS tinyint, 
    @AmountUnit AS INT,
    @StrDivisionID AS NVARCHAR(4000) = '',	
	@IsNotClear AS Tinyint = 0 -- Không bù trừ số dư với các TK lưỡng tính
AS

DECLARE 
    @strSQL AS NVARCHAR(max),
    @ConversionAmountUnit AS INT, 
    @strConversion AS NVARCHAR(50)

DECLARE @StrDivisionID_New AS NVARCHAR(4000)
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + REPLACE(@StrDivisionID, ',',''',''') + ''')' END


IF @AmountUnit = 1 SET @ConversionAmountUnit = 1
IF @AmountUnit = 2 SET @ConversionAmountUnit = 10
IF @AmountUnit = 3 SET @ConversionAmountUnit = 100
IF @AmountUnit = 4 SET @ConversionAmountUnit = 1000
IF @AmountUnit = 5 SET @ConversionAmountUnit = 10000
IF @AmountUnit = 6 SET @ConversionAmountUnit = 100000
IF @AmountUnit = 7 SET @ConversionAmountUnit = 1000000

SET @strConversion = LTRIM(STR(@ConversionAmountUnit))

EXEC AP7300 @DivisionID, @TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, @StrDivisionID

SET @strSQL = '
    SELECT '''+@DivisionID+''' AS DivisionID, 
		V07.AccountID, V07.AccountName, V07.AccountNameE, 
        V07.Closing/' + @strConversion + ' AS Closing, 
        V07.Opening/' + @strConversion + ' AS Opening, 
        V07.PeriodDebit/' + @strConversion + ' AS PeriodDebit, 
        V07.PeriodCredit/' + @strConversion + ' AS PeriodCredit, 
        V07.AccumulatedDebit/' + @strConversion + ' AS AccumulatedDebit, 
        V07.AccumulatedCredit/' + @strConversion + ' AS AccumulatedCredit, 
        V07.AccountID AS GroupAccountID, V07.AccountName AS GroupAccountName, V07.AccountNameE AS GroupAccountNameE 
    FROM AV4207 AS V07
    WHERE (V07.Closing <> 0 
        OR V07.Opening <> 0 
        OR V07.PeriodDebit <> 0 
        OR V07.AccumulatedDebit <> 0 
        OR V07.AccumulatedCredit <> 0)
        AND DivisionID = '''+@DivisionID+'''
'
--PRINT @strSQL

IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7301' AND SYSOBJECTS.XTYPE = 'V')
    EXEC('CREATE VIEW AV7301 AS --AP7301
    ' + @strSQL)
ELSE
    EXEC('ALTER VIEW AV7301 AS --AP7301
    ' + @strSQL)

EXEC AP7302 @DivisionID, @GROUP, @StrDivisionID, @TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, @IsNotClear 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

