IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3201]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3201]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Load detail cho man hinh  ke thua  nhieu  don hang ban(AF3116) 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 26/08/2007 by Nguyen Thi Thuy Tuyen
---- 
---- Modified on 11/09/2008 by Thuy Tuyen
---- Modified on 08/10/2009 by Bao Anh : Lay truong IsDiscount
---- Modified on 10/10/2009 by T.Tuyen
---- Modified on 29/11/2011 by Thien Huynh : Tach chuoi SQL truong hop @lstROrderID qua dai
---- Modified on 05/01/2012 by Le Thi Thu Hien : ISNULL
---- Modified on 05/01/2012 by Thien Huynh : Lay them cac truong ĐVT quy doi
---- Modified on 29/11/2011 by Thien Huynh : Tach chuoi SQL truong hop @sSQL qua dai
---- Modified on 04/07/2014 by Tan Phu : them column PriceListID
---- Modified on 15/10/2014 by Lê Thị Hanh: Lấy thêm nvarchar01, nvarchar02, nvarchar03: theo dõi chiết khấu
---- Modified on 07/01/2015 by Quốc Tuấn: Lấy thêm số lượng quy đổi từ AQ2901
---- Modified on 24/06/2015 by Hoàng Vũ: Custom secoin kế thừa đơn hàng trừ thêm phần điều chỉnh giảm/tăng của đơn hàng
---- Modified by Tieu Mai on 16/12/2015: Bo sung truong hop thiet lap quan ly mat hang theo quy cach
-- <Example>
----


CREATE PROCEDURE [dbo].[AP3201] 
		@DivisionID nvarchar(50),
		@VATGroupID nvarchar(50),
		@lstROrderID nvarchar(4000),
		@VoucherID nvarchar(50), --- Addnew   truyen ''; Load Edit :  so chung tu vua duoc chon sua
		@ConnID nvarchar(100) ='',
		@InheritDHSX int -- kế thừa dhsx:1 Không kế thừa đơn hàng sx:0. Chỉ sử dụng cho khách hàng Minh phương
				
AS
Declare @sSQL  nvarchar(Max),
		@sSQLUnion  nvarchar(Max),
		@sSQL1  nvarchar(4000),
		@sSQL2  nvarchar(4000),
		@VATRate decimal(28,8),
		
		@CustomerName INT		
		SET @CustomerName = (SELECT TOP 1 CustomerName FROM CustomerIndex)
SET @lstROrderID = 	REPLACE(@lstROrderID, ',', ''',''')

SELECT	@VATRate  = ISNULL(VATRate,0)   
FROM	AT1010 
WHERE	VATGroupID = @VATGroupID AND DivisionID =@DivisionID
--- Print @lstROrderID



