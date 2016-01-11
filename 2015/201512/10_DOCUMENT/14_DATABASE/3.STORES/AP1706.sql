if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AP1706]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AP1706]
GO

/****** Object: StoredProcedure [dbo].[AP1706] Script Date: 07/28/2010 15:39:49 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Thuy Tuyen
---- Date 26/12/2006
---- Purpose: Lay du lieu cho man hinh phan bo cac khoan tra va nhan truoc
---- Edit by: Dang Le Bao Quynh; Date: 04/05/2007
---- Purpose: Bo sung them mot so column cho VIEW
---- Edit by B.Anh		date 22/06/2010	Sua truong ResidualMonths (khi phan bo cho nhieu TK)
---- Edit by B.Anh		date 08/01/2011	Sua ResidualMonths len sai (khi phan bo cho 1 TK)
/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1706] 
    @DivisionID AS NVARCHAR(50),
    @TranMonth AS INT,
    @TranYear AS INT 
AS

DECLARE @sSQL1 AS NVARCHAR(4000)

SET @sSQL1 =' 
SELECT 
AT1704.DepreciationID, 
AT1704.VoucherTypeID, 
AT1704.JobID, 
AT1703.JobName,
AT1703.ConvertedAmount,
AT1703.ConvertedAmount - (ISNULL(AT1703.DepValue,0) + (SELECT ISNULL(SUM(ISNULL(DepAmount,0)),0) FROM AT1704 T04 WHERE T04.DivisionID = AT1704.DivisionID AND T04.JobID = AT1704.JobID)) AS ResidualValue,
AT1703.Periods,
(AT1703.Periods - (Isnull(AT1703.DepMonths,0) + (select count(*) from (Select distinct JobID, TranMonth, TranYear, DivisionID From AT1704 T04 Where T04.DivisionID = AT1704.DivisionID AND T04.JobID = AT1704.JobID) A))) As ResidualMonths,
CAST(AT1703.BeginMonth AS NVARCHAR) + ''/'' + CAST (AT1703.BeginYear AS NVARCHAR) AS MonthYearBegin,
AT1704.VoucherNo, 
AT1704.VoucherDate, 
AT1704.TranMonth, 
AT1704.TranYear, 
AT1704.DivisionID, 
AT1704.Status, 
AT1704.CreditAccountID, 
AT1704.DebitAccountID, 
AT1704.DepAmount, 
AT1704.Ana01ID, 
AT1704.Ana02ID, 
AT1704.Ana03ID, 
AT1704.Ana04ID, 
AT1704.Ana05ID,
AT1704.Ana06ID, 
AT1704.Ana07ID, 
AT1704.Ana08ID, 
AT1704.Ana09ID, 
AT1704.Ana10ID,
AT1704.Description, 
AT1704.D_C,
AT1704.ObjectID,
(Select ObjectName From AT1202 Where ObjectID = AT1704.ObjectID and DivisionID = AT1704.DivisionID) As ObjectName,
AT1704.SerialNo,
AT1704.InvoiceNo,
AT1704.InvoiceDate
FROM AT1704
INNER JOIN AT1703 ON AT1703.DivisionID = AT1704.DivisionID AND AT1703.JobID = AT1704.JobID
WHERE AT1704.DivisionID = ''' + @DivisionID + '''
AND AT1704.TranMonth = ' + STR(@TranMonth) + ' 
AND AT1704.TranYear = ' + STR(@TranYear) + ' 
'

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype ='V' AND Name = 'AV1706')
    EXEC('CREATE VIEW AV1706 --tao boi AP1706
        AS '+@sSQL1)
ELSE
    EXEC('ALTER VIEW AV1706 --tao boi AP1706
        AS '+@sSQL1)
        
GO

