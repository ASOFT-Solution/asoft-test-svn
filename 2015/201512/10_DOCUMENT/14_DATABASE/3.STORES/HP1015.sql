
/****** Object:  StoredProcedure [dbo].[HP1015]    Script Date: 11/15/2011 14:56:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1015]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1015]
GO


/****** Object:  StoredProcedure [dbo].[HP1015]    Script Date: 11/15/2011 14:56:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

    
----- Created by Nguyen Van Nhan, Date 31/05/2004    
---- Purpose: Cho phep Xoa, Sua ma san pham    
---- Edit by: Hoàng Vũ on: 03/12/2015: Customize theo khách hàng SECOIN, check Xóa dữ liệu từ Loai sản phẩm bên HRM qua Loại mặt hàng bên CI. 
/***************************************************************    
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]    
'**************************************************************/    
CREATE PROCEDURE  [dbo].[HP1015] @ProductID as nvarchar(50),@DivisionID nvarchar(50)    
    
AS    
Declare @Status as tinyint,    
 @VietMess as nvarchar(250),    
 @EngMess as nvarchar(250)    
    
Set @Status =0    
Set @VietMess =''    
Set @EngMess =''    
    
If Exists(Select Top 1 1 FROM HT2403 Where ProductID = @ProductID and DivisionID = @DivisionID )        
  Begin    
   Set @Status =1    
   Set @VietMess = N'HFML000350' --'§· chÊm c«ng s¶n phÈm nµy cho nh©n viªn. B¹n kh«ng thÓ xãa!'    
   Set @EngMess = N'HFML000350' --'This Product has been absent, you can not delete!'    
   Goto MESS    
  End    
    
If Exists(Select Top 1 1 FROM HT1904 Where ProductID = @ProductID and DivisionID = @DivisionID )        
  Begin    
   Set @Status =1    
   Set @VietMess = N'HFML000350' --'§· chÊm c«ng s¶n phÈm nµy cho nh©n viªn. B¹n kh«ng thÓ xãa!'    
   Set @EngMess = N'HFML000350' --'This Product has been absent, you can not delete!'    
   Goto MESS    
  End    
    
If Exists(Select Top 1 1 FROM HT1903 Where ProductID = @ProductID and DivisionID = @DivisionID )        
  Begin    
   Set @Status =1    
   Set @VietMess = N'HFML000351' --'S¶n phÈm nµy ®• ®­îc thiÕt lËp ®¬n gi¸ l­¬ng. B¹n kh«ng thÓ xãa!'    
   Set @EngMess = N'HFML000351' --'This product was created the salary unit price, you can not delete!'    
   Goto MESS    
  End  
---- Customize theo khách hàng SECOIN, check Xóa dữ liệu từ Loai sản phẩm bên HRM qua Loại mặt hàng bên CI.  
		IF EXISTS (	SELECT TOP 1  1 FROM  AT2017 Where DivisionID = @DivisionID And InventoryID = @ProductID
					Union all
					SELECT TOP 1  1 FROM  AT9000  Where DivisionID = @DivisionID And InventoryID = @ProductID
					Union all
					SELECT TOP 1 1  FROM  AT2008 	Where DivisionID = @DivisionID And InventoryID = @ProductID
					Union all
					SELECT TOP 1  1 FROM  OT2002 	Where DivisionID = @DivisionID And InventoryID = @ProductID
					Union all
					SELECT TOP 1  1 FROM  OT3002 	Where DivisionID = @DivisionID And InventoryID = @ProductID
					)
		Begin
				Set @Status =1
				Set @VietMess = N'HFML000055'
				Set @EngMess = N'HFML000055'
			GOTO MESS   
		End		
 ---- Customize theo khách hàng SECOIN, check Xóa dữ liệu từ Loai sản phẩm bên HRM qua Loại mặt hàng bên CI.   
    
MESS:    
Select @Status as Status, @VietMess  As VietMess,  @EngMess as EngMess  

GO