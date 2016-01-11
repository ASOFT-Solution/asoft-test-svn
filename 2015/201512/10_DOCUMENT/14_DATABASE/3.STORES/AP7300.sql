IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7300]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7300]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Tạo view sử dụng trong phần in bảng cân đối phát sinh
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- Gọi bởi AP7301
-- <History>
---- Create on 21/07/03 by Nguyen Van Nhan
---- Modified on 29/07/2010 by Việt Khánh
---- Modified on 30/12/2011 by Nguyễn Bình Minh (PRT0173): Sửa lỗi lấy số đầu kỳ không đúng do lấy sai điều kiện và sửa lại các điều kiện cho chuẩn
---- Modified on 08/03/2012 by Lê Thị Thu Hiền : Bổ sung Z00 số dư đầu kỳ của tài khoản ngoại bảng
----- Modified on 19/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
----- Modified on 05/11/2012 by Lê Thị Thu Hiền : Không Group theo DivisionID
----- Modified on 10/12/2012 by Bảo Anh : Sửa lỗi Số tiền Có lên sai đối với bút toán ngoại bảng (dùng AV9004.SignConvertedAmount thay cho AV9004.ConvertedAmount)
----- Modified on 05/11/2012 by Lê Thị Thu Hiền : LEFT JOIN bảng DivisionID kết với @DivisionID (0019537 )

-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP7300]
(
    @DivisionID AS NVARCHAR(50), 
    @TranMonthFrom AS INT, 
    @TranYearFrom AS INT, 
    @TranMonthTo AS INT, 
    @TranYearTo AS INT,
    @StrDivisionID AS NVARCHAR(4000) = ''
)    
AS

DECLARE @strSQL1 NVARCHAR(4000), 
		@strSQL2 NVARCHAR(4000), 
		@PeriodFrom AS INT, 
		@PeriodTo AS INT
		
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + REPLACE(@StrDivisionID, ',',''',''') + ''')' END
    
SET @PeriodFrom = @TranYearFrom * 100 + @TranMonthFrom
SET @PeriodTo = @TranYearTo * 100 + @TranMonthTo

SET @strSQL1 = '
SELECT		'''+@DivisionID +''' AS DivisionID,
			V01.AccountID,
			T1.AccountName,
			T1.AccountNameE,
			SUM(ISNULL(ConvertedAmount, 0)) AS Closing,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) < ''' + STR(@PeriodFrom) + ''' 
							OR V01.TransactionTypeID IN( ''T00'', ''Z00'') THEN ISNULL(ConvertedAmount, 0) 
				ELSE 0 END) AS Opening,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@PeriodFrom) + '''
				           AND V01.D_C = ''D'' AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL) 
				THEN ISNULL(ConvertedAmount, 0) ELSE 0 END) AS PeriodDebit,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@PeriodFrom) + '''
							AND V01.D_C = ''C''
							AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL)
				THEN ISNULL(ConvertedAmount, 0) * (-1) ELSE 0 END) AS PeriodCredit,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@TranYearFrom * 100 + 1) + '''
				           AND V01.D_C = ''D'' AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL)
				THEN ISNULL(ConvertedAmount, 0) ELSE 0 END) AS AccumulatedDebit,
	       SUM(	CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@TranYearFrom * 100 + 1) + '''
				           AND V01.D_C = ''C'' AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL)
				THEN ISNULL(ConvertedAmount, 0) * (-1) 
				ELSE 0 END) AS AccumulatedCredit
FROM		AV4201 AS V01
INNER JOIN	AT1005 AS T1
		ON  T1.AccountID = V01.AccountID AND T1.DivisionID = '''+@DivisionID+'''
WHERE		V01.DivisionID '+@StrDivisionID_New+' AND T1.GroupID <> ''G00''
			AND (V01.TranYear * 100 + V01.TranMonth <= ''' + STR(@PeriodTo) + ''' OR V01.TransactionTypeID IN( ''T00'', ''Z00''))
GROUP BY	V01.AccountID,
			T1.AccountName,
			T1.AccountNameE
'
----------------------------- PHAN TAI KHOAN NGOAI BANG ---------------------------------------------------------------------------------------------------------------------------------
SET @strSQL2 = '
UNION ALL 
SELECT		'''+@DivisionID +''' AS DivisionID,
			V01.AccountID,
			T1.AccountName,
			T1.AccountNameE,
			SUM(ISNULL(SignConvertedAmount, 0)) AS Closing,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) < ''' + STR(@PeriodFrom) + ''' 
							OR V01.TransactionTypeID IN( ''T00'', ''Z00'') THEN ISNULL(SignConvertedAmount, 0) 
				ELSE 0 END) AS Opening,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@PeriodFrom) + '''
				           AND V01.D_C = ''D'' AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL) 
				THEN ISNULL(SignConvertedAmount, 0) ELSE 0 END) AS PeriodDebit,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@PeriodFrom) + '''
							AND V01.D_C = ''C''
							AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL)
				THEN ISNULL(SignConvertedAmount, 0) * (-1) ELSE 0 END) AS PeriodCredit,
			SUM(CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@TranYearFrom * 100 + 1) + '''
				           AND V01.D_C = ''D'' AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL)
				THEN ISNULL(SignConvertedAmount, 0) ELSE 0 END) AS AccumulatedDebit,
	       SUM(	CASE WHEN (V01.TranYear * 100 + V01.TranMonth) >= ''' + STR(@TranYearFrom * 100 + 1) + '''
				           AND V01.D_C = ''C'' AND (V01.TransactionTypeID NOT IN( ''T00'', ''Z00'') OR V01.TransactionTypeID IS NULL)
				THEN ISNULL(SignConvertedAmount, 0) * (-1) 
				ELSE 0 END) AS AccumulatedCredit
FROM		AV9004 AS V01 
INNER JOIN	AT1005 AS T1 ON T1.AccountID = V01.AccountID and T1.DivisionID = '''+@DivisionID+'''
WHERE		V01.DivisionID '+@StrDivisionID_New+'
			AND (V01.TranYear * 100 + V01.TranMonth <= ''' + STR(@PeriodTo) + ''' OR V01.TransactionTypeID IN( ''T00'', ''Z00''))
GROUP BY	V01.AccountID, T1.AccountName, T1.AccountNameE
'
--Print @strSQL1 
--Print @strSQL2
IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4207' AND SYSOBJECTS.XTYPE = 'V')
    EXEC('CREATE VIEW AV4207 AS ' + @strSQL1 + @strSQL2)
ELSE
    EXEC('ALTER VIEW AV4207 AS ' + @strSQL1 + @strSQL2)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

