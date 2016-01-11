IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2011]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP2011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----  Created by Nguyen Van Nhan, Date 05/12/2004
-----  Kiem tra khong cho phep Xoa Lenh san xuat
---- Modified on 23/09/2014 by Lê Thị Hạnh 
---- Bổ sung kiểm tra KHÔNG CHO PHÉP SỬA/XÓA (Sài Gòn Petro - Customize index: 36)
-- <Example>
-- MP2011 @DivisionID = 'AP', @PlanID = 'DD/09/2014/0001'
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

CREATE PROCEDURE  [dbo].[MP2011] @DivisionID nvarchar(50), 
				 @PlanID as nvarchar(50)
 AS

DECLARE @CustomerName INT
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng Sài Gòn Petro không (CustomerName = 36)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 

Declare @Status as tinyint ,
		@Mess as nvarchar(250)

Set @Status =0
--@Status = 1: Khong cho xoa, sua
--@Status = 2: co canh bao nhung  cho xoa cho sua
--@Status = 3: Cho sua mot phan thoi
Set @Mess =''
----- Kiem tra o tien do san xuat
If exists (Select top 1 1  From MT2005 Where PlanID = @PlanID  and DivisionID = @DivisionID) 
	Begin
		Set @Status =1
		----Set @Mess =N'Kế hoạch sản xuất đã có tiến độ sản xuất thực tế, bạn không thể xoá được !'
		Set @Mess = 'MFML000245'
		 Insert AT7777 (DivisionID, UserID, Status, Message)
        Values (@DivisionID, '', @Status, @Mess)
        
		GOTO RETURN_VALUES
	END
--Kiểm tra kế hoạch chi tiết Đại Nam Phát
IF @CustomerName = 47
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM MT0120 WHERE DivisionID = @DivisionID AND PlanID = @PlanID)
	BEGIN
		SET @Status = 1
		SET @Mess = 'MFML000245'
		GOTO RETURN_VALUES
	END
END
-- Kiểm tra đã sử dụng lệnh sản xuất cho phiếu xuất kho hay chưa> (Sài Gòn Petro - Customize index: 36)
IF @CustomerName = 36 
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM AT2007 
	           WHERE DivisionID = @DivisionID AND InheritTableID = 'MT2001' AND InheritVoucherID = @PlanID)
	BEGIN
		SET @Status = 1
		SET @Mess = 'MFML000271'
		GOTO RETURN_VALUES
	END
END

RETURN_VALUES:
Select @Status as Status, @Mess as MESSAGE

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
