IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP9000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP9000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----
----- Created by: Phan thanh Hoàng Vũ, date: 13/02/2015
----- Purpose: Kiem tra rang buoc du lieu cho phep Sua, Xoa
----- Exec MP9000 'AS', 3, 2014, '5cc3ac96-d147-4142-b7de-04952d4e65b9','MT2007', 1

CREATE PROCEDURE [dbo].[MP9000] 	@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@VoucherID nvarchar(50),
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

If @TableName =  'MT2007'  and @IsEdit = 1
BEGIN
			IF @CustomerName = 43 --SECOIN
			BEGIN
	
					If exists (	Select top 1 1 
								From MT0810 M inner join MT1001 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
								Where InheritVoucherID = @VoucherID
							  )
					Begin
							Set @Status =3
							Set @VieMessage ='MFML000274'
							Set @EngMessage =''
							Goto EndMess
					End 
					If exists (	Select top 1 1 
								From AT2006 M inner join AT2007 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
								Where InheritVoucherID = @VoucherID
							  )
					Begin
							Set @Status =3
							Set @VieMessage ='MFML000273'
							Set @EngMessage =''
							Goto EndMess
					End
				
		
			END -----IF @CustomerName = 43 --SECOIN
			
END

If @TableName =  'MT2007'  and @IsEdit = 0
BEGIN
			IF @CustomerName = 43 --SECOIN
			BEGIN
					If exists (	Select top 1 1 
								From MT0810 M inner join MT1001 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
								Where InheritVoucherID = @VoucherID
							  )
					Begin
							Set @Status =1
							Set @VieMessage ='MFML000280'
							Set @EngMessage =''
							Goto EndMess
					End 
			END -----IF @CustomerName = 43 --SECOIN
			
END


EndMess:
	Select @Status as Status, @EngMessage as EngMessage, @VieMessage as VieMessage

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

