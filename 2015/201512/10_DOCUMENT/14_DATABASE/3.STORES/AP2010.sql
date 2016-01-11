IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2010]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2010]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Tieu Mai, Date 05/11/2015.
---- Purpose: Bao cao ton kho theo mat hang theo quy cach.


CREATE PROCEDURE [dbo].[AP2010]
       @DivisionID AS nvarchar(50) ,
       @FromMonth AS int ,
       @ToMonth AS int ,
       @FromYear AS int ,
       @ToYear AS int ,
       @FromDate AS datetime ,
       @ToDate AS datetime ,
       @FromWareHouseID AS nvarchar(50) ,
       @ToWareHouseID AS nvarchar(50) ,
       @FromInventoryID AS nvarchar(50) ,
       @ToInventoryID AS nvarchar(50) ,
       @IsDate AS TINYINT
AS

		DECLARE	@sSQLSelect AS nvarchar(4000) ,
				@sSQLFrom AS nvarchar(4000) ,
				@sSQLWhere AS nvarchar(4000) ,
				@sSQLUnion AS nvarchar(4000), 
				@FromMonthYearText NVARCHAR(20), 
				@ToMonthYearText NVARCHAR(20), 
				@FromDateText NVARCHAR(20), 
				@ToDateText NVARCHAR(20)
						    
		SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
		SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
		SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
		SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
		
		IF @IsDate = 0  -- theo kỳ
		   BEGIN
				 SET @sSQLSelect = '
			Select 	AT2008.DivisionID, AT2008.InventoryID, InventoryName,
			AT2008.WareHouseID,	WareHouseName,
			AT1302.UnitID, 	AT1304.UnitName,
			AT1302.Specification,AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
			sum(	Case when TranMonth + TranYear*100 = ' + @FromMonthYearText + '
					then isnull(BeginQuantity, 0) else 0 end) as BeginQuantity,
			sum(	Case when TranMonth + TranYear*100 = ' + @ToMonthYearText + '
					then isnull(EndQuantity, 0) else 0 end) as EndQuantity,
			sum(isnull(DebitQuantity, 0)) as DebitQuantity,
			sum(isnull(CreditQuantity, 0)) as CreditQuantity,
			sum(	Case when TranMonth + TranYear*100 = ' + @FromMonthYearText + '
					then isnull(BeginAmount, 0) else 0 end) as BeginAmount,
			sum(	Case when TranMonth + TranYear*100 = ' + @ToMonthYearText + '
					then isnull(EndAmount, 0) else 0 end) as EndAmount,
			sum(isnull(DebitAmount, 0)) as DebitAmount,
			sum(isnull(CreditAmount, 0)) as CreditAmount,
			sum(isnull(InDebitAmount, 0)) as InDebitAmount,
			sum(isnull(InCreditAmount, 0)) as InCreditAmount,
			sum(isnull(InDebitQuantity, 0)) as InDebitQuantity,
			sum(isnull(InCreditQuantity, 0)) as InCreditQuantity,
			CASE WHEN A.ConvertedQuantity <> 0 THEN Sum(BeginQuantity + DebitQuantity - CreditQuantity) / (A.ConvertedQuantity/3) ELSE 0 END TimeOfUse,
			AT2008.S01ID, AT2008.S02ID,AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
			AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID	'
				 SET @sSQLFrom = '
			From AT2008_QC AT2008 
			LEFT JOIN (SELECT WareHouseID, InventoryID, SUM(ISNULL(ConvertedQuantity,0)) ConvertedQuantity FROM AV7001
									WHERE DivisionID = '''+@DivisionID+'''
									AND TranYear*12 + TranMonth BETWEEN '+STR(@FromYear*12+@FromMonth)+' AND '+STR(@ToYear*12+@ToMonth)+'
									AND D_C = ''C''
									GROUP BY WareHouseID, InventoryID)A
						ON A.WareHouseID = AT2008.WareHouseID AND A.InventoryID = AT2008.InventoryID
			inner 	join AT1303 on AT1303.WareHouseID =AT2008.WareHouseID and  AT1303.DivisionID =AT2008.DivisionID
			inner join AT1302 on AT1302.InventoryID = AT2008.InventoryID and  AT1302.DivisionID =AT2008.DivisionID
			inner join AT1304 on AT1302.UnitID = AT1304.UnitID  and  AT1304.DivisionID =AT2008.DivisionID'

				 SET @sSQLWhere = '
			Where AT2008.DivisionID =''' + @DivisionID + ''' and
			(AT2008.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') and
			(TranMonth + TranYear*100 between ''' + @FromMonthYearText + ''' and ''' + @ToMonthYearText + ''') and
			(AT2008.WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''')
		    Group By AT2008.DivisionID, AT2008.InventoryID, InventoryName, AT2008.WareHouseID, WareHouseName,AT1302.UnitID ,AT1304.UnitName,
			AT1302.Specification,AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, A.ConvertedQuantity,
			AT2008.S01ID, AT2008.S02ID,AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
			AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID '
		   END
		ELSE            -- theo ngày
		   BEGIN
				SET @sSQLSelect = ' Select 	DivisionID, WareHouseID,	InventoryID, InventoryName, UnitID, UnitName,
				Specification, Notes01, Notes02, Notes03, 	
				--InventoryID+WareHouseID as Key1, 
				(ltrim(rtrim(InventoryID)) + ltrim(rtrim(WareHouseID))) as Key1, 
				 S1, S2, S3 ,
				S1Name,  S2Name, S3Name,				
				Sum(SignQuantity) as BeginQuantity,
				Sum(SignAmount) as BeginAmount,
				S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
				S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID,
				A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
				A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
				A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
				A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
				'

				SET @sSQLFrom = ' From AV7002
								LEFT JOIN AT0128 A10 ON A10.DivisionID = AV7002.DivisionID AND A10.StandardID = AV7002.S01ID AND A10.StandardTypeID = ''S01''
								LEFT JOIN AT0128 A11 ON A11.DivisionID = AV7002.DivisionID AND A11.StandardID = AV7002.S02ID AND A11.StandardTypeID = ''S02''
								LEFT JOIN AT0128 A12 ON A12.DivisionID = AV7002.DivisionID AND A12.StandardID = AV7002.S03ID AND A12.StandardTypeID = ''S03''
								LEFT JOIN AT0128 A13 ON A13.DivisionID = AV7002.DivisionID AND A13.StandardID = AV7002.S04ID AND A13.StandardTypeID = ''S04''
								LEFT JOIN AT0128 A14 ON A14.DivisionID = AV7002.DivisionID AND A14.StandardID = AV7002.S05ID AND A14.StandardTypeID = ''S05''
								LEFT JOIN AT0128 A15 ON A15.DivisionID = AV7002.DivisionID AND A15.StandardID = AV7002.S06ID AND A15.StandardTypeID = ''S06''
								LEFT JOIN AT0128 A16 ON A16.DivisionID = AV7002.DivisionID AND A16.StandardID = AV7002.S07ID AND A16.StandardTypeID = ''S07''
								LEFT JOIN AT0128 A17 ON A17.DivisionID = AV7002.DivisionID AND A17.StandardID = AV7002.S08ID AND A17.StandardTypeID = ''S08''
								LEFT JOIN AT0128 A18 ON A18.DivisionID = AV7002.DivisionID AND A18.StandardID = AV7002.S09ID AND A18.StandardTypeID = ''S09''
								LEFT JOIN AT0128 A19 ON A19.DivisionID = AV7002.DivisionID AND A19.StandardID = AV7002.S10ID AND A19.StandardTypeID = ''S10''
								LEFT JOIN AT0128 A20 ON A20.DivisionID = AV7002.DivisionID AND A20.StandardID = AV7002.S11ID AND A20.StandardTypeID = ''S11''
								LEFT JOIN AT0128 A21 ON A21.DivisionID = AV7002.DivisionID AND A21.StandardID = AV7002.S12ID AND A21.StandardTypeID = ''S12''
								LEFT JOIN AT0128 A22 ON A22.DivisionID = AV7002.DivisionID AND A22.StandardID = AV7002.S13ID AND A22.StandardTypeID = ''S13''
								LEFT JOIN AT0128 A23 ON A23.DivisionID = AV7002.DivisionID AND A23.StandardID = AV7002.S14ID AND A23.StandardTypeID = ''S14''
								LEFT JOIN AT0128 A24 ON A24.DivisionID = AV7002.DivisionID AND A24.StandardID = AV7002.S15ID AND A24.StandardTypeID = ''S15''
								LEFT JOIN AT0128 A25 ON A25.DivisionID = AV7002.DivisionID AND A25.StandardID = AV7002.S16ID AND A25.StandardTypeID = ''S16''
								LEFT JOIN AT0128 A26 ON A26.DivisionID = AV7002.DivisionID AND A26.StandardID = AV7002.S17ID AND A26.StandardTypeID = ''S17''
								LEFT JOIN AT0128 A27 ON A27.DivisionID = AV7002.DivisionID AND A27.StandardID = AV7002.S18ID AND A27.StandardTypeID = ''S18''
								LEFT JOIN AT0128 A28 ON A28.DivisionID = AV7002.DivisionID AND A28.StandardID = AV7002.S19ID AND A28.StandardTypeID = ''S19''
								LEFT JOIN AT0128 A29 ON A29.DivisionID = AV7002.DivisionID AND A29.StandardID = AV7002.S20ID AND A29.StandardTypeID = ''S20''
					'
				SET @sSQLWhere = ' Where 	( VoucherDate<''' + @FromDateText + '''  or D_C =''BD'') and
				DivisionID like ''' + @DivisionID + ''' and
				(WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''')  And
				(InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') 
				Group by  DivisionID, WareHouseID,InventoryID,InventoryName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03, 
				S1, S2, S3 ,S1Name,  S2Name, S3Name, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
				S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID,
				A10.StandardName, A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName,
				A15.StandardName, A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName,
				A20.StandardName, A21.StandardName, A22.StandardName, A23.StandardName, A24.StandardName, 
				A25.StandardName, A26.StandardName, A27.StandardName, A28.StandardName, A29.StandardName'
		  
		IF NOT EXISTS ( SELECT TOP 1 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV7018_QC' )
			BEGIN
					EXEC ( ' Create view AV7018_QC --AP2010
					as '+@sSQLSelect+@sSQLFrom+@sSQLWhere )
			END
		ELSE
			BEGIN
					EXEC ( ' Alter view AV7018_QC as  --AP2010
					'+@sSQLSelect+@sSQLFrom+@sSQLWhere )
			END

			SET @sSQLSelect = 'Select 	AV7018.DivisionID, AV7018.InventoryID,
				AT1302.InventoryName,
				AV7018.WareHouseID,
				AT1303.WareHouseName,
				AV7018.UnitID,
				AV7018.UnitName,
				AV7018.Specification, AV7018.Notes01, AV7018.Notes02, AV7018.Notes03, 	
				isnull(AV7018.BeginQuantity,0) as BeginQuantity,
				isnull(AV7018.BeginAmount,0) as BeginAmount,
				0 as DebitQuantity,
				0 as CreditQuantity,
				0 as DebitAmount,
				0 as CreditAmount,
				0 as EndQuantity,
				0 as EndAmount,
				S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
				S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID'

			SET @sSQLFrom = ' From AV7018_QC AV7018 inner join AT1302 on AT1302.InventoryID =AV7018.InventoryID and AT1302.DivisionID =AV7018.DivisionID
					inner join AT1303 on AT1303.WareHouseID = AV7018.WareHouseID  and AT1303.DivisionID =AV7018.DivisionID'

			SET @sSQLWhere = ' where 	(AV7018.WareHouseID between ''' + @FromWareHouseID + ''' and ''' + @ToWareHouseID + ''') and
					AV7018.Key1 not in (Select  (ltrim(rtrim(InventoryID)) + ltrim(rtrim(WareHouseID)))  as Key1 From AV7000 

							Where 	AV7000.DivisionID =''' + @DivisionID + ''' and
							(AV7000.WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''') and
							(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') and
							AV7000.D_C in (''D'', ''C'') and AV7000.VoucherDate between ''' + @FromDateText + ''' and ''' + @ToDateText + ''')
			Group by  AV7018.DivisionID, AV7018.InventoryID, AT1302.InventoryName, AV7018.WareHouseID, AT1303.WareHouseName, 
					AV7018.UnitID, AV7018.UnitName, 
					AV7018.Specification, AV7018.Notes01, AV7018.Notes02, AV7018.Notes03, 	
					AV7018.BeginQuantity,AV7018.BeginAmount,S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
					S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID'
			SET @sSQLUnion = ' Union all
			Select 	AV7000.DivisionID, AV7000.InventoryID,
				AT1302.InventoryName,
				AV7000.WareHouseID,
				AT1303.WareHouseName,
				AV7000.UnitID, 
				AV7000.UnitName,
				AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 	
				isnull(AV7018.BeginQuantity,0) as BeginQuantity,
				isnull(AV7018.BeginAmount,0) as BeginAmount,
				Sum(Case when D_C = ''D'' then isnull(AV7000.ActualQuantity,0) else 0 end) as DebitQuantity,
				Sum(Case when D_C = ''C'' then isnull(AV7000.ActualQuantity,0) else 0 end) as CreditQuantity,
				Sum(Case when D_C = ''D'' then isnull(AV7000.ConvertedAmount,0) else 0 end) as DebitAmount,
				Sum(Case when D_C = ''C'' then isnull(AV7000.ConvertedAmount,0) else 0 end) as CreditAmount,
				0 as EndQuantity,
				0 as EndAmount,
				AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
				AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID
			From AV7002 AV7000 left join AV7018 on (AV7000.WareHouseID = AV7018.WareHouseID and AV7000.InventoryID = AV7018.InventoryID and AV7000.DivisionID = AV7018.DivisionID)
					inner join AT1302 on AT1302.InventoryID = AV7000.InventoryID and AT1302.DivisionID = AV7000.DivisionID
					inner join AT1303 on AT1303.WareHouseID = AV7000.WareHouseID and AT1303.DivisionID = AV7000.DivisionID
					
			Where 	AV7000.DivisionID =''' + @DivisionID + ''' and
				(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') and
				(AV7000.WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''') and
				AV7000.D_C in (''D'', ''C'') and
				AV7000.VoucherDate between ''' + @FromDateText + ''' and ''' + @ToDateText + '''
			Group by  AV7000.DivisionID, AV7000.InventoryID, AT1302.InventoryName, AV7000.WareHouseID, AT1303.WareHouseName,AV7000.UnitName,
					AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 	
					AV7000.UnitID, 	AV7018.BeginQuantity,AV7018.BeginAmount, AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
				AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID  '


			print @sSQLSelect
			print @sSQLFrom
			print @sSQLWhere
			print @sSQLUnion

			IF NOT EXISTS ( SELECT TOP 1 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2089_QC' )
		   BEGIN
				 EXEC ( ' Create view AV2089_QC as --AP2010
				 '+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnion )
		   END
			ELSE
		   BEGIN
				 EXEC ( ' Alter view AV2089_QC as  --AP2010
				 '+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnion )
		   END
		
				SET @sSQLSelect = 'Select 	DivisionID, AV2089.InventoryID, InventoryName,
					AV2089.WareHouseID,	WareHouseName,
					AV2089.UnitID, 
					AV2089.UnitName,
					AV2089.Specification, AV2089.Notes01, AV2089.Notes02, AV2089.Notes03, 	
					Sum(BeginQuantity) as BeginQuantity,
					Sum(BeginAmount) as BeginAmount, 
					Sum(DebitQuantity) as DebitQuantity,
					Sum(CreditQuantity) as CreditQuantity,
					Sum(DebitAmount) as DebitAmount,
					Sum(CreditAmount) as CreditAmount,
					Sum(BeginQuantity + DebitQuantity - CreditQuantity) as EndQuantity,
					Sum(BeginAmount + DebitAmount - CreditAmount) as EndAmount,
					CASE WHEN A.ConvertedQuantity <> 0 THEN Sum(BeginQuantity + DebitQuantity - CreditQuantity) / (A.ConvertedQuantity/3) ELSE 0 END TimeOfUse,
					S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
					S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID,
					A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
					A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
					A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
					A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
				'		

				SET @sSQLFrom= 'FROM AV2089_QC AV2089
				LEFT JOIN (SELECT WareHouseID, InventoryID, SUM(ISNULL(ConvertedQuantity,0)) ConvertedQuantity FROM AV7001
							WHERE DivisionID = '''+@DivisionID+'''
							AND TranYear*12 + TranMonth BETWEEN '+STR(@FromYear*12+@FromMonth)+' AND '+STR(@ToYear*12+@ToMonth)+'
							AND D_C = ''C''
							GROUP BY WareHouseID, InventoryID)A
				ON A.WareHouseID = AV2089.WareHouseID AND A.InventoryID = AV2089.InventoryID
				LEFT JOIN AT0128 A10 ON A10.DivisionID = AV2089.DivisionID AND A10.StandardID = AV2089.S01ID AND A10.StandardTypeID = ''S01''
				LEFT JOIN AT0128 A11 ON A11.DivisionID = AV2089.DivisionID AND A11.StandardID = AV2089.S02ID AND A11.StandardTypeID = ''S02''
				LEFT JOIN AT0128 A12 ON A12.DivisionID = AV2089.DivisionID AND A12.StandardID = AV2089.S03ID AND A12.StandardTypeID = ''S03''
				LEFT JOIN AT0128 A13 ON A13.DivisionID = AV2089.DivisionID AND A13.StandardID = AV2089.S04ID AND A13.StandardTypeID = ''S04''
				LEFT JOIN AT0128 A14 ON A14.DivisionID = AV2089.DivisionID AND A14.StandardID = AV2089.S05ID AND A14.StandardTypeID = ''S05''
				LEFT JOIN AT0128 A15 ON A15.DivisionID = AV2089.DivisionID AND A15.StandardID = AV2089.S06ID AND A15.StandardTypeID = ''S06''
				LEFT JOIN AT0128 A16 ON A16.DivisionID = AV2089.DivisionID AND A16.StandardID = AV2089.S07ID AND A16.StandardTypeID = ''S07''
				LEFT JOIN AT0128 A17 ON A17.DivisionID = AV2089.DivisionID AND A17.StandardID = AV2089.S08ID AND A17.StandardTypeID = ''S08''
				LEFT JOIN AT0128 A18 ON A18.DivisionID = AV2089.DivisionID AND A18.StandardID = AV2089.S09ID AND A18.StandardTypeID = ''S09''
				LEFT JOIN AT0128 A19 ON A19.DivisionID = AV2089.DivisionID AND A19.StandardID = AV2089.S10ID AND A19.StandardTypeID = ''S10''
				LEFT JOIN AT0128 A20 ON A20.DivisionID = AV2089.DivisionID AND A20.StandardID = AV2089.S11ID AND A20.StandardTypeID = ''S11''
				LEFT JOIN AT0128 A21 ON A21.DivisionID = AV2089.DivisionID AND A21.StandardID = AV2089.S12ID AND A21.StandardTypeID = ''S12''
				LEFT JOIN AT0128 A22 ON A22.DivisionID = AV2089.DivisionID AND A22.StandardID = AV2089.S13ID AND A22.StandardTypeID = ''S13''
				LEFT JOIN AT0128 A23 ON A23.DivisionID = AV2089.DivisionID AND A23.StandardID = AV2089.S14ID AND A23.StandardTypeID = ''S14''
				LEFT JOIN AT0128 A24 ON A24.DivisionID = AV2089.DivisionID AND A24.StandardID = AV2089.S15ID AND A24.StandardTypeID = ''S15''
				LEFT JOIN AT0128 A25 ON A25.DivisionID = AV2089.DivisionID AND A25.StandardID = AV2089.S16ID AND A25.StandardTypeID = ''S16''
				LEFT JOIN AT0128 A26 ON A26.DivisionID = AV2089.DivisionID AND A26.StandardID = AV2089.S17ID AND A26.StandardTypeID = ''S17''
				LEFT JOIN AT0128 A27 ON A27.DivisionID = AV2089.DivisionID AND A27.StandardID = AV2089.S18ID AND A27.StandardTypeID = ''S18''
				LEFT JOIN AT0128 A28 ON A28.DivisionID = AV2089.DivisionID AND A28.StandardID = AV2089.S19ID AND A28.StandardTypeID = ''S19''
				LEFT JOIN AT0128 A29 ON A29.DivisionID = AV2089.DivisionID AND A29.StandardID = AV2089.S20ID AND A29.StandardTypeID = ''S20''
				'
									
									
				set @sSQLWhere= ' Where (BeginQuantity <> 0 or BeginAmount <> 0 or DebitQuantity <> 0 or DebitAmount <> 0 or
		CreditQuantity <> 0 or CreditAmount <> 0 or EndQuantity <> 0 or EndAmount <> 0) and DivisionID = ''' + @DivisionID + '''
	Group by  DivisionID, AV2089.InventoryID, InventoryName, AV2089.WareHouseID, WareHouseName, UnitID, UnitName,
		AV2089.Specification, AV2089.Notes01, AV2089.Notes02, AV2089.Notes03, A.ConvertedQuantity, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
		S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID,
		A10.StandardName, A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName,
		A15.StandardName, A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName,
		A20.StandardName, A21.StandardName, A22.StandardName, A23.StandardName, A24.StandardName, 
		A25.StandardName, A26.StandardName, A27.StandardName, A28.StandardName, A29.StandardName '
		END
		EXEC (@sSQLSelect + @sSQLFrom + @sSQLWhere)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
