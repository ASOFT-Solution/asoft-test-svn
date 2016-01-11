IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1234]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1234]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Ke thua du lieu tu phieu mua hang, bán hang, nhap - xuat kho, VCNB
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Created by Van Nhan, Sunday 24/02/2008
---- Last edit by Bao Anh, on 18/03/2008, Purpose: Bo sung loc theo Tu loai chung tu, Den loai chung tu
---- Edit by: Dang Le Bao Quynh; Date: 09/05/2008
---- Purpose: Bo sung dieu kien tu thang den thang, thay doi cach thuc tim kiem doi tuong
---- Edit by: Dang Le Bao Quynh; Date: 14/05/2008
---- Purpose: Bo sung dieu kien tim kiem theo nhom thue suat
---- Modified on 10/11/2011 by Le Thi Thu Hien : Bo sung TransactionType = 'SO'
---- Modified on 14/05/2012 by Le Thi Thu Hien : Bổ sung kế thừa phiếu bảo trì sửa chữa từ Module CS màn hình CSF1010 @TransactionTypeID = 'CST1010'
---- Modified on 04/06/2012 by Thiên Huỳnh: Bổ sung 5 Khoản mục
---- Modified on 07/11/2012 by Bao Anh: Lay them truong, bo sung chung tu kho tam (2T)
---- Modified on 19/11/2012 by Thiên Huỳnh: Bỏ điều kiện Where TransactionTypeID bên AT2007
---- Modified on 27/01/2013 by Bao Anh: Sua Union thanh Union All
---- Modified on 25/03/2013 by Bao Anh: Bổ sung nếu không phải 2T thì vẫn load các phiếu đã kế thừa
---- Modified on 23/07/2013 by Le Thi Thu Hien : Bo sung BDescription,a.TDescription 
---- Modified on 25/07/2013 by Khanh Van: Bo sung load them BatchID
---- Modified on 01/08/2013 by Bao Anh: Bo sung isnull khi Where ObjectID
---- Modified on 03/09/2013 by Khanh Van: Customize cho Sieu Thanh
---- Modified on 21/03/2014 by Mai Duyen: kế thừa dữ liệu từ nhiều chi nhánh(Customize cho PrintTech )
---- Modified on 04/04/2014 by Bảo Anh: kế thừa các phiếu nhập không bắn qua AT9000 (Customize cho Long Trường Vũ)
---- Modified on 15/05/2014 by Bảo Anh: Chỉ lấy phiếu nhập/xuất kho tạm đối với khách hàng 2T
---- Modified on 11/06/2014 by Le Thi Thu Hien : Bo sung lay thong tin phieu chenh lech kho
---- Modified on 07/07/2014 by Le Thi Thu Hien : Bo sung lay kho
---- Modified on 23/07/2014 by Mai Duyen : Sua cu phap End (loi Printech)
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh
---- Modified on 30/10/2015 by Tieu Mai: Bổ sung 20 quy cách hàng hóa
-- <Example>
--exec AP1234 @Divisionid=N'HN',@Transactiontypeid=N'T03',@Vouchertypeidfrom=N'ASGMH',@Vouchertypeidto=N'PRTMH',@Objectid=N'%',@Fromtranmonth=1,@Fromtranyear=2014,@Totranmonth=1,@Totranyear=2014,@Voucherdate=NULL,@Isgroup=0,@Isobject=1,@Iscurrency=1,@Isana=1,@Strvoucherid=N'',@Filter=N'',@Isinherit=0,@Vatgroupid=N'%'
---- 



CREATE PROCEDURE [dbo].[AP1234] 	
				@DivisionID AS nvarchar(50),
				@TransactionTypeID  AS nvarchar(50),   
				@VoucherTypeIDFrom AS nvarchar(50),
				@VoucherTypeIDTo AS nvarchar(50),
				@ObjectID  AS nvarchar(50),
				@FromTranMonth AS int,
				@FromTranYear AS int,
				@ToTranMonth AS int,
				@ToTranYear AS int,
				@VoucherDate AS nvarchar(50),
				@IsGroup AS tinyint = 0,
				@IsObject AS tinyint = 1,
				@IsCurrency AS tinyint = 1,
				@IsAna AS tinyint = 1,
				@strVoucherID nvarchar(4000) = '',
				@Filter AS varchar(4000) = '',
				@IsInherit AS tinyint = 0,
				@VATGroupID AS nvarchar(50) = '%',
				@Isdata as bit =0   ,    -- 0:ke thua trong 1 data; 1: ke thua tu datbase  khac
				@data as varchar (20) =  '',
				@Ok  as bit = 0 , --  0:khi chua nhan dong y; 1: khi da chon
				@WareHouseID AS NVARCHAR(50) = '%'
 AS

if @VoucherDate is null
	SET @VoucherDate='01/01/1900'

---- Note: TransactionTypeID ='T03' mua hang, 'T04' bán hang, 'T05' Nhap kho, 'T06' - xuat kho, 'T66' - VCNB
Declare @sqlSelect nvarchar(4000),
		@sqlFrom nvarchar(4000),
        @sqlWhere nvarchar(4000),
        @sqlGroupBy nvarchar(4000),
        @sqlUnion nvarchar(4000),
        @sqlWhereUnion nvarchar(4000),
        @CustomerName INT
        
--Tao bang tam de kiem tra day co phai la khach hang Sieu Thanh khong (CustomerName = 16)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
IF @CustomerName = 16 --- Customize Sieu Thanh
	Exec AP1234_ST @DivisionID, @TransactionTypeID, @VoucherTypeIDFrom, @VoucherTypeIDTo, @ObjectID, @FromTranMonth, @FromTranYear, @ToTranMonth, @ToTranYear, @VoucherDate, @IsGroup, @IsObject, @IsCurrency, @IsAna, @strVoucherID, @Filter, @IsInherit, @VATGroupID
Else IF @CustomerName = 26 --- Customize PrintTech
	Exec AP1234_PT @DivisionID, @TransactionTypeID, @VoucherTypeIDFrom, @VoucherTypeIDTo, @ObjectID, @FromTranMonth, @FromTranYear, @ToTranMonth, @ToTranYear, @VoucherDate, @IsGroup, @IsObject, @IsCurrency, @IsAna, @strVoucherID, @Filter, @IsInherit, @VATGroupID,@Isdata,@data,@Ok
else	
	
BEGIN

Set @sqlUnion = ''
Set @sqlWhereUnion = ''
   
If @IsGroup=0
Begin
	If @TransactionTypeID<>'T66' AND @TransactionTypeID <> 'SO' AND  @TransactionTypeID <> 'CST1010' --- Khac voi van chuyen noi bo
    	BEGIN
		SET @sqlSelect=N'
		SELECT 	AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo, 
				Serial, InvoiceNo, InvoiceDate, 
				AT9000.VDescription, ObjectName,
				AT9000.ObjectID, AT9000.CurrencyID, ExchangeRate,
				AT9000.InventoryID, InventoryName, InventoryName1,  AT9000.UnitID, AT9000.Orders, 
				Quantity, UnitPrice, OriginalAmount,  ConvertedAmount, 
				Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
				Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
				AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID,AT9000.DivisionID,
				AT9000.MOrderID, AT9000.SOrderID, AT9000.MTransactionID, AT9000.STransactionID,
				AT9000.ConvertedUnitID, AT9000.ConvertedQuantity, AT9000.ConvertedPrice, AT9000.MarkQuantity,
				AT9000.UParameter01 AS Parameter01, AT9000.UParameter02 AS Parameter02, AT9000.UParameter03 AS Parameter03, AT9000.UParameter04 AS Parameter04, AT9000.UParameter05 AS Parameter05,
				WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,	
				AT9000.BDescription, AT9000.TDescription, '''' AS WareHouseID, 	'''' AS WareHouseID2,
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID		
'
		SET @sqlFrom = 
N'			FROM		AT9000 	
			INNER JOIN	AT1302 
				ON		AT1302.DivisionID = AT9000.DivisionID 
						AND AT1302.InventoryID = AT9000.InventoryID
			LEFT JOIN	AT1202 
				ON		AT1202.DivisionID = AT9000.DivisionID 
						AND AT1202.ObjectID = AT9000.ObjectID
			LEFT JOIN	WQ1309 
				ON		WQ1309.InventoryID = AT9000.InventoryID 
						AND WQ1309.DivisionID = AT9000.DivisionID 
						AND WQ1309.ConvertedUnitID = AT9000.ConvertedUnitID
			LEFT JOIN AT8899 O99
				ON		O99.DivisionID = AT9000.DivisionID
						AND O99.VoucherID = AT9000.voucherID
						AND O99.TransactionID = AT9000.TransactionID			
