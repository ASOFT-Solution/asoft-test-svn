IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3200]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3200]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- Created by: Thuy Tuyen
---- Date: 25/08/2008
----- Purpose: Tra ra du lieu load  Master  ke thua nhieu phieu  don hang ban (AF3216)
----- Modify by: Thuy Tuyen, date 11/09/2008
----- Modify by: Hoàng Vũ, on 23/06/2015, Custom sesoin (43) về trường hợp hóa đơn bán hàng kế thừa từ đơn hàng bàn trừ đi phần đã xuất kho và phần điều chỉnh ------tăng giảm đơn hàng 


CREATE  PROCEDURE [dbo].[AP3200]            @DivisionID nvarchar(50),
				    @FromMonth int,
	  			    @FromYear int,
				    @ToMonth int,
				    @ToYear int,  
				    @FromDate as datetime,
				    @ToDate as Datetime,
				    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
				    @ObjectID nvarchar(50)
				
				
 AS
Declare @sSQL as nvarchar(4000),
		@sOrderID as nvarchar(Max),
		@CustomerName INT		
		SET @CustomerName = (SELECT TOP 1 CustomerName FROM CustomerIndex)

		Set @sOrderID = 'Select AQ2901.SOrderID
					from
				(		--Begin View Cu AQ2901
						Select OT2001.DivisionID, OT2001.TranMonth, OT2001.TranYear, OT2002.SOrderID,  OT2001.OrderStatus, 
								OT2002.TransactionID, OT2001.Duedate, OT2001.Shipdate, OT2002.InventoryID, 
								Isnull(OT2002.OrderQuantity,0) as OrderQuantity  ,Isnull( G.ActualQuantity,0) as ActualQuantity, 
								OT2001.PaymentTermID,AT1208.Duedays,
								case when OT2002.Finish = 1 
									then NULL else isnull(OT2002.OrderQuantity, 0)
										- isnull(G.ActualQuantity, 0) 
										+ isnull(T.OrderQuantity,0) end as EndQuantity, 
								G.OrderID as T9OrderID,
								case when OT2002.Finish = 1 
									then NULL else isnull(OT2002.ConvertedQuantity,0)
													- isnull(G.ActualConvertedQuantity, 0) 
													+ Isnull(T.ConvertedQuantity,0)
								end as EndConvertedQuantity,
								( isnull(OT2002.OriginalAmount,0) - isnull(G.ActualOriginalAmount,0 ) + isnull(T.OriginalAmount,0))  as EndOriginalAmount
						From OT2002 inner join OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2002.SOrderID = OT2001.SOrderID
									left join AT1208 ON AT1208.DivisionID = OT2001.DivisionID AND AT1208.PaymentTermID = OT2001.PaymentTermID 	
									left join 	(
													Select AT9000.DivisionID, AT9000.OrderID, OTransactionID,
															InventoryID, sum(Quantity) As ActualQuantity, sum(isnull(OriginalAmount,0)) as ActualOriginalAmount,
															SUM(isnull(ConvertedQuantity,Quantity)) As ActualConvertedQuantity
														From AT9000 
														WHERE TransactionTypeID in (''T04'',''T06'') and IsStock = 0 AND isnull(AT9000.OrderID,'''') <>''''
														Group by AT9000.DivisionID, AT9000.OrderID, InventoryID, OTransactionID
													) as G  --- (co nghia la Giao  hang)
													on 	OT2001.DivisionID = G.DivisionID AND OT2002.SOrderID = G.OrderID 
														and OT2002.InventoryID = G.InventoryID AND OT2002.TransactionID = G.OTransactionID
						--End View Cu AQ2901
									Left join (
												Select D.DivisionID, D.InventoryID, 
														Sum(D.OrderQuantity) as OrderQuantity, 
														Sum(D.ConvertedQuantity) as ConvertedQuantity, 
														Sum(D.OriginalAmount) as OriginalAmount,
														D.InheritVoucherID, D.InheritTransactionID 
												From OT2001 M Inner join OT2002 D on M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
												Where M.OrderTypeID = 1
												Group by D.DivisionID, D.InventoryID, D.InheritVoucherID, D.InheritTransactionID
												) as T on T.DivisionID = OT2002.DivisionID and T.InheritVoucherID = OT2002.SOrderID 
																							and T.InheritTransactionID = OT2002.TransactionID
						Where OT2001.OrderTypeID = 0 or OT2001.OrderTypeID is null
						) AQ2901
						Where AQ2901.EndQuantity > 0'
IF @CustomerName = 43 --- Customize Secoin
			If @IsDate =0
	
			Set @sSQL =' 
			Select top 100 percent AV1023.*
			From AV1023
			Where DivisionID = ''' + @DivisionID + ''' 
 				And ObjectID like '''+@ObjectID+ ''' 
				And Disabled=0  And Type=''SO'' And OrderStatus Not In (0,3,4,5,9)
				And OrderID In ( '+ @sOrderID +' And AQ2901.DivisionID= '''+@DivisionID+''' 
									Group by AQ2901.DivisionID, AQ2901.TranMonth, AQ2901.TranYear, AQ2901.SOrderID, AQ2901.OrderStatus
									)
				And  TranMonth+TranYear*100 between    ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' 
				+  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ' 
			order by ObjectID
			'
	
			Else

			Set @sSQL =' 
			Select  top 100 percent AV1023.*
			From AV1023
			Where DivisionID = ''' + @DivisionID + ''' 
 				And ObjectID like '''+@ObjectID+ ''' 
				And Disabled=0  And Type=''SO'' And OrderStatus Not In (0,3,4,5,9)
				And OrderID In( '+ @sOrderID +' And DivisionID= ''' + @DivisionID + '''   ) 

				And Convert(NVARCHAR,AV1023.OrderDate,112)  Between '''+Convert(NVARCHAR,@FromDate,112)+''' and '''+convert(NVARCHAR, @ToDate,112)+''' 
			order by ObjectID
			'
	
ELSE
Begin

			If @IsDate =0
			Set @sSQL =' 
			Select top 100 percent AV1023.*
			From AV1023
			Where DivisionID = ''' + @DivisionID + ''' 
 				And ObjectID like '''+@ObjectID+ ''' 
				And Disabled=0  And Type=''SO'' And OrderStatus Not In (0,3,4,5,9)
				And OrderID In (Select Distinct AQ1013.OrderID From AQ1013 Where EndQuantity>0 And DivisionID= ''' + @DivisionID + '''   ) 
				And  TranMonth+TranYear*100 between    ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' 
				+  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ' 
			order by ObjectID
			'
			Else

			Set @sSQL =' 
			Select  top 100 percent AV1023.*
			From AV1023
			Where DivisionID = ''' + @DivisionID + ''' 
 				And ObjectID like '''+@ObjectID+ ''' 
				And Disabled=0  And Type=''SO'' And OrderStatus Not In (0,3,4,5,9)
				And OrderID In (Select Distinct AQ1013.OrderID From AQ1013 Where EndQuantity>0 And DivisionID= ''' + @DivisionID + '''   ) 

				And Convert(NVARCHAR,AV1023.OrderDate,112)  Between '''+Convert(NVARCHAR,@FromDate,112)+''' and '''+convert(NVARCHAR, @ToDate,112)+''' 
			order by ObjectID
			'
End

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV3200')
	Exec('Create View AV3200  --tao boi AP3200
		as '+@sSQL)

Else
	Exec('Alter View AV3200  --- tao boi AP3200
		as '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
