IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0114_2T]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0114_2T]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
--- Created on 19/06/2013 by Bảo Anh  
--- Purpose: Hiển thị danh sách chứng từ nhập có thêm cột số lượng tồn cuối theo quy đổi (2T)  
--- EXEC WP0114_2T 'DT','KVX','FD','05/25/2013',1,0,1,'@SL*(3.14*(@T04/2)*(@T04/2)*(@T03/1000)*7.85)/1000'  
  
CREATE PROCEDURE [dbo].[WP0114_2T]  
    @DivisionID NVARCHAR(50),   
    @WareHouseID NVARCHAR(50),   
    @InventoryID NVARCHAR(50),   
    @ReVoucherDate DATETIME,  
    @DataType tinyint,  
    @Operator tinyint = 0,  
    @ConversionFactor decimal(28,8),  
    @FormulaDes NVARCHAR(100)  
AS  
  
--Declare @AT0114 table  
--(  
-- ReVoucherID nvarchar(50),  
-- ReTransactionID nvarchar(50),  
-- Par01 decimal(28,8),  
-- Par02 decimal(28,8),  
-- Par03 decimal(28,8),  
-- Par04 decimal(28,8),  
-- Par05 decimal(28,8),  
-- EndQuantity decimal(28,8),  
-- EndConvertedQuantity decimal(28,8)  
--)  
  
--Declare @AT0114Cur as Cursor,  
--  @ReTransactionID nvarchar(50),  
--  @ReVoucherID nvarchar(50),  
--  @Par01 decimal(28,8),  
--  @Par02 decimal(28,8),  
--  @Par03 decimal(28,8),  
--  @Par04 decimal(28,8),  
--  @Par05 decimal(28,8),  
--  @EndQuantity decimal(28,8),  
--  @EndConvertedQuantity decimal(28,8)  
    
  
----- Tạo bảng các chứng từ nhập giống AT0114  
--INSERT INTO @AT0114 (ReVoucherID, ReTransactionID, Par01, Par02, Par03, Par04, Par05, EndQuantity)  
--SELECT AT0114.ReVoucherID, AT0114.ReTransactionID, ISNULL(AT2007.Parameter01, AT2017.Parameter01) AS Parameter01,  
--      ISNULL(AT2007.Parameter02, AT2017.Parameter02) AS Parameter02, ISNULL(AT2007.Parameter03, AT2017.Parameter03) AS Parameter03,  
--      ISNULL(AT2007.Parameter04, AT2017.Parameter04) AS Parameter04, ISNULL(AT2007.Parameter05, AT2017.Parameter05) AS Parameter05,  
--      AT0114.EndQuantity  
--FROM AT0114  
--LEFT JOIN AT2007 ON AT0114.DivisionID = AT2007.DivisionID AND AT0114.ReVoucherID = AT2007.VoucherID AND AT0114.ReTransactionID = AT2007.TransactionID  
--LEFT JOIN AT2017 ON AT0114.DivisionID = AT2017.DivisionID AND AT0114.ReVoucherID = AT2017.VoucherID AND AT0114.ReTransactionID = AT2017.TransactionID  
--WHERE AT0114.DivisionID = @DivisionID AND AT0114.WareHouseID = @WareHouseID   
--      AND AT0114.InventoryID = @InventoryID AND AT0114.ReVoucherDate <= CAST(@ReVoucherDate AS DATETIME)  
--      AND AT0114.Status = 0 AND AT0114.IsLocked = 0 AND AT0114.EndQuantity >0  
     
 --Declare @ConvertedQuantity as decimal(28,8),
	--	@EndQuantity as decimal(28,8) 
 --IF Isnull(@DataType,0) = 0 --- toan tu  
 -- BEGIN  
 --  IF Isnull(@Operator,0) = 0 
 --  SET @ConvertedQuantity = @EndQuantity/(case when Isnull(@ConversionFactor,0) = 0 then 1 else @ConversionFactor end)  
 --  IF Isnull(@Operator,0) = 1 SET @ConvertedQuantity = @EndQuantity*@ConversionFactor  

 -- END  
 --ELSE --- cong thuc  
 -- BEGIN  
 --  EXEC AP1329 @Par01, @Par02, @Par03, @Par04, @Par05, 1, @FormulaDes, @ConvertedQuantity  
 --  SELECT @ConvertedQuantity = ResultOutput from AV1329  
 --  UPDATE @AT0114 SET EndConvertedQuantity = (case when @ConvertedQuantity = 0 then 0 else @EndQuantity/@ConvertedQuantity end)  
 --  WHERE ReVoucherID = @ReVoucherID AND ReTransactionID = @ReTransactionID     
 -- END  
  
  
  
