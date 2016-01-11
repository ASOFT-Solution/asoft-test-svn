IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1520]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1520]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by Hoang  Thi Lan
--Date 15/12/2003
--Purpose :ThÎ tµi s¶n cè ®Þnh
--Edit by: Nguyen Quoc Huy, Date 11/04/2007
--Edit by: Thuy Tuyen, date 06/06/2008, 20/08,2008
 
/********************************************
'* Edited by: [GS] [Ng?c Nh?t] [29/07/2010]
'********************************************/
--Edit by: Trung Dung, date 28/03/2013 - Sua lai cach lay du lieu truong DepAmount,AccuDepAmount theo nam.
--Bo sung dieu kien tu ky den ky de dam  bao du lieu chi len dung theo khoang thoi gian nguoi dung chon tren form

CREATE PROCEDURE AP1520
(
	@DivisionID NVARCHAR(50),
	@AssetIDFrom NVARCHAR(50),
	@AssetIDTo NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT
)
AS
DECLARE @sSQL NVARCHAR(MAX)

SET @sSQL = '
SELECT DISTINCT A03.AssetID, A03.AssetName, 
	(CASE WHEN EXISTS (SELECT TOP 1 AssetID FROM AT1506 A06 WHERE AssetID = A03.AssetID AND DivisionID = A03.DivisionID
							AND A06.TranMonth + A06.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+')
		  THEN (SELECT TOP 1 A06.ConvertedNewAmount FROM AT1506 A06
		        WHERE A06.AssetID = A03.AssetID AND A06.DivisionID = A03.DivisionID
					AND A06.TranMonth + A06.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+'
				ORDER BY A06.TranYear DESC, A06.TranMonth DESC) ELSE A03.ConvertedAmount END) ConvertedAmount, 
	A03.Serial, A01.CountryName, A03.MadeYear, A03.BeginYear, A03.DepartmentID, A02.DepartmentName, A04.TranYear, 	
	/*Rem by Trung Dung - 28/03/2013
	DepAmount =isnull((Select Sum(DepAmount) 
						From AT1504 
						Where DivisionID = AT1503.DivisionID and AssetID = At1503.AssetID 
							and	AT1504.TranMonth + AT1504.TranYear * 100 between (' + str(@FromMonth) + ' + ' + str(@FromYear) + ' *100) 
							and ' + str(@ToMonth) + ' + ' + str(@ToYear) + ' *100),0),
	 -----AccuDepAmount = (AT1503.ConvertedAmount  -  Isnull(ResidualValue,0)),	
	AccuDepAmount = (isnull (AT1503.ConvertedAmount,0) 	-  
					isnull(AT1503.ResidualValue,0) + 
					isnull((Select Sum(DepAmount) 
							From AT1504 
							Where DivisionID = AT1503.DivisionID and AssetID = At1503.AssetID 
								and	AT1504.TranMonth + AT1504.TranYear * 100 <= ' + str(@ToMonth) + ' + ' + str(@ToYear) + ' *100),0)),
	*/
	A.DepAmount, ISNULL(A03.ConvertedAmount, 0) - ISNULL(A03.ResidualValue, 0) + ISNULL(A.DepAmount, 0) AccuDepAmount,
	A23.ReduceVoucherNo, A23.AssetStatus, A23.ReduceDate, A03.DivisionID, A03.Years,
	V99.MonthYear BeginMonthYear, A03.AssetAccountID, A03.DepAccountID,
	A03.DebitDepAccountID1, A03.DebitDepAccountID2, A03.DebitDepAccountID3,
	A03.DebitDepAccountID4, A03.DebitDepAccountID5, A03.DebitDepAccountID6,
	A03.InvoiceNo, A03.InvoiceDate, A03.SerialNo
FROM AT1503 A03
	LEFT JOIN FV9999 V99 ON V99.DivisionID = A03.DivisionID AND V99.TranMonth = A03.BeginMonth AND V99.TranYear = A03.BeginYear
	LEFT JOIN AT1504 A04 ON A03.AssetID = A04.AssetID
	LEFT JOIN AT1102 A02 ON A02.DepartmentID = A03.DepartmentID AND A02.DivisionID = A03.DivisionID
	LEFT JOIN AT1001 A01 ON A01.CountryID = A03.CountryID
	LEFT JOIN AT1523 A23 ON A23.AssetID = A03.AssetID
	LEFT JOIN (
			SELECT DivisionID, AssetID, TranYear, SUM(DepAmount) DepAmount
			FROM AT1504 WHERE AT1504.TranMonth + AT1504.TranYear * 100 BETWEEN '+STR(@FromMonth+@FromYear*100)+' AND '+STR(@ToMonth+@ToYear*100)+'
			GROUP BY DivisionID, AssetID, TranYear)A ON A.DivisionID = A03.DivisionID AND A.AssetID = A03.AssetID AND A.TranYear = A04.TranYear	
WHERE A03.DivisionID = '''+@DivisionID+''' 
	AND A03.AssetID BETWEEN '''+@AssetIDFrom+''' AND '''+@AssetIDTo+'''
	AND A04.TranMonth + A04.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+' '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'AV1520' AND Xtype = 'V')
	EXEC ('CREATE VIEW AV1520 AS ' + @sSQL)
ELSE 
	EXEC ('ALTER VIEW AV1520 AS ' + @sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
