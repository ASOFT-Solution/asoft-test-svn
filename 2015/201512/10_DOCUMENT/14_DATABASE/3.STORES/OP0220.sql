IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0220]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0220]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 11/11/2013
---- Purpose : Cập nhật doanh số lũy kế cho nhân viên (Sinolife)
-----Mai Duyen,Update 27/11/2013: Bo sung tham so thu tu tach don hang @OrderNo ,fix tinh AccAmount cua bang OT0123
-----Mai Duyen,Update 09/12/2013: Bo sung ContractNo
---- Modify on 27/08/2014 by Bảo Anh: Cập nhật LevelNo, ManagerID cho AT1212 khi insert
---- OP0220 'AS','CN2','SO/02/2012/0001','02/04/2012',250000000
---- OP0220 'AS','GD2','SO/02/2012/0001','02/04/2012',250000000


CREATE PROCEDURE [dbo].[OP0220]
	@DivisionID nvarchar(50),
	@SalesmanID nvarchar(50),
	@SOrderID nvarchar(50),
	@OrderDate datetime,
	@OrderAmount decimal(28,8),
	@ContractNo nvarchar(50),
	@OrderNo int 
	
AS

BEGIN
	Declare @Orders int,
			@LevelNo int,
			@tmpAccAmount decimal(28,8),
			@ManagerID nvarchar(50)
	
	SELECT @LevelNo = LevelNo, @ManagerID = ManagerID from AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID AND ObjectTypeID ='NV'

	--- Cập nhật doanh số lũy kế cuoi cung : kiem tra lai truong hop thay doi so tien don hang
	IF NOT EXISTS (Select Top 1 1 From AT1212 Where DivisionID = @DivisionID AND ObjectID = @SalesmanID And OrderID = @SOrderID AND ContractNo = @ContractNo AND OrderNo = @OrderNo )
		BEGIN
	
			UPDATE AT1202 Set AccAmount = Isnull(AccAmount,0) + @OrderAmount
			WHERE DivisionID = @DivisionID AND ObjectID = @SalesmanID AND ObjectTypeID ='NV'
			
			INSERT INTO AT1212 (DivisionID, ObjectID, LevelNo, OrderID, OrderDate, OrderAmount, ContractNo , OrderNo, ManagerID)
			VALUES (@DivisionID, @SalesmanID, @LevelNo, @SOrderID, @OrderDate, @OrderAmount,@ContractNo,@OrderNo, @ManagerID)
		
		END
	   
	ELSE -- UPDATE 22/11/2013 truong hop cap nhat hoac tinh lai hoa hong
		BEGIN
	
			UPDATE AT1202 Set AccAmount = Isnull(AccAmount,0) + @OrderAmount - (Select MAX(ISNULL(OrderAmount,0)) From AT1212 Where DivisionID = @DivisionID AND ObjectID = @SalesmanID And OrderID = @SOrderID AND ContractNo = @ContractNo   AND OrderNo = @OrderNo )
			WHERE DivisionID = @DivisionID AND ObjectID = @SalesmanID AND ObjectTypeID ='NV'
			
			UPDATE  AT1212  SET  OrderAmount = @OrderAmount  
			 Where DivisionID = @DivisionID AND ObjectID = @SalesmanID And OrderID = @SOrderID And ContractNo = @ContractNo  And OrderNo = @OrderNo
		
	  END
		
	-- Cập nhật doanh số lũy kế den thoi diem sau khi phat sinh don hang
	---Update 09/12/2013. Fix loi truong hop da co so du luy ke ban dau nen khong lay AccAmount bang At1212 ma lay bang AT1202
    UPDATE OT0123
	SET AccAmount = (Select SUM(Isnull(O23.OrderAmount,0)) From AT1212 O23 Where O23.DivisionID = @DivisionID And O23.ObjectID = OT0123.SalesmanID And O23.OrderDate <= OT0123.OrderDate)
	WHERE DivisionID = @DivisionID And OrderID = @SOrderID  And SalesmanID = @SalesmanID ANd ContractNo = @ContractNo AND OrderNo =@OrderNo
	
	
	--UPDATE OT0123
	--SET AccAmount = (Select Isnull(AccAmount,0) From AT1202  Where AT1202.DivisionID = @DivisionID And AT1202.ObjectID = OT0123.SalesmanID And  ObjectTypeID ='NV')
	--WHERE DivisionID = @DivisionID And OrderID = @SOrderID  And SalesmanID = @SalesmanID ANd ContractNo = @ContractNo AND OrderNo =@OrderNo
		
		
	--- Insert nhân viên vào bảng để xét lên cấp
	
	IF NOT EXISTS (Select Top 1 1 From OT0133 Where DivisionID = @DivisionID And SalesmanID = @SalesmanID)
		INSERT INTO OT0133 (DivisionID, SalesmanID, LevelNo, Orders, AccAmount)
		VALUES (@DivisionID, @SalesmanID, @LevelNo,
				(Select Isnull(max(Orders),999) + 1 From OT0133 Where DivisionID = @DivisionID And LevelNo = @LevelNo),
				(Select AccAmount From AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID AND ObjectTypeID ='NV' ))

	
	--- Thực thi tiếp cho các người giới thiệu
    Select  @SalesmanID = Isnull(MiddleID,'') From AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID And ObjectTypeID = 'NV'
    IF @SalesmanID <> ''
		EXEC OP0220 @DivisionID, @SalesmanID, @SOrderID, @OrderDate, @OrderAmount,@ContractNo ,@OrderNo
		
	--- Thực thi tiếp cho các người quản lý 
    Select  @SalesmanID = Isnull(ManagerID,'') From AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID And ObjectTypeID = 'NV'
    IF @SalesmanID <> ''
		EXEC OP0220 @DivisionID, @SalesmanID, @SOrderID, @OrderDate, @OrderAmount,@ContractNo ,@OrderNo

END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO