IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3009]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3009]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Tiểu Mai on 06/11/2015
---- Purpose: In báo cáo nhập xuất tồn theo kho (tất cả các kho) theo quy cách hàng hóa.


CREATE PROCEDURE AP3009
(
    @DivisionID AS nvarchar(50), 
    @FromMonth AS int, 
    @ToMonth AS int, 
    @FromYear AS int, 
    @ToYear AS int, 
    @FromDate AS datetime, 
    @ToDate AS datetime, 
    @FromInventoryID AS nvarchar(50), 
    @ToInventoryID AS nvarchar(50), 
    @IsDate AS tinyint, 
    @IsGroupID AS tinyint, --- 0 Khong nhom; 1 Nhom 1 cap; 2 Nhom 2 cap
    @GroupID1 AS nvarchar(50), 
    @GroupID2 AS nvarchar(50) --- Note : GroupID nhan cac gia tri S1, S2, S3, CI1, CI2, CI3
)
AS
		DECLARE 
			@sSQL1 AS nvarchar(4000), 
			@sSQL2 AS nvarchar(4000), 
			@sSQL3 AS nvarchar(4000), 
			@sSQL4 AS nvarchar(4000), 
			@GroupField1 AS nvarchar(20), 
			@GroupField2 AS nvarchar(20), 
			@FromMonthYearText NVARCHAR(20), 
			@ToMonthYearText NVARCHAR(20), 
			@FromDateText NVARCHAR(20), 
			@ToDateText NVARCHAR(20),
			@3MonthPrevious INT,
			@YearPrevious INT
			

		    
		SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
		SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
		SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
		SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

		--- Xóa các bảng tạm nếu đã tồn tại
		IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.##AV7016')) 
			DROP TABLE ##AV7016

		IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.##AV3088')) 
			DROP TABLE ##AV3088

		IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.##AV3098')) 
			DROP TABLE ##AV3098

		IF @IsDate = 0 --theo ky
			BEGIN
				IF @ToMonth > 3	BEGIN SET @3MonthPrevious = @ToMonth - 3 SET @YearPrevious = @ToYear END
				ELSE BEGIN SET @3MonthPrevious = 9 + @ToMonth SET @YearPrevious = @ToYear - 1 END
				SET @sSQL1 = N' 
					SELECT 
					AT2008.InventoryID, 
					AT1302.InventoryName, 
					AT1302.UnitID, 
					AT1302.VATPercent, 
					AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor, AT1309.Operator, 
					AT1302.S1, AT1302.S2, AT1302.S3, AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID, AT1302.InventoryTypeID, AT1302.Specification, 
					AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
					AT1302.Varchar01,AT1302.Varchar02,AT1302.Varchar03,AT1302.Varchar04,AT1302.Varchar05,
					AT1304.UnitName, 
					SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @FromMonthYearText + '
						THEN ISNULL(BeginQuantity, 0) ELSE 0 END) AS BeginQuantity, 
					SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @ToMonthYearText + '
						THEN ISNULL(EndQuantity, 0) ELSE 0 END) AS EndQuantity, 
					SUM(ISNULL(DebitQuantity, 0) - ISNULL(InDebitQuantity, 0)) AS DebitQuantity, 
					SUM(ISNULL(CreditQuantity, 0) - ISNULL(InCreditQuantity, 0)) AS CreditQuantity, 
					SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @FromMonthYearText + '
						THEN ISNULL(BeginAmount, 0) ELSE 0 END) AS BeginAmount, 
					SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @ToMonthYearText + '
						THEN ISNULL(EndAmount, 0) ELSE 0 END) AS EndAmount, 
					SUM(ISNULL(DebitAmount, 0) - ISNULL(InDebitAmount, 0)) AS DebitAmount, 
					SUM(ISNULL(CreditAmount, 0) - ISNULL(InCreditAmount, 0)) AS CreditAmount, 
					SUM(ISNULL(InDebitAmount, 0)) AS InDebitAmount, 
					SUM(ISNULL(InCreditAmount, 0)) AS InCreditAmount, 
					SUM(ISNULL(InDebitQuantity, 0)) AS InDebitQuantity, 
					SUM(ISNULL(InCreditQuantity, 0)) AS InCreditQuantity, 
					AT2008.DivisionID,
					AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
					AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID
					'
				SET @sSQL2 = N' INTO ##AV3098
					FROM AT2008_QC AT2008 
					INNER JOIN AT1302 ON AT1302.InventoryID = AT2008.InventoryID AND AT1302.DivisionID = AT2008.DivisionID
					INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT2008.DivisionID
					INNER JOIN AT1303 ON AT1303.WareHouseID = AT2008.WareHouseID AND AT1303.DivisionID = AT2008.DivisionID 
					LEFT JOIN AT1309 ON AT1309.InventoryID = AT2008.InventoryID AND AT1309.UnitID = AT1302.UnitID AND AT1309.DivisionID = AT2008.DivisionID 

					WHERE AT1303.IsTemp = 0 
					AND AT2008.DivisionID LIKE ''' + @DivisionID + '''
					AND AT2008.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
					AND AT2008.TranMonth + AT2008.TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + '

					GROUP BY AT2008.InventoryID, InventoryName, AT1302.UnitID, AT1304.UnitName, AT1302.VATPercent, 
					AT1309.UnitID, AT1309.ConversionFactor, AT1309.Operator, 
					AT1302.S1, AT1302.S2, AT1302.S3, AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID, 
					AT1302.InventoryTypeID, AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
					AT1302.Varchar01,AT1302.Varchar02,AT1302.Varchar03,AT1302.Varchar04,AT1302.Varchar05, 
					AT2008.DivisionID,
					AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
					AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID		
					'
			END
		ELSE -- theo ngay
			BEGIN
				IF Month(@ToDate) > 3 BEGIN SET @3MonthPrevious = Month(@ToDate) - 3  SET @YearPrevious = YEAR(@ToDate) END
				ELSE BEGIN SET @3MonthPrevious = 9 + Month(@ToDate) SET @YearPrevious = Month(@ToDate) - 1 END
				SET @sSQL1 = N'
					SELECT 
					InventoryID, InventoryName, UnitID, 
					S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
					UnitName, VATPercent, InventoryTypeID, Specification, 
					V7.Notes01, V7.Notes02, V7.Notes03, 
					V7.Varchar01,V7.Varchar02,V7.Varchar03,V7.Varchar04,V7.Varchar05,
					SUM(SignQuantity) AS BeginQuantity, 
					SUM(SignAmount) AS BeginAmount, 
					DivisionID,
					V7.S01ID, V7.S02ID, V7.S03ID, V7.S04ID, V7.S05ID, V7.S06ID, V7.S07ID, V7.S08ID, V7.S09ID, V7.S10ID,
					V7.S11ID, V7.S12ID, V7.S13ID, V7.S14ID, V7.S15ID, V7.S16ID, V7.S17ID, V7.S18ID, V7.S19ID, V7.S20ID
					'
				SET @sSQL2 = ' INTO ##AV7016
					FROM AV7002 V7		
					WHERE DivisionID LIKE ''' + @DivisionID + '''
					AND (VoucherDate < ''' + @FromDateText + ''' OR D_C = ''BD'')
					AND InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''

					GROUP BY InventoryID, InventoryName, UnitID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
					UnitName, VATPercent, InventoryTypeID, Specification, 
					V7.Notes01, V7.Notes02, V7.Notes03, 
					V7.Varchar01,V7.Varchar02,V7.Varchar03,V7.Varchar04,V7.Varchar05,
					V7.DivisionID,
					V7.S01ID, V7.S02ID, V7.S03ID, V7.S04ID, V7.S05ID, V7.S06ID, V7.S07ID, V7.S08ID, V7.S09ID, V7.S10ID,
					V7.S11ID, V7.S12ID, V7.S13ID, V7.S14ID, V7.S15ID, V7.S16ID, V7.S17ID, V7.S18ID, V7.S19ID, V7.S20ID
					'
		
		EXEC(@sSQL1 + @sSQL2)
		
				SET @sSQL1 = N'
		SELECT InventoryID, InventoryName, UnitID, 
		S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, VATPercent, InventoryTypeID, Specification, 
		Notes01, Notes02, Notes03, 
		Varchar01,Varchar02,Varchar03,Varchar04,Varchar05,
		UnitName, 
		BeginQuantity, 
		BeginAmount, 
		0 AS DebitQuantity, 
		0 AS CreditQuantity, 
		0 AS DebitAmount, 
		0 AS CreditAmount, 
		0 AS EndQuantity, 
		0 AS EndAmount, AV7016.DivisionID,
		AV7016.S01ID, AV7016.S02ID, AV7016.S03ID, AV7016.S04ID, AV7016.S05ID, AV7016.S06ID, AV7016.S07ID, AV7016.S08ID, AV7016.S09ID, AV7016.S10ID,
		AV7016.S11ID, AV7016.S12ID, AV7016.S13ID, AV7016.S14ID, AV7016.S15ID, AV7016.S16ID, AV7016.S17ID, AV7016.S18ID, AV7016.S19ID, AV7016.S20ID
		'
				SET @sSQL2 = N' INTO ##AV3088
		FROM ##AV7016 AV7016
		--WHERE AV7016.InventoryID NOT IN 
		--(
		--SELECT InventoryID 
		--FROM AV7001 AV7000 
		--WHERE AV7000.DivisionID LIKE ''' + @DivisionID + ''' 
		--AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
		--AND AV7000.D_C IN (''D'', ''C'') 
		--AND AV7000.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''')
		--AND AV7016.DivisionID LIKE ''' + @DivisionID + ''' 
		'
				SET @sSQL3 = N'
		UNION ALL

		SELECT 
		AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID, 
		AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
		AV7000.VATPercent, AV7000.InventoryTypeID, AV7000.Specification, 
		AV7000.Notes01, AV7000.Notes02, AV7000.Notes03,
		AV7000.Varchar01,AV7000.Varchar02,AV7000.Varchar03,AV7000.Varchar04,AV7000.Varchar05, 
		AV7000.UnitName, 
		0 AS BeginQuantity, 
		0 AS BeginAmount, 
		SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS DebitQuantity, 
		SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS CreditQuantity, 
		SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ConvertedAmount, 0) ELSE 0 END) AS DebitAmount, 
		SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ConvertedAmount, 0) ELSE 0 END) AS CreditAmount, 
		0 AS EndQuantity, 
		0 AS EndAmount, AV7000.DivisionID,
		AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
		AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID
		'
				SET @sSQL4 =N'
		FROM AV7003 AV7000 
		--LEFT JOIN AV7016 ON AV7000.InventoryID = AV7016.InventoryID AND AV7000.UnitID = AV7016.UnitID AND AV7016.DivisionID = AV7000.DivisionID

		WHERE AV7000.IsTemp = 0 	
		AND AV7000.D_C IN (''D'', ''C'') 
		AND AV7000.DivisionID LIKE ''' + @DivisionID + ''' 
		AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
		AND AV7000.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''

		GROUP BY AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID, AV7000.UnitName, ---AV7016.BeginQuantity, AV7016.BeginAmount, 
		AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
		AV7000.VATPercent, AV7000.InventoryTypeID, AV7000.Specification, 
		AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 
		AV7000.Varchar01,AV7000.Varchar02,AV7000.Varchar03,AV7000.Varchar04,AV7000.Varchar05, 
		AV7000.DivisionID,
		AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
		AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID 
		'
		EXEC(@sSQL1 + @sSQL2 + @sSQL3 + @sSQL4)
		
				SET @sSQL1 = N'
		SELECT AV3088.InventoryID, 
		InventoryName, 
		AV3088.UnitID, 
		UnitName, AV3088.VATPercent, AV3088.InventoryTypeID, Specification, 
		AV3088.Notes01, AV3088.Notes02, AV3088.Notes03, 
		AV3088.Varchar01,AV3088.Varchar02,AV3088.Varchar03,AV3088.Varchar04,AV3088.Varchar05, 
		AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor, AT1309.Operator, 
		S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
		SUM(BeginQuantity) AS BeginQuantity, 
		SUM(BeginAmount) AS BeginAmount, 
		DebitQuantity, 
		CreditQuantity, 
		DebitAmount, 
		CreditAmount, 
		0 AS InDebitAmount, 0 AS InCreditAmount, 0 AS InDebitQuantity, 
		0 AS InCreditQuantity, 
		SUM(BeginQuantity) + DebitQuantity - CreditQuantity AS EndQuantity, 
		SUM(BeginAmount) + DebitAmount - CreditAmount AS EndAmount, AV3088.DivisionID,
		AV3088.S01ID, AV3088.S02ID, AV3088.S03ID, AV3088.S04ID, AV3088.S05ID, AV3088.S06ID, AV3088.S07ID, AV3088.S08ID, AV3088.S09ID, AV3088.S10ID,
		AV3088.S11ID, AV3088.S12ID, AV3088.S13ID, AV3088.S14ID, AV3088.S15ID, AV3088.S16ID, AV3088.S17ID, AV3088.S18ID, AV3088.S19ID, AV3088.S20ID 
		'
				SET @sSQL2 = N'INTO ##AV3098
		FROM ##AV3088 AV3088 
		LEFT JOIN AT1309 ON AT1309.InventoryID = AV3088.InventoryID AND AT1309.UnitID = AV3088.UnitID AND AT1309.DivisionID = AV3088.DivisionID

		GROUP BY S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
		AV3088.InventoryID, InventoryName, AV3088.UnitID, UnitName, 
		AT1309.UnitID, AT1309.ConversionFactor, AT1309.Operator, 
		DebitQuantity, DebitAmount, CreditQuantity, CreditAmount, 
		AV3088.VATPercent, AV3088.InventoryTypeID, Specification, 
		AV3088.Notes01, AV3088.Notes02, AV3088.Notes03, 
		AV3088.Varchar01,AV3088.Varchar02,AV3088.Varchar03,AV3088.Varchar04,AV3088.Varchar05, 
		AV3088.DivisionID,
		AV3088.S01ID, AV3088.S02ID, AV3088.S03ID, AV3088.S04ID, AV3088.S05ID, AV3088.S06ID, AV3088.S07ID, AV3088.S08ID, AV3088.S09ID, AV3088.S10ID,
		AV3088.S11ID, AV3088.S12ID, AV3088.S13ID, AV3088.S14ID, AV3088.S15ID, AV3088.S16ID, AV3088.S17ID, AV3088.S18ID, AV3088.S19ID, AV3088.S20ID 
		'
			END --- theo ngay -------------------------------------------------------
	EXEC(@sSQL1 + @sSQL2)
	    
		SET @GroupField1 = 
		(
			SELECT CASE @GroupID1
				WHEN 'CI1' THEN 'S1'
				WHEN 'CI2' THEN 'S2'
				WHEN 'CI3' THEN 'S3'
				WHEN 'I01' THEN 'I01ID'
				WHEN 'I02' THEN 'I02ID'
				WHEN 'I03' THEN 'I03ID'
				WHEN 'I04' THEN 'I04ID'
				WHEN 'I05' THEN 'I05ID' 
			END
		)
		SET @GroupField2 = @GroupField1

		SET @GroupField2 = 
		(
			SELECT CASE @GroupID2
				WHEN 'CI1' THEN 'S1'
				WHEN 'CI2' THEN 'S2'
				WHEN 'CI3' THEN 'S3'
				WHEN 'I01' THEN 'I01ID'
				WHEN 'I02' THEN 'I02ID'
				WHEN 'I03' THEN 'I03ID'
				WHEN 'I04' THEN 'I04ID'
				WHEN 'I05' THEN 'I05ID' 
			END
		)

		SET @GroupField1 = ISNULL(@GroupField1, '')
		SET @GroupField2 = ISNULL(@GroupField2, '')
		        
		IF ((@IsGroupID >= 2) AND (@GroupField1 <> '') AND (@GroupField2 <> ''))
			BEGIN
				SET @sSQL1 = N'
					SELECT 
					V1.ID AS GroupID1, V2.ID AS GroupID2, 
					V1.SName AS GroupName1, V2.SName AS GroupName2, 
					AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
					AV3098.InventoryName, AV3098.UnitID, AV3098.UnitName, VATPercent, AV3098.InventoryTypeID, AV3098.Specification, 
					AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, 
					AV3098.Varchar01,AV3098.Varchar02,AV3098.Varchar03,AV3098.Varchar04,AV3098.Varchar05, 
					AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator, 
					SUM(AV3098.BeginQuantity) AS BeginQuantity, SUM(AV3098.EndQuantity) AS EndQuantity, 
					CASE WHEN AV3098.ConversionFactor = NULL OR AV3098.ConversionFactor = 0 THEN NULL
					ELSE ISNULL(SUM(AV3098.EndQuantity), 0) / AV3098.ConversionFactor END AS ConversionQuantity, 
					SUM(AV3098.DebitQuantity) as DebitQuantity, SUM(AV3098.CreditQuantity) as CreditQuantity, SUM(AV3098.BeginAmount) as BeginAmount, SUM(AV3098.EndAmount) as EndAmount, 
					SUM(AV3098.DebitAmount) as DebitAmount, SUM(AV3098.CreditAmount) as CreditAmount, 
					SUM(AV3098.InDebitAmount) as InDebitAmount, SUM(AV3098.InCreditAmount) as InCreditAmount, SUM(AV3098.InDebitQuantity) as InDebitQuantity, 
					SUM(AV3098.InCreditQuantity) as InCreditQuantity, AV3098.DivisionID,
					AT1314.MinQuantity, AT1314.MaxQuantity,		
					CASE WHEN (	SELECT SUM(ActualQuantity) FROM AT2007
								Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID 
								WHERE InventoryID = AV3098.InventoryID
								AND KindVoucherID IN (2,4,6)
								AND AT2007.TranMonth + AT2007.TranYear * 100 > '+STR(@3MonthPrevious + @YearPrevious * 100)+'
								AND AT2007.TranMonth + AT2007.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+') = 0 THEN 0
					ELSE SUM(AV3098.EndQuantity)/
								((SELECT SUM(ActualQuantity) FROM AT2007
								Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID 
								WHERE InventoryID = AV3098.InventoryID
								AND KindVoucherID IN (2,4,6)
								AND AT2007.TranMonth + AT2007.TranYear * 100 > '+STR(@3MonthPrevious + @YearPrevious * 100)+'
								AND AT2007.TranMonth + AT2007.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+')/3)
					END TimeOfUse,
					AV3098.S01ID, AV3098.S02ID, AV3098.S03ID, AV3098.S04ID, AV3098.S05ID, AV3098.S06ID, AV3098.S07ID, AV3098.S08ID, AV3098.S09ID, AV3098.S10ID,
					AV3098.S11ID, AV3098.S12ID, AV3098.S13ID, AV3098.S14ID, AV3098.S15ID, AV3098.S16ID, AV3098.S17ID, AV3098.S18ID, AV3098.S19ID, AV3098.S20ID'

				SET @sSQL2 = N'
					FROM ##AV3098 AV3098
					LEFT JOIN AV1310 V1 ON V1.ID = AV3098.' + @GroupField1 + ' AND V1.TypeID =''' + @GroupID1 + ''' AND V1.DivisionID = AV3098.DivisionID
					LEFT JOIN AV1310 V2 ON V2.ID = AV3098.' + @GroupField2 + ' AND V2.TypeID =''' + @GroupID2 + ''' AND V2.DivisionID = AV3098.DivisionID
					LEFT JOIN (	SELECT A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, DivisionID
								FROM AT1314 A GROUP BY InventoryID, DivisionID ) AT1314
						ON		AT1314.DivisionID = AV3098.DivisionID AND AT1314.InventoryID = AV3098.InventoryID
					WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 OR DebitQuantity <> 0 OR DebitAmount <> 0 OR
					CreditQuantity <> 0 OR CreditAmount <> 0 OR EndQuantity <> 0 OR EndAmount <>0 )
					AND AV3098.DivisionID = ''' + @DivisionID + '''
					GROUP BY V1.ID, V2.ID, 
					V1.SName, V2.SName, 
					AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
					AV3098.InventoryName, AV3098.UnitID, AV3098.UnitName, VATPercent, AV3098.InventoryTypeID, AV3098.Specification, 
					AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, 
					AV3098.Varchar01,AV3098.Varchar02,AV3098.Varchar03,AV3098.Varchar04,AV3098.Varchar05, 
					AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator, 
					AV3098.DivisionID,  AT1314.MinQuantity, AT1314.MaxQuantity,
					AV3098.S01ID, AV3098.S02ID, AV3098.S03ID, AV3098.S04ID, AV3098.S05ID, AV3098.S06ID, AV3098.S07ID, AV3098.S08ID, AV3098.S09ID, AV3098.S10ID,
					AV3098.S11ID, AV3098.S12ID, AV3098.S13ID, AV3098.S14ID, AV3098.S15ID, AV3098.S16ID, AV3098.S17ID, AV3098.S18ID, AV3098.S19ID, AV3098.S20ID
					'
			END 
		ELSE IF ((@IsGroupID >= 1) AND ((@GroupField1 <> '') OR (@GroupField2 <> '')))
			BEGIN        
				IF(@GroupField1 = '') SET @GroupField1 = @GroupField2
				SET @sSQL1 = N'
					SELECT 
					V1.ID AS GroupID1, '''' AS GroupID2, 
					V1.SName AS GroupName1, '''' AS GroupName2, 
					AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
					AV3098.InventoryName, AV3098.UnitID, AV3098.UnitName, AV3098.VATPercent, AV3098.InventoryTypeID, AV3098.Specification, 
					AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, 
					AV3098.Varchar01,AV3098.Varchar02,AV3098.Varchar03,AV3098.Varchar04,AV3098.Varchar05, 
					AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator, 
					AV3098.BeginQuantity, AV3098.EndQuantity, 
					CASE WHEN AV3098.ConversionFactor = NULL OR AV3098.ConversionFactor = 0 THEN NULL
					ELSE ISNULL(AV3098.EndQuantity, 0) / AV3098.ConversionFactor END AS ConversionQuantity, 
					AV3098.DebitQuantity, AV3098.CreditQuantity, AV3098.BeginAmount, AV3098.EndAmount, 
					AV3098.DebitAmount, AV3098.CreditAmount, 
					AV3098.InDebitAmount, AV3098.InCreditAmount, AV3098.InDebitQuantity, 
					AV3098.InCreditQuantity, AV3098.DivisionID,
					AT1314.MinQuantity, AT1314.MaxQuantity,
					CASE WHEN (	SELECT SUM(ActualQuantity) FROM AT2007
								Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID 
								WHERE InventoryID = AV3098.InventoryID
								AND KindVoucherID IN (2,4,6)
								AND AT2007.TranMonth + AT2007.TranYear * 100 > '+STR(@3MonthPrevious + @YearPrevious * 100)+'
								AND AT2007.TranMonth + AT2007.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+') = 0 THEN 0
					ELSE AV3098.EndQuantity/
								((SELECT SUM(ActualQuantity) FROM AT2007
								Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID
								WHERE InventoryID = AV3098.InventoryID
								AND KindVoucherID IN (2,4,6)
								AND AT2007.TranMonth + AT2007.TranYear * 100 > '+STR(@3MonthPrevious + @YearPrevious * 100)+'
								AND AT2007.TranMonth + AT2007.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+')/3)
					END TimeOfUse,
					AV3098.S01ID, AV3098.S02ID, AV3098.S03ID, AV3098.S04ID, AV3098.S05ID, AV3098.S06ID, AV3098.S07ID, AV3098.S08ID, AV3098.S09ID, AV3098.S10ID,
					AV3098.S11ID, AV3098.S12ID, AV3098.S13ID, AV3098.S14ID, AV3098.S15ID, AV3098.S16ID, AV3098.S17ID, AV3098.S18ID, AV3098.S19ID, AV3098.S20ID,
					A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
					A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
					A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
					A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
					'
		
				SET @sSQL2 = N'
					FROM ##AV3098 AV3098 
					LEFT JOIN AV1310 V1 ON V1.ID = AV3098.' + @GroupField1 + ' AND V1.TypeID =''' + @GroupID1 + ''' AND V1.DivisionID = AV3098.DivisionID
					LEFT JOIN (	SELECT A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, DivisionID
								FROM AT1314 A GROUP BY InventoryID, DivisionID ) AT1314
						ON		AT1314.DivisionID = AV3098.DivisionID AND AT1314.InventoryID = AV3098.InventoryID
					LEFT JOIN AT0128 A10 ON A10.DivisionID = AV3098.DivisionID AND A10.StandardID = AV3098.S01ID AND A10.StandardTypeID = ''S01''
					LEFT JOIN AT0128 A11 ON A11.DivisionID = AV3098.DivisionID AND A11.StandardID = AV3098.S02ID AND A11.StandardTypeID = ''S02''
					LEFT JOIN AT0128 A12 ON A12.DivisionID = AV3098.DivisionID AND A12.StandardID = AV3098.S03ID AND A12.StandardTypeID = ''S03''
					LEFT JOIN AT0128 A13 ON A13.DivisionID = AV3098.DivisionID AND A13.StandardID = AV3098.S04ID AND A13.StandardTypeID = ''S04''
					LEFT JOIN AT0128 A14 ON A14.DivisionID = AV3098.DivisionID AND A14.StandardID = AV3098.S05ID AND A14.StandardTypeID = ''S05''
					LEFT JOIN AT0128 A15 ON A15.DivisionID = AV3098.DivisionID AND A15.StandardID = AV3098.S06ID AND A15.StandardTypeID = ''S06''
					LEFT JOIN AT0128 A16 ON A16.DivisionID = AV3098.DivisionID AND A16.StandardID = AV3098.S07ID AND A16.StandardTypeID = ''S07''
					LEFT JOIN AT0128 A17 ON A17.DivisionID = AV3098.DivisionID AND A17.StandardID = AV3098.S08ID AND A17.StandardTypeID = ''S08''
					LEFT JOIN AT0128 A18 ON A18.DivisionID = AV3098.DivisionID AND A18.StandardID = AV3098.S09ID AND A18.StandardTypeID = ''S09''
					LEFT JOIN AT0128 A19 ON A19.DivisionID = AV3098.DivisionID AND A19.StandardID = AV3098.S10ID AND A19.StandardTypeID = ''S10''
					LEFT JOIN AT0128 A20 ON A20.DivisionID = AV3098.DivisionID AND A20.StandardID = AV3098.S11ID AND A20.StandardTypeID = ''S11''
					LEFT JOIN AT0128 A21 ON A21.DivisionID = AV3098.DivisionID AND A21.StandardID = AV3098.S12ID AND A21.StandardTypeID = ''S12''
					LEFT JOIN AT0128 A22 ON A22.DivisionID = AV3098.DivisionID AND A22.StandardID = AV3098.S13ID AND A22.StandardTypeID = ''S13''
					LEFT JOIN AT0128 A23 ON A23.DivisionID = AV3098.DivisionID AND A23.StandardID = AV3098.S14ID AND A23.StandardTypeID = ''S14''
					LEFT JOIN AT0128 A24 ON A24.DivisionID = AV3098.DivisionID AND A24.StandardID = AV3098.S15ID AND A24.StandardTypeID = ''S15''
					LEFT JOIN AT0128 A25 ON A25.DivisionID = AV3098.DivisionID AND A25.StandardID = AV3098.S16ID AND A25.StandardTypeID = ''S16''
					LEFT JOIN AT0128 A26 ON A26.DivisionID = AV3098.DivisionID AND A26.StandardID = AV3098.S17ID AND A26.StandardTypeID = ''S17''
					LEFT JOIN AT0128 A27 ON A27.DivisionID = AV3098.DivisionID AND A27.StandardID = AV3098.S18ID AND A27.StandardTypeID = ''S18''
					LEFT JOIN AT0128 A28 ON A28.DivisionID = AV3098.DivisionID AND A28.StandardID = AV3098.S19ID AND A28.StandardTypeID = ''S19''
					LEFT JOIN AT0128 A29 ON A29.DivisionID = AV3098.DivisionID AND A29.StandardID = AV3098.S20ID AND A29.StandardTypeID = ''S20''	
					WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 OR DebitQuantity <> 0 OR DebitAmount <> 0 OR
					CreditQuantity <> 0 OR CreditAmount <> 0 OR EndQuantity <> 0 OR EndAmount <>0 )
					AND AV3098.DivisionID = ''' + @DivisionID + '''
					'
			END     
		ELSE
			BEGIN
				SET @sSQL1 = N'
					SELECT '''' AS GroupID1, '''' AS GroupID2, '''' AS GroupName1, '''' AS GroupName2, 
					AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, 
					AV3098.InventoryName, AV3098.UnitID, AV3098.UnitName, AV3098.VATPercent, AV3098.InventoryTypeID, Specification, 
					AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, 
					AV3098.Varchar01,AV3098.Varchar02,AV3098.Varchar03,AV3098.Varchar04,AV3098.Varchar05, 
					AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator, 
					AV3098.BeginQuantity, AV3098.EndQuantity, 
					CASE WHEN AV3098.ConversionFactor = NULL OR AV3098.ConversionFactor = 0 THEN NULL
					ELSE ISNULL(AV3098.EndQuantity, 0) / AV3098.ConversionFactor END AS ConversionQuantity, 
					AV3098.DebitQuantity, AV3098.CreditQuantity, AV3098.BeginAmount, AV3098.EndAmount, 
					AV3098.DebitAmount, AV3098.CreditAmount, 
					AV3098.InDebitAmount, AV3098.InCreditAmount, AV3098.InDebitQuantity, 
					AV3098.InCreditQuantity, AV3098.DivisionID ,
					AT1314.MinQuantity, AT1314.MaxQuantity, 
					CASE WHEN (	SELECT SUM(ActualQuantity) FROM AT2007
								Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID
								WHERE InventoryID = AV3098.InventoryID
								AND KindVoucherID IN (2,4,6)
								AND AT2007.TranMonth + AT2007.TranYear * 100 > '+STR(@3MonthPrevious + @YearPrevious * 100)+'
								AND AT2007.TranMonth + AT2007.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+') = 0 THEN 0
					ELSE AV3098.EndQuantity/
								((SELECT SUM(ActualQuantity) FROM AT2007
								Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2007.VoucherID = AT2006.VoucherID
								WHERE InventoryID = AV3098.InventoryID
								AND KindVoucherID IN (2,4,6)
								AND AT2007.TranMonth + AT2007.TranYear * 100 > '+STR(@3MonthPrevious + @YearPrevious * 100)+'
								AND AT2007.TranMonth + AT2007.TranYear * 100 <= '+STR(@ToMonth + @ToYear * 100)+')/3)
					END TimeOfUse,
					AV3098.S01ID, AV3098.S02ID, AV3098.S03ID, AV3098.S04ID, AV3098.S05ID, AV3098.S06ID, AV3098.S07ID, AV3098.S08ID, AV3098.S09ID, AV3098.S10ID,
					AV3098.S11ID, AV3098.S12ID, AV3098.S13ID, AV3098.S14ID, AV3098.S15ID, AV3098.S16ID, AV3098.S17ID, AV3098.S18ID, AV3098.S19ID, AV3098.S20ID,
					A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
					A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
					A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
					A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
					'
							SET @sSQL2 = N'
					FROM ##AV3098 AV3098 
					LEFT JOIN (	SELECT A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, DivisionID
								FROM AT1314 A GROUP BY InventoryID, DivisionID  ) AT1314
						ON		AT1314.DivisionID = AV3098.DivisionID AND AT1314.InventoryID = AV3098.InventoryID
					LEFT JOIN AT0128 A10 ON A10.DivisionID = AV3098.DivisionID AND A10.StandardID = AV3098.S01ID AND A10.StandardTypeID = ''S01''
					LEFT JOIN AT0128 A11 ON A11.DivisionID = AV3098.DivisionID AND A11.StandardID = AV3098.S02ID AND A11.StandardTypeID = ''S02''
					LEFT JOIN AT0128 A12 ON A12.DivisionID = AV3098.DivisionID AND A12.StandardID = AV3098.S03ID AND A12.StandardTypeID = ''S03''
					LEFT JOIN AT0128 A13 ON A13.DivisionID = AV3098.DivisionID AND A13.StandardID = AV3098.S04ID AND A13.StandardTypeID = ''S04''
					LEFT JOIN AT0128 A14 ON A14.DivisionID = AV3098.DivisionID AND A14.StandardID = AV3098.S05ID AND A14.StandardTypeID = ''S05''
					LEFT JOIN AT0128 A15 ON A15.DivisionID = AV3098.DivisionID AND A15.StandardID = AV3098.S06ID AND A15.StandardTypeID = ''S06''
					LEFT JOIN AT0128 A16 ON A16.DivisionID = AV3098.DivisionID AND A16.StandardID = AV3098.S07ID AND A16.StandardTypeID = ''S07''
					LEFT JOIN AT0128 A17 ON A17.DivisionID = AV3098.DivisionID AND A17.StandardID = AV3098.S08ID AND A17.StandardTypeID = ''S08''
					LEFT JOIN AT0128 A18 ON A18.DivisionID = AV3098.DivisionID AND A18.StandardID = AV3098.S09ID AND A18.StandardTypeID = ''S09''
					LEFT JOIN AT0128 A19 ON A19.DivisionID = AV3098.DivisionID AND A19.StandardID = AV3098.S10ID AND A19.StandardTypeID = ''S10''
					LEFT JOIN AT0128 A20 ON A20.DivisionID = AV3098.DivisionID AND A20.StandardID = AV3098.S11ID AND A20.StandardTypeID = ''S11''
					LEFT JOIN AT0128 A21 ON A21.DivisionID = AV3098.DivisionID AND A21.StandardID = AV3098.S12ID AND A21.StandardTypeID = ''S12''
					LEFT JOIN AT0128 A22 ON A22.DivisionID = AV3098.DivisionID AND A22.StandardID = AV3098.S13ID AND A22.StandardTypeID = ''S13''
					LEFT JOIN AT0128 A23 ON A23.DivisionID = AV3098.DivisionID AND A23.StandardID = AV3098.S14ID AND A23.StandardTypeID = ''S14''
					LEFT JOIN AT0128 A24 ON A24.DivisionID = AV3098.DivisionID AND A24.StandardID = AV3098.S15ID AND A24.StandardTypeID = ''S15''
					LEFT JOIN AT0128 A25 ON A25.DivisionID = AV3098.DivisionID AND A25.StandardID = AV3098.S16ID AND A25.StandardTypeID = ''S16''
					LEFT JOIN AT0128 A26 ON A26.DivisionID = AV3098.DivisionID AND A26.StandardID = AV3098.S17ID AND A26.StandardTypeID = ''S17''
					LEFT JOIN AT0128 A27 ON A27.DivisionID = AV3098.DivisionID AND A27.StandardID = AV3098.S18ID AND A27.StandardTypeID = ''S18''
					LEFT JOIN AT0128 A28 ON A28.DivisionID = AV3098.DivisionID AND A28.StandardID = AV3098.S19ID AND A28.StandardTypeID = ''S19''
					LEFT JOIN AT0128 A29 ON A29.DivisionID = AV3098.DivisionID AND A29.StandardID = AV3098.S20ID AND A29.StandardTypeID = ''S20''	
					WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 OR DebitQuantity <> 0 OR DebitAmount <> 0 OR
					CreditQuantity <> 0 OR CreditAmount <> 0 OR EndQuantity <> 0 OR EndAmount <>0 )
					AND AV3098.DivisionID = ''' + @DivisionID + '''
					'
			END
		 
		EXEC(@sSQL1 + @sSQL2)
		--PRINT (@sSQL1 + @sSQL2)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON