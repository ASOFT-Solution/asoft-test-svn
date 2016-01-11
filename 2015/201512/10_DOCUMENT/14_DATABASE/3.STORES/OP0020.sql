IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0020]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0020]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Kế thừa bảng giá phụ phí và bảng giá chi tiết theo từng quy cách
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 29/04/2015
---- Modified on 
-- <Example>
/*
	OP0020 'AS', '', '1222', 'NBNoDiscount'
*/
CREATE PROCEDURE OP0020
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@PriceID VARCHAR(50),
	@InheritID VARCHAR(50)
)
AS
---- Kế thừa bảng giá phụ phí
INSERT INTO OT1300 (APK, DivisionID, PriceID, StandardID, UnitPrice)
SELECT NEWID(), DivisionID, @PriceID, StandardID, UnitPrice
FROM OT1300
WHERE DivisionID = @DivisionID
AND PriceID = @InheritID
---- Kế thừa bảng giá chi tiết theo quy cách

INSERT AT0135 (APK, DivisionID, PriceID, InventoryID, StandardID, UnitPrice, CreateUserID, CreateDate)
SELECT NEWID(), DivisionID, @PriceID, InventoryID, StandardID, UnitPrice, CreateUserID, CreateDate
FROM AT0135 
WHERE DivisionID = @DivisionID
AND PriceID = @InheritID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
