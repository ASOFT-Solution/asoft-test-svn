IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP02821]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP02821]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load chi tiết thông tin phiếu bán hàng từ POS
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 24/06/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 24/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE AP02821
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@APK AS NVARCHAR(50)
) 
AS 

SELECT P.DivisionID, P.ShopID, P.APKMaster, P.WareHouseID, P.WareHouseName,
       P.InventoryID, P.InventoryName, P.UnitID, P.UnitName, P.UnitPrice,
       P.ActualQuantity, P.Amount, P.DiscountAmount, P.TaxAmount,
       P.InventoryAmount, P.VATGroupID, P.VATPercent, P.DiscountRate,
       P.IsPromotion, P.DeleteFlg, P.EVoucherNo, P.APKMInherited, P.APKDInherited,
       P.MarkQuantity, P.Ana01ID, P.Ana02ID, P.Ana03ID, P.Ana04ID, P.Ana05ID,
       P.Ana06ID, P.Ana08ID, P.Ana07ID, P.Ana09ID, P.Ana10ID, P.Imei01, P.Imei02,
       P.CreateUserID, P.CreateDate, P.LastModifyUserID, P.LastModifyDate

FROM POST00161 P
WHERE P.DivisionID = @DivisionID
AND P.APKMaster = @APK

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

