IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0320]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0320]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 11/11/2013
---- Purpose : Xét lên cấp cho nhân viên (Sinolife)
---- Mai Duyen, date 25/11/2013 :sua dieu kien @LevelNo->LevelNo va Rem cap nhat nguoi gioi thieu ,
-----   Bo sung them field @OrderNo; Fix dieu kien  LevelNo =@LevelNo +1, PrelevelNo de cap nhat trang thai len cap
---- Modify on 03/12/2013 by Bảo Anh: Update cấp và người quản lý trong AT1212 dùng để cập nhật lại thông tin khi xóa hoa hồng
---- Modify on 09/12/2013 by Mai Duyen: Bo sung @ContractNo
---- Modify on 11/12/2013 by Bảo Anh: Where thêm điều kiện ContractNo khi cập nhật LevelNo và ManagerID trong AT1212
---- Modify on 24/12/2013 by Mai Duyen: Bo sung dieu kien len cap cho truong hop cap TG(LevelNo =2 ) 
---- Modify on 26/06/2014 by Bảo Anh:	1/ Bổ sung trường hợp GD có thể quản lý GD khi xét điều kiện lên cấp TG
----									2/ Cấp CN lên GD thì người quản lý luôn là người giới thiệu
---- Modify on 05/08/2014 by Bảo Anh: Sửa điều kiện lên cấp TG (dựa vào lịch sử giám đốc đã từng quản lý bao nhiêu chủ nhiệm được lên giám đốc)
---- Modify on 18/08/2014 by Bảo Anh:	1/ Xét thêm nhánh khi lên cấp TG (quản lý 2 GD thuộc 2 nhánh khác nhau)
----									2/ Cập nhật lại người quản lý, người giới thiệu cho các nhân viên có người giới thiệu lên cấp, lưu lịch sử quản lý vào AT1213
---- Update by Bảo Anh, Date 17/09/2014 : Sửa cách tính @CountEmployeeID (bỏ xét theo mã nhánh)
---  OP0320 'AS','SO/02/2012/0004','02/26/2012'

CREATE PROCEDURE [dbo].[OP0320]
	@DivisionID nvarchar(50),
	@SOrderID nvarchar(50),
	@OrderDate datetime ,
	@ContractNo nvarchar(50),
	@OrderNo int
AS

Declare @Cur cursor,
		@SalesmanID nvarchar(50),
		@LevelNo int,
		@Orders int,
		@AccAmount decimal(28,8),
		@UpLevelNo int,
		@UpAmount decimal(28,8),
		@ManagerID nvarchar(50),
		@MiddleID nvarchar(50),
		@OldManagerID nvarchar(50),
		@CountEmployeeID int

SET @Cur = CURSOR SCROLL KEYSET FOR

SELECT SalesmanID, LevelNo, Orders, AccAmount FROM OT0133 
WHERE LevelNo <> (Select LevelCounts from AT0000 Where DefDivisionID = @DivisionID) - 1
Order by LevelNo DESC, Orders DESC

