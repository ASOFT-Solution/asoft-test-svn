IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0279]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0279]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Form AF0280 Danh muc phieu chênh lệch
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 06/06/2014 by Lê Thi Thu Hiền
---- 
---- Modified on 06/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE AP0279
( 
	@DivisionID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@AnaID AS NVARCHAR(50)

) 
AS 


SELECT A.* , A1.AnaName
FROM AT0280 A
LEFT JOIN AT1015 A1 ON A.DivisionID = A1.DivisionID AND A1.AnaID = A.AnaID 
AND A1.AnaTypeID = (SELECT TOP 1 ShopTypeID 
                 FROM POST0001 
                 WHERE POST0001.DivisionID = @DivisionID)
WHERE A.DivisionID = @DivisionID
AND TranMonth = @TranMonth
AND TranYear = @TranYear
AND A.VoucherDate BETWEEN Convert(nvarchar(10),@FromDate,21) AND convert(nvarchar(10), @ToDate,21)
AND A.AnaID LIKE @AnaID