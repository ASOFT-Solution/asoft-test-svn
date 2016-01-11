IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7222]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7222]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created BY Nguyen Van Nhan.
---- Date 02/06/2004
---- Purpose: Doi chieu so lieu theo TK doi ung
---- Modified by on 12/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified by on 06/11/2012 by Lê Thị Thu Hiền : Không GROUP BY theo DivisionID
---- Modified by on 15/11/2012 by Thiên Huỳnh : Cắt chuỗi @ListAccountID quá dài

CREATE PROCEDURE [dbo].[AP7222] 
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @D_C NVARCHAR(1), 
    @ListAccountID VARCHAR(8000), 
    @CorAcc01 NVARCHAR(50), 
    @CorAcc02 NVARCHAR(50), 
    @CorAcc03 NVARCHAR(50), 
    @CorAcc04 NVARCHAR(50), 
    @CorAcc05 NVARCHAR(50), 
    @CorAcc06 NVARCHAR(50), 
    @CorAcc07 NVARCHAR(50), 
    @CorAcc08 NVARCHAR(50), 
    @CorAcc09 NVARCHAR(50), 
    @CorAcc10 NVARCHAR(50), 
    @CorAcc11 NVARCHAR(50), 
    @CorAcc12 NVARCHAR(50), 
    @CorAcc13 NVARCHAR(50), 
    @CorAcc14 NVARCHAR(50), 
    @CorAcc15 NVARCHAR(50), 
    @CorAcc16 NVARCHAR(50), 
    @CorAcc17 NVARCHAR(50), 
    @CorAcc18 NVARCHAR(50),     
    @CorAcc19 NVARCHAR(50), 
    @CorAcc20 NVARCHAR(50),
    @StrDivisionID AS NVARCHAR(4000) = ''
AS

DECLARE 
    @ListCorAcc NVARCHAR(4000),
    @sSQL1 NVARCHAR(4000),
    @sSQL2 NVARCHAR(4000),
    @sSQL3 VARCHAR(8000),
    @StrDivisionID_New AS NVARCHAR(4000)
    
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END		

SET @ListCorAcc = '(''' + ISNULL(@CorAcc01,'') + ''', ''' + Isnull(@CorAcc02,'') + ''', ''' + ISNULL(@CorAcc03,'') + ''', ''' + ISNULL(@CorAcc04,'') + ''', ''' + ISNULL(@CorAcc05,'') + ''', ''' + ISNULL(@CorAcc06,'') + ''', ''' + ISNULL(@CorAcc07,'') + ''', ''' + ISNULL(@CorAcc08,'') + ''', ''' + ISNULL(@CorAcc09,'') + ''', ''' + ISNULL(@CorAcc10,'') + ''', ''' + ISNULL(@CorAcc11,'') + ''', ''' + ISNULL(@CorAcc12,'') + ''', ''' + ISNULL(@CorAcc13,'') + ''', ''' + ISNULL(@CorAcc14,'') + ''', ''' + ISNULL(@CorAcc15,'') + ''', ''' + ISNULL(@CorAcc16,'') + ''', ''' + ISNULL(@CorAcc17,'') + ''', ''' + ISNULL(@CorAcc18,'') + ''', ''' + ISNULL(@CorAcc19,'') + ''', ''' + ISNULL(@CorAcc20,'') + ''')'

SET @sSQL1 = '
SELECT	'''+@DivisionID +''' AS DivisionID,
	    AV4300.AccountID, 
        AccountName, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc01,'') + ''' THEN ConvertedAmount ELSE 0 END) AS Amount01, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc02,'') + ''' THEN ConvertedAmount ELSE 0 END) AS Amount02, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc03,'') + ''' THEN ConvertedAmount ELSE 0 END) AS Amount03, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc04,'') + ''' THEN ConvertedAmount ELSE 0 END) AS Amount04, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc05,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount05, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc06,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount06, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc07,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount07, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc08,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount08, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc09,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount09, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc10,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount10, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc11,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount11, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc12,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount12, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc13,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount13, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc14,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount14, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc15,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount15, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc16,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount16, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc17,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount17, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc18,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount18, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc19,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount19, 
        SUM(CASE WHEN CorAccountID = ''' + ISNULL(@CorAcc20,'')  + ''' THEN ConvertedAmount ELSE 0 END) AS Amount20
FROM AV4300 
INNER JOIN AT1005 ON AT1005.AccountID = AV4300.AccountID and AT1005.DivisionID = AV4300.DivisionID '
set @sSQL2 = '
WHERE AT1005.DivisionID '+@StrDivisionID_New+'
        AND (TranMonth + TranYear * 100 BETWEEN ' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100 AND ' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100) 
        AND TransactionTypeID <> ''T00'' 
        AND D_C = ''' + @D_C + ''' 
        AND CorAccountID in ' + @ListCorAcc + ' 
        AND AV4300.AccountID IN ' --+ @ListAccountID + '
        
SET @sSQL3 = @ListAccountID + '
GROUP BY  AV4300.AccountID, AccountName
'

IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7222' AND SYSOBJECTS.XTYPE = 'V')
    EXEC('CREATE VIEW AV7222 AS ' + @sSQL1 + @sSQL2 + @sSQL3)
ELSE
    EXEC('ALTER VIEW AV7222 AS ' + @sSQL1 + @sSQL2 + @sSQL3)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