--- Trả ra các chứng từ nhập có thêm cột số lượng tồn cuối quy đổi  
 SELECT AT0114.*,
		ISNULL(AT2007.ConvertedUnitID, AT2017.ConvertedUnitID) AS ConvertedUnitID,
		ISNULL(AT2007.Parameter01, AT2017.Parameter01) AS Parameter01,
		ISNULL(AT2007.Parameter02, AT2017.Parameter02) AS Parameter02,
		ISNULL(AT2007.Parameter03, AT2017.Parameter03) AS Parameter03,
		ISNULL(AT2007.Parameter04, AT2017.Parameter04) AS Parameter04,
		ISNULL(AT2007.Parameter05, AT2017.Parameter05) AS Parameter05,
		Isnull(AT2007.Notes01,AT2017.Notes01) as Notes01,  
		Isnull(AT2007.Notes02,AT2017.Notes02) as Notes02,  
		Isnull(AT2007.Notes03,AT2017.Notes03) as Notes03,  
		Isnull(AT2007.Notes04,AT2017.Notes04) as Notes04,  
		Isnull(AT2007.Notes05,AT2017.Notes05) as Notes05,  
		Isnull(AT2007.Notes06,AT2017.Notes06) as Notes06,  
		Isnull(AT2007.Notes07,AT2017.Notes07) as Notes07,  
		Isnull(AT2007.Notes08,AT2017.Notes08) as Notes08,  
		Isnull(AT2007.Notes09,AT2017.Notes09) as Notes09,  
		Isnull(AT2007.Notes10,AT2017.Notes10) as Notes10,  
		Isnull(AT2007.Notes11,AT2017.Notes11) as Notes11,  
		Isnull(AT2007.Notes12,AT2017.Notes12) as Notes12,  
		Isnull(AT2007.Notes13,AT2017.Notes13) as Notes13,  
		Isnull(AT2007.Notes14,AT2017.Notes14) as Notes14,  
		Isnull(AT2007.Notes15,AT2017.Notes15) as Notes15, 
		ISNULL(AT2007.Ana01ID, AT2017.Ana01ID) AS Ana01ID,
		ISNULL(AT2007.Ana02ID, AT2017.Ana02ID) AS Ana02ID,
		ISNULL(AT2007.Ana03ID, AT2017.Ana03ID) AS Ana03ID,
		ISNULL(AT2007.Ana04ID, AT2017.Ana04ID) AS Ana04ID,
		ISNULL(AT2007.Ana05ID, AT2017.Ana05ID) AS Ana05ID,
		ISNULL(AT2007.Ana06ID, AT2017.Ana06ID) AS Ana06ID,
		ISNULL(AT2007.Ana07ID, AT2017.Ana07ID) AS Ana07ID,
		ISNULL(AT2007.Ana08ID, AT2017.Ana08ID) AS Ana08ID,
		ISNULL(AT2007.Ana09ID, AT2017.Ana09ID) AS Ana09ID,
		ISNULL(AT2007.Ana10ID, AT2017.Ana10ID) AS Ana10ID,
		(Case when Isnull(@DataType,0) = 0 and Isnull(@Operator,0) = 0 and Isnull(@ConversionFactor,0) = 0 then AT0114.EndQuantity
		when Isnull(@DataType,0) = 0 and Isnull(@Operator,0) = 0 and Isnull(@ConversionFactor,0) <> 0 then
	AT0114.EndQuantity/@ConversionFactor
	when Isnull(@DataType,0) = 0 and Isnull(@Operator,0) = 1 then AT0114.EndQuantity*@ConversionFactor
	else AT0114.EndMarkQuantity end) as EndConvertedQuantity
        FROM AT0114  
        Left join AT2007 on AT0114.ReVoucherID = AT2007.VoucherID And AT0114.ReTransactionID = AT2007.TransactionID  
       And AT0114.DivisionID = AT2007.DivisionID  
  Left join AT2017 on AT0114.ReVoucherID = AT2017.VoucherID And AT0114.ReTransactionID = AT2017.TransactionID  
       And AT0114.DivisionID = AT2017.DivisionID  
 
            WHERE AT0114.DivisionID = @DivisionID  
            AND AT0114.WareHouseID = @WareHouseID  
            AND AT0114.InventoryID = @InventoryID  
            AND AT0114.ReVoucherDate <= CAST(@ReVoucherDate AS DATETIME)  
            AND AT0114.Status = 0 AND AT0114.IsLocked = 0   
			AND AT0114.EndQuantity >0  
     
  ORDER BY AT0114.ReVoucherDate  
    
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

