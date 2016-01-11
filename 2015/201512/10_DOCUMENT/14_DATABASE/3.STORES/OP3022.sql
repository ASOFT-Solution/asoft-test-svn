IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3022]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP3022]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In chi tiet don hang ban
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 30/12/2004 by Vo Thanh Huong
---- 
----Thuy Tuyen  5/12/2006 sua goi store AP47000 , AV6666 sang OP4700, OV6666
---Last Edit ThuyTuyen 16/04/2008 ,27/05/2009,21/09/2009.
--ThuyTuyen, lay cac thong tin theo DVT qui doi 
---- Modified on 23/09/2011 by Le Thi Thu Hien : Customize cho khach hang Quang Huy ( Tach 50% doanh thu cho nhan vien kinh doanh)
---- Modified on 11/11/2011 by Le Thi Thu Hien : Bo sung so luong xuat kho ActualQuantity va so luong con lai QuantityEnd
---- Modified on 31/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 31/01/2012 by Le Thi Thu Hien : Sua dieu kien AND ISNULL (@Condition, '')  <> ''
---- Modified on 02/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 02/10/2014 by Thanh Sơn: Bổ sung 10 mã phân tích nghiệp vụ (Name & ID)
---- Modified on 25/05/2015 by Lê Thị Hạnh: Bổ sung ETaxConvertedUnit (Customize Index: 36 - SGPT)
---- Modified on 10/12/2015 by Kim Vũ: Bổ sung nvarchar01 - nvarchar20 (ABA)
-- <Example>
---- 


CREATE PROCEDURE [dbo].[OP3022] 
			@DivisionID AS nvarchar(50),
			@FromMonth AS int,
			@ToMonth AS int,
			@FromYear AS int,
			@ToYear AS int,
			@FromDate AS datetime,
			@ToDate AS datetime,
			@FromObjectID AS nvarchar(50),
			@ToObjectID AS nvarchar(50),				
			@IsDate AS tinyint,
			@IsGroup AS tinyint,
			@GroupID nvarchar(50), -- GroupID: OB, CI1, CI2, CI3, I01, I02, I03, I04, I05		
			@CurrencyID AS nvarchar(50),
			@UserID As nvarchar(50),
			@UserGroupID As nvarchar(50)
 AS
DECLARE 	@sSQL nvarchar(4000),
			@sSQL1 nvarchar(4000),
			@sSQL2 nvarchar(4000),
			@GroupField nvarchar(20),
			@sFROM nvarchar(500),
			@sSELECT nvarchar(500), 
			@FromMonthYearText NVARCHAR(20), 
			@ToMonthYearText NVARCHAR(20), 
			@FromDateText NVARCHAR(20), 
			@ToDateText NVARCHAR(20),
			@Condition NVARCHAR(4000),
			@CustomerName INT,
			@sSQL3 NVARCHAR(200) = '',
			@sSQL4 NVARCHAR(100) = ''
			
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
IF @CustomerName = 20 --- Customize Sinolife
BEGIN
	SET @sSQL3 = 'LEFT JOIN AT1202 AT1202_1 ON AT1202_1.DivisionID = O1.DivisionID AND AT1202_1.ObjectID = O1.SalesManID'
	SET @sSQL4 = 'AT1202_1.ObjectName SalesManName'
END
ELSE 
BEGIN
	SET @sSQL3 = 'LEFT JOIN AT1103 AT1103_2 ON AT1103_2.DivisionID = O1.DivisionID AND AT1103_2.EmployeeID = O1.SalesManID'
	SET @sSQL4 = 'SalesManName'
END	
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM OT0001 WHERE DivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = OV2300.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = OV2300.CreateUserID '
		SET @sWHEREPer = ' AND (OV2300.CreateUserID = AT0010.UserID
								OR  OV2300.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	
If @UserID<>''
EXEC AP1409 @DivisionID,'ASOFTOP','VT','VT',@UserID,@UserGroupID,0,@Condition OUTPUT     

SELECT @sFROM = '',  @sSELECT = ''
IF @IsGroup  = 1 
	BEGIN
	EXEC OP4700  	@GroupID,	@GroupField OUTPUT
	SELECT @sFROM = @sFROM + ' 
		LEFT JOIN	OV6666 V1 
			ON		V1.SelectionType = ''' + @GroupID + ''' 
					AND V1.SelectionID = Convert(nvarchar(50),OV2300.' + @GroupField + ') 
					AND OV2300.DivisionID = V1.DivisionID' ,
		@sSELECT = @sSELECT + ', 
		V1.SelectionID AS GroupID, V1.SelectionName AS GroupName'
				
	END
ELSE
	SET @sSELECT = @sSELECT +  ', 
		'''' AS GroupID, '''' AS GroupName'	

