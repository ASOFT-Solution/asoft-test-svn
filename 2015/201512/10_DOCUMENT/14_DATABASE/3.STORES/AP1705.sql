/****** Object: StoredProcedure [dbo].[AP1705] Script Date: 08/04/2010 09:38:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Thuy Tuyen
---- Date 25/12/2006
---- Purpose: Lay du lieu cho man hinh Doanh thu va chi phi xuat dung..-AF1703
---- Last edit by Nguyen Thi Thuy Tuyen, Date: 18/04/2007
---- Edit by: Dang Le Bao Quynh; Date: 26/04/2007
---- Purpose: Bo sung them cac cot chi tiet ve doi tuong 
---- Edit by Bao Anh, Date: 05/11/2008
---- Purpose: Thay doi cach lay DL cho muc phan bo ConvertedUnit

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

ALTER PROCEDURE [dbo].[AP1705] 
    @DivisionID AS NVARCHAR(50),
    @FromMonth AS INT,
    @FromYear AS INT, 
    @ToMonth AS INT,
    @ToYear AS INT, 
    @D_C AS NVARCHAR(50)
AS

DECLARE @sSQL1 AS NVARCHAR(4000)

IF @D_C = 'D'
    BEGIN
        SET @sSQL1 =' 
        SELECT 
        AT1703.*,
        AT1202.ObjectName,
        AT1703.ApportionAmount AS ConvertedUnit,
        CASE AT1703.UseStatus 
            WHEN 0 THEN ''AFML000179'' 
            WHEN 1 THEN ''AFML000180'' 
            WHEN 8 THEN ''AFML000181'' 
                   ELSE ''AFML000182'' END AS IsStop,
        CAST(AT1703.BeginMonth AS NVARCHAR) + ''/'' + CAST(AT1703.BeginYear AS NVARCHAR) AS MonthYearBegin,
        CAST(AT1703.TranMonth AS NVARCHAR) + ''/'' + CAST(AT1703.TranYear AS NVARCHAR) AS MonthYear,
        AV1702.VDescription
        FROM AT1703
        LEFT JOIN AT1202 ON AT1202.DivisionID = AT1703.DivisionID AND AT1202.ObjectID = AT1703.ObjectID
        INNER JOIN AV1702 ON AV1702.DivisionID = AT1703.DivisionID AND AV1702.AccountID = AT1703.CreditAccountID AND AV1702.VoucherID = AT1703.VoucherID 
        WHERE AT1703.DivisionID = '''+ @DivisionID+ '''
        AND AT1703.D_C = ''D'' 
        AND AT1703.TranMonth + AT1703.TranYear * 12 BETWEEN ' + LTRIM(@FromMonth + @FromYear * 12) + ' AND ' + LTRIM(@ToMonth + @ToYear * 12)
    END
ELSE IF @D_C = 'C'
    BEGIN
        SET @sSQL1 =' 
        SELECT 
        AT1703.*,
        AT1202.ObjectName,
        AT1703.ApportionAmount AS ConvertedUnit,
        CASE AT1703.UseStatus 
            WHEN 0 THEN ''AFML000179'' 
            WHEN 1 THEN ''AFML000180'' 
            WHEN 8 THEN ''AFML000181'' 
                   ELSE ''AFML000182'' END AS IsStop,
        CAST(AT1703.BeginMonth AS NVARCHAR) + ''/'' + CAST(AT1703.BeginYear AS NVARCHAR) AS MonthYearBegin,
        CAST(AT1703.TranMonth AS NVARCHAR) + ''/'' + CAST(AT1703.TranYear AS NVARCHAR) AS MonthYear,
        AV1702.VDescription
        FROM AT1703
        LEFT JOIN AT1202 ON AT1202.DivisionID = AT1703.DivisionID AND AT1202.ObjectID = AT1703.ObjectID
        INNER JOIN AV1702 ON AV1702.DivisionID = AT1703.DivisionID AND AV1702.AccountID = AT1703.DebitAccountID AND AV1702.VoucherID = AT1703.VoucherID 
        WHERE AT1703.DivisionID = '''+ @DivisionID+ '''
        AND AT1703.D_C = ''C'' 
        AND AT1703.TranMonth + AT1703.TranYear * 12 BETWEEN ' + LTRIM(@FromMonth + @FromYear * 12) + ' AND ' + LTRIM(@ToMonth + @ToYear * 12)
    END

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype ='V' AND Name = 'AV1705')
    EXEC('CREATE VIEW AV1705 --tao boi AP1705
        AS '+@sSQL1)
ELSE
    EXEC('ALTER VIEW AV1705 --- tao boi AP1705
        AS '+@sSQL1)
GO