'
		SET @sqlWhere = 
N'			WHERE	AT9000.DivisionID =N'''+@DivisionID+N''' AND
					Isnull(AT9000.ObjectID,'''') Like N'''+@ObjectID+N''' AND
					(TranMonth +12*TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+N' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + N') AND 
					CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
					TransactionTypeID =N'''+@TransactionTypeID+''' AND
					VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' AND 
					ISNULL(AT9000.VATGroupID,''%'') Like N''' + @VATGroupID + ''''
		
		IF @CustomerName = 15 --- Customize 2T
			SET @sqlWhere = @sqlWhere + N' AND VoucherID NOT IN (SELECT WOrderID FROM AT9000 WHERE Isnull(WOrderID,'''') <> '''' and DivisionID= ''' + @DivisionID + ''')'
					
		SET @sqlGroupBy = N''
		--- Union chung tu kho tam
		If (@TransactionTypeID = 'T05' or @TransactionTypeID = 'T06') and (@CustomerName = 15 or @CustomerName = 24)
		BEGIN
    		SET @sqlUnion = N' UNION ALL
    		SELECT 	AT2006.VoucherID, '''' as BatchID, VoucherDate, VoucherNo, 
				NULL AS Serial, NULL AS InvoiceNo, NULL AS InvoiceDate, 
				Description AS VDescription, ObjectName,
				AT2006.ObjectID, NULL AS CurrencyID, NULL AS ExchangeRate,
				AT2007.InventoryID, InventoryName, InventoryName1,  AT2007.UnitID, AT2007.Orders, 
				ActualQuantity AS Quantity, UnitPrice, OriginalAmount,  ConvertedAmount, 
				Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
				Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
				AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
				AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
				AT2007.ConvertedUnitID, AT2007.ConvertedQuantity, AT2007.ConvertedPrice, AT2007.MarkQuantity,
				AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
				WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
				AT2007.Notes AS BDescription, AT2007.Notes AS TDescription, AT2006.WareHouseID, AT2006.WareHouseID2,
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
'
				
			SET @sqlWhereUnion = N'
			FROM		AT2007
			INNER JOIN	AT2006
				ON		AT2007.DivisionID = AT2006.DivisionID 
						And AT2007.VoucherID = AT2006.VoucherID
			INNER JOIN	AT1303
				ON		AT1303.DivisionID = AT2006.DivisionID 
						And AT1303.WarehouseID = AT2006.WarehouseID
			INNER JOIN	AT1302 
				ON		AT1302.DivisionID = AT2007.DivisionID 
						AND AT1302.InventoryID = AT2007.InventoryID
			LEFT JOIN	AT1202 
				ON		AT1202.DivisionID = AT2006.DivisionID 
						AND AT1202.ObjectID = AT2006.ObjectID
			LEFT JOIN	WQ1309 
				ON		WQ1309.InventoryID = AT2007.InventoryID 
						AND WQ1309.DivisionID = AT2007.DivisionID 
						AND WQ1309.ConvertedUnitID = AT2007.ConvertedUnitID
			LEFT JOIN WT8899 O99
				ON		O99.DivisionID = AT2007.DivisionID
						AND O99.VoucherID = AT2007.voucherID
						AND O99.TransactionID = AT2007.TransactionID			
			
			WHERE	AT2007.DivisionID = N''' + @DivisionID + N''' AND
					(AT2006.WareHouseID LIKE '''+@WareHouseID+''' OR AT2006.WareHouseID2 LIKE '''+@WareHouseID+''') AND
					Isnull(AT2006.ObjectID,'''') Like N''' + @ObjectID + N''' AND
					(AT2007.TranMonth +12*AT2007.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+N' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + N') AND 
					CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End)
					AND KindVoucherID = (Case When ''' + @TransactionTypeID + ''' = ''T05'' then 1 else 2 end) AND
					VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + '''' 
			
			IF @CustomerName = 15 --- Customize 2T		
				SET @sqlWhereUnion = @sqlWhereUnion + N' AND Isnull(AT1303.IsTemp,0) = 1  AND
					AT2007.VoucherID NOT IN (SELECT WOrderID FROM AT9000 WHERE Isnull(WOrderID,'''') <> '''' and DivisionID= ''' + @DivisionID + '''
									Union Select WVoucherID from AT2007 Where Isnull(WVoucherID,'''') <> '''' and DivisionID= ''' + @DivisionID + ''')'
									
			IF @CustomerName = 24 --- Customize Long Trường Vũ
				SET @sqlWhereUnion = @sqlWhereUnion + N' AND (VoucherTypeID = ''ANM'' or VoucherTypeID = ''BNM'' or VoucherTypeID = ''CNM'')'
		END
    END
    	
	IF @TransactionTypeID = 'SO'
		BEGIN
			SET @sqlSelect = N'
		   SELECT 	OT2002.SOrderID AS VoucherID, '''' as BatchID, OT2001.OrderDate AS VoucherDate, OT2001.VoucherNo, 
		   NULL AS Serial, NULL AS InvoiceNo, NULL AS InvoiceDate,
					OT2001.Notes AS VDescription, AT1202.ObjectName, OT2001.ObjectID, OT2001.CurrencyID, OT2001.ExchangeRate,
					OT2002.InventoryID, InventoryName,	'''' AS InventoryName1, OT2002.UnitID, OT2002.Orders ,
					(OT2002.OrderQuantity - ISNULL(AT2007.ActualQuantity,0)) AS Quantity, OT2002.SalePrice AS UnitPrice, 
					OriginalAmount,  ConvertedAmount, 
					OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
					OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
					AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, 
					AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, OT2002.DivisionID,
					'''' AS MOrderID, OT2002.RefSOrderID AS SOrderID, 
					'''' AS MTransactionID, OT2002.RefSTransactionID AS STransactionID,
					OT2002.Description AS BDescription, OT2002.Notes AS TDescription, '''' AS WareHouseID, '''' AS WareHouseID2,
					O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
			'
		SET @sqlFrom = N'
			FROM		OT2002 	
			INNER JOIN	OT2001 
				ON		OT2001.DivisionID = OT2002.DivisionID 
						AND OT2001.SOrderID = OT2002.SOrderID
			INNER JOIN	AT1302 
				ON		AT1302.DivisionID = OT2002.DivisionID 
						AND AT1302.InventoryID = OT2002.InventoryID
			LEFT JOIN	AT1202 
				ON		AT1202.DivisionID = OT2002.DivisionID 
						AND AT1202.ObjectID = OT2001.ObjectID
			LEFT JOIN	(	SELECT		SUM(ISNULL(ActualQuantity,0)) AS ActualQuantity, OrderID 
							FROM		AT2027
							GROUP BY	OrderID
			         	 )AT2007
			     ON		OT2002.SOrderID = AT2007.OrderID
			            AND OT2002.DivisionID = AT2007.DivisionID
			LEFT JOIN OT8899 O99
				ON		O99.DivisionID = OT2002.DivisionID
						AND O99.VoucherID = OT2002.SOrderID
						AND O99.TransactionID = OT2002.TransactionID            
			'
		SET @sqlWhere = N'
			WHERE	OT2002.DivisionID = N'''+@DivisionID+N''' AND
					Isnull(OT2001.ObjectID,'''') Like N'''+@ObjectID+N''' AND
					OT2001.OrderStatus = 1 AND
					OT2002.Finish = 0 AND
					OT2002.OrderQuantity > ISNULL(AT2007.ActualQuantity,0) AND
					(OT2001.TranMonth + 10*OT2001.TranYear Between  '+ STR(@FromTranMonth + 10*@FromTranYear)+N' AND ' + STR(@ToTranMonth + 10*@ToTranYear) + N') AND 
					CONVERT(varchar(10),OT2001.OrderDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+N'''  =''01/01/1900'' THEN CONVERT(varchar(10),OT2001.OrderDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+N''' End) AND
					OT2001.VoucherTypeID between N''' + @VoucherTypeIDFrom + N''' AND N''' + @VoucherTypeIDTo + N''''
		SET @sqlGroupBy = N''
		END
		
	IF @TransactionTypeID = 'T66'
		BEGIN			
			SET @sqlSelect = N'
			   SELECT 	AT2007.VoucherID, '''' as BatchID, AT2006.VoucherDate, AT2006.VoucherNo, 
						AT2006.Description AS VDescription, ObjectName,
						AT2006.ObjectID, AT2007.CurrencyID, AT2007.ExchangeRate,
						AT2007.InventoryID, InventoryName, InventoryName1, AT2007.UnitID, AT2007.Orders ,
						ActualQuantity AS Quantity, UnitPrice, OriginalAmount,  ConvertedAmount, 
						Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
						Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
						AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
						AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
						AT2007.ConvertedUnitID, AT2007.ConvertedQuantity, AT2007.ConvertedPrice, AT2007.MarkQuantity,
						AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
						WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
						AT2007.Notes AS BDescription, AT2007.Notes AS TDescription, AT2006.WareHouseID, AT2006.WareHouseID2,
						O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
						O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
						'
			SET @sqlFrom = N'
				FROM		AT2007 	
				INNER JOIN	AT2006 
					ON		AT2006.DivisionID = AT2007.DivisionID 
							AND AT2006.VoucherID = AT2007.VoucherID
				INNER JOIN	AT1302 
					ON		AT1302.DivisionID = AT2007.DivisionID 
							AND AT1302.InventoryID = AT2007.InventoryID
				LEFT JOIN	AT1202 
					ON		AT1202.DivisionID = AT2006.DivisionID 
							AND AT1202.ObjectID = AT2006.ObjectID
				Left Join WQ1309 
					On		WQ1309.InventoryID = AT2007.InventoryID 
							AND WQ1309.DivisionID = AT2007.DivisionID 
							AND WQ1309.ConvertedUnitID = AT2007.ConvertedUnitID
				LEFT JOIN WT8899 O99
				ON		O99.DivisionID = AT2007.DivisionID
						AND O99.VoucherID = AT2007.voucherID
						AND O99.TransactionID = AT2007.TransactionID 			'
			
			SET @sqlWhere = N'
				WHERE	AT2007.DivisionID = N'''+@DivisionID+N''' AND
						(AT2006.WareHouseID LIKE '''+@WareHouseID+''' OR AT2006.WareHouseID2 LIKE '''+@WareHouseID+''') AND
						Isnull(AT2006.ObjectID,'''') Like N'''+@ObjectID+N''' AND
						(AT2007.TranMonth +12*AT2007.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+N' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + N') AND 
						CONVERT(varchar(10),AT2006.VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+N'''  =''01/01/1900'' THEN CONVERT(varchar(10),AT2006.VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+N''' End) AND
						KindVoucherID =3  AND --- Van chuyen noi bo
						AT2006.VoucherTypeID between N''' + @VoucherTypeIDFrom + N''' AND N''' + @VoucherTypeIDTo + ''''
			
			--IF @CustomerName = 15 --- Customize 2T
				SET @sqlWhere =	@sqlWhere + ' AND Isnull(AT2007.WVoucherID,'''') = '''''
				
			SET @sqlGroupBy = N''
				
		END
		If @TransactionTypeID = 'CST1010'   --- Bổ sung Hồ sơ sửa chữa bên ModuleCS
        		BEGIN
					SET @sqlSelect = N'
					SELECT		C.DivisionID,
								C1.ObjectID, C1.ObjectName, 
								C1.VoucherDate, C1.VoucherNo, C1.VoucherID,
								A.BaseCurrencyID AS CurrencyID,
								1 AS ExchangeRate,
								C1.VoucherDate AS InvoiceDate,
								NULL AS InvoiceNo, NULL AS Serial,
								C.InventoryID, A1.InventoryName, A1.UnitID,
								C.Quantity, C.Price AS UnitPrice, 
								C.Amount AS OriginalAmount, C.Amount AS ConvertedAmount
								'
					SET @sqlFrom = N'				
					FROM		CST2013 C
					LEFT JOIN	CST2010 C1 
						ON		C1.DivisionID = C.DivisionID AND C1.VoucherID = C.VoucherID
					LEFT JOIN	AT1101 A
						ON		A.DivisionID = C1.DivisionID
					LEFT JOIN	AT1302 A1
						ON		A1.DivisionID = C.DivisionID AND A1.InventoryID = C.InventoryID
					'
					SET @sqlWhere = N'				
					WHERE		C.DivisionID = N'''+@DivisionID+N''' AND 
								Isnull(C1.ObjectID,'''') Like N'''+@ObjectID+N''' AND ' + 
								CASE WHEN len(@strVoucherID)>0 THEN 'C1.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
								CASE WHEN len(@Filter)>0 THEN 'ISNULL(C1.ObjectID,'''') In ' + @Filter + ' AND ' ELSE ' ' END + 
								'(TranMonth +12*TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
								CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND 
								C1.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' 	'
					SET @sqlGroupBy = N''
				END
		
END
-------------------If @IsGroup=0
Else
If @IsInherit = 0
	BEGIN
          If @TransactionTypeID <> 'T66' AND @TransactionTypeID <> 'SO' AND  @TransactionTypeID <> 'CST1010' --- Khac voi van chuyen noi bo
            BEGIN
				SET @sqlSelect = N'
				SELECT		AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo, 
							Serial, InvoiceNo, InvoiceDate, VDescription, ObjectName,
							AT9000.ObjectID, AT9000.CurrencyID, ExchangeRate,
							AT9000.InventoryID, InventoryName, Null AS InventoryName1,  AT9000.UnitID, Min(AT9000.Orders) AS Orders,  
							Sum(ISNULL(Quantity,0)) AS Quantity, CASE WHEN ISNULL(Sum(ISNULL(Quantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(Quantity,0)) END AS UnitPrice, Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, 
							Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
							Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
							AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT9000.DivisionID,
    						AT9000.MOrderID, AT9000.SOrderID, AT9000.MTransactionID, AT9000.STransactionID,
    						AT9000.ConvertedUnitID, Sum(Isnull(AT9000.ConvertedQuantity,0)) AS ConvertedQuantity, 
    						AVG(AT9000.ConvertedPrice) AS ConvertedPrice, Sum(Isnull(AT9000.MarkQuantity,0)) AS MarkQuantity,
							AT9000.UParameter01 AS Parameter01, AT9000.UParameter02 AS Parameter02, AT9000.UParameter03 AS Parameter03, AT9000.UParameter04 AS Parameter04, AT9000.UParameter05 AS Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT9000.BDescription, AT9000.TDescription, '''' AS WareHouseID, '''' AS WareHouseID2,
							O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		'
				SET @sqlFrom = 
N'				FROM		AT9000 	
				INNER JOIN	AT1302 
					ON		AT1302.DivisionID = AT9000.DivisionID 
							AND AT1302.InventoryID = AT9000.InventoryID
				LEFT JOIN	AT1202 
					ON		AT1202.DivisionID = AT9000.DivisionID 
							AND AT1202.ObjectID = AT9000.ObjectID
				Left Join WQ1309 On WQ1309.InventoryID = AT9000.InventoryID AND WQ1309.DivisionID = AT9000.DivisionID AND WQ1309.ConvertedUnitID = AT9000.ConvertedUnitID
				LEFT JOIN AT8899 O99
				ON		O99.DivisionID = AT9000.DivisionID
						AND O99.VoucherID = AT9000.VoucherID
						AND O99.TransactionID = AT9000.TransactionID '
				
				SET @sqlWhere = 
N'				WHERE		AT9000.DivisionID =N'''+@DivisionID+N''' AND
							Isnull(AT9000.ObjectID,'''') Like N'''+@ObjectID+N''' AND
							(TranMonth +12*TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
							CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
							TransactionTypeID =N'''+@TransactionTypeID+''' AND
							VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' AND 
							ISNULL(AT9000.VATGroupID,''%'') Like N''' + @VATGroupID + ''''
							
				IF @CustomerName = 15 --- Customize 2T
					SET @sqlWhere = @sqlWhere + N' AND VoucherID not in (Select WOrderID from AT9000 Where Isnull(WOrderID,'''') <> '''' and DivisionID= ''' + @DivisionID + ''')'
				
				SET @sqlGroupBy = 
N'				GROUP BY 
					AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo, Serial, InvoiceNo, InvoiceDate, VDescription, ObjectName,
					AT9000.ObjectID, AT9000.CurrencyID, ExchangeRate,
					AT9000.InventoryID, InventoryName, AT9000.UnitID, 
					Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
					Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
					AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT9000.DivisionID,
				    AT9000.MOrderID, AT9000.SOrderID, AT9000.MTransactionID, AT9000.STransactionID,
				    AT9000.ConvertedUnitID, AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05,
				    WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
				    AT9000.BDescription, AT9000.TDescription, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		'
				    
				If (@TransactionTypeID = 'T05' or @TransactionTypeID = 'T06') and (@CustomerName = 15 or @CustomerName = 24)
				BEGIN
					SET @sqlUnion = N' UNION ALL
					SELECT	AT2006.VoucherID, '''' as BatchID, VoucherDate, VoucherNo, 
							NULL AS Serial, NULL AS InvoiceNo, NULL AS InvoiceDate, Description AS VDescription, ObjectName,
							AT2006.ObjectID, NULL AS CurrencyID, NULL AS ExchangeRate,
							AT2007.InventoryID, InventoryName, Null AS InventoryName1,  AT2007.UnitID, Min(AT2007.Orders) AS Orders,  
							Sum(ISNULL(ActualQuantity,0)) AS Quantity, CASE WHEN ISNULL(Sum(ISNULL(ActualQuantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(ActualQuantity,0)) END AS UnitPrice, Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, 
							Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
							Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
							AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
    						AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
    						AT2007.ConvertedUnitID, Sum(Isnull(AT2007.ConvertedQuantity,0)) AS ConvertedQuantity, 
    						AVG(AT2007.ConvertedPrice) AS ConvertedPrice, Sum(Isnull(AT2007.MarkQuantity,0)) AS MarkQuantity,
							AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT2007.Notes AS BDescription, AT2007.Notes AS TDescription, AT2006.WareHouseID, AT2006.WareHouseID2,
							O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		
							
					FROM		AT2007
					INNER JOIN	AT2006
						ON		AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID
					INNER JOIN	AT1303
						ON		AT1303.DivisionID = AT2006.DivisionID And AT1303.WarehouseID = AT2006.WarehouseID
					INNER JOIN	AT1302 
						ON		AT1302.DivisionID = AT2007.DivisionID 
								AND AT1302.InventoryID = AT2007.InventoryID
					LEFT JOIN	AT1202 
						ON		AT1202.DivisionID = AT2006.DivisionID 
								AND AT1202.ObjectID = AT2006.ObjectID
					Left Join WQ1309 On WQ1309.InventoryID = AT2007.InventoryID AND WQ1309.DivisionID = AT2007.DivisionID AND WQ1309.ConvertedUnitID = AT2007.ConvertedUnitID
					LEFT JOIN WT8899 O99
				ON		O99.DivisionID = AT2007.DivisionID
						AND O99.VoucherID = AT2007.VoucherID
						AND O99.TransactionID = AT2007.TransactionID'
					
					SET @sqlWhereUnion = N' WHERE AT2007.DivisionID =N'''+@DivisionID+N''' AND
							(AT2006.WareHouseID LIKE '''+@WareHouseID+''' OR AT2006.WareHouseID2 LIKE '''+@WareHouseID+''') AND
							Isnull(AT2006.ObjectID,'''') Like N'''+@ObjectID+N''' AND
							(AT2007.TranMonth +12*AT2007.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
							CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
							--TransactionTypeID =N'''+@TransactionTypeID+''' AND
							VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' AND
							KindVoucherID = (Case When ''' + @TransactionTypeID + ''' = ''T05'' then 1 else 2 end) '
					
					IF @CustomerName = 15 --- Customize 2T
							SET @sqlWhereUnion = @sqlWhereUnion + N'AND Isnull(AT1303.IsTemp,0) = 1 AND
							AT2007.VoucherID not in (Select WOrderID from AT9000 Where Isnull(WOrderID,'''') <> '''' and DivisionID= ''' + @DivisionID + '''
									Union Select WVoucherID from AT2007 Where Isnull(WVoucherID,'''') <> '''' and DivisionID= ''' + @DivisionID + ''')'
					
					IF @CustomerName = 24 --- Customize Long Trường Vũ
							SET @sqlWhereUnion = @sqlWhereUnion + N'AND (VoucherTypeID = ''ANM'' or VoucherTypeID = ''BNM'' or VoucherTypeID = ''CNM'')'
						
					SET @sqlWhereUnion = @sqlWhereUnion + N'GROUP BY 
							AT2006.VoucherID, VoucherDate, VoucherNo, Description, ObjectName,
							AT2006.ObjectID, AT2007.InventoryID, InventoryName, AT2007.UnitID, 
							Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
							Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
							AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
							AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
							AT2007.ConvertedUnitID, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT2007.Notes, AT2006.WareHouseID, AT2006.WareHouseID2, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		 '		
				END
		    end
		If @TransactionTypeID = 'T66' 
        	BEGIN
				SET @sqlSelect =N'
				SELECT 		AT2007.VoucherID, '''' as BatchID, AT2006.VoucherDate, AT2006.VoucherNo, 
							AT2006.Description AS VDescription, ObjectName,
							AT2006.ObjectID, AT2007.CurrencyID, AT2007.ExchangeRate,
							AT2007.InventoryID, InventoryName, Null AS InventoryName1, AT2007.UnitID, Min(AT2007.Orders) AS Orders ,
							Sum(ISNULL(ActualQuantity,0)) AS Quantity, CASE WHEN ISNULL(Sum(ISNULL(ActualQuantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(ActualQuantity,0)) END AS UnitPrice, Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, 
							Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
							Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
							AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
							AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
							AT2007.ConvertedUnitID, Sum(Isnull(AT2007.ConvertedQuantity,0)) AS ConvertedQuantity, 
    						AVG(AT2007.ConvertedPrice) AS ConvertedPrice, Sum(Isnull(AT2007.MarkQuantity,0)) AS MarkQuantity,
							AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT2007.Notes AS BDescription, AT2007.Notes AS TDescription, AT2006.WareHouseID, AT2006.WareHouseID2,
							O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		 '
				
				SET @sqlFrom = 
N'				FROM		AT2007 	
				INNER JOIN	AT2006 
					ON		AT2006.DivisionID = AT2007.DivisionID 
							AND AT2006.VoucherID = AT2007.VoucherID
				INNER JOIN	AT1302 
					ON		AT1302.DivisionID = AT2007.DivisionID 
							AND AT1302.InventoryID = AT2007.InventoryID
				LEFT JOIN	AT1202 
					ON		AT1202.DivisionID = AT2006.DivisionID 
							AND AT1202.ObjectID = AT2006.ObjectID
				LEFT JOIN	WQ1309 
					ON		WQ1309.InventoryID = AT2007.InventoryID 
							AND WQ1309.DivisionID = AT2007.DivisionID 
							AND WQ1309.ConvertedUnitID = AT2007.ConvertedUnitID
				LEFT JOIN WT8899 O99
					ON		O99.DivisionID = AT2007.DivisionID
							AND O99.VoucherID = AT2007.VoucherID
							AND O99.TransactionID = AT2007.TransactionID			'
				
				SET @sqlWhere = 
N'				WHERE	AT2007.DivisionID =N'''+@DivisionID+''' AND
						(AT2006.WareHouseID LIKE '''+@WareHouseID+''' OR AT2006.WareHouseID2 LIKE '''+@WareHouseID+''') AND
						Isnull(AT2006.ObjectID,'''') Like N'''+@ObjectID+''' AND
						(AT2007.TranMonth +12*AT2007.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
						CONVERT(varchar(10),AT2006.VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+'''  =''01/01/1900'' THEN CONVERT(varchar(10),AT2006.VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
						KindVoucherID =3  AND --- Van chuyen noi bo
						AT2006.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + '''
'
				SET @sqlGroupBy = 
N'				GROUP BY
					AT2007.VoucherID, AT2006.VoucherDate, AT2006.VoucherNo, 
					AT2006.Description , ObjectName,
					AT2006.ObjectID, AT2007.CurrencyID, AT2007.ExchangeRate,
					AT2007.InventoryID, InventoryName,  AT2007.UnitID, 
					Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
					Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
					AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
				    AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
				    AT2007.ConvertedUnitID, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
					WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
					AT2007.Notes, AT2006.WareHouseID, AT2006.WareHouseID2,O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		  '
        	END
        	IF @TransactionTypeID = 'SO'
        	BEGIN
        		SET @sqlSelect = N'
				   SELECT 	OT2002.SOrderID AS VoucherID, '''' as BatchID, OT2001.OrderDate AS VoucherDate, OT2001.VoucherNo, NULL AS Serial, NULL AS InvoiceNo, NULL AS InvoiceDate,
							OT2001.Notes AS VDescription, AT1202.ObjectName, OT2001.ObjectID, OT2001.CurrencyID, OT2001.ExchangeRate,
							OT2002.InventoryID, InventoryName,	'''' AS InventoryName1, OT2002.UnitID, OT2002.Orders ,
							(OT2002.OrderQuantity - ISNULL(AT2007.ActualQuantity,0)) AS Quantity AS Quantity, OT2002.SalePrice AS UnitPrice, 
							OriginalAmount,  ConvertedAmount, 
							OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
							OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
							AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, OT2002.DivisionID,
							'''' AS MOrderID, OT2002.RefSOrderID AS SOrderID, 
							'''' AS MTransactionID, OT2002.RefSTransactionID AS STransactionID,
							OT2002.Description AS BDescription, OT2002.Notes AS TDescription , '''' AS WareHouseID, '''' AS WareHouseID2,
							O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		 
					'
				SET @sqlFrom = N'
					FROM		OT2002 	
					INNER JOIN	OT2001 
						ON		OT2001.DivisionID = OT2002.DivisionID 
								AND OT2001.SOrderID = OT2002.SOrderID
					INNER JOIN	AT1302 
						ON		AT1302.DivisionID = OT2002.DivisionID 
								AND AT1302.InventoryID = OT2002.InventoryID
					LEFT JOIN	AT1202 
						ON		AT1202.DivisionID = OT2002.DivisionID 
								AND AT1202.ObjectID = OT2001.ObjectID
					LEFT JOIN	(	SELECT		SUM(ISNULL(ActualQuantity,0)) AS ActualQuantity, OrderID 
									FROM		AT2027
									GROUP BY	OrderID
			         			 )AT2007
						 ON		OT2002.SOrderID = AT2007.OrderID
					LEFT JOIN OT8899 O99
					ON		O99.DivisionID = OT2002.DivisionID
							AND O99.VoucherID = OT2002.SOrderID
							AND O99.TransactionID = OT2002.TransactionID'
				SET @sqlWhere = N'
					WHERE	OT2002.DivisionID = N'''+@DivisionID+N''' AND
							Isnull(OT2001.ObjectID,'''') Like N'''+@ObjectID+N''' AND
							OT2001.OrderStatus = 1 AND
							OT2002.Finish = 0 AND
							OT2002.OrderQuantity > ISNULL(AT2007.ActualQuantity,0) AND
							(OT2001.TranMonth + 10*OT2001.TranYear Between  '+ STR(@FromTranMonth + 10*@FromTranYear) + N' AND ' + STR(@ToTranMonth + 10*@ToTranYear) + N') AND 
							CONVERT(varchar(10),OT2001.OrderDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+N'''  =''01/01/1900'' THEN CONVERT(varchar(10),OT2001.OrderDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+N''' End) AND
							OT2001.VoucherTypeID between N''' + @VoucherTypeIDFrom + N''' AND N''' + @VoucherTypeIDTo + N''''
				SET @sqlGroupBy = N'
					GROUP BY ' + 
						CASE WHEN @IsObject=1 THEN 'AT1202.ObjectName, OT2001.ObjectID, ' ELSE ' ' END + 
						CASE WHEN @IsCurrency=1 THEN 'OT2001.CurrencyID, ' ELSE ' ' END +
						'OT2002.InventoryID, InventoryName,  OrderQuantity.UnitID, ' + 
						CASE WHEN @IsAna=1 THEN 'OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,' ELSE ' ' END +
						'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, OT2002.DivisionID,
						OT2002.RefSOrderID AS SOrderID, 
						OT2002.RefSTransactionID AS STransactionID,
						OT2002.Description , OT2002.Notes,O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
						O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
						'
        	END
        	If @TransactionTypeID = 'CST1010'   --- Bổ sung Hồ sơ sửa chữa bên ModuleCS
        		BEGIN
					SET @sqlSelect = N'
					SELECT		C.DivisionID,
								C1.ObjectID, C1.ObjectName, 
								C1.VoucherDate, C1.VoucherNo, C1.VoucherID,
								A.BaseCurrencyID AS CurrencyID,
								1 AS ExchangeRate,
								C1.VoucherDate AS InvoiceDate,
								NULL AS InvoiceNo, NULL AS Serial,
								C.InventoryID, A1.InventoryName, A1.UnitID,
								C.Quantity, C.Price AS UnitPrice, 
								C.Amount AS OriginalAmount, C.Amount AS ConvertedAmount
								'
					SET @sqlFrom = N'				
					FROM		CST2013 C
					LEFT JOIN	CST2010 C1 
						ON		C1.DivisionID = C.DivisionID AND C1.VoucherID = C.VoucherID
					LEFT JOIN	AT1101 A
						ON		A.DivisionID = C1.DivisionID
					LEFT JOIN	AT1302 A1
						ON		A1.DivisionID = C.DivisionID AND A1.InventoryID = C.InventoryID
					'
					SET @sqlWhere = N'				
					WHERE		C.DivisionID = N'''+@DivisionID+N''' AND 
								Isnull(C1.ObjectID,'''') Like N'''+@ObjectID+N''' AND ' + 
								CASE WHEN len(@strVoucherID)>0 THEN 'C1.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
								CASE WHEN len(@Filter)>0 THEN 'ISNULL(C1.ObjectID,'''') In ' + @Filter + ' AND ' ELSE ' ' END + 
								'(TranMonth +12*TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
								CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND 
								C1.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + '''	'
					SET @sqlGroupBy = N''
				END
	END -------------If @IsInherit = 0
ELSE
	BEGIN ----------If @IsInherit <> 0
		If @TransactionTypeID <> 'T66'  AND @TransactionTypeID <> 'SO' AND  @TransactionTypeID <> 'CST1010'--- Khac voi van chuyen noi bo
        	BEGIN
				SET @sqlSelect = N'
				SELECT		NULL AS VoucherID, '''' as BatchID, Null AS VoucherDate, Null AS VoucherNo, Null AS Serial, Null AS InvoiceNo, Null AS InvoiceDate, Null AS VDescription, ' + 
							CASE WHEN @IsObject=1 AND @ObjectID = '%' THEN 'ObjectName, AT9000.ObjectID, ' ELSE 'Null AS ObjectName, Null AS ObjectID, ' END + 
							CASE WHEN @IsCurrency=1 THEN 'AT9000.CurrencyID, ' ELSE 'Null AS CurrencyID, ' END +
							N'Null AS ExchangeRate,
							AT9000.InventoryID, InventoryName, Null AS InventoryName1, AT9000.UnitID, Min(AT9000.Orders) AS Orders,  
							Sum(ISNULL(Quantity,0)) AS Quantity, CASE WHEN ISNULL(Sum(ISNULL(Quantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(Quantity,0)) END AS UnitPrice, Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, ' +
							CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,' ELSE 'Null AS Ana01ID, Null AS Ana02ID, Null AS Ana03ID, Null AS Ana04ID, Null AS Ana05ID,' END +
							N'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT9000.DivisionID,
							AT9000.MOrderID, AT9000.SOrderID, AT9000.MTransactionID, AT9000.STransactionID,
							AT9000.ConvertedUnitID, Sum(Isnull(AT9000.ConvertedQuantity,0)) AS ConvertedQuantity, 
    						AVG(AT9000.ConvertedPrice) AS ConvertedPrice, Sum(Isnull(AT9000.MarkQuantity,0)) AS MarkQuantity,
							AT9000.UParameter01 AS Parameter01, AT9000.UParameter02 AS Parameter02, AT9000.UParameter03 AS Parameter03, AT9000.UParameter04 AS Parameter04, AT9000.UParameter05 AS Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT9000.BDescription, AT9000.TDescription,'''' AS WareHouseID, '''' AS WareHouseID2,
							O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		 
'
				SET @sqlFrom = 
N'				FROM		AT9000 	
				INNER JOIN	AT1302 
					ON		AT1302.DivisionID = AT9000.DivisionID 
							AND AT1302.InventoryID = AT9000.InventoryID
				LEFT JOIN	AT1202 
					ON		AT1202.DivisionID = AT9000.DivisionID 
							AND AT1202.ObjectID = AT9000.ObjectID
				Left Join WQ1309 On WQ1309.InventoryID = AT9000.InventoryID AND WQ1309.DivisionID = AT9000.DivisionID AND WQ1309.ConvertedUnitID = AT9000.ConvertedUnitID
				LEFT JOIN AT8899 O99
					ON		O99.DivisionID = AT9000.DivisionID
							AND O99.VoucherID = AT9000.VoucherID
							AND O99.TransactionID = AT9000.TransactionID'
				
				SET @sqlWhere = 
N'				WHERE		AT9000.DivisionID = N'''+@DivisionID+N''' AND 
							Isnull(AT9000.ObjectID,'''') Like N'''+@ObjectID+N''' AND ' + 
							CASE WHEN len(@strVoucherID)>0 THEN 'AT9000.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
							CASE WHEN len(@Filter)>0 THEN 'ISNULL(AT9000.ObjectID,'''') In ' + @Filter + ' AND ' ELSE ' ' END + 
							'(TranMonth +12*TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
							CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND 
							TransactionTypeID =N'''+@TransactionTypeID+''' AND
							VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' AND 
							ISNULL(AT9000.VATGroupID,''%'') Like N''' + @VATGroupID + ''''
				
				IF @CustomerName = 15 --- Customize 2T
					SET @sqlWhere = @sqlWhere + N' AND
							VoucherID not in (Select WOrderID from AT9000 Where Isnull(WOrderID,'''') <> '''' and DivisionID= ''' + @DivisionID + ''')'
				
				SET @sqlGroupBy = 
N'				GROUP BY ' +
					CASE WHEN @IsObject=1 THEN 'ObjectName, AT9000.ObjectID, ' ELSE ' ' END + 
					CASE WHEN @IsCurrency=1 THEN 'AT9000.CurrencyID, ' ELSE ' ' END +
					N'AT9000.InventoryID, InventoryName, AT9000.UnitID, ' + 
					CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,' ELSE ' ' END +
					N'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT9000.DivisionID,
				    AT9000.MOrderID, AT9000.SOrderID, AT9000.MTransactionID, AT9000.STransactionID,
				    AT9000.ConvertedUnitID, AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05,
				    WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
				    AT9000.BDescription, AT9000.TDescription, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
				     '
				    
				If (@TransactionTypeID = 'T05' or @TransactionTypeID = 'T06') and (@CustomerName = 15 or @CustomerName = 24)
				BEGIN
					SET @sqlUnion = N' UNION ALL
					SELECT		NULL AS VoucherID, '''' as BatchID, Null AS VoucherDate, Null AS VoucherNo, Null AS Serial, Null AS InvoiceNo, Null AS InvoiceDate, Null AS VDescription, ' + 
							CASE WHEN @IsObject=1 AND @ObjectID = '%' THEN 'ObjectName, AT2006.ObjectID, ' ELSE 'Null AS ObjectName, Null AS ObjectID, ' END + 
							'Null AS CurrencyID, Null AS ExchangeRate,
							AT2007.InventoryID, InventoryName, Null AS InventoryName1, AT2007.UnitID, Min(AT2007.Orders) AS Orders,  
							Sum(ISNULL(ActualQuantity,0)) AS Quantity, CASE WHEN ISNULL(Sum(ISNULL(ActualQuantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(ActualQuantity,0)) END AS UnitPrice, Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, ' +
							CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,' ELSE 'Null AS Ana01ID, Null AS Ana02ID, Null AS Ana03ID, Null AS Ana04ID, Null AS Ana05ID,' END +
							N'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
							AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
							AT2007.ConvertedUnitID, Sum(Isnull(AT2007.ConvertedQuantity,0)) AS ConvertedQuantity, 
    						AVG(AT2007.ConvertedPrice) AS ConvertedPrice, Sum(Isnull(AT2007.MarkQuantity,0)) AS MarkQuantity,
							AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT2007.Notes AS BDescription, AT2007.Notes AS TDescription, AT2006.WareHouseID, AT2006.WareHouseID2,
							O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
							O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		 
					FROM		AT2007
					INNER JOIN	AT2006
						ON		AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID
					INNER JOIN	AT1303
						ON		AT1303.DivisionID = AT2006.DivisionID And AT1303.WarehouseID = AT2006.WarehouseID
					INNER JOIN	AT1302 
						ON		AT1302.DivisionID = AT2007.DivisionID 
							AND AT1302.InventoryID = AT2007.InventoryID
					LEFT JOIN	AT1202 
						ON		AT1202.DivisionID = AT2006.DivisionID 
								AND AT1202.ObjectID = AT2006.ObjectID
					LEFT JOIN	WQ1309 
						ON		WQ1309.InventoryID = AT2007.InventoryID 
								AND WQ1309.DivisionID = AT2007.DivisionID 
								AND WQ1309.ConvertedUnitID = AT2007.ConvertedUnitID
					LEFT JOIN WT8899 O99
					ON		O99.DivisionID = AT2007.DivisionID
							AND O99.VoucherID = AT2007.VoucherID
							AND O99.TransactionID = AT2007.TransactionID			'
							
					SET @sqlWhereUnion = N' WHERE AT2007.DivisionID = N'''+@DivisionID+N''' AND 
							(AT2006.WareHouseID LIKE '''+@WareHouseID+''' OR AT2006.WareHouseID2 LIKE '''+@WareHouseID+''') AND
							Isnull(AT2006.ObjectID,'''') Like N'''+@ObjectID+N''' AND ' + 
							CASE WHEN len(@strVoucherID)>0 THEN 'AT2007.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
							CASE WHEN len(@Filter)>0 THEN 'ISNULL(AT2006.ObjectID,'''') In ' + @Filter + ' AND ' ELSE ' ' END + 
							'(AT2007.TranMonth +12*AT2007.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
							CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND 
							--TransactionTypeID =N'''+@TransactionTypeID+''' AND
							VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' AND
							KindVoucherID = (Case When ''' + @TransactionTypeID + ''' = ''T05'' then 1 else 2 end)'
							
					IF @CustomerName = 15 --- Customize 2T
							SET @sqlWhereUnion = @sqlWhereUnion + N' AND Isnull(AT1303.IsTemp,0) = 1 AND							
							AT2007.VoucherID not in (Select WOrderID from AT9000 Where Isnull(WOrderID,'''') <> '''' and DivisionID= ''' + @DivisionID + '''
									Union Select WVoucherID from AT2007 Where Isnull(WVoucherID,'''') <> '''' and DivisionID= ''' + @DivisionID + ''')'
					
					IF @CustomerName = 24 --- Customize Long Trường Vũ
							SET @sqlWhereUnion = @sqlWhereUnion + N' AND (VoucherTypeID = ''ANM'' or VoucherTypeID = ''BNM'' or VoucherTypeID = ''CNM'')'
							
					SET @sqlWhereUnion = @sqlWhereUnion + N' GROUP BY ' +
							CASE WHEN @IsObject=1 THEN 'ObjectName, AT2006.ObjectID, ' ELSE ' ' END + 
							N'AT2007.InventoryID, InventoryName, AT2007.UnitID, ' + 
							CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,' ELSE ' ' END +
							N'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, AT2007.DivisionID,
							AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
							AT2007.ConvertedUnitID, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
							AT2007.Notes,AT2006.WareHouseID, AT2006.WareHouseID2 '
				END			
			END
			IF @TransactionTypeID ='T66'
				BEGIN
					SET @sqlSelect = N'
					SELECT		NULL AS VoucherID, '''' as BatchID, Null AS VoucherDate, Null AS VoucherNo, Null AS VDescription, ' + 
								CASE WHEN @IsObject=1 AND @ObjectID = '%' THEN 'ObjectName, AT2006.ObjectID, ' ELSE 'Null AS ObjectName, Null AS ObjectID, ' END + 
								CASE WHEN @IsCurrency=1 THEN 'AT2007.CurrencyID, ' ELSE 'Null AS CurrencyID, ' END +
								'Null AS ExchangeRate,
								AT2007.InventoryID, InventoryName, Null AS InventoryName1, AT2007.UnitID, Min(AT2007.Orders) AS Orders ,
								Sum(ISNULL(ActualQuantity,0)) AS Quantity, CASE WHEN ISNULL(Sum(ISNULL(ActualQuantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(ActualQuantity,0)) END AS UnitPrice, Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, ' + 
								CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,' ELSE 'Null AS Ana01ID, Null AS Ana02ID, Null AS Ana03ID, Null AS Ana04ID, Null AS Ana05ID,' END +
								'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID,AT2007.DivisionID,
								AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
								AT2007.ConvertedUnitID, Sum(Isnull(AT2007.ConvertedQuantity,0)) AS ConvertedQuantity, 
    							AVG(AT2007.ConvertedPrice) AS ConvertedPrice, Sum(Isnull(AT2007.MarkQuantity,0)) AS MarkQuantity,
								AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
								WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
								AT2007.Notes AS BDescription, AT2007.Notes AS TDescription, AT2006.WareHouseID, AT2006.WareHouseID2,
								O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
								O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		  '
								
					SET @sqlFrom = N'
					FROM		AT2007 	
					INNER JOIN	AT2006 
						ON		AT2006.DivisionID = AT2007.DivisionID 
								AND AT2006.VoucherID = AT2007.VoucherID
					INNER JOIN	AT1302 
						ON		AT1302.DivisionID = AT2007.DivisionID 
								AND AT1302.InventoryID = AT2007.InventoryID
					LEFT JOIN	AT1202 
						ON		AT1202.DivisionID = AT2006.DivisionID 
								AND AT1202.ObjectID = AT2006.ObjectID
					Left Join WQ1309 On WQ1309.InventoryID = AT2007.InventoryID AND WQ1309.DivisionID = AT2007.DivisionID AND WQ1309.ConvertedUnitID = AT2007.ConvertedUnitID
					LEFT JOIN WT8899 O99
						ON		O99.DivisionID = AT2007.DivisionID
								AND O99.VoucherID = AT2007.VoucherID
								AND O99.TransactionID = AT2007.TransactionID'
					
					SET @sqlWhere = N'
					WHERE		AT2007.DivisionID =N'''+@DivisionID+''' AND
								(AT2006.WareHouseID LIKE '''+@WareHouseID+''' OR AT2006.WareHouseID2 LIKE '''+@WareHouseID+''') AND
								Isnull(AT2006.ObjectID,'''') Like N'''+@ObjectID+''' AND ' + 
								CASE WHEN len(@strVoucherID)>0 THEN 'AT2007.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
								--CASE WHEN len(@Filter)>0 THEN 'ISNULL(AT9000.ObjectID,'''') In ' + @Filter + ' AND '  ELSE ' ' END + 
								'(AT2007.TranMonth +12*AT2007.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
								CONVERT(varchar(10),AT2006.VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+'''  =''01/01/1900'' THEN CONVERT(varchar(10),AT2006.VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
								KindVoucherID =3  AND --- Van chuyen noi bo
								AT2006.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + '''
								'
					SET @sqlGroupBy = N'
					GROUP BY ' + 
						CASE WHEN @IsObject=1 THEN 'ObjectName, AT2006.ObjectID, ' ELSE ' ' END + 
						CASE WHEN @IsCurrency=1 THEN 'AT2007.CurrencyID, ' ELSE ' ' END +
						'AT2007.InventoryID, InventoryName,  AT2007.UnitID, ' + 
						CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,' ELSE ' ' END +
						'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID,AT2007.DivisionID,
						AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
						AT2007.ConvertedUnitID, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
						WQ1309.ConversionFactor, WQ1309.Operator, WQ1309.DataType, WQ1309.FormulaDes,
						AT2007.Notes, AT2006.WareHouseID, AT2006.WareHouseID2, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
						O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		  '
				END
				IF @TransactionTypeID = 'SO'
				BEGIN
					SET @sqlSelect = N'
					SELECT		NULL AS VoucherID, '''' as BatchID, NULL AS VoucherDate, NULL AS VoucherNo, NULL AS VDescription, NULL AS Serial, NULL AS InvoiceNo, NULL AS InvoiceDate, ' + 
								CASE WHEN @IsObject=1 AND @ObjectID = '%' THEN 'AT1202.ObjectName, OT2001.ObjectID, ' ELSE 'Null AS ObjectName, Null AS ObjectID, ' END + 
								CASE WHEN @IsCurrency=1 THEN 'OT2001.CurrencyID, ' ELSE 'Null AS CurrencyID, ' END +
								'Null AS ExchangeRate,
								OT2002.InventoryID, InventoryName, Null AS InventoryName1, OT2002.UnitID, Min(OT2002.Orders) AS Orders ,
								(Sum(ISNULL(OT2002.OrderQuantity,0)) - ISNULL(AT2007.ActualQuantity,0)) ) AS Quantity, 
								CASE WHEN ISNULL(Sum(ISNULL(OT2002.OrderQuantity,0)),0)=0 THEN 0 ELSE Sum(ISNULL(OriginalAmount,0))/Sum(ISNULL(OT2002.OrderQuantity,0)) END AS UnitPrice, 
								Sum(ISNULL(OriginalAmount,0)) AS OriginalAmount,  Sum(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, 
								' + CASE WHEN @IsAna = 1 THEN 'OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID, ' ELSE 'Null AS Ana01ID, Null AS Ana02ID, Null AS Ana03ID, Null AS Ana04ID, Null AS Ana05ID, Null AS Ana06ID, Null AS Ana07ID, Null AS Ana08ID, Null AS Ana09ID, Null AS Ana10ID,' END + '
								AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, OT2002.DivisionID,
								'''' AS MOrderID, OT2002.RefSOrderID AS SOrderID, 
								'''' AS MTransactionID, OT2002.RefSTransactionID AS STransactionID,
								OT2002.Notes AS BDescription, OT2002.Description AS TDescription, '''' AS WareHouseID, '''' AS WareHouseID2,
								O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
								O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
								'
					SET @sqlFrom = N'
					FROM		OT2002 	
					INNER JOIN	OT2001 
						ON		OT2001.DivisionID = OT2002.DivisionID 
								AND OT2001.SOrderID = OT2002.SOrderID
					INNER JOIN	AT1302 
						ON		AT1302.DivisionID = OT2002.DivisionID 
								AND AT1302.InventoryID = OT2002.InventoryID
					LEFT JOIN	AT1202 
						ON		AT1202.DivisionID = OT2002.DivisionID 
								AND AT1202.ObjectID = OT2001.ObjectID
					LEFT JOIN	(	SELECT		SUM(ISNULL(ActualQuantity,0)) AS ActualQuantity, OrderID 
									FROM		AT2027
									GROUP BY	OrderID
			         			 )AT2007
						 ON		OT2002.SOrderID = AT2007.OrderID
					LEFT JOIN OT8899 O99
						ON		O99.DivisionID = OT2002.DivisionID
								AND O99.VoucherID = OT2002.SOrderID
								AND O99.TransactionID = OT2002.TransactionID	 
								'
					SET @sqlWhere = N'
					WHERE		OT2002.DivisionID =N'''+@DivisionID+''' AND
								Isnull(OT2001.ObjectID,'''') Like N'''+@ObjectID+''' AND 
								OT2001.OrderStatus = 1 AND
								OT2002.Finish = 0 AND
								OT2002.OrderQuantity > ISNULL(AT2007.ActualQuantity,0) AND
								' + CASE WHEN len(@strVoucherID)>0 THEN 'OT2002.SOrderID In (' + @strVoucherID + ') AND ' ELSE ' '	END + 
								'(OT2001.TranMonth + 10 *OT2001.TranYear Between  '+STR(@FromTranMonth + 10 *@FromTranYear)+' AND ' + STR(@ToTranMonth + 10*@ToTranYear) + ') AND 
								CONVERT(varchar(10),OT2001.OrderDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+'''  =''01/01/1900'' THEN CONVERT(varchar(10),OT2001.OrderDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
								OT2001.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + '''
								'
					SET @sqlGroupBy = N'
					GROUP BY ' + 
						CASE WHEN @IsObject=1 THEN 'AT1202.ObjectName, OT2001.ObjectID, ' ELSE ' ' END + 
						CASE WHEN @IsCurrency=1 THEN 'OT2001.CurrencyID, ' ELSE ' ' END +
						'OT2002.InventoryID, InventoryName,  OrderQuantity.UnitID, ' + 
						CASE WHEN @IsAna=1 THEN 'OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,' ELSE ' ' END +
						'AT1302.SalePrice01, AT1302.SalesAccountID, AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsStocked, AT1302.IsLocation, AT1302.MethodID, AT1302.AccountID, AT1302.PrimeCostAccountID, OT2002.DivisionID,
						OT2002.RefSOrderID AS SOrderID, 
						OT2002.RefSTransactionID AS STransactionID,
						OT2002.Notes, OT2002.Description, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
						O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		  '
				END -----------IF @TransactionTypeID = 'SO'
				If @TransactionTypeID = 'CST1010'   --- Bổ sung Hồ sơ sửa chữa bên ModuleCS
        		BEGIN
					SET @sqlSelect = N'
					SELECT		C.DivisionID,
								C1.ObjectID, C1.ObjectName, 
								C1.VoucherDate, C1.VoucherNo, C1.VoucherID,
								A.BaseCurrencyID AS CurrencyID,
								1 AS ExchangeRate,
								C1.VoucherDate AS InvoiceDate,
								NULL AS InvoiceNo, NULL AS Serial,
								C.InventoryID, A1.InventoryName, A1.UnitID,
								SUM(ISNULL(C.Quantity,0)) AS Quantity, 
								SUM(ISNULL(C.Amount,0))/SUM(ISNULL(C.Quantity,0)) AS UnitPrice, 
								SUM(ISNULL(C.Amount,0)) AS OriginalAmount, 
								SUM(ISNULL(C.Amount,0)) AS ConvertedAmount
								'
					SET @sqlFrom = N'				
					FROM		CST2013 C
					LEFT JOIN	CST2010 C1 
						ON		C1.DivisionID = C.DivisionID AND C1.VoucherID = C.VoucherID
					LEFT JOIN	AT1101 A
						ON		A.DivisionID = C1.DivisionID
					LEFT JOIN	AT1302 A1
						ON		A1.DivisionID = C.DivisionID AND A1.InventoryID = C.InventoryID
					'
					SET @sqlWhere = N'				
					WHERE		C.DivisionID = N'''+@DivisionID+N''' AND 
								Isnull(C1.ObjectID,'''') Like N'''+@ObjectID+N''' AND ' + 
								CASE WHEN len(@strVoucherID)>0 THEN 'C1.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
								CASE WHEN len(@Filter)>0 THEN 'ISNULL(C1.ObjectID,'''') In ' + @Filter + ' AND ' ELSE ' ' END + 
								'(TranMonth +12*TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
								CONVERT(varchar(10),VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+''' =''01/01/1900'' THEN CONVERT(varchar(10),VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND 
								C1.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + ''' 	'
					SET @sqlGroupBy = N'				
					GROUP BY	C.DivisionID,
								C1.ObjectID, C1.ObjectName, 
								C1.VoucherDate, C1.VoucherNo, C1.VoucherID,
								A.BaseCurrencyID AS CurrencyID,
								1 AS ExchangeRate,
								C1.VoucherDate AS InvoiceDate,
								NULL AS InvoiceNo, NULL AS Serial,
								C.InventoryID, A1.InventoryName, A1.UnitID,'
				END ------If @TransactionTypeID = 'CST1010' 
				


	END ----------If @IsInherit <> 0
IF @TransactionTypeID = 'T65'   --- Phieu chenh lech kho
BEGIN
	SET @sqlSelect = N'
		SELECT		''WT0101'' AS InheritTableID, WT0101.VoucherID AS InheritVoucherID, WT0102.TransactionID AS InheritTransactionID,
					NULL AS VoucherID, '''' AS BatchID, Null AS VoucherDate, Null AS VoucherNo, Null AS VDescription, ' + 
					CASE WHEN @IsObject=1 AND @ObjectID = '%' THEN 'ObjectName, WT0101.ObjectID, ' ELSE 'NULL AS ObjectName, NULL AS ObjectID, ' END + '
					AT1101.BaseCurrencyID AS CurrencyID,
					1 AS ExchangeRate,
					WT0102.InventoryID, AT1302.InventoryName, AT1302.InventoryName AS InventoryName1, 
					WT0102.UnitID, WT0102.Orders,
					ISNULL(WT0102.ActualQuantity,0) AS Quantity, 
					WT0102.Price AS UnitPrice, 
					ISNULL(ConvertedAmount,0) AS OriginalAmount,  
					ISNULL(ConvertedAmount,0) AS ConvertedAmount, ' + 
					CASE WHEN @IsAna=1 THEN 'Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,' ELSE 'Null AS Ana01ID, Null AS Ana02ID, Null AS Ana03ID, Null AS Ana04ID, Null AS Ana05ID, Null AS Ana06ID, Null AS Ana07ID, Null AS Ana08ID, Null AS Ana09ID, Null AS Ana10ID,' END + '
					WT0101.DivisionID,
					NULL AS Serial, NULL AS InvoiceNo, NULL AS InvoiceDate, 
					WT0102.UnitID AS ConvertedUnitID, ISNULL(WT0102.ActualQuantity,0) AS ConvertedQuantity, 
					WT0102.Price AS ConvertedPrice, 
					NULL AS BDescription, WT0102.Notes AS TDescription, '''' AS WareHouseID, '''' AS WareHouseID2,
					O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID '
					
		SET @sqlFrom = N'
		FROM		WT0102 WT0102 	
		INNER JOIN	WT0101 WT0101
			ON		WT0101.DivisionID = WT0102.DivisionID 
					AND WT0101.VoucherID = WT0102.VoucherID
		INNER JOIN	AT1302 AT1302 
			ON		AT1302.DivisionID = WT0102.DivisionID 
					AND AT1302.InventoryID = WT0102.InventoryID
		LEFT JOIN	AT1202 AT1202 
			ON		AT1202.DivisionID = WT0101.DivisionID 
					AND AT1202.ObjectID = WT0101.ObjectID
		LEFT JOIN	AT1101 AT1101
			ON		AT1101.DivisionID = WT0101.DivisionID
		LEFT JOIN WT8899 O99
						ON		O99.DivisionID = WT0102.DivisionID
								AND O99.VoucherID = WT0102.SOrderID
								AND O99.TransactionID = WT0102.TransactionID	
		'		
		SET @sqlWhere = N'
		WHERE		WT0102.DivisionID =N'''+@DivisionID+''' AND
					Isnull(WT0101.ObjectID,'''') Like N'''+@ObjectID+''' AND ' + 
					CASE WHEN len(@strVoucherID)>0 THEN 'WT0102.VoucherID In (' + @strVoucherID + ') AND ' ELSE ' '	End + 
					--CASE WHEN len(@Filter)>0 THEN 'ISNULL(AT9000.ObjectID,'''') In ' + @Filter + ' AND '  ELSE ' ' END + 
					'(WT0102.TranMonth +12*WT0102.TranYear Between  '+ltrim(@FromTranMonth + 12*@FromTranYear)+' AND ' + ltrim(@ToTranMonth + 12*@ToTranYear) + ') AND 
					CONVERT(varchar(10),WT0101.VoucherDate,21) = (CASE WHEN '''+CONVERT(varchar(10),@VoucherDate,21)+'''  =''01/01/1900'' THEN CONVERT(varchar(10),WT0101.VoucherDate,21) ELSE '''+CONVERT(varchar(10),@VoucherDate,21)+''' End) AND
					WT0101.VoucherTypeID between N''' + @VoucherTypeIDFrom + ''' AND N''' + @VoucherTypeIDTo + '''
					'
		SET @sqlGroupBy = N'
		 '
	END -------IF @TransactionTypeID = 'T65'   --- Phieu chenh lech kho


		
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME = 'AV1234' AND XTYPE ='V')
     EXEC ('  CREATE VIEW AV1234 -- TAO BOI AP1234
     AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy + @sqlUnion + @sqlWhereUnion)
ELSE
     EXEC ('  ALTER VIEW AV1234  -- TAO BOI AP1234
     AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy + @sqlUnion + @sqlWhereUnion)

END	





GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