Set @sSQL =  '
SELECT  
		OV2300.DivisionID,
		OV2300.OrderID AS SOrderID,  
		VoucherNo,           
		VoucherDate AS OrderDate,
		ObjectID,
		ObjectName,
		CurrencyID,
		Orders,
		OrderStatus,
		StatusName,
		InventoryID, 
		InventoryName, 
		SName1,
		SName2,
		InNotes01,
		InNotes02,
		Specification,
		UnitName,
		OV2300.OrderQuantity, -- So luong don hang
		OV2300.ActualQuantity, -- So luong xuat kho
		(OV2300.OrderQuantity - OV2300.ActualQuantity) AS QuantityEnd, --So luong con lai
		ConversionUnitID, 
		ConversionUnitName,
		isnull(ConvertedQuantity,0)  AS ConvertedQuantity ,
		VATPercent,		
		DiscountPercent,
		CommissionPercent,
		SalePrice,
		isnull(SalePrice, 0) * isnull(ExchangeRate, 0) AS ConvertedPrice,	
		OV2300.OriginalAmount,
		OV2300.ConvertedAmount,
		OV2300.VATOriginalAmount,
		OV2300.VATConvertedAmount,
		isnull (OV2300.OriginalAmount ,0) + isnull(OV2300.VATOriginalAmount,0) AS SumOriginalAmount,
		isnull (OV2300.ConvertedAmount ,0) + isnull(OV2300.VATConvertedAmount,0) AS SumConvertedAmount,	
		OV2300.DiscountOriginalAmount,
		OV2300.DiscountConvertedAmount,
		OV2300.CommissionOAmount, 
		OV2300.CommissionCAmount,
		OV2300.QuotationID,
		OV2300.Shipdate , OV2300.Description, OV2300.RefInfor,  OV2300.Notes, OV2300.Notes01, OV2300.Notes02,
		OV2300.SaleOffPercent01,
		OV2300.SaleOffAmount01,
		OV2300.SaleOffPercent02,
		OV2300.SaleOffAmount02,
		OV2300.SaleOffPercent03,
		OV2300.SaleOffAmount03,
		OV2300.SaleOffPercent04,
		OV2300.SaleOffAmount04,
		OV2300.SaleOffPercent05,
		OV2300.SaleOffAmount05,
		OV2300.SalesManID, OV2300.SalesManName,
		OV2300.SalesMan2ID, OV2300.SalesMan2Name, OV2300.WareHouseID, OV2300.WareHouseName,
		OV2300.Ana01ID, OV2300.Ana02ID, OV2300.Ana03ID, OV2300.Ana04ID, OV2300.Ana05ID, 
		OV2300.Ana06ID, OV2300.Ana07ID, OV2300.Ana08ID, OV2300.Ana09ID, OV2300.Ana10ID,
		OV2300.AnaName01, OV2300.AnaName02, OV2300.AnaName03, OV2300.AnaName04, OV2300.AnaName05, 
		OV2300.AnaName06, OV2300.AnaName07, OV2300.AnaName08, OV2300.AnaName09, OV2300.AnaName10, 		
		OV2300.TDescription,OV2300.DeliveryAddress, OV2300.Contact,OV2300.Transport,
		ISNULL(OV2300.ETaxConvertedUnit,0) AS ETaxConvertedUnit,
		TotalOriginalAmount AS TOriginalAmount,
		TotalConvertedAmount AS TConvertedAmount ,
		OV2300.nvarchar01, OV2300.nvarchar02, OV2300.nvarchar03, OV2300.nvarchar04, OV2300.nvarchar05,
		OV2300.nvarchar06, OV2300.nvarchar07, OV2300.nvarchar08, OV2300.nvarchar09, OV2300.nvarchar10, 
		OV2300.nvarchar11, OV2300.nvarchar12, OV2300.nvarchar13, OV2300.nvarchar14, OV2300.nvarchar15, 
		OV2300.nvarchar16, OV2300.nvarchar17, OV2300.nvarchar18, OV2300.nvarchar19, OV2300.nvarchar20 ' + 
		IsNull(@sSELECT,'')  + '
		
