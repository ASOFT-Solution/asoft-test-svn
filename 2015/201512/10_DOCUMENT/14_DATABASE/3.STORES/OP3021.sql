IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3021]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3021]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- in bao cao chi tiet don hang mua
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 30/12/2004 by Vo Thanh Huong
---- Modified on 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 07/09/2015 by Tiểu Mai: Bổ sung mã và tên 10 mã phân tích, 10 tham số.
---- Modified on 30/12/2015 by Quốc Tuấn: Bổ sung thêm Note03-Note09
-- <Example>
---- 


CREATE PROCEDURE [dbo].[OP3021] 
				@DivisionID as nvarchar(50),
				@FromMonth as int,
				@ToMonth as int,
				@FromYear as int,
				@ToYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),				
				@IsDate as tinyint,
				@IsGroup as tinyint,
				@GroupID nvarchar(50), -- GroupID: OB, CI1, CI2, CI3, I01, I02, I03, I04, I05		
				@CurrencyID as nvarchar(50)
 AS
DECLARE 	@sSQL nvarchar(4000),
			@GroupField nvarchar(20),
			@sFROM nvarchar(500),
			@sSELECT nvarchar(500), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'


Select @sFROM = '',  @sSELECT = ''
IF @IsGroup  = 1 
	BEGIN
	Exec AP4700  	@GroupID,	@GroupField OUTPUT
	Select @sFROM = @sFROM + ' left join AV6666 V1 on V1.SelectionType = ''' + @GroupID + ''' and V1.DivisionID = OV2400.DivisionID and V1.SelectionID = OV2400.' + @GroupField,
		@sSELECT = @sSELECT + ', 
		V1.SelectionID as GroupID, V1.SelectionName as GroupName'
				
	END
ELSE
	Set @sSELECT = @sSELECT +  ', 
		'''' as GroupID, '''' as GroupName'	

Set @sSQL =  '
Select  OV2400.DivisionID,
		OV2400.OrderID as POrderID,  
		VoucherNo,           
		VoucherDate as OrderDate,
		CurrencyID,
		ObjectID,
		ObjectName,
		Orders,
		OrderStatus,
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
		Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
		AnaName01,AnaName02,AnaName03,AnaName04,AnaName05,
		AnaName06,AnaName07,AnaName08,AnaName09,AnaName10,
		Parameter01,Parameter02,Parameter03,Parameter04,Parameter05,
		Parameter06,Parameter07,Parameter08,Parameter09,Parameter10, Notes, Notes01, Notes02,Notes03,
		Notes04, Notes05, Notes06,Notes07, Notes08,	Notes09,
		InventoryID, 
		InventoryName, 
		UnitName,
		Specification,
		InventoryTypeID,
		OrderQuantity,
		PurchasePrice,
		VATPercent,
		VATConvertedAmount,
		DiscountPercent,
		isnull(PurchasePrice, 0)* isnull(ExchangeRate, 0) as ConvertedPrice,	
		TotalOriginalAmount as TOriginalAmount,
		TotalConvertedAmount as TConvertedAmount ' + 
		@sSELECT  + '
From OV2400 ' + @sFROM + '
Where OV2400.DivisionID = ''' + @DivisionID + ''' and
		ObjectID between N''' + @FromObjectID + ''' and N''' + @ToObjectID + ''' and ' + 
		 case when @IsDate = 1 then ' CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) between ''' + 
		 + @FromDateText + ''' and ''' +  @ToDateText  + ''''
		else 	' TranMonth + TranYear*100 between ' +  @FromMonthYearText +  ' and ' +  @ToMonthYearText  end  + '  AND
		OV2400.CurrencyID like ''' + @CurrencyID + ''''
	

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3021')
	Drop view OV3021
EXEC('Create view OV3021---tao boi OP3021
		as ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

