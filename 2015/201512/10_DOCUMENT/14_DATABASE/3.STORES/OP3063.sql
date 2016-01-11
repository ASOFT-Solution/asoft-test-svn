IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3063]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3063]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---Created by: Vo Thanh Huong, date:  15/03/2006
---Purpose: In bao cao Tong hop Don hang mua
----Last Update Nguyen Thi ThuyTuyen: 21/11/2006 (Sua lai tu ky den ky)
---- Modified on 31/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 07/02/2013 by Le Thi Thu Hien : WHERE thêm DivisionID khi lấy SUM tiền
---- Modified on 08/09/2015 by Tiểu Mai: bổ sung lấy tên và mã của 10 MPT <Customize cho An Phú Gia>

CREATE PROCEDURE [dbo].[OP3063] 
				@DivisionID nvarchar(50),
				@IsDate tinyint,
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,	
				@FromDate datetime,
				@ToDate datetime,
				@FromObject nvarchar(20),
				@ToObject nvarchar(20),
				@OrderStatus int				
AS
DECLARE @sSQL nvarchar(4000),
		@sSQL1 NVARCHAR(4000),
		@sPeriod nvarchar(4000), 
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Set @sPeriod = case when @IsDate = 1 then ' and CONVERT(DATETIME,CONVERT(VARCHAR(10),OT3001.OrderDate,101),101) BETWEEN ''' + @FromDateText + '''  and  ''' + 
		@ToDateText + ''''   else 
		' and OT3001.TranMonth + OT3001.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText  end

Set @sSQL = '
Select 	OT3001.DivisionID, 	
		OT3001.POrderID, 
		OT3001.VoucherTypeID, 
		OT3001.VoucherNo, 
		OT3001.ClassifyID, 
		OT3001.InventoryTypeID, 
		OT3001.CurrencyID, 
		AT1004.CurrencyName,
		OT3001.ExchangeRate, 
		OT3001.OrderType, 
		OT3001.ObjectID, 
		case when isnull(OT3001.ObjectName, '''') <> '''' then OT3001.ObjectName else AT1202.ObjectName end as ObjectName,
		case when isnull(OT3001.VatNo, '''') <> '''' then OT3001.VATNo else  AT1202.VATNo end as VATNo,
		case when isnull(OT3001.Address, '''') <> '''' then OT3001.Address else AT1202.Address end as Address,
		OT3001.ReceivedAddress, 
		OT3001.Notes, 
		OT3001.Description, 
		OT3001.Disabled, 
		OT3001.OrderStatus, 
		OV1001.Description as OrderStatusName,
		OV1001.EDescription as EOrderStatusName,		
		OT3002.Ana01ID, 
		OT3002.Ana02ID, 
		OT3002.Ana03ID, 
		OT3002.Ana04ID, 
		OT3002.Ana05ID, 
		OT3002.Ana06ID,
		OT3002.Ana07ID, 
		OT3002.Ana08ID, 
		OT3002.Ana09ID,
		OT3002.Ana10ID,
		A01.AnaName as Ana01Name,
		A02.AnaName as Ana02Name,
		A03.AnaName as Ana03Name,
		A04.AnaName as Ana04Name,
		A05.AnaName as Ana05Name,
		A06.AnaName as Ana06Name,
		A07.AnaName as Ana07Name,
		A08.AnaName as Ana08Name,
		A09.AnaName as Ana09Name,
		A10.AnaName as Ana10Name,
		OT3001.TranMonth, 
		OT3001.TranYear, 		
		OT3001.EmployeeID, 
		AT1103.FullName,
		OT3001.OrderDate, 
		OT3001.Transport, 
		OT3001.PaymentID, 
		OT3001.ShipDate, 
		OT3001.ContractNo, 
		OT3001.ContractDate, 
		OT3001.CreateUserID, 
		OT3001.Createdate, 
		OT3001.LastModifyUserID, 
		OT3001.LastModifyDate, 
		OT3001.DueDate,
		OriginalAmount = (Select sum(isnull(OriginalAmount, 0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = '''+@DivisionID+'''),
		ConvertedAmount = (Select sum(isnull(ConvertedAmount, 0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = '''+@DivisionID+'''),
		VATOriginalAmount = (Select sum(isnull(VATOriginalAmount, 0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = '''+@DivisionID+'''),
		VATConvertedAmount = (Select sum(isnull(VATConvertedAmount, 0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = '''+@DivisionID+'''),
		DiscountOriginalAmount = (Select sum(isnull(DiscountOriginalAmount, 0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = '''+@DivisionID+'''),
		DiscountConvertedAmount = (Select sum(isnull(DiscountConvertedAmount, 0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = '''+@DivisionID+''')'
		
 

SET @sSQL1 = 'FROM OT3001 
LEFT JOIN (select OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID, OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID, OT3002.POrderID, OT3002.DivisionID 
           FROM OT3002 where OT3002.DivisionID = ''' + @DivisionID + ''' and OT3002.Orders = 1 ) OT3002 on OT3002.POrderID = OT3001.POrderID and OT3002.DivisionID = OT3001.DivisionID
left join AT1011 A01 on A01.AnaTypeID = ''A01'' and A01.AnaID = OT3002.Ana01ID  and A01.DivisionID= OT3002.DivisionID
left join AT1011 A02 on A02.AnaTypeID = ''A02'' and A02.AnaID = OT3002.Ana02ID  and A02.DivisionID= OT3002.DivisionID
left join AT1011 A03 on A03.AnaTypeID = ''A03'' and A03.AnaID = OT3002.Ana03ID  and A03.DivisionID= OT3002.DivisionID
left join AT1011 A04 on A04.AnaTypeID = ''A04'' and A04.AnaID = OT3002.Ana04ID  and A04.DivisionID= OT3002.DivisionID
left join AT1011 A05 on A05.AnaTypeID = ''A05'' and A05.AnaID = OT3002.Ana05ID  and A05.DivisionID= OT3002.DivisionID
left join AT1011 A06 on A06.AnaTypeID = ''A06'' and A06.AnaID = OT3002.Ana06ID  and A06.DivisionID= OT3002.DivisionID
left join AT1011 A07 on A07.AnaTypeID = ''A07'' and A07.AnaID = OT3002.Ana07ID  and A07.DivisionID= OT3002.DivisionID
left join AT1011 A08 on A08.AnaTypeID = ''A08'' and A08.AnaID = OT3002.Ana08ID  and A08.DivisionID= OT3002.DivisionID
left join AT1011 A09 on A09.AnaTypeID = ''A09'' and A09.AnaID = OT3002.Ana09ID  and A09.DivisionID= OT3002.DivisionID
left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = OT3002.Ana10ID  and A10.DivisionID= OT3002.DivisionID
LEFT JOIN OV1001            on OV1001.DivisionID    = OT3001.DivisionID and OV1001.OrderStatus = OT3001.OrderStatus and OV1001.TypeID =''PO''
LEFT JOIN AT1202            on AT1202.DivisionID    = OT3001.DivisionID and AT1202.ObjectID = OT3001.ObjectID
LEFT JOIN AT1103            on AT1103.DivisionID    = OT3001.DivisionID and AT1103.FullName = OT3001.EmployeeID 
LEFT JOIN AT1004            on AT1004.DivisionID    = OT3001.DivisionID and AT1004.CurrencyID = OT3001.CurrencyID 
Where	OT3001.DivisionID like ''' + @DivisionID + ''' and 
		OT3001.ObjectID between ''' + @FromObject + ''' and ''' + @ToObject + ''' and 
		OT3001.OrderStatus like ' + case when @OrderStatus = - 1 then '''%''' else cast(@OrderStatus as nvarchar(1))  end + @sPeriod
IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XType = 'V' and Name = 'OV3063')
	DROP VIEW OV3063

EXEC('CREATE VIEW OV3063 --tao boi OP3063
		as ' + @sSQL + @sSQL1)
--PRINT  (@sSQL + @sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