FROM	OV2300 ' + IsNull(@sFROM,'') + '
'+@sSQLPer+'
WHERE	OV2300.OrderType = 0 
		'+@sWHEREPer+'
		AND OV2300.DivisionID = ''' + @DivisionID + ''' 
		AND	ObjectID between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''' 
		AND ' + CASE WHEN @IsDate = 1 THEN ' CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101)  BETWEEN ''' + @FromDateText + ''' AND ''' +  @ToDateText  + ''''
				ELSE 	' TranMonth + TranYear*100 between ' +  @FromMonthYearText +  ' AND ' + @ToMonthYearText  end  + ' 
		AND OV2300.CurrencyID like ''' + @CurrencyID + '''' + Case When @UserID<>'' AND ISNULL (@Condition, '')  <> ''Then ' AND isnull(OV2300.VoucherTypeID,''#'') In ' + @Condition Else '' End


IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV3022A')
	DROP VIEW OV3022A
EXEC('CREATE VIEW OV3022A AS ' + @sSQL)    --tao boi OP3022
	

Set @sSQL1 =  '
SELECT		
			O1.DivisionID,
			SOrderID,
			VoucherNo,
			OrderDate,
			O1.ObjectID,
			O1.ObjectName,
			O1.CurrencyID,
			Orders,
			OrderStatus,
			StatusName,
			InventoryID,
			InventoryName,
			SName1,
			SName2,
			InNotes01,
			InNotes02,
			Specification,
			UnitName,
			OrderQuantity,
			ActualQuantity,
			QuantityEnd,
			ConversionUnitID,
			ConversionUnitName,
			ConvertedQuantity,
			VATPercent,
			DiscountPercent,
			CommissionPercent,
			SalePrice,
			ConvertedPrice,
			OriginalAmount,
			ConvertedAmount,
			VATOriginalAmount,
			VATConvertedAmount,
			SumOriginalAmount,
			SumConvertedAmount,
			DiscountOriginalAmount,
			DiscountConvertedAmount,
			CommissionOAmount,
			CommissionCAmount,
			QuotationID,
			Shipdate,
			Description,
			RefInfor,
			Notes,
			Notes01,
			Notes02,
			SaleOffPercent01,
			SaleOffAmount01,
			SaleOffPercent02,
			SaleOffAmount02,
			SaleOffPercent03,
			SaleOffAmount03,
			SaleOffPercent04,
			SaleOffAmount04,
			SaleOffPercent05,
			SaleOffAmount05,
			SalesManID,
			'+@sSQL4+',
			SalesMan2ID,
			SalesMan2Name,
			TDescription,
			DeliveryAddress,
			Contact,
			Transport,
			TOriginalAmount,
			TConvertedAmount,
			GroupID,
			GroupName,
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
			AnaName01, AnaName02, AnaName03, AnaName04, AnaName05, 
			AnaName06, AnaName07, AnaName08, AnaName09, AnaName10, WareHouseID, WareHouseName,
			ISNULL(O1.ETaxConvertedUnit,0) AS ETaxConvertedUnit,
			nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05,
			nvarchar06, nvarchar07, nvarchar08, nvarchar09, nvarchar10, 
			nvarchar11, nvarchar12, nvarchar13, nvarchar14, nvarchar15, 
			nvarchar16, nvarchar17, nvarchar18, nvarchar19, nvarchar20
FROM		OV3022A O1
'+@sSQL3+'
WHERE 		ISNULL(O1.SalesMan2ID, '''') = ''''
'

Set @sSQL2 =  '
UNION ALL
SELECT		
			O1.DivisionID,
			SOrderID,
			VoucherNo,
			OrderDate,
			O1.ObjectID,
			O1.ObjectName,
			O1.CurrencyID,
			Orders,
			OrderStatus,
			StatusName,
			InventoryID,
			InventoryName,
			SName1,
			SName2,
			InNotes01,
			InNotes02,
			Specification,
			UnitName,
			OrderQuantity/2,
			ActualQuantity/2,
			QuantityEnd/2,
			ConversionUnitID,
			ConversionUnitName,
			ConvertedQuantity,
			VATPercent,
			DiscountPercent,
			CommissionPercent,
			SalePrice,
			ConvertedPrice,
			OriginalAmount/2,
			ConvertedAmount/2,
			VATOriginalAmount/2,
			VATConvertedAmount/2,
			SumOriginalAmount/2,
			SumConvertedAmount/2,
			DiscountOriginalAmount/2,
			DiscountConvertedAmount/2,
			CommissionOAmount/2,
			CommissionCAmount/2,
			QuotationID,
			Shipdate,
			Description,
			RefInfor,
			Notes,
			Notes01,
			Notes02,
			SaleOffPercent01,
			SaleOffAmount01,
			SaleOffPercent02,
			SaleOffAmount02,
			SaleOffPercent03,
			SaleOffAmount03,
			SaleOffPercent04,
			SaleOffAmount04,
			SaleOffPercent05,
			SaleOffAmount05,
			SalesManID,
			'+@sSQL4+',
			SalesMan2ID,
			SalesMan2Name,
			TDescription,
			DeliveryAddress,
			Contact,
			Transport,
			TOriginalAmount/2,
			TConvertedAmount/2,
			GroupID,
			GroupName,
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
			AnaName01, AnaName02, AnaName03, AnaName04, AnaName05, 
			AnaName06, AnaName07, AnaName08, AnaName09, AnaName10, WareHouseID, WareHouseName,
			ISNULL(O1.ETaxConvertedUnit,0) AS ETaxConvertedUnit,
			nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05,
			nvarchar06, nvarchar07, nvarchar08, nvarchar09, nvarchar10, 
			nvarchar11, nvarchar12, nvarchar13, nvarchar14, nvarchar15, 
			nvarchar16, nvarchar17, nvarchar18, nvarchar19, nvarchar20
FROM		OV3022A O1
'+@sSQL3+'
WHERE 		ISNULL(O1.SalesMan2ID, '''') <> ''''
'
IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV3022')
	DROP VIEW OV3022
EXEC('CREATE VIEW OV3022 AS ' + @sSQL1 + @sSQL2)-- + @sSQL2)    --tao boi OP3022
--EXEC (@sSQL1 + @sSQL2 + @sSQL2)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
