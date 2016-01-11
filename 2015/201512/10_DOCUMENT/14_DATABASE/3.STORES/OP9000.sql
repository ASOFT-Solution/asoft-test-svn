IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP9000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP9000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----- Created by: Vo Thanh Huong, date: 30/09/2004
---- Purpose: Kiem tra rang buoc du lieu cho phep Sua, Xoa
--- Last Edit Thuy Tuyen -- Date 03/05/20008, 18/06/2009,24/09/2009
-- Tuyen , date 26/10/2009 xu ly xoa sua khi duyet don hang
--Edit Tuyen, date 20/11/2009 , kiem tra xo khi da duyet du tru chi phi san xuat
-- Edit Nguyen, date 06/07/2010, chuyen message ra file resource, su dung message ID 
-- Edit by Khanh Van on 15/01/2014: them dieu kien kiem tra khi xoa don hang san xuat
--- Last modify on 20/01/2014 by Bảo Anh: Bổ sung kiểm tra đơn hàng đã lập hợp đồng (Sinolife)
--- Last modify on 11/02/2014 by Bảo Anh: Sửa câu thông báo OFML000070 (Sinolife)
---- Modified on 03/10/2014 by Le Thi Thu Hien : Bo sung kiem tra cho BOURBON
---- Modified on 05/05/2015 by Lê Thị Hạnh: Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa [Customize Index: 45 - ABA]
-- Edit by Hoàng Vũ on 08/07/2015:khi xoa don hang san xuat kiểm tra tồn tại bên Phiếu giao việc hay không
--- Modified on 16/09/2015 by Tiểu Mai: bổ sung kiểm tra xóa phiếu chào giá cho An Phú Gia
--- Modified by Tieu Mai on 29/12/2015: bo sung kiem tra xoa don hang san xuat cho An Phat
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP9000] 	@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@OrderID nvarchar(50),
				@TableName  nvarchar(50),
				@IsEdit tinyint   ----  =0  la Xoa,  = 1 la Sua

AS

Declare @Status as tinyint, --- 1: Khong cho xoa, sua:    2--- co canh bao nhung  cho xoa cho sua; --3: Cho sua mot phan thoi
	@EngMessage as nvarchar(250),
	@VieMessage as nvarchar(250)

Select @Status =0, 	@EngMessage ='',	 @VieMessage=''

DECLARE @CustomerName INT
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 

