IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0282]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0282]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load thông tin màn hình Chọn phiếu bán hàng từ POS
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 24/07/2014 by Lê Thị Thu Hiền : Bổ sung DeleteFlg = 0
---- 
---- Modified on 24/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE AP0282
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@VoucherDate AS DATETIME,
		@ShopID AS NVARCHAR(50),
		@VoucherTypeID AS NVARCHAR(50),
		@VoucherNo AS NVARCHAR(50)
) 
AS 
DECLARE @sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX)

SET @sSQL = N'
SELECT P.APK AS APKMaster, P.DivisionID, P.ShopID, P.VoucherTypeID, P.TranMonth, P.TranYear,
       P.VoucherNo, P.VoucherDate, P.ObjectID, P.ObjectName, P.PaymentObjectID01,
       P.PaymentObjectName01, P.EmployeeID, P.EmployeeName, P.MemberID,
       P.MemberName, P.APKPaymentID, P.CurrencyID, P.CurrencyName, P.ExchangeRate,
       P.TotalAmount, P.TotalTaxAmount, P.TotalDiscountAmount,
       P.TotalInventoryAmount, P.AccruedScore, P.PayScore, P.LastAccruedScore,
       P.AmountOfPoint, P.DeleteFlg, P.CreateUserID, P.CreateDate,
       P.LastModifyUserID, P.LastModifyDate, P.Change, P.PaymentObjectID02,
       P.PaymentObjectName02, P.TotalDiscountRate, P.TotalRedureRate,
       P.TotalRedureAmount, P.PaymentObjectAmount01, P.PaymentObjectAmount02,
       P.AccountNumber01, P.AccountNumber02, P.IsTransferred

FROM POST0016 P
WHERE P.DivisionID = '''+@DivisionID+'''
AND P.IsTransferred = 0
AND P.DeleteFlg = 0
AND P.ShopID = '''+@ShopID+'''
AND P.VoucherTypeID LIKE ''%'+@VoucherTypeID+'%''
AND P.VoucherNo LIKE ''%'+@VoucherNo+'%''
AND CONVERT(NVARCHAR(10),P.VoucherDate,21) = '''+CONVERT(NVARCHAR(10),@VoucherDate,21)+'''
AND P.VoucherTypeID = (SELECT TOP 1 VoucherType05 FROM POST0004 
		                         WHERE DivisionID = '''+@DivisionID+''' AND ShopID LIKE '''+@ShopID+''')

'

SET @sSQL1 = N'
UNION ALL
SELECT P.APK AS APKMaster, P.DivisionID, P.ShopID, P.VoucherTypeID, P.TranMonth, P.TranYear,
       P.PVoucherNo as VoucherNo, P.VoucherDate, P.ObjectID, P.ObjectName, P.PaymentObjectID01,
       P.PaymentObjectName01, P.EmployeeID, P.EmployeeName, P.MemberID,
       P.MemberName, P.APKPaymentID, P.CurrencyID, P.CurrencyName, P.ExchangeRate,
       P.TotalAmount, P.TotalTaxAmount, P.TotalDiscountAmount,
       P.TotalInventoryAmount, P.AccruedScore, P.PayScore, P.LastAccruedScore,
       P.AmountOfPoint, P.DeleteFlg, P.CreateUserID, P.CreateDate,
       P.LastModifyUserID, P.LastModifyDate, P.Change, P.PaymentObjectID02,
       P.PaymentObjectName02, P.TotalDiscountRate, P.TotalRedureRate,
       P.TotalRedureAmount, P.PaymentObjectAmount01, P.PaymentObjectAmount02,
       P.AccountNumber01, P.AccountNumber02, P.IsTransferred

FROM POST0016 P
WHERE P.DivisionID = '''+@DivisionID+'''
AND P.IsTransferred = 0
AND P.DeleteFlg = 0
AND P.ShopID = '''+@ShopID+'''
AND P.VoucherTypeID LIKE ''%'+@VoucherTypeID+'%''
AND P.VoucherNo LIKE ''%'+@VoucherNo+'%''
AND CONVERT(NVARCHAR(10),P.VoucherDate,21) = '''+CONVERT(NVARCHAR(10),@VoucherDate,21)+'''
AND P.VoucherTypeID = (SELECT TOP 1 VoucherType02 FROM POST0004 
		                         WHERE DivisionID = '''+@DivisionID+''' AND ShopID LIKE '''+@ShopID+''')

'
SET @sSQL2 = N'
UNION ALL
SELECT P.APK AS APKMaster, P.DivisionID, P.ShopID, P.VoucherTypeID, P.TranMonth, P.TranYear,
       P.CVoucherNo as VoucherNo, P.VoucherDate, P.ObjectID, P.ObjectName, P.PaymentObjectID01,
       P.PaymentObjectName01, P.EmployeeID, P.EmployeeName, P.MemberID,
       P.MemberName, P.APKPaymentID, P.CurrencyID, P.CurrencyName, P.ExchangeRate,
       P.TotalAmount, P.TotalTaxAmount, P.TotalDiscountAmount,
       P.TotalInventoryAmount, P.AccruedScore, P.PayScore, P.LastAccruedScore,
       P.AmountOfPoint, P.DeleteFlg, P.CreateUserID, P.CreateDate,
       P.LastModifyUserID, P.LastModifyDate, P.Change, P.PaymentObjectID02,
       P.PaymentObjectName02, P.TotalDiscountRate, P.TotalRedureRate,
       P.TotalRedureAmount, P.PaymentObjectAmount01, P.PaymentObjectAmount02,
       P.AccountNumber01, P.AccountNumber02, P.IsTransferred

FROM POST0016 P
WHERE P.DivisionID = '''+@DivisionID+'''
AND P.IsTransferred = 0
AND P.DeleteFlg = 0
AND P.ShopID = '''+@ShopID+'''
AND P.VoucherTypeID LIKE ''%'+@VoucherTypeID+'%''
AND P.VoucherNo LIKE ''%'+@VoucherNo+'%''
AND CONVERT(NVARCHAR(10),P.VoucherDate,21) = '''+CONVERT(NVARCHAR(10),@VoucherDate,21)+'''
AND P.VoucherTypeID = (SELECT TOP 1 VoucherType12 FROM POST0004 
		                         WHERE DivisionID = '''+@DivisionID+''' AND ShopID LIKE '''+@ShopID+''')

'
PRINT(@sSQL)
EXEC(@sSQL +@sSQL1 +@sSQL2)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

