
/****** Object:  StoredProcedure [dbo].[OP9001]    Script Date: 08/04/2010 13:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by: Thuy Tuyen  date: 23/06/2009
---- Purpose: Kiem tra rang buoc du lieu cho phep  them moi man hinh  quan ly gia
----Update : Thuy Tuyen set Set @Status =0, date 19/01/2010
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP9001] 	
				@FromDate datetime ,
				@ToDate datetime ,
				@OID nvarchar(50),
				@InventoryTypeID nvarchar(50),
				@IsEdit tinyint,  -- 0:" Khi them moi, 1khi sua
				@EditID as varchar -- ma so quan ly gia khi sua,  khi them moi thi truyen =  ''
				

AS

Declare @Status as tinyint, --- 1: Khong cho them moi :    0: Cho them moi
	@EngMessage as nvarchar(250),
	@VieMessage as nvarchar(250)
	



Select @Status =0, 	@EngMessage ='',	 @VieMessage=''



 If  exists (Select  top 1 1   from OT1301 where
		( case when  InventoryTypeID = '%' then @InventoryTypeID else InventoryTypeID  end)  =  ( case when  @InventoryTypeID = '%' then InventoryTypeID else @InventoryTypeID  end) and
		(Case When OID = '%' then @OID else OID end ) = (Case When @OID = '%' then OID else @OID end ) and
		(@Fromdate between fromdate and ( case when Todate = '1900/01/01' then '9999/01/01' else Todate  end) or
		 ( case when @Todate = '1900/01/01' then '9999/01/01' else @Todate  end)  between fromdate and ( case when Todate = '1900/01/01' then '9999/01/01' else Todate  end) ))
		BEGIN
			
					Set @Status =0 --- tam thoi do yeu cau nhap lieu nen chua xu ly ( Set @Status =0)
					Set @VieMessage = N'B¶ng gi¸ ®· ®­îc cËp nhËt. B¹n vui lßng kiÓm tra!  '
					Set @EngMessage = N'Price control  has been updated. You must check!'
					Goto EndMess
			
		
			
		END



---------------------------------------------------------------------

EndMess:
	Select @Status as Status, @EngMessage as EngMessage, @VieMessage as VieMessage
GO
