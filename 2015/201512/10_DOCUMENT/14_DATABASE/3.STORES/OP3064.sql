IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3064]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3064]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by: Vo Thanh Huong, date:  15/03/2006
---Purpose: In bao cao Tong hop Don hang ban
----Last EDit : Thuy Tuyen 04/07/2007 
---- Modified on 31/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 11/12/2012 by Bao Anh : Khong load don hang san xuat (Where them OrderType = 0)
---- Modified on 09/12/2013 by Bao Anh : Customize báo cáo công nợ cho Sinolife
---- Modified on 16/07/2014 by Bao Anh : Bổ sung số tiền đã thu (ReceivedOriginalAmount)
---- Modified on 24/09/2014 by Bao Anh : Lấy thông tin hóa đơn bán hàng theo quy trình kế thừa ĐHB -> Phiếu xuất -> HĐBH (SG Petrol)

CREATE PROCEDURE [dbo].[OP3064] 
				@DivisionID nvarchar(50),
				@IsDate tinyint,
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,	
				@FromDate datetime,
				@ToDate datetime,
				@FromObject nvarchar(50),
				@ToObject nvarchar(50),
				@OrderStatus int				
AS

DECLARE @CustomerName INT
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng Sinolife không (CustomerName = 20)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

DECLARE @sSQL nvarchar(4000),
		@sSQL1 nvarchar(4000),
		@sPeriod nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Set @sPeriod = case when @IsDate = 1 then ' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),OT2001.OrderDate,101),101) BETWEEN ''' + @FromDateText + '''  and  ''' + 
		@ToDateText + ''''   else 
		' and OT2001.TranMonth + OT2001.TranYear*100 between ' + @FromMonthYearText + ' and ' +
		@ToMonthYearText  end

Set @sSQL = '
Select 	OT2001.DivisionID,
		OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		OT2001.VoucherNo as OrderNo, 
		OT2001.OrderDate, 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.ClassifyID, 
		OT2001.OrderType, 
		OT2001.ObjectID, 
		OT2001.DeliveryAddress, 
		OT2001.Notes, 		
		OT2001.OrderStatus, 
		OT2001.QuotationID, 
		OT2001.CurrencyID, 
		OT2001.ExchangeRate, 
		OT2001.EmployeeID, 
		AT1103.FullName,
		OT2001.Transport, 
		OT2001.PaymentID, 
		case when isnull(OT2001.ObjectName, '''') <> '''' then OT2001.ObjectName else AT1202.ObjectName end as ObjectName,
		case when isnull(OT2001.VatNo, '''') <> '''' then OT2001.VATNo else  AT1202.VATNo end as VATNo,
		case when isnull(OT2001.Address, '''') <> '''' then OT2001.Address else AT1202.Address end as Address,
		AT1202.Tel,
		AT1202.Fax,
		AT1202.Email,
		OT2001.IsPeriod, 
		OT2001.IsPlan, 
		OT2001.DepartmentID, 
		OT2001.SalesManID, 
		AT1103_2.FullName as SalesManName,
		OT2001.ShipDate, 
		OT2001.InheritSOrderID, 
		OT2001.DueDate, 
		OT2001.PaymentTermID, 
		OV1001.Description as OrderStatusName,
		OV1001.EDescription as EOrderStatusName,
		OriginalAmount = (Select sum(isnull(OriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		ConvertedAmount = (Select sum(isnull(ConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		VATOriginalAmount = (Select sum(isnull(VATOriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		VATConvertedAmount = (Select sum(isnull(VATConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		DiscountOriginalAmount = (Select sum(isnull(DiscountOriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		DiscountConvertedAmount = (Select sum(isnull(DiscountConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		CommissionCAmount = (Select sum(isnull(CommissionCAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		CommissionOAmount = (Select sum(isnull(CommissionOAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		AT9000.VoucherNo ,
		AT9000.VoucherDate,
		AT9000.InvoiceNo,
		AT9000.InvoiceDate,
		AT9000.CurrencyID as InvoiceCurrencyID,
		AT9000.OriginalAmount as InvoiceOriginalAmount,
		AT9000.ConvertedAmount as InvoiceConvertedAmount,
		(Select sum(T90.OriginalAmount) From AT9000 T90 Where T90.DivisionID = ''' + @DivisionID + '''
														and T90.TransactionTypeID in (''T01'', ''T21'')
														And T90.TVoucherID = AT9000.VoucherID) as ReceivedOriginalAmount'
														
IF @CustomerName = 36 --- AP SG Petrol
    Set @sSQL = @sSQL + ', T90.VoucherNo as PVoucherNo,
		T90.VoucherDate as PVoucherDate,
		T90.InvoiceNo as PInvoiceNo,
		T90.InvoiceDate as PInvoiceDate,
		T90.CurrencyID as PInvoiceCurrencyID,
		T90.OriginalAmount as PInvoiceOriginalAmount,
		T90.ConvertedAmount as PInvoiceConvertedAmount'
		
Set @sSQL1 = '														
From OT2001 left join OV1001 on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.DivisionID = OT2001.DivisionID and OV1001.TypeID= ''SO''
		left join AT1202 on AT1202.ObjectID = OT2001.ObjectID and AT1202.DivisionID = OT2001.DivisionID
		left join AT1103 on AT1103.FullName = OT2001.EmployeeID  and AT1103.DivisionID = OT2001.DivisionID
		left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.SalesManID and AT1103_2.DivisionID = OT2001.DivisionID
		left join 
		(
			Select DivisionID, VoucherID, VoucherNo, VoucherDate,  OrderID, InvoiceNo, InvoiceDate, CurrencyID, 
				sum(isnull(OriginalAmount, 0)) as OriginalAmount,
				sum(isnull(ConvertedAmount, 0)) as ConvertedAmount
			From AT9000 
			Where DivisionID = ''' + @DivisionID + ''' and 
					TransactionTypeID in (''T04'', ''T14'')
			Group by DivisionID, VoucherID, VoucherNo, VoucherDate, OrderID, InvoiceNo, InvoiceDate, CurrencyID		
		)	AT9000 on AT9000.OrderID = OT2001.SOrderID  and AT9000.DivisionID = OT2001.DivisionID'
		
IF @CustomerName = 36 --- AP SG Petrol
    Set @sSQL1 = @sSQL1 + '
    LEFT JOIN
    (
		Select AT2007.DivisionID, AT2007.VoucherID, AT2007.OrderID,
				sum(isnull(AT2007.OriginalAmount, 0)) as OriginalAmount,
				sum(isnull(AT2007.ConvertedAmount, 0)) as ConvertedAmount
		From AT2007 Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID
		Where AT2007.DivisionID = ''' + @DivisionID + ''' and AT2006.KindVoucherID = 2 And Isnull(AT2007.OrderID,'''') <> ''''
		Group by AT2007.DivisionID, AT2007.VoucherID, AT2007.OrderID
    ) AT2007 on OT2001.DivisionID = AT2007.DivisionID And OT2001.SOrderID = AT2007.OrderID                  
	
	LEFT JOIN
    (
		Select DivisionID, VoucherID, VoucherNo, VoucherDate, WOrderID, InvoiceNo, InvoiceDate, CurrencyID,
				sum(isnull(OriginalAmount, 0)) as OriginalAmount,
				sum(isnull(ConvertedAmount, 0)) as ConvertedAmount
		From AT9000
		Where DivisionID = ''' + @DivisionID + ''' and 
					TransactionTypeID in (''T04'', ''T14'')
		Group by DivisionID, VoucherID, VoucherNo, VoucherDate, WOrderID, InvoiceNo, InvoiceDate, CurrencyID
    ) T90 on AT2007.DivisionID = T90.DivisionID And AT2007.VoucherID = T90.WOrderID  	
	'
	
Set @sSQL1 = @sSQL1 + ' Where OT2001.DivisionID like ''' + @DivisionID + ''' and 
	OT2001.ObjectID between N''' + @FromObject + ''' and N''' + @ToObject + ''' and OT2001.OrderType = 0 and
	OT2001.OrderStatus like ' + case when @OrderStatus = - 1 then '''%''' else cast(@OrderStatus as nvarchar(1))  end + @sPeriod 

IF exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3064')
	DROP VIEW OV3064

EXEC('Create view OV3064 --tao boi OP3064
		as ' + @sSQL + @sSQL1)

--Phan Tuyen them vao in bao cao chi tiet tinh hinh thanh toan
Set @sSQL = '
Select 	OT2001.DivisionID,	
		OT2001.SOrderID, 
		OT2001.VoucherNo as OrderNo, 
		OT2001.OrderDate, 
		OT2001.ObjectID, 
		AT1202.ObjectName,
		OT2001.CurrencyID, 
		OT2001.ExchangeRate, 
		OriginalAmount = (Select sum(isnull(OriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		ConvertedAmount = (Select sum(isnull(ConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		VATOriginalAmount = (Select sum(isnull(VATOriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		VATConvertedAmount = (Select sum(isnull(VATConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		DiscountOriginalAmount = (Select sum(isnull(DiscountOriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		DiscountConvertedAmount = (Select sum(isnull(DiscountConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		CommissionCAmount = (Select sum(isnull(CommissionCAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		CommissionOAmount = (Select sum(isnull(CommissionOAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID),
		T90.VoucherNo ,
		T90.VoucherDate,
		T90.InvoiceNo,
		T90.InvoiceDate,
		T90.CurrencyID as InvoiceCurrencyID,
		T90.InventoryID,
		AT1302.InventoryName,
		T90.Quantity as ActualQuantity  ,
		T90.OriginalAmount as InvoiceOriginalAmount,
		T90.ConvertedAmount as InvoiceConvertedAmount,
		VATCoAmount=
		(
			(
				Select isnull(Sum(AT9000.ConvertedAmount),0) 
				From AT9000 
				Where AT9000.InventoryID = T90.InventoryID and 
					AT9000.OrderID =T90.OrderID and 
					AT9000.VoucherNO = T90.VoucherNO 
					and AT9000.DivisionID = T90.DivisionID 
			)
			* 
			(
				Select isnull(VATRate,0) 
				From at1010 
				Where VATGroupID In 
				(	
					Select Top 1 VATGroupID 
					From AT9000 
					Where AT9000.InventoryID = T90.InventoryID and 
						AT9000.OrderID =T90.OrderID and 
						AT9000.VoucherNO = T90.VoucherNO and 
						TransactiontypeID = ''T04''
						and AT9000.DivisionID = T90.DivisionID 
				)
			)/100
		),		
		PayOriginalAmount = (Select Isnull(Sum(OriginalAmount),0) From AT9000 Where  CreditAccountID = AT1202.ReAccountID and  AT9000.OrderID = T90.OrderID and  AT9000.DivisionID = T90.DivisionID),
		PayCovertedAmount = (Select Isnull(Sum(ConvertedAmount),0) From AT9000 Where CreditAccountID = AT1202.ReAccountID and  AT9000.OrderID = T90.OrderID and  AT9000.DivisionID = T90.DivisionID)

From OT2001 left join OV1001 on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.DivisionID = OT2001.DivisionID  and OV1001.TypeID= ''SO''
	left join AT1202 on AT1202.ObjectID = OT2001.ObjectID	 and AT1202.DivisionID = OT2001.DivisionID	
	left join AT1103 on AT1103.FullName = OT2001.EmployeeID  and AT1103.DivisionID = OT2001.DivisionID
	left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.SalesManID and AT1103_2.DivisionID = OT2001.DivisionID
	left join AT9000 T90  on T90.OrderID = OT2001.SOrderID  and T90.DivisionID = OT2001.DivisionID
	Left Join AT1302 on AT1302.InventoryID = T90.InventoryID and AT1302.DivisionID = OT2001.DivisionID
			
Where OT2001.DivisionID like ''' + @DivisionID + ''' and 
	T90.InventoryID is not null and
	T90.OriginalAmount is not null and
	OT2001.ObjectID between N''' + @FromObject + ''' and N''' + @ToObject + ''' and OT2001.OrderType = 0 and
	OT2001.OrderStatus like '  + case when @OrderStatus = - 1 then '''%''' else cast(@OrderStatus as varchar(1))  end + @sPeriod 

IF exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3065')
	DROP VIEW OV3065

EXEC('Create view OV3065 --tao boi OP3064
		as ' + @sSQL)

IF @CustomerName = 20 --- Sinolife
BEGIN
	Declare @ContractAnaTypeID nvarchar(50),
			@sTime as nvarchar(max)
	
	SET @ContractAnaTypeID = ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID), 'A03')
	
	Set @sTime = case when @IsDate = 1 then ' AND CONVERT(VARCHAR(10),dateadd(day,AT1021.StepDays,AT1020.SignDate),101) BETWEEN ''' + @FromDateText + '''  and  ''' + 
		@ToDateText + ''''   else 
		' AND Month(dateadd(day,AT1021.StepDays,AT1020.SignDate)) + Year(dateadd(day,AT1021.StepDays,AT1020.SignDate)) * 100 between ' + @FromMonthYearText + ' and ' +
		@ToMonthYearText  end

	Set @sSQL = 'SELECT OT2001.ObjectID, AT1202.ObjectName,
						(CASE WHEN ''' + @ContractAnaTypeID + ''' = ''A01'' THEN OT2002.Ana01ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A02'' THEN OT2002.Ana02ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A03'' THEN OT2002.Ana03ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A04'' THEN OT2002.Ana04ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A05'' THEN OT2002.Ana05ID END) as ContractNo,
						OT2002.InventoryID, AT1020.Amount as ContractAmount,
						
						(Select sum(AT9000.ConvertedAmount) From AT9000 Inner join AT1021 On AT9000.DivisionID = AT1021.DivisionID And AT9000.ContractDetailID = AT1021.ContractDetailID
						Where AT9000.DivisionID = ''' + @DivisionID + ''' And AT1021.ContractID = AT1020.ContractID) as PaymentAmount,
						
						(Select sum(PaymentAmount) From AT1021 Where AT1021.DivisionID = ''' + @DivisionID + ''' And AT1021.ContractID = AT1020.ContractID' + @sTime + '
						AND Isnull(AT1021.PaymentStatus,0) = 0) as InPaymentAmount
						 
						
				FROM OT2001
				INNER JOIN OT2002 On OT2001.DivisionID = OT2002.DivisionID And OT2001.SOrderID = OT2002.SOrderID
				LEFT JOIN AT1202 On OT2001.DivisionID = AT1202.DivisionID And OT2001.ObjectID = AT1202.ObjectID
				'
	
	IF @ContractAnaTypeID = 'A01'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 On OT2002.DivisionID = AT1020.DivisionID And OT2002.Ana01ID = AT1020.ContractNo'
	IF @ContractAnaTypeID = 'A02'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 On OT2002.DivisionID = AT1020.DivisionID And OT2002.Ana02ID = AT1020.ContractNo'
	IF @ContractAnaTypeID = 'A03'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 On OT2002.DivisionID = AT1020.DivisionID And OT2002.Ana03ID = AT1020.ContractNo'
	IF @ContractAnaTypeID = 'A04'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 On OT2002.DivisionID = AT1020.DivisionID And OT2002.Ana04ID = AT1020.ContractNo'
	IF @ContractAnaTypeID = 'A05'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 On OT2002.DivisionID = AT1020.DivisionID And OT2002.Ana05ID = AT1020.ContractNo'
			
	Set @sSQL =	@sSQL +	' WHERE OT2001.DivisionID like ''' + @DivisionID + '''
				AND OT2001.ObjectID between N''' + @FromObject + ''' and N''' + @ToObject + ''' and OT2001.OrderType = 0
				AND OT2001.OrderStatus like '  + case when @OrderStatus = - 1 then '''%''' else cast(@OrderStatus as varchar(1)) end + @sPeriod 

	EXEC(@sSQL)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

