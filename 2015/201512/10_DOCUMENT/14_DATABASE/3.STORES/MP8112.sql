IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP8112]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP8112]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Dang Thi Tieu Mai
--Date 17/09/2015
--Purpose: Cap nhat lai gia ket qua san xuat thanh pham khi bo tinh gia thanh.


CREATE PROCEDURE [dbo].[MP8112] 	@DivisionID as nvarchar(50),
					@PeriodID as  nvarchar(50)

 AS
DECLARE @sSQL  as nvarchar(4000),
		@AT2007_cur AS CURSOR,
		@TransactionID as nvarchar(50),
		@ProductID as nvarchar(50)
	
SET @sSQL =	'	Delete From MT1614 Where DivisionID = '''+@DivisionID+''' And PeriodID = '''+@PeriodID+''';
				Update MT1601 Set IsCost=0 Where PeriodID ='''+@PeriodID+''' and DivisionID = '''+@DivisionID+'''	'
EXEC (@sSQL)
	
Set @AT2007_cur  = Cursor Scroll KeySet FOR 
Select  	TransactionID, 
	ProductID
From 	MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID AND MT0810.DivisionID = MT1001.DivisionID
Where 	MT0810.PeriodID = @PeriodID and MT1001.DivisionID =@DivisionID and
	MT0810.IsWareHouse =1 and ResultTypeID ='R01'

Open @AT2007_cur
FETCH NEXT FROM @AT2007_cur INTO  @TransactionID, @ProductID
		WHILE @@Fetch_Status = 0
			Begin	
				Update AT2007 Set	 UnitPrice = 0,
							OriginalAmount = 0,
							ConvertedAmount = 0
				Where DivisionID =@DivisionID and
					TransactionID =@TransactionID and
					InventoryID =@ProductID
				
				FETCH NEXT FROM @AT2007_cur INTO  @TransactionID, @ProductID		
			End

ClOSE @AT2007_cur

SET @sSQL = 'UPDATE MT1001 SET 	Price = 0, 
								OriginalAmount = 0,
								ConvertedAmount = 0
			From 	MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID AND MT0810.DivisionID = MT1001.DivisionID
			Where 	MT0810.PeriodID = '''+@PeriodID+''' and MT1001.DivisionID = '''+@DivisionID+''' and
					MT0810.IsWareHouse =1 and ResultTypeID =''R01'''
EXEC (@sSQL)							