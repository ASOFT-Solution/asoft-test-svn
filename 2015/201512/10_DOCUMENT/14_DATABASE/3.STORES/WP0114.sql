/****** Object:  StoredProcedure [dbo].[WP0114]    Script Date: 08/03/2010 15:02:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 -- Create by : Dang Le Bao Quynh; Date 08/01/2009
 -- Purpose: Tra ra view
--- Edited by Bao Anh	Date: 25/11/2012 
--- Bổ sung tham so, DVT quy doi
--- Edited by Bao Anh	Date: 11/12/2012 
--- Sua loi khong len phieu so du (do khong join voi AT2017)
--- Modify on 26/03/2013 by Bao Anh: Bo sung 15 tham so (2T)
--- Modify on 30/05/2013 by Bao Anh: Bo sung Ana02ID
--- Modify on 30/06/2014 by Quốc Tuấn: Bo sung thêm 9 mã phân tích Ana01ID->Ana10ID
/********************************************
'* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/
ALTER PROCEDURE [dbo].[WP0114]
    @DivisionID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @InventoryID NVARCHAR(50), 
    @ReVoucherDate DATETIME, 
    @ConnID NVARCHAR(100) = ''
AS

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE id = Object_ID('WV0114' + @ConnID) AND xType = 'V')
    EXEC('DROP VIEW WV0114' + @ConnID)
    
EXEC('-- Create by WP0114
    CREATE VIEW WV0114' + @ConnID + ' AS 
        SELECT AT0114.*,
			Isnull(AT2007.ConvertedUnitID,AT2017.ConvertedUnitID) as ConvertedUnitID,
			Isnull(AT2007.Parameter01,AT2017.Parameter01) as Parameter01,
			Isnull(AT2007.Parameter02,AT2017.Parameter02) as Parameter02,
			Isnull(AT2007.Parameter03,AT2017.Parameter03) as Parameter03,
			Isnull(AT2007.Parameter04,AT2017.Parameter04) as Parameter04,
			Isnull(AT2007.Parameter05,AT2017.Parameter05) as Parameter05,
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
			ISNULL(AT2007.Ana10ID, AT2017.Ana10ID) AS Ana10ID
        FROM AT0114
        Left join AT2007 on AT0114.ReVoucherID = AT2007.VoucherID And AT0114.ReTransactionID = AT2007.TransactionID
							And AT0114.DivisionID = AT2007.DivisionID
		Left join AT2017 on AT0114.ReVoucherID = AT2017.VoucherID And AT0114.ReTransactionID = AT2017.TransactionID
							And AT0114.DivisionID = AT2017.DivisionID
        WHERE AT0114.DivisionID = ''' + @DivisionID + ''' 
            AND AT0114.WareHouseID = ''' + @WareHouseID + ''' 
            AND AT0114.InventoryID = ''' + @InventoryID + ''' 
            AND AT0114.ReVoucherDate <= CAST(''' + @ReVoucherDate + ''' AS DATETIME)')