If @TableName =  'OT2001'  and @IsEdit = 0
BEGIN
	
	IF @CustomerName = 43 -- SECOIN
	BEGIN
			--Kiểm tra đơn hàng sản xuất có tồn tại bên phiếu giao việc hay không
			If exists (Select top 1 1 From MT2007 INNER JOIN MT2008 ON MT2007.DivisionID = MT2008.DivisionID AND MT2007.VoucherID = MT2008.VoucherID
					   Where MT2008.InheritVoucherID = @OrderID and MT2008.DivisionID = @DivisionID)
			Begin
					Set @Status =1
					Set @VieMessage ='OFML000037'
					Set @EngMessage ='This order is used. You can not delete one. You must check!'
					Goto EndMess
			END
		
	END -----IF @CustomerName = 43 -- SECOIN




	----------- Kiểm cho cho khách hàng BOURBON Xác nhận hoàn thành
	------------- Xác nhận hoàn thành	
	IF @CustomerName = 38 -- BOURBON
	BEGIN
	
	If exists (Select top 1 1 From OT3001 Where SOrderID = @OrderID AND ISNULL(KindVoucherID,0) = 2 )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000219'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
		------------- Lệnh điều động
	If exists (Select top 1 1 From OT3002
				INNER JOIN OT3001 ON OT3002.DivisionID = OT3001.DivisionID AND OT3002.POrderID = OT3001.POrderID 
	           Where OT3002.DivisionID = @DivisionID
	           AND OT3002.Notes03 = @OrderID
	           AND OT3001.KindVoucherID = 1 )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000220'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	END
		
	END -----IF @CustomerName = 38 -- BOURBON
	
	If exists (Select top 1 1 From AT9000 Where OrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000083'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
	If exists (Select top 1 1 From OT2202 Where MOrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000037'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
	If exists (Select top 1 1 From OT2001 Where InheritSOrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000037'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
	If exists ( select top 1 1 from OT2001 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and  SOrderID =  @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000067'
			Set @EngMessage ='This order is confirm. You can not delete one. You must check!'
			Goto EndMess
	End 	
	
	If exists (Select 1 From OT2003 Where SOrderID = @OrderID)
	Begin
			Set @Status = 2 
			Set @VieMessage ='OFML000068'
			Set @EngMessage ='This order has schedule delivery. Do you want to delete this order and schedule receiving ?'
			Goto EndMess
	End
	
	If exists (Select 1 From AT1020 Where DivisionID = @DivisionID And Isnull(SOrderID,'') = @OrderID)
	Begin
			Set @Status = 2 
			Set @VieMessage ='OFML000214'
			Set @EngMessage ='This order has made to contract. You cannot delete it'
			Goto EndMess
	END
	IF @CustomerName = 45 -- ABA
	BEGIN
		--- Đã được sử dụng trong quyết toán đơn hàng hay chưa? - OT0141
	IF EXISTS (SELECT TOP 1 1 FROM OT0141 WHERE DivisionID = @DivisionID AND OPVoucherID = @OrderID AND OPTableID = 'OT2001' )
	BEGIN
			SET @Status = 1
			SET @VieMessage ='OFML000228'
			Set @EngMessage ='OFML000228'
			GOTO EndMess
	END 
	END
	IF @CustomerName = 54 -- An Phat
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM MT2001 WHERE DivisionID = @DivisionID AND SOderID = @OrderID)
		BEGIN
			Set @Status =1
			Set @VieMessage ='OFML000037'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
		END
	END
	
END

If @TableName =  'OT2001'  and @IsEdit = 1
BEGIN
	----------- Kiểm cho cho khách hàng BOURBON Xác nhận hoàn thành
	------------- Xác nhận hoàn thành	
	IF @CustomerName = 38 -- BOURBON
	BEGIN
	
	If exists (Select top 1 1 From OT3001 Where SOrderID = @OrderID AND ISNULL(KindVoucherID,0) = 2 )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000219'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
		------------- Lệnh điều động
	If exists (Select top 1 1 From OT3002
				INNER JOIN OT3001 ON OT3002.DivisionID = OT3001.DivisionID AND OT3002.POrderID = OT3001.POrderID 
	           Where OT3002.DivisionID = @DivisionID
	           AND OT3002.Notes03 = @OrderID
	           AND OT3001.KindVoucherID = 1 )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000220'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	END
		
	END -----IF @CustomerName = 38 -- BOURBON
	If exists (Select top 1 1 From AT9000 Where OrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000069 '
			Set @EngMessage ='This order is used. You can  edit  field: Description, Notes 1,2,3, finished. Do you want to edit ?'
			Goto EndMess
	End 	

	If exists ( select top 1 1 from OT2001 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and  SOrderID =  @OrderID  )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000070'
			Set @EngMessage ='This order is  confirm. You can  edit  field: Description, Notes 1,2,3, finished, analysis codes. Do you want to edit ?'
			Goto EndMess
	End 	

	If  exists(Select Top 1 1 From OT2003 Where SOrderID = @OrderID) 
		Begin
			Set @Status = 2
			Set @VieMessage ='OFML000071'
			Set @EngMessage ='This order has  delivery. Do you want to edit ?'
			Goto EndMess
		End
		
	If exists (Select 1 From AT1020 Where DivisionID = @DivisionID And Isnull(SOrderID,'') = @OrderID)
	Begin
			Set @Status = 2 
			Set @VieMessage ='OFML000215'
			Set @EngMessage ='This order has made to contract. You can  edit  field: Description, Notes 1,2,3, finished. Do you want to edit ?'
			Goto EndMess
	END
	IF @CustomerName = 45 -- ABA
	BEGIN
		--- Đã được sử dụng trong quyết toán đơn hàng hay chưa? - OT0141
	IF EXISTS (SELECT TOP 1 1 FROM OT0141 WHERE DivisionID = @DivisionID AND OPVoucherID = @OrderID AND OPTableID = 'OT2001' )
	BEGIN
			SET @Status = 1
			SET @VieMessage ='OFML000228'
			Set @EngMessage ='OFML000228'
			GOTO EndMess
	END 
	END
END

If @TableName =  'OT3001'  and @IsEdit = 0
BEGIN
	If exists  (Select top 1 1 From AT9000 Where OrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000083'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 	
	If exists (Select top 1 1  from OT3002 inner join AT2007 on OT3002.TransactionID = AT2007.OTransactionID Where OT3002.POrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000083'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
	If exists (Select 1 From OT3003 Where POrderID = @OrderID)
	Begin
			Set @Status = 2 
			Set @VieMessage ='OFML000072'
			Set @EngMessage ='This order has schedule delivery. Do you want to delete this order and schedule receiving ?'
			Goto EndMess
	End

	If  exists(Select Top 1 1 From OT3001 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and POrderID = @OrderID) 
		Begin
			Set @Status = 1
			Set @VieMessage = 'OFML000067'
			Set @EngMessage ='This order is confirm. You can not delete one! '
			Goto EndMess
		END
	IF @CustomerName = 45 -- ABA
	BEGIN
	--- Đã được sử dụng trong quyết toán đơn hàng hay chưa? - OT0141
	IF EXISTS (SELECT TOP 1 1 FROM OT0141 WHERE DivisionID = @DivisionID AND OPVoucherID = @OrderID AND OPTableID = 'OT3001' )
	BEGIN
			SET @Status = 1
			SET @VieMessage ='OFML000228'
			SET @EngMessage ='OFML000228'
			GOTO EndMess
	END 	
	--- Đã được kế thừa trong đơn hàng bán hay chưa? - OT2001-2002
	IF EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE DivisionID = @DivisionID AND InheritVoucherID = @OrderID AND InheritTableID = 'OT3001' )
	BEGIN
			SET @Status = 1
			SET @VieMessage ='OFML000230'
			SET @EngMessage ='OFML000230'
			GOTO EndMess
	END 
	END
	
END

If @TableName =  'OT3001'  and @IsEdit = 1
BEGIN
	If exists  (Select top 1 1 From AT9000 Where OrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000069'
			Set @EngMessage ='This order is used. You can edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'
			Goto EndMess
	End 	
	If exists (Select top 1 1  from OT3002 inner join AT2007 on OT3002.TransactionID = AT2007.OTransactionID Where OT3002.POrderID = @OrderID )
	Begin
			Set @Status =1
			Set @VieMessage ='OFML000069'
			Set @EngMessage ='This order is used. You can not delete one. You must check!'
			Goto EndMess
	End 
	If  exists(Select Top 1 1 From OT3003 Where POrderID = @OrderID) 
		Begin
			Set @Status = 2
			Set @VieMessage ='OFML000073'
			Set @EngMessage ='This order has  delivery. Do you want to edit ?'
			Goto EndMess
		End
	If  exists(Select Top 1 1 From OT3001 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and POrderID = @OrderID) 
		Begin
			Set @Status = 1
			Set @VieMessage = 'OFML000070'
			Set @EngMessage ='This order is confirm. You can edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'
			Goto EndMess
		END
	IF @CustomerName = 45 -- ABA
	BEGIN
	--- Đã được sử dụng trong quyết toán đơn hàng hay chưa? - OT0141
	IF EXISTS (SELECT TOP 1 1 FROM OT0141 WHERE DivisionID = @DivisionID AND OPVoucherID = @OrderID AND OPTableID = 'OT3001' )
	BEGIN
			SET @Status = 1
			SET @VieMessage ='OFML000228'
			SET @EngMessage ='OFML000228'
			GOTO EndMess
	END 
	--- Đã được kế thừa trong đơn hàng bán hay chưa? - OT2001-2002
	IF EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE DivisionID = @DivisionID AND InheritVoucherID = @OrderID AND InheritTableID = 'OT3001' )
	BEGIN
			SET @Status = 1
			SET @VieMessage ='OFML000230'
			SET @EngMessage ='OFML000230'
			GOTO EndMess
	END 
	END
END
------------------------------------------------du toan don hang -----------------------------------------------------------------------
If @TableName = 'OT2004' and @IsEdit = 1
BEGIN
	IF exists (Select Top 1 1 From OT4001 Where DivisionID = @DivisionID and SOrderID = @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000074',
			@EngMessage = 'This order had estimated. You just edit Description !'	
		End 
END

If @TableName = 'OT2004' and @IsEdit = 0
BEGIN
	IF exists (Select Top 1 1 From OT4001 Where DivisionID = @DivisionID and SOrderID = @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000075',
			@EngMessage = 'This order had estimated. You can not delete one !'	
		End 
END
-----------------------------------------------------------------------------------------------------------------------------------------------


------ Kiem tra truoc khi xoa sua yeu cau mua hang -------------------------------------------

If @TableName = 'OT3101' and @IsEdit = 0
BEGIN
	IF exists( Select Top 1 1 From OT3002  Inner Join  OT3001 on OT3001.POrderID = OT3002.POrderID Where OT3002.DivisionID = @DivisionID and OT3002.ROrderID =  @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000076',
			@EngMessage = 'This order is used. You can not delete one !'	
		End 
	IF exists( Select Top 1 1 from OT3101 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and ROrderID =   @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000067',
			@EngMessage = 'This order is IsConfirm. You can not delete one !'	
		End 
	
	
	
END

If @TableName = 'OT3101' and @IsEdit = 1
BEGIN
	IF exists (Select Top 1 1 From OT3002  Inner Join  OT3001 on OT3001.POrderID = OT3002.POrderID Where OT3002.DivisionID = @DivisionID and OT3002.ROrderID =  @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000077',
			@EngMessage = 'This order is used. You can  edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'	
		End 
	IF exists( Select Top 1 1 from OT3101 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and ROrderID =   @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000070',
			@EngMessage = 'This order is IsConfirm. You can  edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'	
		End 
	
	
END

--------------- Kiem tra khi xoa , sua cua chao gia

If @TableName = 'OT2101' and @IsEdit = 0
BEGIN
	IF exists (Select Top 1 1 From OT2002  Inner Join  OT2001 on OT2001.SOrderID = OT2002.SOrderID Where OT2002.DivisionID = @DivisionID and OT2002.QuotationID = @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000078',
			@EngMessage = 'This order is used. You can not delete one !'	
		End 

	BEGIN
	IF exists (Select top 1 1 from OT2101 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and  QuotationID =  @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000067',
			@EngMessage = 'This order is IsConfirm. You can not delete one !'	
		End 
	IF @CustomerName = 48 -- Customize An Phú Gia
	BEGIN
		IF EXISTS (Select Top 1 1 From MT1603 Where MT1603.DivisionID = @DivisionID and MT1603.InheritQuotationID = @OrderID)
		BEGIN
			Select @Status = 1, 
			@VieMessage = 'OFML000237',
			@EngMessage = 'This order is used. You can not delete one !'
		END
	END
	
END
	
	
END

If @TableName = 'OT2101' and @IsEdit = 1
BEGIN
	IF exists (Select Top 1 1 From OT2002  Inner Join  OT2001 on OT2001.SOrderID = OT2002.SOrderID Where OT2002.DivisionID = @DivisionID and OT2002.QuotationID = @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000079',
			@EngMessage = 'This order is used.You  can  edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'	
		End 
	IF exists (Select top 1 1 from OT2101 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and  QuotationID =  @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000070',
			@EngMessage = 'This order is IsConfirm. You  can  edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'	
		End 
	IF @CustomerName = 48 -- Customize An Phú Gia
	BEGIN
		IF EXISTS (Select Top 1 1 From MT1603 Where MT1603.DivisionID = @DivisionID and MT1603.InheritQuotationID = @OrderID)
		BEGIN
			Select @Status = 1, 
			@VieMessage = 'OFML000238',
			@EngMessage = 'This order is IsConfirm. You  can  edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'
		END
	END
	
END


If @TableName = 'OT3019' and @IsEdit = 0
BEGIN
	IF exists( Select Top 1 1 From OT2002  Inner Join  OT3019 on OT2002.SOKitTransactionID = OT3019.SOKitTransactionID AND SOKitID =@OrderID Where OT2002.DivisionID =@DivisionID  )
		Begin
			Select @Status = 1,
			@VieMessage = 'OFML000080',
			@EngMessage = 'This order is used.You can not delete one !'	
		End 
	
	
END

If @TableName = 'OT3019' and @IsEdit =1
BEGIN
	IF exists ( Select Top 1 1 From OT2002  Inner Join  OT3019 on OT2002.SOKitTransactionID = OT3019.SOKitTransactionID AND SOKitID =@OrderID Where OT2002.DivisionID =@DivisionID  )
		Begin
			Select @Status = 1,
			@VieMessage = 'OFML000081',
			@EngMessage = 'This order is used.You can not edit  one !'	
		End 
	
	
END

---------------------------------------------------------------------

---------- Xu ky xoa sua khi da tinh du tru----------------



If @TableName = 'OT2201' and @IsEdit = 0
BEGIN
/*
	IF exists (Select Top 1 1 From OT2202  Inner Join  OT2001 on OT2001.SOrderID = OT2002.SOrderID Where DivisionID = @DivisionID and OT2002.QuotationID = @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = '§¬n hµng nµy ®· ®­îc kÕ thõa sang ®¬n hµng b¸n. B¹n kh«ng ®­îc xo¸ !',
			@EngMessage = 'This order is used. You can not delete one !'	
		End 
*/
		
	IF exists (Select top 1 1 from OT2201 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and  EstimateID =  @OrderID AND DivisionID = @DivisionID )
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000067',
			@EngMessage = 'This order is IsConfirm. You can not delete one !'	
		End 
	IF exists (Select top 1 1 from OT2203 inner join AT2007 on OT2203.DivisionID = AT2007.DivisionID and OT2203.TransactionID = AT2007.ETransactionID
	Where OT2203.EstimateID =  @OrderID AND OT2203.DivisionID = @DivisionID )
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000037',
			@EngMessage = 'This order is used. You can not delete one. You must check!'	
		End 
	
END
	
If @TableName = 'OT2201' and @IsEdit = 1
BEGIN
/*
	IF exists (Select Top 1 1 From OT2002  Inner Join  OT2001 on OT2001.SOrderID = OT2002.SOrderID Where DivisionID = @DivisionID and OT2002.QuotationID = @OrderID)
		Begin
			Select @Status = 1, 
			@VieMessage = '§¬n hµng nµy ®· ®­îc kÕ thõa sang ®¬n hµng b¸n. B¹n  chØ söa ®­îc c¸c th«ng tin: DiÔn gi¶i, ghi chó 1,2,3, hoµn tÊt.B¹n muèn söa kh«ng?',
			@EngMessage = 'This order is used.You  can  edit  field: Description, Notes 1,2,3, finished.Do you want to edit ?'	
		End 
*/
	IF exists (Select top 1 1 from OT2201 Where isnull(IsConfirm,0) = 1  and isnull (Orderstatus,0) = 1 and  EstimateID =  @OrderID AND DivisionID = @DivisionID)
		Begin
			Select @Status = 1, 
			@VieMessage = 'OFML000082',
			@EngMessage = 'This order is IsConfirm. You  can not edit one !'	
		End 
	
	
END



-------------------------------------------------------------------


EndMess:
	Select @Status as Status, @EngMessage as EngMessage, @VieMessage as VieMessage

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

