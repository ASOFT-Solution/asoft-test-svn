IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2009]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2009]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Nguyen Quoc Huy, Date 30/07/2003.
---- Purpose: Bao cao ton kho theo mat hang
---- Edited by Nguyen Quoc Huy, Date 06/11/2006.
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/
---- Modified on 24/09/2012 by Bao Anh : Customize cho 2T (tồn kho theo quy cách), gọi AP2999
---- Modified on 17/04/2014 by Mai Duyen : Sua loi khong len du lieu khi in bao cao theo ngay (KH AN Phuc Thinh)
---- Modified on 27/06/2014 by Mai Duyen : Sua loi sai so lieu so du dau ky khi in bao cao theo ngay (KH KingCOM)
---- Modified on 09/07/2014 by Thanh Sơn: lấy thêm trường TimeOfUse (KH VIENGUT)
---- Modified on 10/07/2014 by Thanh Sơn: lấy dữ liệu trực tiếp từ view, không sinh ra view AV2009

CREATE PROCEDURE [dbo].[AP2009]
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
       @IsDate AS tinyint
AS

DECLARE @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF @CustomerName = 15 --- Customize 2T
	EXEC AP2999 @DivisionID, @FromMonth, @ToMonth, @FromYear, @ToYear, @FromDate, @ToDate, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID, @IsDate
ELSE
	BEGIN
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
			CASE WHEN A.ConvertedQuantity <> 0 THEN Sum(BeginQuantity + DebitQuantity - CreditQuantity) / (A.ConvertedQuantity/3) ELSE 0 END TimeOfUse	'
				 SET @sSQLFrom = '
			From AT2008 
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
			AT1302.Specification,AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, A.ConvertedQuantity '
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
				Sum(SignAmount) as BeginAmount'

				SET @sSQLFrom = ' From AV7000'
				SET @sSQLWhere = ' Where 	( VoucherDate<''' + @FromDateText + '''  or D_C =''BD'') and
				DivisionID like ''' + @DivisionID + ''' and
				(WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''')  And
				(InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') 
				Group by  DivisionID, WareHouseID,InventoryID,InventoryName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03, 
				S1, S2, S3 ,S1Name,  S2Name, S3Name '
		   
			IF NOT EXISTS ( SELECT TOP 1 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV7018' )
			   BEGIN
					 EXEC ( ' Create view AV7018 --AP2009
					 as '+@sSQLSelect+@sSQLFrom+@sSQLWhere )
			   END
			ELSE
			   BEGIN
					 EXEC ( ' Alter view AV7018 as  --AP2009
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
				0 as EndAmount'

			SET @sSQLFrom = ' From AV7018 inner join AT1302 on AT1302.InventoryID =AV7018.InventoryID and AT1302.DivisionID =AV7018.DivisionID
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
					AV7018.BeginQuantity,AV7018.BeginAmount'
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
				0 as EndAmount			From AV7000 left join AV7018 on (AV7000.WareHouseID = AV7018.WareHouseID and AV7000.InventoryID = AV7018.InventoryID and AV7000.DivisionID = AV7018.DivisionID)
					inner join AT1302 on AT1302.InventoryID = AV7000.InventoryID and AT1302.DivisionID = AV7000.DivisionID
					inner join AT1303 on AT1303.WareHouseID = AV7000.WareHouseID and AT1303.DivisionID = AV7000.DivisionID
					
			Where 	AV7000.DivisionID =''' + @DivisionID + ''' and
				(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') and
				(AV7000.WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''') and
				AV7000.D_C in (''D'', ''C'') and
				AV7000.VoucherDate between ''' + @FromDateText + ''' and ''' + @ToDateText + '''
			Group by  AV7000.DivisionID, AV7000.InventoryID, AT1302.InventoryName, AV7000.WareHouseID, AT1303.WareHouseName,AV7000.UnitName,
					AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 	
					AV7000.UnitID, 	AV7018.BeginQuantity,AV7018.BeginAmount  '


			--print @sSQL

		IF NOT EXISTS ( SELECT TOP 1 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2089' )
		   BEGIN
				 EXEC ( ' Create view AV2089 as --AP2009
				 '+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnion )
		   END
		ELSE
		   BEGIN
				 EXEC ( ' Alter view AV2089 as  --AP2009
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
			CASE WHEN A.ConvertedQuantity <> 0 THEN Sum(BeginQuantity + DebitQuantity - CreditQuantity) / (A.ConvertedQuantity/3) ELSE 0 END TimeOfUse	'		

		SET @sSQLFrom= 'FROM AV2089
						LEFT JOIN (SELECT WareHouseID, InventoryID, SUM(ISNULL(ConvertedQuantity,0)) ConvertedQuantity FROM AV7001
									WHERE DivisionID = '''+@DivisionID+'''
									AND TranYear*12 + TranMonth BETWEEN '+STR(@FromYear*12+@FromMonth)+' AND '+STR(@ToYear*12+@ToMonth)+'
									AND D_C = ''C''
									GROUP BY WareHouseID, InventoryID)A
						ON A.WareHouseID = AV2089.WareHouseID AND A.InventoryID = AV2089.InventoryID'
									
									
		set @sSQLWhere= ' Where (BeginQuantity <> 0 or BeginAmount <> 0 or DebitQuantity <> 0 or DebitAmount <> 0 or
			CreditQuantity <> 0 or CreditAmount <> 0 or EndQuantity <> 0 or EndAmount <> 0) and DivisionID = ''' + @DivisionID + '''
		Group by  DivisionID, AV2089.InventoryID, InventoryName, AV2089.WareHouseID, WareHouseName, UnitID, UnitName,
			AV2089.Specification, AV2089.Notes01, AV2089.Notes02, AV2089.Notes03, A.ConvertedQuantity '

		END
		--print @sSQL
		EXEC (@sSQLSelect + @sSQLFrom + @sSQLWhere)
		
		--IF NOT EXISTS ( SELECT
		--					1
		--				FROM
		--					sysObjects
		--				WHERE
		--					Xtype = 'V' AND Name = 'AV2009' )
		--   BEGIN
		--		 EXEC ( ' Create view AV2009 as  --AP2009
		--		 '+@sSQLSelect+@sSQLFrom+@sSQLWhere  )
		--   END
		--ELSE
		--   BEGIN
		--		 EXEC ( ' Alter view AV2009 as  --AP2009
		--		 '+@sSQLSelect+@sSQLFrom+@sSQLWhere  )
		--/*
		--Set @sSQL = 
		--'SELECT AV2099.*,  AT1304.UnitName  F
		--	ROM AV2099  inner join AT1304 on AT1304.UnitID = AV2099.UnitID
		--Where BeginQuantity <> 0 or BeginAmount <> 0 or DebitQuantity <> 0 or DebitAmount <> 0 or
		--	CreditQuantity <> 0 or CreditAmount <> 0 or EndQuantity <> 0 or EndAmount <>0 
		-- '

		--If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV2009')
		--	Exec(' Create view AV2009 as '+@sSQL)
		--Else
		--	Exec(' Alter view AV2009 as '+@sSQL)
		--*/
		--   END
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
