IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3026]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3026]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In bao cao chi tiet chao gia
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 08/07/2005 by Vo Thanh Huong
---- 
---- Modified on 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 29/09/2015 by Tieu Mai: bổ sung 10 tham số, mã và tên 10 MPT
-- <Example>
---- 

CREATE PROCEDURE [dbo].[OP3026] 
				@DivisionID as nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,				
				@ToYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@IsDate as tinyint,
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),				
				@FromInventoryID nvarchar(50),
				@ToInventoryID nvarchar(50),				
				@IsGroup as tinyint,
				@GroupID nvarchar(50) -- GroupID: OB, CI1, CI2, CI3, I01, I02, I03, I04, I05		
 AS
DECLARE 	@sSQL nvarchar(4000),
			@GroupField nvarchar(20),
			@sFROM nvarchar(500),
			@sSELECT nvarchar(500),
    @sPeriod NVARCHAR(4000),
    @FromDateText AS NVARCHAR(20),
    @ToDateText AS NVARCHAR(20),
    @FromMonthYearText AS NVARCHAR(40),
    @ToMonthYearText AS NVARCHAR(40)

SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59'
SET @FromMonthYearText = CAST(@FromMonth + @FromYear * 100 AS NVARCHAR(20))
SET @ToMonthYearText = CAST(@ToMonth + @ToYear * 100 AS NVARCHAR(20))

IF @IsDate = 1
    SET @sPeriod = ' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''' 
ELSE 
    SET @sPeriod = ' AND TranMonth + TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText


Select @sFROM = '',  @sSELECT = ''
IF @IsGroup  = 1 
	BEGIN
	Exec AP4700  	@GroupID,	@GroupField OUTPUT
	Select @sFROM = @sFROM + ' left join AV6666 V1 on V1.DivisionID = OV2200.DivisionID AND V1.SelectionType = ''' + @GroupID + ''' and V1.SelectionID = OV2200.' + @GroupField,
		@sSELECT = @sSELECT + ', 
		V1.SelectionID as GroupID, V1.SelectionName as GroupName'
				
	END
ELSE
	Set @sSELECT = @sSELECT +  ', 
		'''' as GroupID, '''' as GroupName'	

Set @sSQL =  '
Select  OV2200.DivisionID,
		OV2200.OrderID as QuotationID,  
		VoucherNo,           
		VoucherDate as VoucherDate,
		OV2200.SOrderNo,
		OV2200.SOrderDate,
		OV2200.StatusName,
		OV2200.EStatusName,
		OV2200.InNotes01,
		OV2200.InNotes02,
		OV2200.SName1,
		OV2200.SName2,
		OV2200.Specification,
		OV2200.InventoryTypeID,
		ObjectID,
		ObjectName,
		Orders,
		InventoryID, 
		InventoryName, 
		UnitName,
		OrderQuantity,
		VATPercent,
		DiscountPercent,
		UnitPrice,
		isnull(UnitPrice, 0)* isnull(ExchangeRate, 0) as ConvertedPrice,	
		OV2200.OriginalAmount,
		OV2200.ConvertedAmount,
		OV2200. VATOriginalAmount,
		OV2200.VATConvertedAmount,
		OV2200.DiscountOriginalAmount,
		OV2200.DiscountConvertedAmount,
		TotalOriginalAmount as TOriginalAmount,
		TotalConvertedAmount as TConvertedAmount,
		ISNULL(OV2200.Ana01ID, '') AS Ana01ID, 		ISNULL(OV2200.Ana02ID, '') AS Ana02ID, 		
		ISNULL(OV2200.Ana03ID, '') AS Ana03ID, 		ISNULL(OV2200.Ana04ID, '') AS Ana04ID, 		
		ISNULL(OV2200.Ana05ID, '') AS Ana05ID,		ISNULL(OV2200.Ana06ID, '') AS Ana06ID,
		ISNULL(OV2200.Ana07ID, '') AS Ana07ID,		ISNULL(OV2200.Ana08ID, '') AS Ana08ID,
		ISNULL(OV2200.Ana09ID, '') AS Ana09ID,		ISNULL(OV2200.Ana10ID, '') AS Ana10ID,
		OV2200.Ana01Name,					OV2200.Ana02Name,
		OV2200.Ana03Name,					OV2200.Ana04Name,
		OV2200.Ana05Name,					OV2200.Ana06Name,
		OV2200.Ana07Name,					OV2200.Ana08Name,
		OV2200.Ana09Name,					OV2200.Ana10Name,
		OV2200.QD01,OV2200.QD02,OV2200.QD03,OV2200.QD04,OV2200.QD05,OV2200.QD06,OV2200.QD07,OV2200.QD08,OV2200.QD09,OV2200.QD10,
		OV2200.QuoQuantity01 ' + 
		@sSELECT  + '
From OV2200 ' + @sFROM + '
Where OV2200.DivisionID = ''' + @DivisionID + ''' and
		ObjectID between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''' and 
		InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' ' + @sPeriod


If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3026')
	Drop view OV3026
EXEC('Create view OV3026---tao boi OP3026
		as ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