IF(@CustomerName = 1 AND @InheritDHSX = 1) --Customername = 1 khách hàng minh phuong
	BEGIN
		IF isNULL (@VoucherID,'') <> '' 
		BEGIN
			SET @sSQL ='
		SELECT 
				T00.ObjectID,  T00.VATObjectID , T00.CurrencyID,T00.Exchangerate,
				T00.OrderID,T00.OTransactionID AS TransactionID ,
				T00.InventoryID,T01.InventoryName, T01.UnitID,  0 AS IsEditInventoryName,
				T00.Quantity, T00.UnitPrice,  T00.CommissionPercent,
				T00.OriginalAmount, T00.ConvertedAmount, 
				NULL AS DiscountPercent, 
				NULL AS DiscountConvertedAmount,
				T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
				T01.AccountID, T01.MethodID, T01.IsStocked,
				T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID,  T00.Ana05ID, 
				T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID,  T00.Ana10ID, 
				T00.Orders, NULL  AS DueDate,NULL AS ShipDate, NULL AS DueDays,'''' AS VATNo,
				'''' AS PaymentID, '''' AS PaymenttermID,
				1 AS IsCheck, AT1010.VATRate AS VATPercent, T00.VatGroupID,
				(SELECT OriginalAMount FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  AND TransactionTypeID = ''T14'')as VATOriginalAMount,
				(SELECT ConvertedAmount FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  AND TransactionTypeID = ''T14'')as VATConvertedAmount,
				T00.BDescription, T01.IsDiscount, T00.DivisionID,
				T00.MOrderID,
				T00.SOrderID,
				T00.MTransactionID,
				T00.STransactionID,
				T00.ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedPrice, 
				T00.UParameter01, T00.UParameter02, T00.UParameter03, T00.UParameter04, T00.UParameter05, T00.StandardPrice
				, T00.StandardAmount, T00.PriceListID
		FROM	AT9000  T00 
		LEFT JOIN  AT1010 on AT1010.VATGroupID= T00.VATGroupID AND AT1010.DivisionID = T00.DivisionID
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
		WHERE	T00.DivisionID = ''' + @DivisionID + '''  
				AND T00.VoucherID =  '''+@VoucherID+'''  
				AND TransactionTypeID in (''T04'',''T64'')
		'
			SET @sSQLUnion = '
					UNION

					SELECT	T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T02.Exchangerate,
							OT3.SOrderID AS OrderID,
							T00.TransactionID,
							T00.InventoryID,		
							ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
							T01.UnitID, 
							CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
							V00.EndQuantity AS Quantity,	
							T00.SalePrice AS UnitPrice, T00.CommissionPercent,
							CASE WHEN V00.EndQuantity= V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
							V00.EndQuantity*T00.SalePrice*(100- ISNULL(T00.DiscountPercent, 0))/100	end AS OriginalAmount , 	  
							CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
							V00.EndQuantity*T00.SalePrice*T02.Exchangerate*(100- ISNULL(T00.DiscountPercent, 0))/100 END as ConvertedAmount,
							T00.DiscountPercent, 
							T00.DiscountConvertedAmount, T01.IsSource, 
							T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
							T01.AccountID, T01.MethodID, T01.IsStocked,
							T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
							T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
							T00.Orders ,V00.DueDate,
							V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,
							0 AS IsCheck,  T00.VATPercent,	 T00.VatGroupID,T00.VATOriginalAmount ,
							T00.VATConvertedAmount ,T02.notes AS BDescription, T01.IsDiscount, T00.DivisionID,
							OT3.SOrderID AS MOrderID,
							OT3.RefSOrderID AS SOrderID,
							OT3.TransactionID AS MTransactionID,
							OT3.RefSTransactionID AS STransactionID,
							OT3.UnitID As ConvertedUnitID, OT3.ConvertedQuantity, OT3.ConvertedSalePrice As ConvertedPrice, 
							OT3.Parameter01 As UParameter01, OT3.Parameter02 As UParameter02, OT3.Parameter03 As UParameter03, 
							OT3.Parameter04 As UParameter04, OT3.Parameter05 As UParameter05, OT3.StandardPrice
							, OT3.StandardAmount, OT4.PriceListID

						FROM	OT2002 OT3  
						INNER JOIN OT2001 OT4 on OT3.SOrderID =  OT4.SOrderID AND OT3.DivisionID = OT4.DivisionID
						INNER JOIN AQ2901 V00 on V00.SOrderID = OT3.SOrderID AND V00.TransactionID = OT3.TransactionID  AND V00.DivisionID = OT3.DivisionID 
						INNER JOIN AT1302 T01 on OT3.InventoryID = T01.InventoryID AND OT3.DivisionID = T01.DivisionID 
						LEFT JOIN OT2002 T00 On T00.SOrderID = OT3.RefSOrderID AND T00.InventoryID = OT3.InventoryID
						LEFT JOIN OT2001 T02 on OT3.RefSOrderID =  T02.SOrderID AND OT3.DivisionID = T02.DivisionID 
		
						WHERE  OT4.DivisionID = ''' + @DivisionID + ''' AND '		
			SET @sSQL1 = '
							OT3.SOrderID in (''' + @lstROrderID + ''') 
							AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
							 ' + 
							CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 
		END
		ELSE -- Nếu Load New
		BEGIN
			SET @sSQL ='
			SELECT	T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T02.Exchangerate,
					OT3.SOrderID AS OrderID,
					T00.TransactionID,
					T00.InventoryID,		
					ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
					T01.UnitID, 
					CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
					V00.EndQuantity AS Quantity,	
					T00.SalePrice AS UnitPrice, T00.CommissionPercent,
					CASE WHEN V00.EndQuantity= V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
					V00.EndQuantity * T00.SalePrice * (100- ISNULL(T00.DiscountPercent, 0))/100	end AS OriginalAmount , 	  
					CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
					V00.EndQuantity * T00.SalePrice * T02.Exchangerate * (100- ISNULL(T00.DiscountPercent, 0))/100 END as ConvertedAmount,
					T00.DiscountPercent, 
					T00.DiscountConvertedAmount, T01.IsSource, 
					T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
					T01.AccountID, T01.MethodID, T01.IsStocked,
					T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
					T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
					T00.Orders ,V00.DueDate,
					V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,  T00.VATPercent,  T00.VatGroupID,T00.VATOriginalAmount, T00.VATConvertedAmount,
					T02.notes AS BDescription, T01.IsDiscount, T00.DivisionID,
					OT3.SOrderID AS MOrderID,
					OT3.RefSOrderID AS SOrderID,
					OT3.TransactionID AS MTransactionID,
					OT3.RefSTransactionID AS STransactionID,
					OT3.UnitID As ConvertedUnitID, OT3.ConvertedQuantity, OT3.ConvertedSalePrice As ConvertedPrice, 
					OT3.Parameter01 As UParameter01, OT3.Parameter02 As UParameter02, OT3.Parameter03 As UParameter03, 
					OT3.Parameter04 As UParameter04, OT3.Parameter05 As UParameter05, OT3.StandardPrice
					, OT3.StandardAmount, OT4.PriceListID

			FROM	OT2002 OT3  
			INNER JOIN OT2001 OT4 on OT3.SOrderID =  OT4.SOrderID AND OT3.DivisionID = OT4.DivisionID
			INNER JOIN AQ2901 V00 on V00.SOrderID = OT3.SOrderID AND V00.TransactionID = OT3.TransactionID  AND V00.DivisionID = OT3.DivisionID 
			INNER JOIN AT1302 T01 on OT3.InventoryID = T01.InventoryID AND OT3.DivisionID = T01.DivisionID		
			LEFT JOIN OT2002 T00 On T00.SOrderID = OT3.RefSOrderID AND T00.InventoryID = OT3.InventoryID
			LEFT JOIN OT2001 T02 on OT3.RefSOrderID =  T02.SOrderID AND OT3.DivisionID = T02.DivisionID 
			
			WHERE  OT4.DivisionID = ''' + @DivisionID + ''' AND '
			SET @sSQL1 = '
					OT3.SOrderID in (''' + @lstROrderID + ''')
					AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
					 ' + 
					CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 
		END
	END
	
ELSE IF (@Customername = 43) --Customername = 43 khách hàng Secoin
	BEGIN
		IF isNULL (@VoucherID,'') <> '' 
		BEGIN
			SET @sSQL ='
			SELECT 
					T00.ObjectID,  T00.VATObjectID , T00.CurrencyID,T00.Exchangerate,
					T00.OrderID,T00.OTransactionID AS TransactionID ,
					T00.InventoryID,T01.InventoryName, T01.UnitID,  0 AS IsEditInventoryName,
					T00.Quantity, T00.UnitPrice,  T00.CommissionPercent,
					T00.OriginalAmount, T00.ConvertedAmount, 
					NULL AS DiscountPercent, 
					NULL AS DiscountConvertedAmount,
					T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
					T01.AccountID, T01.MethodID, T01.IsStocked,
					T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID,  T00.Ana05ID, 
					T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID,  T00.Ana10ID, 
					T00.Orders, NULL  AS DueDate,NULL AS ShipDate, NULL AS DueDays,'''' AS VATNo,
					'''' AS PaymentID, '''' AS PaymenttermID,
					1 AS IsCheck, AT1010.VATRate AS VATPercent, T00.VatGroupID,
					(SELECT OriginalAMount FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  AND TransactionTypeID = ''T14'')as VATOriginalAMount,
					(SELECT ConvertedAmount FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  AND TransactionTypeID = ''T14'')as VATConvertedAmount,
					T00.BDescription, T01.IsDiscount, T00.DivisionID,
					T00.MOrderID,
					T00.SOrderID,
					T00.MTransactionID,
					T00.STransactionID,
					T00.ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedPrice, 
					T00.UParameter01, T00.UParameter02, T00.UParameter03, T00.UParameter04, T00.UParameter05, T00.StandardPrice
					, T00.StandardAmount, T00.PriceListID
			FROM	AT9000  T00 
			LEFT JOIN  AT1010 on AT1010.VATGroupID= T00.VATGroupID AND AT1010.DivisionID = T00.DivisionID
			INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
			WHERE	T00.DivisionID = ''' + @DivisionID + '''  
					AND T00.VoucherID =  '''+@VoucherID+'''  
					AND TransactionTypeID in (''T04'',''T64'')
			'
			SET @sSQLUnion = '
						UNION

						SELECT	OT4.ObjectID, OT4.VATObjectID, OT4.CurrencyID, OT4.Exchangerate,
								OT3.SOrderID AS OrderID,
								OT3.TransactionID,
								OT3.InventoryID,		
								ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
								OT3.UnitID, 
								CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
								Isnull(V00.EndQuantity,0) AS Quantity,	
								isnull(T00.SalePrice, OT3.SalePrice) AS UnitPrice, isnull(T00.CommissionPercent, 0) as CommissionPercent ,
								CASE WHEN V00.EndQuantity= V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
								isnull(V00.EndQuantity,0) * Isnull(T00.SalePrice, OT3.SalePrice)*(100- ISNULL(T00.DiscountPercent, 0))/100	end AS OriginalAmount , 	  
								CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
								isnull(V00.EndQuantity,0) * Isnull(T00.SalePrice, OT3.SalePrice)*Isnull(OT4.Exchangerate,0)*(100- ISNULL(T00.DiscountPercent, 0))/100 END as ConvertedAmount,
								isnull(T00.DiscountPercent,0) as DiscountPercent, 
								Isnull(T00.DiscountConvertedAmount,0), T01.IsSource, 
								T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
								T01.AccountID, T01.MethodID, T01.IsStocked,
								T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
								T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
								T00.Orders ,V00.DueDate,
								V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,
								0 AS IsCheck,  T00.VATPercent,	 T00.VatGroupID,T00.VATOriginalAmount ,
								T00.VATConvertedAmount ,T02.notes AS BDescription, T01.IsDiscount, OT3.DivisionID,
								OT3.SOrderID AS MOrderID,
								OT3.RefSOrderID AS SOrderID,
								OT3.TransactionID AS MTransactionID,
				
								OT3.RefSTransactionID AS STransactionID,
								OT3.UnitID As ConvertedUnitID, OT3.ConvertedQuantity, OT3.ConvertedSalePrice As ConvertedPrice, 
								OT3.Parameter01 As UParameter01, OT3.Parameter02 As UParameter02, OT3.Parameter03 As UParameter03, 
								OT3.Parameter04 As UParameter04, OT3.Parameter05 As UParameter05, OT3.StandardPrice
								, OT3.StandardAmount, OT4.PriceListID

							FROM	OT2002 OT3  
							INNER JOIN OT2001 OT4 on OT3.SOrderID =  OT4.SOrderID AND OT3.DivisionID = OT4.DivisionID
							INNER JOIN     (--Begin View Cu AQ2901
											Select OT2001.DivisionID, OT2001.TranMonth, OT2001.TranYear, OT2002.SOrderID,  OT2001.OrderStatus, 
													OT2002.TransactionID, OT2001.Duedate, OT2001.Shipdate, OT2002.InventoryID, 
													Isnull(OT2002.OrderQuantity,0) as OrderQuantity  ,Isnull( G.ActualQuantity,0) as ActualQuantity, 
													OT2001.PaymentTermID,AT1208.Duedays,
													case when OT2002.Finish = 1 
														then NULL else isnull(OT2002.OrderQuantity, 0)
															- isnull(G.ActualQuantity, 0) 
															+ isnull(T.OrderQuantity,0) 
															end as EndQuantity, 
													G.OrderID as T9OrderID,
													case when OT2002.Finish = 1 
														then NULL else isnull(OT2002.ConvertedQuantity, 0)
																		- isnull(G.ActualConvertedQuantity, 0) 
																		+ Isnull(T.ConvertedQuantity,0)
													end as EndConvertedQuantity,
													( isnull(OT2002.OriginalAmount,0) - isnull(G.ActualOriginalAmount,0 ) + isnull(T.OriginalAmount,0))  
													as EndOriginalAmount'
			SET @sSQL2 ='
						From OT2002 inner join OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2002.SOrderID = OT2001.SOrderID
									left join AT1208 ON AT1208.DivisionID = OT2001.DivisionID AND AT1208.PaymentTermID = OT2001.PaymentTermID 	
									left join 	(
													Select AT9000.DivisionID, AT9000.OrderID, OTransactionID,
															InventoryID, sum(Quantity) As ActualQuantity, sum(isnull(OriginalAmount,0)) 
															as ActualOriginalAmount,
															SUM(isnull(ConvertedQuantity,Quantity)) As ActualConvertedQuantity
														From AT9000 
														WHERE TransactionTypeID in (''T04'', ''T06'') and IsStock = 0 AND isnull(AT9000.OrderID,'''') <>''''
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
										) V00 on V00.SOrderID = OT3.SOrderID AND V00.TransactionID = OT3.TransactionID  AND V00.DivisionID = OT3.DivisionID 
						INNER JOIN AT1302 T01 on OT3.InventoryID = T01.InventoryID AND OT3.DivisionID = T01.DivisionID 
						LEFT JOIN OT2002 T00 On T00.SOrderID = OT3.RefSOrderID AND T00.InventoryID = OT3.InventoryID
						LEFT JOIN OT2001 T02 on OT3.RefSOrderID =  T02.SOrderID AND OT3.DivisionID = T02.DivisionID 
		
						WHERE  OT4.OrderTypeID = 0 and OT4.DivisionID = ''' + @DivisionID + ''' AND '
			SET @sSQL1 = '
								OT3.SOrderID in (''' + @lstROrderID + ''') 
								AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
									' + 
								CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 
		END
	ELSE -- Nếu Load New
	BEGIN
		SET @sSQL ='
		SELECT	OT4.ObjectID, OT4.VATObjectID, OT4.CurrencyID, OT4.Exchangerate,
				OT3.SOrderID AS OrderID,
				OT3.TransactionID,
				OT3.InventoryID,		
				ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
				OT3.UnitID, 
				CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
				Isnull(V00.EndQuantity,0) AS Quantity,	
				Isnull(T00.SalePrice, OT3.SalePrice) AS UnitPrice, Isnull(T00.CommissionPercent,0) as CommissionPercent,
				CASE WHEN V00.EndQuantity= V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
				isnull(V00.EndQuantity,0) * Isnull(T00.SalePrice, OT3.SalePrice) * (100- ISNULL(T00.DiscountPercent, 0))/100	end AS OriginalAmount , 	  
				CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
				isnull(V00.EndQuantity,0) * Isnull(T00.SalePrice, OT3.SalePrice) * Isnull(OT4.Exchangerate,0) * (100- ISNULL(T00.DiscountPercent, 0))/100 END as ConvertedAmount,
				Isnull(T00.DiscountPercent,0) as DiscountPercent, 
				isnull(T00.DiscountConvertedAmount,0) as DiscountConvertedAmount, T01.IsSource, 
				T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
				T01.AccountID, T01.MethodID, T01.IsStocked,
				T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
				T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
				T00.Orders ,V00.DueDate,
				V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,  T00.VATPercent,  T00.VatGroupID,T00.VATOriginalAmount, T00.VATConvertedAmount,
				T02.notes AS BDescription, T01.IsDiscount, OT3.DivisionID,
				OT3.SOrderID AS MOrderID,
				OT3.RefSOrderID AS SOrderID,
				OT3.TransactionID AS MTransactionID,
				OT3.RefSTransactionID AS STransactionID,
				OT3.UnitID As ConvertedUnitID, Isnull(V00.EndConvertedQuantity,0) as ConvertedQuantity, OT3.ConvertedSalePrice As ConvertedPrice, 
				OT3.Parameter01 As UParameter01, OT3.Parameter02 As UParameter02, OT3.Parameter03 As UParameter03, 
				OT3.Parameter04 As UParameter04, OT3.Parameter05 As UParameter05, OT3.StandardPrice
				, OT3.StandardAmount, OT4.PriceListID

		FROM	OT2002 OT3  
		INNER JOIN OT2001 OT4 on OT3.SOrderID =  OT4.SOrderID AND OT3.DivisionID = OT4.DivisionID
		INNER JOIN					(--Begin View Cu AQ2901
										Select OT2001.DivisionID, OT2001.TranMonth, OT2001.TranYear, OT2002.SOrderID,  OT2001.OrderStatus, 
												OT2002.TransactionID, OT2001.Duedate, OT2001.Shipdate, OT2002.InventoryID, 
												Isnull(OT2002.OrderQuantity,0) as OrderQuantity  ,Isnull( G.ActualQuantity,0) as ActualQuantity, '
		SET @sSQL2 ='								OT2001.PaymentTermID,AT1208.Duedays,
												case when OT2002.Finish = 1 
													then NULL else isnull(OT2002.OrderQuantity, 0)
														- isnull(G.ActualQuantity, 0) 
														+ isnull(T.OrderQuantity,0) 
														end as EndQuantity, 
												G.OrderID as T9OrderID,
												case when OT2002.Finish = 1 
													then NULL else isnull(OT2002.ConvertedQuantity,0)
																	- isnull(G.ActualConvertedQuantity, 0) 
																	+ Isnull(T.ConvertedQuantity,0)
												end as EndConvertedQuantity,
												( isnull(OT2002.OriginalAmount,0) - isnull(G.ActualOriginalAmount,0 ) + isnull(T.OriginalAmount,0))  
												as EndOriginalAmount
										From OT2002 inner join OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2002.SOrderID = OT2001.SOrderID
													left join AT1208 ON AT1208.DivisionID = OT2001.DivisionID AND AT1208.PaymentTermID = OT2001.PaymentTermID 	
													left join 	(
																	Select AT9000.DivisionID, AT9000.OrderID, OTransactionID,
																			InventoryID, sum(Quantity) As ActualQuantity, sum(isnull(OriginalAmount,0)) 
																			as ActualOriginalAmount,
																			SUM(isnull(ConvertedQuantity,Quantity)) As ActualConvertedQuantity
																		From AT9000 
																		WHERE TransactionTypeID in (''T04'', ''T06'') and IsStock = 0 AND isnull(AT9000.OrderID,'''') <>''''
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
										) V00 on V00.SOrderID = OT3.SOrderID AND V00.TransactionID = OT3.TransactionID  AND V00.DivisionID = OT3.DivisionID 
		INNER JOIN AT1302 T01 on OT3.InventoryID = T01.InventoryID AND OT3.DivisionID = T01.DivisionID		
		LEFT JOIN OT2002 T00 On T00.SOrderID = OT3.RefSOrderID AND T00.InventoryID = OT3.InventoryID
		LEFT JOIN OT2001 T02 on OT3.RefSOrderID =  T02.SOrderID AND OT3.DivisionID = T02.DivisionID 
			
		WHERE  OT4.OrderTypeID = 0 and OT4.DivisionID = ''' + @DivisionID + ''' AND '
		SET @sSQL1 = '
				OT3.SOrderID in (''' + @lstROrderID + ''')
				AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
				 ' + 
				CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 
	END
	END
ELSE ------Bảng chuẩn
	begin
	If isNULL (@VoucherID,'') <> '' 
	BEGIN
		IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
		BEGIN
				SET @sSQL ='
		SELECT 
			T00.ObjectID,  T00.VATObjectID , T00.CurrencyID,T00.Exchangerate,
			T00.OrderID,T00.TDescription,T00.OTransactionID AS TransactionID ,
			T00.InventoryID,T01.InventoryName, T01.UnitID,  0 AS IsEditInventoryName,
			T00.Quantity, T00.UnitPrice,  T00.CommissionPercent,
			T00.OriginalAmount, T00.ConvertedAmount, 
			NULL AS DiscountPercent, 
			NULL AS DiscountConvertedAmount,
			T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
			T01.AccountID, T01.MethodID, T01.IsStocked,
			T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID,  T00.Ana05ID, 
			T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID,  T00.Ana10ID, 
			T00.Orders, NULL  AS DueDate,NULL AS ShipDate, NULL AS DueDays,'''' AS VATNo,
			'''' AS PaymentID, '''' AS PaymenttermID,
			1 AS IsCheck, AT1010.VATRate AS VATPercent, T00.VatGroupID,
			(SELECT OriginalAMount FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  
			AND AT9000.DivisionID = T00.DivisionID
			AND TransactionTypeID = ''T14''
			AND AT9000.MTransactionID = T00.MTransactionID
			AND AT9000.STransactionID = T00.STransactionID)as VATOriginalAMount,
			(SELECT  ConvertedAmount  FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  
			AND AT9000.DivisionID = T00.DivisionID
			AND TransactionTypeID = ''T14''
			AND AT9000.MTransactionID = T00.MTransactionID
			AND AT9000.STransactionID = T00.STransactionID)as VATConvertedAmount,

			T00.BDescription, T01.IsDiscount, T00.DivisionID,
			T00.MOrderID,
			T00.SOrderID,
			T00.MTransactionID,
			T00.STransactionID,
			T00.ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedPrice, 
			T00.UParameter01, T00.UParameter02, T00.UParameter03, T00.UParameter04, T00.UParameter05, T00.StandardPrice
			, T00.StandardAmount, T00.PriceListID, T00.DParameter01,
			T00.DParameter02, T00.DParameter03,
			NULL S01ID, NULL S02ID, NULL S03ID, NULL S04ID, NULL S05ID, NULL S06ID, NULL S07ID, NULL S08ID, NULL S09ID, NULL S10ID,
			NULL S11ID, NULL S12ID, NULL S13ID, NULL S14ID, NULL S15ID, NULL S16ID, NULL S17ID, NULL S18ID, NULL S19ID, NULL S20ID
			
		FROM AT9000  T00
		LEFT JOIN  AT1010 on AT1010.VATGroupID= T00.VATGroupID AND AT1010.DivisionID = T00.DivisionID
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
		WHERE	T00.DivisionID = ''' + @DivisionID + '''  AND 
				T00.VoucherID =  '''+@VoucherID+'''  
				AND TransactionTypeID in (''T04'',''T64'')
		'
				SET @sSQLUnion = '
		UNION

		SELECT	T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T02.Exchangerate,
				T00.SorderID AS OrderID,T00.Description,
				T00.TransactionID,
				T00.InventoryID,		
				ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
				T01.UnitID, 
				CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
				V00.EndQuantity AS Quantity,	
				T00.SalePrice AS UnitPrice, T00.CommissionPercent,
				CASE WHEN V00.EndQuantity= V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
				V00.EndQuantity*T00.SalePrice*(100- ISNULL(T00.DiscountPercent, 0))/100	end AS OriginalAmount , 	  
				CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
				V00.EndQuantity*T00.SalePrice*ExchangeRate*(100- ISNULL(T00.DiscountPercent,0))/100	end 	as ConvertedAmount,
				T00.DiscountPercent, 
				T00.DiscountConvertedAmount, T01.IsSource, 
				T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
				T01.AccountID, T01.MethodID, T01.IsStocked,
				T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
				T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
				T00.Orders ,V00.DueDate, V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,
				0 AS IsCheck,  
				T00.VATPercent,	 
				T00.VatGroupID,
				T00.VATOriginalAmount ,
				T00.VATConvertedAmount,
				T02.notes AS BDescription, 
				T01.IsDiscount, 
				T00.DivisionID,
				T00.SOrderID AS MOrderID,
				T00.RefSOrderID AS SOrderID,
				T00.TransactionID AS MTransactionID,
				T00.RefSTransactionID AS STransactionID,
				T00.UnitID As ConvertedUnitID, V00.EndConvertedQuantity ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
				T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
				T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05, T00.StandardPrice
				, T00.StandardAmount, T02.PriceListID, T00.nvarchar01,
				T00.nvarchar02, T00.nvarchar03,			
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID

		FROM	OT2002 T00  
		INNER JOIN OT2001 T02 on T00.SOrderID =  T02.SOrderID AND T00.DivisionID = T02.DivisionID
		INNER JOIN AQ2901 V00 on V00.SOrderID = T00.SOrderID AND V00.TransactionID = T00.TransactionID  AND V00.DivisionID = T00.DivisionID 
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
		left join OT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.SOrderID and O99.TransactionID = T00.TransactionID and O99.TableID = ''OT2002''
		WHERE  T02.DivisionID = ''' + @DivisionID + ''' AND '
		
				SET @sSQL1 = '
				T00.SOrderID in (''' + @lstROrderID + ''') 
				AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
				 ' + 
				CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 				
		END
		ELSE
			BEGIN
				SET @sSQL ='
		SELECT 
			T00.ObjectID,  T00.VATObjectID , T00.CurrencyID,T00.Exchangerate,
			T00.OrderID,T00.TDescription,T00.OTransactionID AS TransactionID ,
			T00.InventoryID,T01.InventoryName, T01.UnitID,  0 AS IsEditInventoryName,
			T00.Quantity, T00.UnitPrice,  T00.CommissionPercent,
			T00.OriginalAmount, T00.ConvertedAmount, 
			NULL AS DiscountPercent, 
			NULL AS DiscountConvertedAmount,
			T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
			T01.AccountID, T01.MethodID, T01.IsStocked,
			T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID,  T00.Ana05ID, 
			T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID,  T00.Ana10ID, 
			T00.Orders, NULL  AS DueDate,NULL AS ShipDate, NULL AS DueDays,'''' AS VATNo,
			'''' AS PaymentID, '''' AS PaymenttermID,
			1 AS IsCheck, AT1010.VATRate AS VATPercent, T00.VatGroupID,
			(SELECT OriginalAMount FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  
			AND AT9000.DivisionID = T00.DivisionID
			AND TransactionTypeID = ''T14''
			AND AT9000.MTransactionID = T00.MTransactionID
			AND AT9000.STransactionID = T00.STransactionID)as VATOriginalAMount,
			(SELECT  ConvertedAmount  FROM AT9000 WHERE AT9000.VoucherID = T00.VoucherID  
			AND AT9000.DivisionID = T00.DivisionID
			AND TransactionTypeID = ''T14''
			AND AT9000.MTransactionID = T00.MTransactionID
			AND AT9000.STransactionID = T00.STransactionID)as VATConvertedAmount,

			T00.BDescription, T01.IsDiscount, T00.DivisionID,
			T00.MOrderID,
			T00.SOrderID,
			T00.MTransactionID,
			T00.STransactionID,
			T00.ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedPrice, 
			T00.UParameter01, T00.UParameter02, T00.UParameter03, T00.UParameter04, T00.UParameter05, T00.StandardPrice
			, T00.StandardAmount, T00.PriceListID, T00.DParameter01,
			T00.DParameter02, T00.DParameter03
		FROM AT9000  T00
		LEFT JOIN  AT1010 on AT1010.VATGroupID= T00.VATGroupID AND AT1010.DivisionID = T00.DivisionID
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
		WHERE	T00.DivisionID = ''' + @DivisionID + '''  AND 
				T00.VoucherID =  '''+@VoucherID+'''  
				AND TransactionTypeID in (''T04'',''T64'')
		'
				SET @sSQLUnion = '
		UNION

		SELECT	T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T02.Exchangerate,
				T00.SorderID AS OrderID,T00.Description,
				T00.TransactionID,
				T00.InventoryID,		
				ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
				T01.UnitID, 
				CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
				V00.EndQuantity AS Quantity,	
				T00.SalePrice AS UnitPrice, T00.CommissionPercent,
				CASE WHEN V00.EndQuantity= V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
				V00.EndQuantity*T00.SalePrice*(100- ISNULL(T00.DiscountPercent, 0))/100	end AS OriginalAmount , 	  
				CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
				V00.EndQuantity*T00.SalePrice*ExchangeRate*(100- ISNULL(T00.DiscountPercent,0))/100	end 	as ConvertedAmount,
				T00.DiscountPercent, 
				T00.DiscountConvertedAmount, T01.IsSource, 
				T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
				T01.AccountID, T01.MethodID, T01.IsStocked,
				T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
				T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
				T00.Orders ,V00.DueDate, V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,
				0 AS IsCheck,  
				T00.VATPercent,	 
				T00.VatGroupID,
				T00.VATOriginalAmount ,
				T00.VATConvertedAmount,
				T02.notes AS BDescription, 
				T01.IsDiscount, 
				T00.DivisionID,
				T00.SOrderID AS MOrderID,
				T00.RefSOrderID AS SOrderID,
				T00.TransactionID AS MTransactionID,
				T00.RefSTransactionID AS STransactionID,
				T00.UnitID As ConvertedUnitID, V00.EndConvertedQuantity ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
				T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
				T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05, T00.StandardPrice
				, T00.StandardAmount, T02.PriceListID, T00.nvarchar01,
				T00.nvarchar02, T00.nvarchar03

		FROM	OT2002 T00  
		INNER JOIN OT2001 T02 on T00.SOrderID =  T02.SOrderID AND T00.DivisionID = T02.DivisionID
		INNER JOIN AQ2901 V00 on V00.SOrderID = T00.SOrderID AND V00.TransactionID = T00.TransactionID  AND V00.DivisionID = T00.DivisionID 
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
		WHERE  T02.DivisionID = ''' + @DivisionID + ''' AND '
		
				SET @sSQL1 = '
				T00.SOrderID in (''' + @lstROrderID + ''') 
				AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
				 ' + 
				CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 		
			END

	END
	ELSE -- Load New
	BEGIN
		IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
		BEGIN
				SET @sSQL ='
		SELECT	T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T02.Exchangerate,
				T00.SorderID AS OrderID,T00.Description,
				T00.TransactionID,
				T00.InventoryID,		
				ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
				T01.UnitID, 
				CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
				V00.EndQuantity AS Quantity,	
				T00.SalePrice AS UnitPrice, T00.CommissionPercent,
				CASE WHEN V00.EndQuantity = V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
				V00.EndQuantity * T00.SalePrice * (100- ISNULL(T00.DiscountPercent,0))/100	end AS OriginalAmount , 	  
				CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
				V00.EndQuantity * T00.SalePrice * ExchangeRate * (100- ISNULL(T00.DiscountPercent,0))/100	end as ConvertedAmount,
				T00.DiscountPercent, 
				T00.DiscountConvertedAmount, T01.IsSource, 
				T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
				T01.AccountID, T01.MethodID, T01.IsStocked,
				T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
				T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
				T00.Orders ,V00.DueDate,
				V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,  T00.VATPercent,  T00.VatGroupID,T00.VATOriginalAmount, T00.VATConvertedAmount,
				T02.notes AS BDescription, T01.IsDiscount, T00.DivisionID,
				T00.SOrderID AS MOrderID,
				T00.RefSOrderID AS SOrderID,
				T00.TransactionID AS MTransactionID,
				T00.RefSTransactionID AS STransactionID,
				T00.UnitID As ConvertedUnitID,V00.EndConvertedQuantity ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
				T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
				T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05, T00.StandardPrice
				, T00.StandardAmount, T02.PriceListID, T00.nvarchar01,
				T00.nvarchar02, T00.nvarchar03,			
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID

		FROM OT2002 T00  INNER JOIN OT2001 T02 on T00.SOrderID =  T02.SOrderID AND T00.DivisionID = T02.DivisionID 
		INNER JOIN AQ2901 V00 on V00.SOrderID = T00.SOrderID AND V00.TransactionID = T00.TransactionID AND V00.DivisionID = T00.DivisionID 
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID
		left join OT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.SOrderID and O99.TransactionID = T00.TransactionID and O99.TableID = ''OT2002''
		WHERE  T02.DivisionID = ''' + @DivisionID + ''' AND '
		
				SET @sSQL1 = '
				T00.SOrderID in (''' + @lstROrderID + ''')
				AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
				 ' + 
				CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 			
		END
		ELSE
			BEGIN
				SET @sSQL ='
		SELECT	T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T02.Exchangerate,
				T00.SorderID AS OrderID,T00.Description,
				T00.TransactionID,
				T00.InventoryID,		
				ISNULL(T00.InventoryCommonName, T01.InventoryName)  AS InventoryName, 
				T01.UnitID, 
				CASE WHEN ISNULL(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  AS  IsEditInventoryName, 
				V00.EndQuantity AS Quantity,	
				T00.SalePrice AS UnitPrice, T00.CommissionPercent,
				CASE WHEN V00.EndQuantity = V00.OrderQuantity then ISNULL(T00.OriginalAmount,0) - ISNULL(T00.DiscountOriginalAmount, 0)  else
				V00.EndQuantity * T00.SalePrice * (100- ISNULL(T00.DiscountPercent,0))/100	end AS OriginalAmount , 	  
				CASE WHEN  V00.EndQuantity= V00.OrderQuantity then  ISNULL(T00.ConvertedAmount,0) - ISNULL(T00.DiscountConvertedAmount, 0) else 
				V00.EndQuantity * T00.SalePrice * ExchangeRate * (100- ISNULL(T00.DiscountPercent,0))/100	end as ConvertedAmount,
				T00.DiscountPercent, 
				T00.DiscountConvertedAmount, T01.IsSource, 
				T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
				T01.AccountID, T01.MethodID, T01.IsStocked,
				T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
				T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
				T00.Orders ,V00.DueDate,
				V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,  T00.VATPercent,  T00.VatGroupID,T00.VATOriginalAmount, T00.VATConvertedAmount,
				T02.notes AS BDescription, T01.IsDiscount, T00.DivisionID,
				T00.SOrderID AS MOrderID,
				T00.RefSOrderID AS SOrderID,
				T00.TransactionID AS MTransactionID,
				T00.RefSTransactionID AS STransactionID,
				T00.UnitID As ConvertedUnitID,V00.EndConvertedQuantity ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
				T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
				T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05, T00.StandardPrice
				, T00.StandardAmount, T02.PriceListID, T00.nvarchar01,
				T00.nvarchar02, T00.nvarchar03

		FROM OT2002 T00  INNER JOIN OT2001 T02 on T00.SOrderID =  T02.SOrderID AND T00.DivisionID = T02.DivisionID 
		INNER JOIN AQ2901 V00 on V00.SOrderID = T00.SOrderID AND V00.TransactionID = T00.TransactionID AND V00.DivisionID = T00.DivisionID 
		INNER JOIN AT1302 T01 on T00.InventoryID = T01.InventoryID AND T00.DivisionID = T01.DivisionID 
		WHERE  T02.DivisionID = ''' + @DivisionID + ''' AND '
		
				SET @sSQL1 = '
				T00.SOrderID in (''' + @lstROrderID + ''')
				AND (CASE WHEN T01.IsDiscount = 1 then V00.EndOriginalAmount else V00.EndQuantity  end ) > 0
				 ' + 
				CASE WHEN ISNULL(@VATGroupID , '') <> ''  AND ISNULL(@VATGroupID , '') <> '%' then ' AND T00.VATPercent = ' + cast(@VATRate AS nvarchar(50))  else '' end 
			END
	END 
END
--Print @sSQL
--Print @sSQLUnion
--Print @sSQL2
--Print @sSQL1
IF NOT EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'AV3201' + @CONNID)
	EXEC('CREATE VIEW AV3201' + @ConnID + ' ----tao boi AP3201
			as ' + @sSQL + @sSQLUnion + @sSQL2 +  @sSQL1)
ELSE	
	EXEC('ALTER VIEW AV3201' + @ConnID + ' ----tao boi AP3201
			as ' + @sSQL + @sSQLUnion + @sSQL2 +  @sSQL1)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