OPEN @Cur
FETCH NEXT FROM @Cur INTO @SalesmanID, @LevelNo, @Orders, @AccAmount
WHILE @@FETCH_STATUS = 0
BEGIN
	Set @UpLevelNo = 0
	SELECT @OldManagerID = ManagerID from AT1202 Where DivisionID = @DivisionID AND ObjectID = @SalesmanID AND ObjectTypeID = 'NV'
	SELECT @UpLevelNo = LevelNo, @UpAmount = DiffSales
	FROM (	Select top 1 LevelNo, (@AccAmount - Isnull(UpSales,0)) as DiffSales From AT0101
			--Where DivisionID = @DivisionID AND (@AccAmount - UpSales) > 0 
			Where DivisionID = @DivisionID AND (@AccAmount - Isnull(UpSales,0)) > 0 AND LevelNo =@LevelNo +1
			Order by (@AccAmount - Isnull(UpSales,0)) DESC) A

     --Cap nhat lai PreLevelNo truoc de tinh hoa hong--------
		UPDATE OT0123
		SET  PreLevelNo = (Select LevelNo from AT1202 Where
		 DivisionID = @DivisionID AND ObjectTypeID ='NV' AND ObjectID = @SalesmanID )
		WHERE DivisionID = @DivisionID AND SalesmanID = @SalesmanID AND OrderID = @SOrderID AND ContractNo = @ContractNo  AND OrderNo = @OrderNo	
	
	----------------------------------------------------
	 -- Update 24/12/2013 lay so luong nhan vien cap duoi
		SET @CountEmployeeID = 0
		IF ISNULL(@UpLevelNo,0) = 2 -- Neu la cap 2
			BEGIN
				/*
				SELECT @CountEmployeeID =  COUNT(BranchID) FROM (
											Select BranchID,COUNT(ObjectID) as OBCounts From AT1202 Where DivisionID = @DivisionID
											AND ManagerID = @SalesmanID AND AccAmount >= (Select UpSales from AT0101 Where DivisionID = @DivisionID AND LevelNo =1)
											GROUP BY BranchID
											HAVING COUNT(ObjectID) > 0) A
				*/
				/*
				--- Modify on 26/06/2014 by Bảo Anh: Bổ sung trường hợp GD có thể quản lý GD
				IF @CountEmployeeID = 1 --- nếu chỉ quản lý 1 GD thì xét thêm GD này có quản lý GD nào nữa không
					Begin
						Declare @GD nvarchar(50)						
						Select @GD = ObjectID From AT1202 Where DivisionID = @DivisionID AND ManagerID = @SalesmanID AND AccAmount >= (Select UpSales from AT0101 Where DivisionID = @DivisionID AND LevelNo =1)
						IF EXISTS (Select top 1 1 From AT1202 Where DivisionID = @DivisionID AND ManagerID = @GD AND AccAmount >= (Select UpSales from AT0101 Where DivisionID = @DivisionID AND LevelNo =1))
							SET @CountEmployeeID = 2
					End
				*/
				
				--- Modify on 05/08/2014 by Bảo Anh: Lấy số giám đốc cấp dưới theo bảng lịch sử AT1213
				
				SELECT @CountEmployeeID =	COUNT(ObjectID)
											From AT1202
											Where DivisionID = @DivisionID AND MiddleID = @SalesmanID
											AND ObjectID in (Select ObjectID From AT1213 Where DivisionID = @DivisionID AND ManagerID = @SalesmanID)
											AND AccAmount > (Select UpSales from AT0101 Where DivisionID = @DivisionID AND LevelNo =1)
			END
	------------------------------------------------------------------------------------------------		
	IF ( ISNULL(@UpLevelNo,0) =2  AND @CountEmployeeID >1 ) or ISNULL(@UpLevelNo,0) =1 --Bổ sung điều kiện xét lên cấp 2
	BEGIN
		--- Update doanh số lên cấp và cấp được lên		
		UPDATE OT0123
		SET UpAmount = @UpAmount, UpLevelNo = @UpLevelNo, PreLevelNo =@UpLevelNo-1,  IsUpLevel = 1
		WHERE DivisionID = @DivisionID AND SalesmanID = @SalesmanID AND OrderID = @SOrderID AND ContractNo = @ContractNo AND OrderNo = @OrderNo
		
		--- Update lại người quản lý
		-----	1. Update người quản lý trong trường hợp lên cấp cao nhất	
		IF @UpLevelNo = (Select LevelCounts from AT0000 Where DefDivisionID = @DivisionID) - 1 --2
			BEGIN
				SET @ManagerID = ''									
			END
		ELSE --- 2. Update người quản lý trong trường hợp chưa lên cấp cao nhất
			BEGIN
				
				--- nhân viên lên cấp nhưng người quản lý chưa đủ điều kiện lên cấp cao hơn
				IF @UpLevelNo = (SELECT LevelNo from AT1202 Where DivisionID = @DivisionID
								AND ObjectID = (Select ManagerID from AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID))
					BEGIN
						SELECT @ManagerID = ManagerID from AT1202 Where DivisionID = @DivisionID
						And ObjectID = (Select ManagerID from AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID)
						
					END	
				Else
					---Mai Duyen bo sung them truong hop nguoi quan ly cung len cap cao 26/11/2013
					BEGIN
						SELECT @ManagerID = (Select ManagerID from AT1202 Where DivisionID = @DivisionID And ObjectID = @SalesmanID)
					END
			END
		----	3. Update người quản lý cho các nhân viên có người giới thiệu lên cấp
		IF ISNULL(@UpLevelNo,0) > 0
		BEGIN
			DELETE OT0113 WHERE DivisionID = @DivisionID
			EXEC OP0321 @DivisionID, @SalesmanID
				
			--- Insert vào OT0153 dùng update lại người quản lý sau khi xóa hoa hồng
			INSERT INTO OT0153 (DivisionID, OrderID, OrderNo, SalesmanID, ManagerID, MiddleID)
			SELECT 	@DivisionID, @SOrderID, @OrderNo, ObjectID,
			(Select ManagerID From AT1202 WHERE DivisionID = @DivisionID AND ObjectID = OT0113.ObjectID), (Select MiddleID From AT1202 WHERE DivisionID = @DivisionID AND ObjectID = OT0113.ObjectID)
			FROM OT0113
			WHERE DivisionID = @DivisionID
		
			--- Update người quản lý
			UPDATE AT1202 SET ManagerID = @SalesmanID WHERE DivisionID = @DivisionID
			AND ObjectID in (Select ObjectID From OT0113 Where DivisionID = @DivisionID)
			
			--- Insert vào AT1213 để lưu thông tin người quản lý của chủ nhiệm (dùng xét lên cấp tổng giám)
			INSERT INTO AT1213 (DivisionID,ObjectID,ManagerID)
			SELECT DivisionID, ObjectID, @SalesmanID
			FROM OT0113
			WHERE DivisionID = @DivisionID AND LevelNo = 0
			AND ObjectID + @SalesmanID NOT IN (Select ObjectID + ManagerID From AT1213 Where DivisionID = @DivisionID)
		END
					
		--- Cập nhật giá trị mới cho nhân viên lên cấp trong bảng dữ liệu xét lên cấp
		INSERT INTO OT0133 (DivisionID, SalesmanID, LevelNo, Orders, AccAmount)
		VALUES	(@DivisionID, @SalesmanID, @UpLevelNo,
				(Select Isnull(min(Orders),1001) - 1 From OT0133 Where LevelNo = @UpLevelNo),
				@AccAmount)
				
		DELETE OT0133 WHERE LevelNo = @LevelNo AND SalesmanID = @SalesmanID
		
		--- Update cấp trong thông tin nhân viên
		UPDATE AT1202
		---Rem cap nhat nguoi gioi thieu
		--SET LevelNo = @UpLevelNo, ManagerID = @ManagerID, MiddleID = @MiddleID
		SET LevelNo = @UpLevelNo, ManagerID = @ManagerID
		WHERE DivisionID = @DivisionID AND ObjectID = @SalesmanID
	END
	
	----- Update lại cấp và người quản lý cho AT1212 dùng ở store xóa hoa hồng: để lấy lại dữ liệu trước khi lên cấp
	UPDATE AT1212 Set LevelNo = (case when ISNULL(@UpLevelNo,0) = 0 then @LevelNo else @UpLevelNo end),
					ManagerID = (case when ISNULL(@UpLevelNo,0) = 0 then @OldManagerID else @ManagerID end)
	WHERE DivisionID = @DivisionID AND OrderID = @SOrderID AND ObjectID = @SalesmanID AND ContractNo = @ContractNo AND OrderNo = @OrderNo
	
	FETCH NEXT FROM @Cur INTO @SalesmanID, @LevelNo, @Orders, @AccAmount

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON