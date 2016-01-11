IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP9000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----- Created by Nguyen Van Nhan.
---- Created Date Sunday 06/06/2004
---- Purpose: Kiem tra rang buoc du lieu cho phep Sua, Xoa
---- Edit by: Dang Le Bao Quynh Date 16/05/2007
---- Purpose: Kiem tra chung tu da duoc chon phan bo DTNT & CPTT truoc khi xoa
---- Edit by B.Anh, date 25/07/2009, bo sung kiem tra doi voi nhap kho mua hang, xuat kho ba'n hang
---- Modified on 10/05/2012 by Lê Thị Thu Hiền : Bổ sung kiểm tra Định nghĩa vị trí (Lô) FormID = WF0081
---- Modified on 10/05/2012 by Lê Thị Thu Hiền : Bổ sung kiểm tra vị trí (Lô) FormID = WF0079
---- Modified on 21/10/2012 by Bao Anh : Kiểm tra khi bỏ duyệt tạm chi/tạm chi qua ngân hàng
---- Modified on 11/12/2012 by Bao Anh : Kiểm tra khi sua/xoa phieu mua/ban hang co ke thua lap phieu chi/thu
---- Modified on 22/01/2013 by Bao Anh : Sửa lỗi Status trả về sai khi sua/xoa phieu mua/ban hang co ke thua lap phieu chi/thu
---- Modified on 11/06/2014 by Lê Thị Thu Hiền : Bổ sung kiểm tra Phiếu kết chuyển từ POS
---- Modified on 19/06/2014 by Lê Thị Thu Hiền : Status = 3 Bạn được sửa 1 số thông tin
---- Modified on 30/06/2014 by Trần Quốc Tuấn : Status = 3 thay tableID thành ReTableID
---- Modified on 21/07/2014 by Lê Thị Thu Hiền : Kiểm tra hàng bán trả lại được chuyển từ POS
---- Modified on 04/03/2015 by Lê Thị Hạnh: Bổ sung kiểm tra trước khi sửa, xoá AF0080, AF0072, AF0085, AF0094 [Phân bổ chi phí mua hàng - LAVO]
---- Modified on 21/12/2015 by Phương Thảo : Kiểm tra tại màn hình phiếu Chi (bỏ qua không kiểm tra dòng Thuế nhà thầu 'T43')

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
/* 
exec AP9000 @Divisionid=N'LV',@Tranmonth=2,@Tranyear=2015,@Voucherid=N'TVff78d783-729c-409e-b0cf-b3e975c7fb9f',@Tableid=N'AT9000',@Batchid=N'TB2111f898-bf16-46b1-9ffa-4a8fc691bd9b',@Fromid=N'AF0080'

*/


CREATE PROCEDURE [dbo].[AP9000] 	
				@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@VoucherID nvarchar(50),
				@TableID  nvarchar(50),
				@BatchID as nvarchar(50),
				@FromID as nvarchar(50)
AS

Declare @Status as tinyint,
	@EngMessage as nvarchar(250),
	@VieMessage as nvarchar(250)

	SET @Status =0
	SET @EngMessage =''
	SET @VieMessage=''

--Add by Dang Le Bao Quynh; Date 02/05/2013
--Purpose: Kiem tra customize cho Sieu Thanh

Declare @AP4444 Table(CustomerName Int, Export Int)
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')



/*
If (Select CustomerName From @AP4444)=16
	----- Xu ly chung
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where 	VoucherID =@VoucherID and TableID = @TableID and DivisionID =@DivisionID and 
								TranMonth =@TranMonth And TranYear =@TranYear and (IsCost<>0 or IsAudit <>0 ))
			BEGIN
				SET @Status =1
				SET @VieMessage =N'AFML000042'
				SET @EngMessage =N'AFML000042'
				Goto EndMess
			End
	End	
Else
*/
	BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where VoucherID =@VoucherID and TableID = @TableID and DivisionID =@DivisionID and 
							TranMonth =@TranMonth And TranYear =@TranYear and (Status <>0 or IsCost<>0 or IsAudit <>0 ) )
		BEGIN
			SET @Status =1
			SET @VieMessage =N'AFML000042'
			SET @EngMessage =N'AFML000042'
			Goto EndMess
		End
	End
	
	IF EXISTS (SELECT TOP 1 1 FROM AT1703 WHERE VoucherID =@VoucherID AND DivisionID =@DivisionID)
		BEGIN
			SET @Status =1
			SET @VieMessage =N'AFML000043'
			SET @EngMessage =N'AFML000043'
			Goto EndMess
		End

	IF @FromID ='WF0008'		----- Phieu xuat kho kiem van chuyen noi bo
		BEGIN
			Exec AP0701 @DivisionID,@TranMonth,	@TranYear,@VoucherID,@Status  output, @EngMessage  output, @VieMessage output
			Goto EndMess
		End

	IF @FromID ='AF0058' OR @FromID ='WF0014'		----- Phieu xuat kho theo bo
		BEGIN
			Exec AP0701 @DivisionID,@TranMonth,	@TranYear,@VoucherID,@Status  output, @EngMessage  output, @VieMessage output
			Goto EndMess
		End


	IF @FromID ='AF0091' or @FromID ='AF0096'		----- Phieu mua hang, ba'n hang, nhap kho mua hang, xuat kho ba'n hang
		BEGIN
			Exec  AP3033 	@VoucherID, @BatchID, @DivisionID, @TranMonth, @TranYear,	@Status output, @VieMessage output, @EngMessage output
			Goto EndMess
		End

	If @FromID ='WF0007'   ---- So du hang ton kho
		BEGIN
			 Exec AP1701 @DivisionID,@TranMonth, @TranYear,@VoucherID, @Status output, @EngMessage output, @VieMessage output	
			Goto EndMess			
		End
	If @FromID ='AF0072' -- Truy vấn phiếu thu chi
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where TransactionTypeID not in ('T01','T02','T11','T43') and VoucherID =@VoucherID and BatchID = @BatchID and TableID = @TableID and DivisionID =@DivisionID)
				BEGIN
					SET @Status =1
					SET @VieMessage =N'AFML000044'
					SET @EngMessage =N'AFML000044'
					--SET @EngMessage ='This voucher is in used. You can not edit or delete one. You must check!'
					Goto EndMess
				End
			IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where VoucherID =@VoucherID and BatchID = @BatchID and TableID = 'CMT0015' and DivisionID =@DivisionID)
				BEGIN
					SET @Status =1
					SET @VieMessage =N'AFML000044'
					SET @EngMessage =N'AFML000044'
					--SET @EngMessage ='This voucher is in used. You can not edit or delete one. You must check!'
					Goto EndMess
				END
				-- Kiểm tra phiếu đã thực hiện phân bổ chi phí mua hàng hay chưa?
			IF EXISTS (SELECT TOP 1 1 FROM AT0321 WHERE DivisionID = @DivisionID AND POCVoucherID = @VoucherID )
				BEGIN
						SET @Status = 1
						SET @VieMessage ='AFML000386'
						SET @EngMessage ='AFML000386'
						GOTO EndMess
				END 				
		End
	If @FromID ='AF0085' -- Truy vấn thu chi ngân hàng
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where VoucherID =@VoucherID and BatchID = @BatchID and TableID = 'CMT0015' and DivisionID =@DivisionID)
				BEGIN
					SET @Status =1
					SET @VieMessage =N'AFML000044'
					SET @EngMessage =N'AFML000044'
					--SET @EngMessage ='This voucher is in used. You can not edit or delete one. You must check!'
					Goto EndMess
				END
				-- Kiểm tra phiếu đã thực hiện phân bổ chi phí mua hàng hay chưa?
			IF EXISTS (SELECT TOP 1 1 FROM AT0321 WHERE DivisionID = @DivisionID AND POCVoucherID = @VoucherID )
				BEGIN
						SET @Status = 1
						SET @VieMessage ='AFML000386'
						SET @EngMessage ='AFML000386'
						GOTO EndMess
				END
		End
	------------------ Định nghĩa vị trí------------
	IF @FromID = 'WF0081'
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM AT2007 WHERE SourceNo = @VoucherID AND DivisionID = @DivisionID)
		BEGIN
			SET @Status = 1
			SET @VieMessage = N'WFML000042'
			SET @EngMessage = N'WFML000042'
			GOTO EndMess
		END
	END
	------------------ Vị trí------------
	IF @FromID = 'WF0079'
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM WT1006 WHERE (	Location01ID = @VoucherID OR 
														Location02ID = @VoucherID OR 
														Location03ID = @VoucherID OR 
														Location04ID = @VoucherID OR 
														Location05ID = @VoucherID ) 
														AND DivisionID = @DivisionID)
		BEGIN
			SET @Status = 1
			SET @VieMessage = N'WFML000042'
			SET @EngMessage = N'WFML000042'
			GOTO EndMess
		END
	END
	--- kiem tra khong cho bo duyet tam chi/tam chi qua ngan hang
	IF @FromID ='AF0098' or @FromID ='AF0257'
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM AT9010 Where Isnull(ReVoucherID,'') = @VoucherID	And DivisionID = @DivisionID)
				BEGIN
					SET @Status =1
					SET @VieMessage =N'AFML000365'
					SET @EngMessage =N'AFML000365'
					Goto EndMess
				End
				
			IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where VoucherID =@VoucherID and DivisionID =@DivisionID and 
							TranMonth =@TranMonth And TranYear =@TranYear and (Status <>0 or IsCost<>0 or IsAudit <>0 ) )
				BEGIN
					SET @Status =1
					SET @VieMessage =N'AFML000370'
					SET @EngMessage =N'AFML000370'
					Goto EndMess
				End
		END
	--- kiem tra khong cho Sua/Xoa khi phieu hang/ban hang duoc ke thua lap phieu chi/thu
	IF @FromID = 'AF0093'
		BEGIN
			--If (Select CustomerName From @AP4444)<>16
			--BEGIN
				IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where TransactionTypeID in( 'T01','T21') And Isnull(TVoucherID,'') = @VoucherID and DivisionID =@DivisionID)
					BEGIN
						SET @Status =1
						SET @VieMessage =N'AFML000371'
						SET @EngMessage =N'AFML000371'
					End

				IF EXISTS (SELECT TOP 1 1 FROM CMT0010 Where VoucherID = @VoucherID and DivisionID =@DivisionID)
					BEGIN
						SET @Status =1
						SET @VieMessage =N'AFML000379'
						SET @EngMessage =N'AFML000379'
					End
				Else
					Exec  AP3033 	@VoucherID, @BatchID, @DivisionID, @TranMonth, @TranYear,	@Status output, @VieMessage output, @EngMessage output
				
				------------ Phiếu kết chuyển từ POS
				IF EXISTS (SELECT TOP 1 1 FROM AT9000 
							Where AT9000.DivisionID =@DivisionID AND AT9000.ReTableID = 'POST0016' AND AT9000.VoucherID = @VoucherID)
					BEGIN
						SET @Status = 3
						SET @VieMessage =N'AFML000381' 
						SET @EngMessage =N'AFML000381'
					End
				Goto EndMess
				
				
			--End
		End
	
	IF @FromID = 'AF0080' -- Truy vấn phiếu mua hàng
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM AT9000 Where TransactionTypeID = 'T02' And Isnull(TVoucherID,'') = @VoucherID and DivisionID =@DivisionID)
				BEGIN
					SET @Status =1
					SET @VieMessage =N'AFML000372'
					SET @EngMessage =N'AFML000372'
				End
			else
				Exec  AP3033 	@VoucherID, @BatchID, @DivisionID, @TranMonth, @TranYear,	@Status output, @VieMessage output, @EngMessage output
			
			
				-- Kiểm tra phiếu đã thực hiện phân bổ chi phí mua hàng hay chưa?
			IF EXISTS (SELECT TOP 1 1 FROM AT0321 WHERE DivisionID = @DivisionID AND POVoucherID = @VoucherID )
				BEGIN
						SET @Status = 1
						SET @VieMessage ='AFML000386'
						SET @EngMessage ='AFML000386'
				END
			Goto EndMess
		END
		
		
	If @FromID ='AF0097'  ---- Hàng bán trả lại
		BEGIN
			------------ Phiếu kết chuyển từ POS
				IF EXISTS (SELECT TOP 1 1 FROM AT9000 
							Where AT9000.DivisionID =@DivisionID AND AT9000.ReTableID = 'POST0016' AND AT9000.VoucherID = @VoucherID)
					BEGIN
						SET @Status = 3
						SET @VieMessage =N'AFML000381' 
						SET @EngMessage =N'AFML000381'
					END
					
				Goto EndMess
				
		End

IF @FromID ='AF0094' -- Bút toán tổng hợp
	BEGIN
		-- Kiểm tra phiếu đã thực hiện phân bổ chi phí mua hàng hay chưa?
			IF EXISTS (SELECT TOP 1 1 FROM AT0321 WHERE DivisionID = @DivisionID AND POCVoucherID = @VoucherID )
				BEGIN
						SET @Status = 1
						SET @VieMessage ='AFML000386'
						SET @EngMessage ='AFML000386'
						
				END
			GOTO EndMess
	END
--================================================
	EndMess:
	Select @Status as Status, @EngMessage as EngMessage, @VieMessage as VieMessage



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


