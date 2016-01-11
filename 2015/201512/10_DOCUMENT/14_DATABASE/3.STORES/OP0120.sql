IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0120]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0120]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by B?o Anh	Date: 11/11/2013
---- Purpose : Tính hoa h?ng nhân viên, c?p nh?t doanh s? l?y k? và xét lên c?p
---- Update Mai Duyen : Fix loi cong gia tri null OT0123,bo sung tham so @OrderNo, fix lai cong thuc tinh hoa hong
----             goi lai SP OP0121,OP0122 de cap nhat lai lai extandAmount và SameAmount cua nguoi quan ly va nguoi gioi thieu
---- Update Mai Duyen,09/12/2013: Bo sung tham so @ContractNo, tinh @PercentCommission cua bang OT0123
---- Modify on 04/08/2014 by Bảo Anh: Không tính hoa hồng doanh số nếu nhân viên bán đã được chiết khấu trên đơn hàng
---- Update by Bảo Anh,date 14/08/2014 : Bổ sung @Orders cho OP0121 và OP0122
---- Modify on 22/09/2014 by Bảo Anh: Nếu nhân viên là chủ nhiệm và người quản lý là tổng giám thì hoa hồng phụ đạo được nhân đôi
---- OP0120 'AS','CN2','SO/02/2012/0001','02/04/2012',250000000
---- OP0120 'AS','CN2','SO/02/2012/0004','02/26/2012',500000000

CREATE PROCEDURE [dbo].[OP0120]
	@DivisionID nvarchar(50),
	@SalesmanID nvarchar(50),
	@SOrderID nvarchar(50),
	@OrderDate datetime,
	@OrderAmount decimal(28,8),	
	@ContractNo nvarchar(50),
	@OrderNo int
AS
	
--- Update doanh s? l?y k? c?a các nhân viên
DELETE OT0133 Where DivisionID = @DivisionID
EXEC OP0220 @DivisionID, @SalesmanID, @SOrderID, @OrderDate, @OrderAmount ,@ContractNo,@OrderNo

--- Xét lên c?p
EXEC OP0320 @DivisionID, @SOrderID, @OrderDate,@ContractNo,@OrderNo
--	--26/11/2013-------------------------------------

------------------bo sung
--- Xóa thông tin bang hoa hong truoc khi tính de cap nhat lai SameAmount va ExtendAmount
	DELETE OT0123 WHERE DivisionID = @DivisionID AND OrderDate >= @OrderDate AND OrderID = @SOrderID  AND Orderno = @OrderNo AND ContractNo = @ContractNo AND (SameAmount =1 OR ExtendAmount =1)
	
    ----- 2. Insert ng??i qu?n lý
	EXEC OP0122 @DivisionID, @SOrderID,	@OrderDate,	@OrderAmount, @SalesmanID,@ContractNo,@OrderNo,NULL
	
	---- 3. Insert ng??i gi?i thi?u
	EXEC OP0121 @DivisionID, @SOrderID,	@OrderDate,	@OrderAmount,@ContractNo,@OrderNo,NULL
	
------- Update hoa h?ng cho nhân viên tr?c ti?p bán ??n hàng
Declare @IsSalesCommission tinyint
SELECT @IsSalesCommission = Isnull(IsSalesCommission,0)
FROM OT2001 Where DivisionID = @DivisionID AND SOrderID = @SOrderID

IF @IsSalesCommission = 0 --- có tính hoa hồng doanh số cho nhân viên trực tiếp bán đơn hàng
	UPDATE OT0123
	SET SalesAmount = @OrderAmount * (Select isnull(SalesCommission,0) From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )/100 
	, SalesPercent = (Select isnull(SalesCommission,0) From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )
	WHERE DivisionID = @DivisionID And OrderID = @SOrderID And Isnull(SalesAmount,0) = 1 AND ContractNo = @ContractNo AND OrderNo = @OrderNo 
ELSE    
	UPDATE OT0123
	SET SalesAmount = 0
	, SalesPercent = 0
	WHERE DivisionID = @DivisionID And OrderID = @SOrderID And Isnull(SalesAmount,0) = 1 AND ContractNo = @ContractNo AND OrderNo = @OrderNo 

--- Update hoa h?ng cho ng??i qu?n lý
Declare @ManagerID nvarchar(50)
SELECT @ManagerID = ManagerID From AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID

IF (Select LevelNo From AT1202 Where DivisionID = @DivisionID And ObjectID = @ManagerID) - (Select LevelNo From AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID) = 1
	UPDATE OT0123
	SET ExtendAmount =  @OrderAmount *  (Select MiddleCommission From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )/100
	, ExtendPercent = (Select MiddleCommission From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )
	WHERE DivisionID = @DivisionID And OrderID = @SOrderID And Isnull(ExtendAmount,0) = 1 AND ContractNo = @ContractNo AND OrderNo = @OrderNo
ELSE --- nếu nhân viên là chủ nhiệm và người quản lý là tổng giám
	UPDATE OT0123
	SET ExtendAmount =  @OrderAmount * 2 * (Select MiddleCommission From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )/100
	, ExtendPercent = 2 * (Select MiddleCommission From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )
	WHERE DivisionID = @DivisionID And OrderID = @SOrderID And Isnull(ExtendAmount,0) = 1 AND ContractNo = @ContractNo AND OrderNo = @OrderNo

--- Update hoa h?ng cho nhân viên ??ng c?p
UPDATE OT0123
SET SameAmount =  @OrderAmount * (Select SameLevelCommission From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )/100
, SamePercent = (Select SameLevelCommission From AT0101 Where DivisionID = @DivisionID And LevelNo = ( case when OT0123.IsUpLevel = 1 then  OT0123.PreLevelNo +1 Else OT0123.PreLevelNo end) )
WHERE DivisionID = @DivisionID And OrderID = @SOrderID And Isnull(SameAmount,0) = 1  AND ContractNo = @ContractNo AND OrderNo = @OrderNo 


UPDATE OT0123 Set AccAmount = (Select AccAmount from AT1202 Where ObjectTypeID = 'NV' AND AT1202.ObjectID = OT0123.SalesmanID )
WHERE DivisionID = @DivisionID And OrderID = @SOrderID  AND ContractNo = @ContractNo AND OrderNo = @OrderNo 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


