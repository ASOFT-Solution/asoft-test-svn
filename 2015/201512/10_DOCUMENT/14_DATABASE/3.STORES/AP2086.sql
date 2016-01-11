IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2086]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2086]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--- Created by Bao Anh	Date: 09/10/2012
--- Bao cao ton kho theo tai khoan, quy cach cho cac kho (2T)
--- <Example>

CREATE PROCEDURE [dbo].[AP2086]
       @DivisionID AS nvarchar(50) ,
       @FromMonth AS int ,
       @FromYear AS int ,
       @ToMonth AS int ,
       @ToYear AS int ,
       @FromAccountID AS nvarchar(50) ,
       @ToAccountID AS nvarchar(50) ,
       @IsWareHouse AS tinyint   ---co nhom theo tung kho khong?

AS
DECLARE
        @sSQL1 AS nvarchar(4000) ,
        @sSQL2 AS nvarchar(4000) ,
        @sSQL3 AS nvarchar(4000) ,
        @sGroupWareHouse AS nvarchar(250), 
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)

IF @IsWareHouse = 1
   SET @sGroupWareHouse = 'AT2888.WareHouseID, AT1303.WareHouseName, '
ELSE
   SET @sGroupWareHouse = ''	

--B/c cho 1 ky
IF @FromMonth + @FromYear * 100 = @ToMonth + 100 * @ToYear
   BEGIN
	SET @sSQL1 = ' 
		SELECT	AT2888.DivisionID, AT2888.InventoryID, InventoryName,
				AT1302.UnitID, AT1302.InventoryTypeID, AT1302.Specification,
				AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
				AT1304.UnitName, AT2888.InventoryAccountID, AT1005.AccountName,
				AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,'
				
	SET @sSQL2 = @sGroupWareHouse + '
				SUM(ISNULL(BeginQuantity,0)) AS BeginQuantity,
				SUM(ISNULL(EndQuantity,0)) AS EndQuantity,
				SUM(ISNULL(DebitQuantity,0)  ) AS DebitQuantity,
				SUM(ISNULL(CreditQuantity,0)  ) AS CreditQuantity,	
				SUM(ISNULL(BeginAmount,0)) AS BeginAmount,
				SUM(ISNULL(EndAmount,0)) AS EndAmount,
				SUM(ISNULL(DebitAmount,0)  ) AS DebitAmount,
				SUM(ISNULL(CreditAmount,0)  ) AS CreditAmount,
				SUM(ISNULL(InDebitAmount,0)) AS InDebitAmount,
				SUM(ISNULL(InCreditAmount,0)) AS InCreditAmount,
				SUM(ISNULL(InDebitQuantity,0)) AS InDebitQuantity,
				SUM(ISNULL(InCreditQuantity,0)) AS InCreditQuantity,
				AT1302.I01ID,AT1302.I02ID,AT1302.I03ID,AT1302.I04ID,AT1302.I05ID,
				I01.AnaName AS I01Name,I02.AnaName AS I02Name,
				I03.AnaName AS I03Name,I04.AnaName AS I04Name,
				I05.AnaName AS I05Name
			
		FROM	AT2888 	
		INNER JOIN AT1302 ON AT1302.InventoryID = AT2888.InventoryID AND At1302.DivisionID = AT2888.DivisionID
		INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID
		LEFT JOIN AT1005 ON AT1005.AccountID = AT2888.InventoryAccountID AND AT1005.DivisionID = AT2888.DivisionID
		LEFT JOIN AT1303 ON AT2888.WareHouseID = AT1303.WareHouseID AND AT2888.DivisionID = AT1303.DivisionID
		LEFT JOIN AT1015 I01 ON I01.AnaTypeID = ''I01'' AND I01.AnaID = AT1302.I01ID AND I01.DivisionID = AT2888.DivisionID
		LEFT JOIN AT1015 I02 ON I02.AnaTypeID = ''I02'' AND I02.AnaID = AT1302.I02ID AND I02.DivisionID = AT2888.DivisionID
		LEFT JOIN AT1015 I03 ON I03.AnaTypeID = ''I03'' AND I03.AnaID = AT1302.I03ID AND I03.DivisionID = AT2888.DivisionID
		LEFT JOIN AT1015 I04 ON I04.AnaTypeID = ''I04'' AND I04.AnaID = AT1302.I04ID AND I04.DivisionID = AT2888.DivisionID
		LEFT JOIN AT1015 I05 ON I05.AnaTypeID = ''I05'' AND I05.AnaID = AT1302.I05ID AND I05.DivisionID = AT2888.DivisionID
		
		WHERE 	--AT1302.Disabled = 0 AND
				AT2888.DivisionID = ''' + @DivisionID + ''' AND
				(AT2888.InventoryAccountID between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''') AND
				( TranMonth  +100*TranYear  = ' + @FromMonthYearText + ') 
		GROUP BY	AT2888.DivisionID, 
					AT2888.InventoryID,	InventoryName,	
					AT1302.UnitID,	AT1304.UnitName ,'
         
	SET @sSQL3 = @sGroupWareHouse + '	
				AT1302.InventoryTypeID, AT1302.Specification,  
				AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
				AT2888.InventoryAccountID, AT1005.AccountName,
				AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,
				AT1302.I01ID,AT1302.I02ID,AT1302.I03ID,AT1302.I04ID,AT1302.I05ID,
				I01.AnaName,I02.AnaName,I03.AnaName,I04.AnaName,I05.AnaName '

   END
ELSE --B/c cho nhieu ky
   BEGIN

	SET @sSQL1 = '
			SELECT	AT2888.DivisionID, AT2888.InventoryID, AT1302.InventoryName,
					AT1302.UnitID,	AT1304.UnitName,
					AT1302.InventoryTypeID, AT1302.Specification,	
					AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
					AT2888.InventoryAccountID, AT1005.AccountName,
					AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,'
	SET @sSQL2 = @sGroupWareHouse + ' 
		BeginQuantity = isnull((	SELECT	SUM(ISNULL(BeginQuantity,0)) 
									FROM	AT2888 T08 
		                        	WHERE 	T08.InventoryID = AT2888.InventoryID AND
		                        			T08.Parameter01 = AT2888.Parameter01 AND T08.Parameter02 = AT2888.Parameter02 AND
		                        			T08.Parameter03 = AT2888.Parameter03 AND T08.Parameter04 = AT2888.Parameter04 AND T08.Parameter05 = AT2888.Parameter05 AND
		                        			' + CASE  WHEN @IsWareHouse = 1 THEN 'T08.WareHouseID = AT2888.WareHouseID AND '
                                            ELSE ' ' END + '
                                            T08.InventoryAccountID = AT2888.InventoryAccountID AND
											T08.DivisionID = ''' + @DivisionID + ''' AND
											T08.TranMonth + T08.TranYear*100 = ' + @FromMonthYearText + ' ),0) ,
		EndQuantity = isnull((SELECT SUM(ISNULL(EndQuantity,0)) 
		                      FROM	AT2888 T08 
		                      WHERE T08.InventoryID = AT2888.InventoryID AND
									T08.Parameter01 = AT2888.Parameter01 AND T08.Parameter02 = AT2888.Parameter02 AND
		                        	T08.Parameter03 = AT2888.Parameter03 AND T08.Parameter04 = AT2888.Parameter04 AND T08.Parameter05 = AT2888.Parameter05 AND
									' + CASE WHEN @IsWareHouse = 1 THEN 'T08.WareHouseID = AT2888.WareHouseID AND ' 
									ELSE ' ' END + '
									T08.InventoryAccountID = AT2888.InventoryAccountID AND
									T08.DivisionID = ''' + @DivisionID + ''' AND
									T08.TranMonth + T08.TranYear*100 = ' + @ToMonthYearText + ' ),0) ,
		Sum( isnull(DebitQuantity,0)  ) AS DebitQuantity,
		SUM(ISNULL(CreditQuantity,0) ) AS CreditQuantity,	
		BeginAmount = isnull((	SELECT	SUM(ISNULL(BeginAmount,0)) 
		                      	FROM	AT2888 T08 
		                      	WHERE 	T08.InventoryID = AT2888.InventoryID AND
		                      			T08.Parameter01 = AT2888.Parameter01 AND T08.Parameter02 = AT2888.Parameter02 AND
		                        		T08.Parameter03 = AT2888.Parameter03 AND T08.Parameter04 = AT2888.Parameter04 AND T08.Parameter05 = AT2888.Parameter05 AND
		                      	' + CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         WHEN @IsWareHouse = 1 THEN 'T08.WareHouseID = AT2888.WareHouseID AND '
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ELSE ' '
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            END + 'T08.InventoryAccountID = AT2888.InventoryAccountID AND
								T08.DivisionID = ''' + @DivisionID + ''' AND
								T08.TranMonth + T08.TranYear*100 = ' + @FromMonthYearText + ' ),0) ,
		EndAmount = isnull((Select SUM(ISNULL(EndAmount,0)) From AT2888 T08 Where 	
								T08.InventoryID = AT2888.InventoryID AND 
								T08.Parameter01 = AT2888.Parameter01 AND T08.Parameter02 = AT2888.Parameter02 AND
		                        T08.Parameter03 = AT2888.Parameter03 AND T08.Parameter04 = AT2888.Parameter04 AND T08.Parameter05 = AT2888.Parameter05 AND
								' + CASE
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      WHEN @IsWareHouse = 1 THEN 'T08.WareHouseID = AT2888.WareHouseID AND '
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ELSE ' '
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 END + 'T08.InventoryAccountID = AT2888.InventoryAccountID AND
								T08.DivisionID = ''' + @DivisionID + ''' AND
								T08.TranMonth + T08.TranYear*100 = ' + @ToMonthYearText + ' ),0) ,
		SUM(ISNULL(DebitAmount,0)) AS DebitAmount,
		SUM(ISNULL(CreditAmount,0)) AS CreditAmount,
		SUM(ISNULL(InDebitAmount,0)) AS InDebitAmount,
		SUM(ISNULL(InCreditAmount,0)) AS InCreditAmount,
		SUM(ISNULL(InDebitQuantity,0)) AS InDebitQuantity,
		SUM(ISNULL(InCreditQuantity,0)) AS InCreditQuantity,
		AT1302.I01ID,AT1302.I02ID,AT1302.I03ID,AT1302.I04ID,AT1302.I05ID,
		I01.AnaName AS I01Name,I02.AnaName AS I02Name,
		I03.AnaName AS I03Name,I04.AnaName AS I04Name,
		I05.AnaName AS I05Name '
	SET @sSQL3 ='FROM	AT2888 	
	INNER JOIN AT1302 ON AT1302.InventoryID = AT2888.InventoryID AND AT1302.DivisionID = AT2888.DivisionID
	INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1005 ON AT1005.AccountID = AT2888.InventoryAccountID AND AT1005.DivisionID = AT2888.DivisionID
	LEFT JOIN AT1303 ON AT2888.WareHouseID = AT1303.WareHouseID AND AT2888.DivisionID = AT1303.DivisionID
	LEFT JOIN AT1015 I01 ON I01.AnaTypeID = ''I01'' AND I01.AnaID = AT1302.I01ID AND I01.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015 I02 ON I02.AnaTypeID = ''I02'' AND I02.AnaID = AT1302.I02ID AND I02.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015 I03 ON I03.AnaTypeID = ''I03'' AND I03.AnaID = AT1302.I03ID AND I03.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015 I04 ON I04.AnaTypeID = ''I04'' AND I04.AnaID = AT1302.I04ID AND I04.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015 I05 ON I05.AnaTypeID = ''I05'' AND I05.AnaID = AT1302.I05ID AND I05.DivisionID = AT1302.DivisionID
		
	WHERE 	--AT1302.Disabled = 0 AND
			AT2888.DivisionID = ''' + @DivisionID + ''' AND
			(AT2888.InventoryAccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''') AND
			( TranMonth  +100*TranYear  BETWEEN ' + @FromMonthYearText + ' AND ' + str(@ToMonth) + ' +  100*' + str(@ToYear) + ') 
	GROUP BY	AT2888.DivisionID, 
				AT2888.InventoryID,	AT1302.InventoryName,  
				AT1302.UnitID,	AT1304.UnitName, 
				AT2888.InventoryAccountID ,  AT1005.AccountName,
				AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,
				AT1302.I01ID,AT1302.I02ID,AT1302.I03ID,AT1302.I04ID,AT1302.I05ID,
				I01.AnaName,I02.AnaName,I03.AnaName,I04.AnaName,I05.AnaName, '
         
SET @sSQL3 = @sSQL3 + @sGroupWareHouse + ' AT1302.InventoryTypeID, AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03 '

   END

IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2016' )
   EXEC ( ' CREATE VIEW AV2016 AS '+@sSQL1+@sSQL2+@sSQL3 )
ELSE
   EXEC ( ' ALTER VIEW AV2016 AS '+@sSQL1+@sSQL2+@sSQL3 )


SET @sSQL1 = ' 
	SELECT * FROM AV2016		
	WHERE 	(	BeginQuantity<>0 or EndQuantity<>0 or 
				DebitQuantity<>0 or CreditQuantity<>0 or 
				BeginAmount<>0 or EndAmount <>0 or 
				DebitAmount<>0 or CreditAmount<>0) '

IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2007' )
   EXEC ( ' CREATE VIEW AV2007 AS '+@sSQL1 )
ELSE
   EXEC ( ' ALTER VIEW AV2007 AS '+@sSQL1 )

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

