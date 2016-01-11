IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0023]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0023]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- IN phieu nhap xuat kho (mau 2: phieu ke toan)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: 
---- 
---- Edit by: Nguyen Quoc Huy, date: 20/07/2009
---- Edited by: [GS] [Việt Khánh] [04/08/2010]
---- Modified by Thanh Sơn on 08/07/2014: Lấy dữ liệu trực tiếp từ Store
-- <Example>
/*
    EXEC WP0023 '','',''
*/

CREATE PROCEDURE WP0023
(
    @DivisionID NVARCHAR(50),
    @UserID VARCHAR(50),
    @VoucherID NVARCHAR(50)
)

AS
DECLARE @sSQL NVARCHAR(MAX)

SET @sSQL = '
SELECT A06.ReDeTypeID, A06.VoucherTypeID, A06.VoucherNo, A06.VoucherDate, A06.[Description], A06.VoucherID,
	SUM(A07.ActualQuantity) ActualQuantity, SUM(A07.OriginalAmount) AS OriginalAmount, SUM(A07.ConvertedAmount) ConvertedAmount,
	A07.DebitAccountID, A07.CreditAccountID, A07.Notes, 0 Orders
FROM AT2006 A06
	LEFT JOIN AT2007 A07 ON A07.DivisionID = A06.DivisionID AND A07.VoucherID = A06.VoucherID
WHERE A06.DivisionID = '''+@DivisionID+'''
	AND A06.VoucherID = '''+@VoucherID+'''
GROUP BY A06.ReDeTypeID, A06.VoucherTypeID, A06.VoucherNo, A06.VoucherDate, A06.[Description], A06.VoucherID, A07.DebitAccountID,
	A07.CreditAccountID, A07.Notes '

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
