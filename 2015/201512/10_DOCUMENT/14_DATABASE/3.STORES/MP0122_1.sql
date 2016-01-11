IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0122_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0122_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Đổ nguồn Grid kế thừa kế hoạch sản xuất chi tiết
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 18/03/2015
---- Modified on 07/09/2015 by Bảo Anh: KHSX chi tiết đã được kế thừa lập 1 lệnh sản xuất thì không cho kế thừa nữa
-- <Example>
/*
	 MP0122_1 'PL', '', ''
*/

 CREATE PROCEDURE MP0122_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@PlanID VARCHAR(50),
	@PlanDetailID varchar(50) = ''
)
AS
SELECT M20.*, M21.VoucherNo PlanNo, O21.VoucherNo SOrderNo, A02.InventoryName
FROM MT0120 M20
LEFT JOIN AT1302 A02 ON A02.DivisionID = M20.DivisionID AND A02.InventoryID = M20.InventoryID
LEFT JOIN MT2001 M21 ON M21.DivisionID = M20.DivisionID AND M21.PlanID = M20.PlanID
LEFT JOIN OT2001 O21 ON O21.DivisionID = M21.DivisionID AND O21.SOrderID = M21.SOderID
WHERE M20.DivisionID = @DivisionID
AND M20.PlanID = @PlanID
AND (NOT EXISTS (Select top 1 1 From MT0121 Where DivisionID = @DivisionID And PlanID = @PlanID And PlanDetailID = M20.PlanDetailID)
OR Isnull(M20.PlanDetailID,'') = @PlanDetailID)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON