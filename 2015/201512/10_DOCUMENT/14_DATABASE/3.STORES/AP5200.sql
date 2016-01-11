IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5200]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5200]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-------- 	Created by Nguyen Van Nhan.
------- 	Created Date 06/04/2005.
-------	Purpose: In bao cao  phan tich ban hang
------- Edit by: Dang Le Bao Quynh; Date : 20/02/2008
------- Purpose: Chuyen tu AV6666 - AT6666
---- Modified on 13/03/2012 by Lê Thị Thu Hiền : Bổ sung tính toán cho cột 3 và cột 4
---- Modified on 30/03/2012 by Lê Thị Thu Hiền : Sửa lại IsColumn04
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP5200] 		
					@DivisionID AS nvarchar(50),
					@FromMonth AS int,
					@FromYear AS int,
					@ToMonth AS int,
					@ToYear AS int,
					@ReportCodeID AS nvarchar(50),
					@ColumTypeID	 AS nvarchar(50),
					@Selection01IDFrom AS nvarchar(50),		
					@Selection01IDTo AS nvarchar(50),		
					@Selection02IDFrom AS nvarchar(50),		
					@Selection02IDTo AS nvarchar(50),		
					@Selection03IDFrom AS nvarchar(50),		
					@Selection03IDTo AS nvarchar(50)		

 AS

DECLARE @RowTypeID AS nvarchar(50),
		@RowGroupID AS nvarchar(50),
		@IsColumn01 AS tinyint,
		@IsColumn02 AS tinyint,
		@IsColumn03 AS tinyint,
		@IsColumn04 AS tinyint,
		@RowField AS nvarchar(50),
		@GroupField AS nvarchar(50),
		@ColumnField AS nvarchar(50),
		@sSQL AS nvarchar(MAX),
		@sSQLFrom AS nvarchar(4000),
		@Caption01 AS nvarchar(250),
		@Caption02 AS nvarchar(250),
		@Caption03 AS nvarchar(250),
		@Caption04 AS nvarchar(250),
		@IsFromAccount  AS tinyint,
		@AmountType1 nvarchar(50),
		@AmountType2 nvarchar(50),
		@AmountType3 nvarchar(50),
		@FromAccountID1  nvarchar(50),
		@ToAccountID1   nvarchar(50),
		@FromAccountID2   nvarchar(50), 
		@ToAccountID2   nvarchar(50),
		@FromAccountID3    nvarchar(50),
		@ToAccountID3    nvarchar(50),
		@Colum01ID       nvarchar(50),
		@Colum02ID  nvarchar(50),
		@Sign1    nvarchar(50),
	 	@Sign2    nvarchar(50),
		@Sign3  nvarchar(50),
		@SQL nvarchar(4000),
		@Sign    nvarchar(50),
		@Selection01ID AS nvarchar(50),
		@Selection02ID AS nvarchar(50),
		@Selection03ID AS nvarchar(50),
		@SelectionField AS  nvarchar(50),
		@sqlSelection AS nvarchar(4000),
		@IsQuantity AS tinyint,
		@Field AS nvarchar(50)

SELECT 	@RowTypeID = RowTypeID, 
		@RowGroupID = RowGroupID,
		@IsColumn01 = IsColumn01, 
		@IsColumn02 = IsColumn02, 
		@IsColumn03 = IsColumn03, 
		@IsColumn04 = IsColumn04,
		@Caption01 = Caption01,
		@Caption02 = Caption02,
		@Caption03 = Caption03,
		@Caption04 = Caption04,
		@Selection01ID = Selection01ID	, 
		@Selection02ID = Selection02ID, 
		@Selection03ID = Selection03ID
FROM	AT4723 
WHERE ReportCodeID = @ReportCodeID

--SELECT(@IsColumn03)
--SELECT(@IsColumn04)
----- Lay cac Field
EXEC AP4700  @RowTypeID ,  @RowField 	OUTPUT
EXEC AP4700  @RowGroupID,  @GroupField  	OUTPUT
EXEC AP4700  @ColumTypeID,   @ColumnField  	OUTPUT

SET @sqlSelection =''

IF ISNULL(@Selection01ID,'') <>'' 
   Begin
		EXEC AP4700  @Selection01ID,   @SelectionField 	OUTPUT
		SET @sqlSelection  = @sqlSelection +' And  ( '+@SelectionField+ ' BETWEEN '''+isnull(@Selection01IDFrom,'')+''' and '''+isnull(@Selection01IDTo,'')+''') '	
   End
IF ISNULL(@Selection02ID,'') <>'' 
   Begin
		EXEC AP4700  @Selection02ID,   @SelectionField 	OUTPUT
		SET @sqlSelection  = @sqlSelection +' And  ( '+@SelectionField+ ' BETWEEN '''+isnull(@Selection02IDFrom,'')+''' and '''+isnull(@Selection02IDTo,'')+''') '	
   End
IF ISNULL(@Selection03ID,'') <>'' 
   Begin
		EXEC AP4700  @Selection03ID,   @SelectionField 	OUTPUT
		SET @sqlSelection  = @sqlSelection +' And  ( '+@SelectionField+ ' BETWEEN '''+isnull(@Selection03IDFrom,'')+''' and '''+isnull(@Selection03IDTo,'')+''') '	
   End
---Print @sqlSelection+' Nhan '+@RowTypeID

SET @sSQLFrom = N'  
FROM		AV4301  	
LEFT JOIN	AT6666 V61 
	ON		V61.DivisionID = AV4301.DivisionID 
			AND V61.SelectionType =N'''+@RowTypeID+N''' 
			AND V61.SelectionID = AV4301.'+@RowField+N' 
LEFT JOIN	AT6666 V62 
	ON		V62.DivisionID = AV4301.DivisionID 
			AND V62.SelectionType =N'''+@RowGroupID+N''' 
			AND V62.SelectionID = AV4301.'+@GroupField+N' 
WHERE 		AV4301.DivisionID = N'''+@DivisionID+N''' 
			AND BudgetID = N''AA'' 
			AND	TranMonth+TranYear*100 BETWEEN '+str(@FromMOnth)+' +100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' +100*'+str(@ToYear)+  '  '+@sqlSelection+'
	
GROUP BY 	AV4301.DivisionID, V61.SelectionName, V62.SelectionName, 	
			'+@ColumnField+' ,   '+@RowField+', 	'+@GroupField+' 

'

SET @sSQL = N'
SELECT	AV4301.DivisionID, 
		N'''+isnull(@Caption01,'')+N''' AS Caption01,
		'+isnull(@RowField,N'''''')+N' AS RowID,
		'+isnull(@GroupField,N'''''')+N' AS GroupID, 
		'+isnull(@ColumnField,N'''''')+N' AS Caption00,
		V61.SelectionName AS ItemName,
		V62.SelectionName AS GroupName,
	
'	
-------------------------------------------------------------------------------- Xu ly cac cot -----------------------------------------------------------
IF @IsColumn01 <> 0
	Begin
		SELECT 	@IsFromAccount  = IsFromAccount,
				@AmountType1  = AmountType1,
				@AmountType2  = AmountType2,
				@AmountType3 = AmountType3,
				@FromAccountID1  = FromAccountID1, 
				@ToAccountID1  = ToAccountID1,
				@FromAccountID2   = FromAccountID2, 
				@ToAccountID2  = ToAccountID2,
				@FromAccountID3   =    FromAccountID3,	
				@ToAccountID3  =    ToAccountID3,
				@Colum01ID = Colum01ID,	
				@Colum02ID = Colum02ID,
				@Sign1 = Sign1, 
				@Sign2 =  Sign2,
				@Sign3 = Sign3, 
				@Sign  = Sign,
				@IsQuantity = IsQuantity
		FROM	AT4724
		WHERE	ReportCodeID = @ReportCodeID 
				AND ColumnID = 1
		
		if @IsQuantity = 0  
 		  	SET @Field = N'ConvertedAmount'
		Else
			SET @Field = N'Quantity'
			
-- Khánh thêm ngày 09/01/2012
-- Tránh trường hợp: không rơi vào các điều kiện bên dưới làm @SQL bị sai
SET @SQL = ' 0 '
		IF ISNULL(@Sign1,'')<>''
		BEGIN
			IF ISNULL(@AmountType1,'') ='PA' -- So du trong ky
				   SET @SQL = @Sign1+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then SignAmount  else 0 End)  '
			ELSE
				IF ISNULL(@AmountType1,'') ='PC'
					 SET @SQL = @Sign1+N'  SUM(CASE WHEN D_C=N''C''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
				Else 
					IF ISNULL(@AmountType1,'') ='PD'
						 SET @SQL = @Sign1+'  SUM(CASE WHEN D_C=N''D''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
		END
		IF ISNULL(@Sign2,'')<>''
		BEGIN
			IF ISNULL( @AmountType2,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then SignAmount  else 0 End)  '
			Else
				IF ISNULL( @AmountType2,'') ='PC'  -- Phat sinh Co
					SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''C''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
				Else
					IF ISNULL( @AmountType2,'') ='PD'  -- Phat sinh No
						SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''D''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
		END
		 
		IF ISNULL(@Sign3,'')<>''
		BEGIN
			IF ISNULL(@AmountType3,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then SignAmount  else 0 End)  '
			ELSE 
				IF ISNULL(@AmountType3,'') ='PC'  --- Phat sinh Co
					SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''C'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '
				ELSE
					IF ISNULL(@AmountType3,'') ='PD'  --- Phat sinh No
						SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''D'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '

		END		
	
		SET @SQL = @SQL+ ' AS ColumnValues   '

	END

SET @sSQL = @sSQL + @SQL + @sSQLFrom

If @IsColumn02 <> 0
BEGIN
SET @sSQL =@sSQL+ N'   
UNION ALL 

SELECT	AV4301.DivisionID, 
		N'''+isnull(@Caption02,'')+N''' AS Caption01,
		'+isnull(@RowField,N'''''')+N' AS RowID,
		'+isnull(@GroupField,N'''''')+N' AS GroupID, 
		'+isnull(@ColumnField,N'''''')+N' AS Caption00,
		V61.SelectionName AS ItemName,
		V62.SelectionName AS GroupName,	
'	
Select  	@IsFromAccount  = IsFromAccount,
			@AmountType1  = AmountType1,@AmountType2  = AmountType2,@AmountType3 = AmountType3,
			@FromAccountID1  = FromAccountID1, @ToAccountID1  = ToAccountID1,
			@FromAccountID2   = FromAccountID2, @ToAccountID2  = ToAccountID2,
			@FromAccountID3    =    FromAccountID3,	@ToAccountID3      =    ToAccountID3,
			@Colum01ID             = Colum01ID,	@Colum02ID           = Colum02ID,
			@Sign1                  = Sign1, @Sign2               =  Sign2,@Sign3                 = Sign3, @Sign  = Sign
		From AT4724
		Where ReportCodeID = @ReportCodeID and ColumnID = 2
		--Print @AmountType1+'  '+@ToAccountID1		
		--Print @AmountType2+'  '+@ToAccountID2	
		--Print @AmountType3
		
		--Print @AmountType1
			
-- Khánh thêm ngày 09/01/2012
-- Tránh trường hợp: không rơi vào các điều kiện bên dưới làm @SQL bị sai
SET @SQL = ' 0 '

		IF ISNULL(@Sign1,'')<>''
		BEGIN
			IF ISNULL(@AmountType1,'') ='PA' -- So du trong ky
				   SET @SQL = @Sign1+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then SignAmount  else 0 End)  '
			ELSE
				IF ISNULL(@AmountType1,'') ='PC'
					 SET @SQL = @Sign1+N'  SUM(CASE WHEN D_C=N''C''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
				Else 
					IF ISNULL(@AmountType1,'') ='PD'
						 SET @SQL = @Sign1+'  SUM(CASE WHEN D_C=N''D''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
		END
		IF ISNULL(@Sign2,'')<>''
		BEGIN
			IF ISNULL( @AmountType2,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then SignAmount  else 0 End)  '
			Else
				IF ISNULL( @AmountType2,'') ='PC'  -- Phat sinh Co
					SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''C''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
				Else
					IF ISNULL( @AmountType2,'') ='PD'  -- Phat sinh No
						SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''D''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
		END
		 
		IF ISNULL(@Sign3,'')<>''
		BEGIN
			IF ISNULL(@AmountType3,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then SignAmount  else 0 End)  '
			ELSE 
				IF ISNULL(@AmountType3,'') ='PC'  --- Phat sinh Co
					SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''C'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '
				ELSE
					IF ISNULL(@AmountType3,'') ='PD'  --- Phat sinh No
						SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''D'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '

		END		
	
		SET @SQL = @SQL+ ' AS ColumnValues   '


SET @sSQL = @sSQL + @SQL + @sSQLFrom

END


------------------------------------>>>>Cột 3
If @IsColumn03 <> 0
BEGIN
SET @sSQL =@sSQL+ N'   
UNION ALL 
SELECT	AV4301.DivisionID, 
		N'''+isnull(@Caption03,'')+N''' AS Caption01,
		'+isnull(@RowField,N'''''')+N' AS RowID,
		'+isnull(@GroupField,N'''''')+N' AS GroupID, 
		'+isnull(@ColumnField,N'''''')+N' AS Caption00,
		V61.SelectionName AS ItemName,
		V62.SelectionName AS GroupName,
	
'	

Select  	@IsFromAccount  = IsFromAccount,
			@AmountType1  = AmountType1,@AmountType2  = AmountType2,@AmountType3 = AmountType3,
			@FromAccountID1  = FromAccountID1, @ToAccountID1  = ToAccountID1,
			@FromAccountID2   = FromAccountID2, @ToAccountID2  = ToAccountID2,
			@FromAccountID3    =    FromAccountID3,	@ToAccountID3      =    ToAccountID3,
			@Colum01ID             = Colum01ID,	@Colum02ID           = Colum02ID,
			@Sign1                  = Sign1, @Sign2               =  Sign2,@Sign3                 = Sign3, @Sign  = Sign
		From AT4724
		Where ReportCodeID = @ReportCodeID and ColumnID = 3
		
SET @SQL = ' 0 '

	IF ISNULL(@Sign1,'')<>''
		BEGIN
			IF ISNULL(@AmountType1,'') ='PA' -- So du trong ky
				   SET @SQL = @Sign1+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then SignAmount  else 0 End)  '
			ELSE
				IF ISNULL(@AmountType1,'') ='PC'
					 SET @SQL = @Sign1+N'  SUM(CASE WHEN D_C=N''C''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
				Else 
					IF ISNULL(@AmountType1,'') ='PD'
						 SET @SQL = @Sign1+'  SUM(CASE WHEN D_C=N''D''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
		END
		IF ISNULL(@Sign2,'')<>''
		BEGIN
			IF ISNULL( @AmountType2,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then SignAmount  else 0 End)  '
			Else
				IF ISNULL( @AmountType2,'') ='PC'  -- Phat sinh Co
					SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''C''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
				Else
					IF ISNULL( @AmountType2,'') ='PD'  -- Phat sinh No
						SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''D''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
		END
		 
		IF ISNULL(@Sign3,'')<>''
		BEGIN
			IF ISNULL(@AmountType3,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then SignAmount  else 0 End)  '
			ELSE 
				IF ISNULL(@AmountType3,'') ='PC'  --- Phat sinh Co
					SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''C'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '
				ELSE
					IF ISNULL(@AmountType3,'') ='PD'  --- Phat sinh No
						SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''D'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '

		END		
	
		SET @SQL = @SQL+ ' AS ColumnValues   '


SET @sSQL = @sSQL + @SQL + @sSQLFrom

END
			
------------------------------------<<<<<<Cột 3

------------------------------------>>>>Cột 4
If @IsColumn04 <> 0
BEGIN
SET @sSQL =@sSQL+ N'   
UNION ALL 
SELECT	AV4301.DivisionID, 
		N'''+isnull(@Caption04,'')+N''' AS Caption01,
		'+isnull(@RowField,N'''''')+N' AS RowID,
		'+isnull(@GroupField,N'''''')+N' AS GroupID, 
		'+isnull(@ColumnField,N'''''')+N' AS Caption00,
		V61.SelectionName AS ItemName,
		V62.SelectionName AS GroupName,
	
'	

Select  	@IsFromAccount  = IsFromAccount,
			@AmountType1  = AmountType1,@AmountType2  = AmountType2,@AmountType3 = AmountType3,
			@FromAccountID1  = FromAccountID1, @ToAccountID1  = ToAccountID1,
			@FromAccountID2   = FromAccountID2, @ToAccountID2  = ToAccountID2,
			@FromAccountID3    =    FromAccountID3,	@ToAccountID3      =    ToAccountID3,
			@Colum01ID             = Colum01ID,	@Colum02ID           = Colum02ID,
			@Sign1                  = Sign1, @Sign2               =  Sign2,@Sign3                 = Sign3, @Sign  = Sign
		From AT4724
		Where ReportCodeID = @ReportCodeID and ColumnID = 4
		
SET @SQL = ' 0 '

	IF ISNULL(@Sign1,'')<>''
		BEGIN
			IF ISNULL(@AmountType1,'') ='PA' -- So du trong ky
				   SET @SQL = @Sign1+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then SignAmount  else 0 End)  '
			ELSE
				IF ISNULL(@AmountType1,'') ='PC'
					 SET @SQL = @Sign1+N'  SUM(CASE WHEN D_C=N''C''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
				Else 
					IF ISNULL(@AmountType1,'') ='PD'
						 SET @SQL = @Sign1+'  SUM(CASE WHEN D_C=N''D''  and AccountID BETWEEN  N'''+@FromAccountID1+N''' and N'''+@ToAccountID1+N''' then '+@Field+'  else 0 End)  '
		END
		IF ISNULL(@Sign2,'')<>''
		BEGIN
			IF ISNULL( @AmountType2,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then SignAmount  else 0 End)  '
			Else
				IF ISNULL( @AmountType2,'') ='PC'  -- Phat sinh Co
					SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''C''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
				Else
					IF ISNULL( @AmountType2,'') ='PD'  -- Phat sinh No
						SET @SQL = @SQL+@Sign2+N'  SUM(CASE WHEN  D_C=''D''  and AccountID BETWEEN  N'''+isnull(@FromAccountID2,'')+N''' and N'''+isnull(@ToAccountID2,'')+N''' then ConvertedAmount  else 0 End)  '
		END
		 
		IF ISNULL(@Sign3,'')<>''
		BEGIN
			IF ISNULL(@AmountType3,'') ='PA' -- So du trong ky
		       SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then SignAmount  else 0 End)  '
			ELSE 
				IF ISNULL(@AmountType3,'') ='PC'  --- Phat sinh Co
					SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''C'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '
				ELSE
					IF ISNULL(@AmountType3,'') ='PD'  --- Phat sinh No
						SET @SQL = @SQL+@Sign3+N'  SUM(CASE WHEN D_C =''D'' and AccountID BETWEEN  N'''+@FromAccountID3+N''' and N'''+@ToAccountID3+N''' then ConvertedAmount  else 0 End)  '

		END		
	
		SET @SQL = @SQL+ ' AS ColumnValues   '

		SET @sSQL = @sSQL + @SQL + @sSQLFrom

END
			
------------------------------------<<<<<<Cột 4
PRINT @sSQL


IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV5199')
	EXEC('CREATE VIEW AV5199 	--CREATED BY 
			AS '+@sSQL)
ELSE	
	EXEC('ALTER VIEW AV5199 		--CREATED BY 
			AS '+@sSQL)



SET @sSQL ='
SELECT * FROM AV5199
WHERE ColumnValues<>0 '

--PRINT @sSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV5200')
	EXEC('CREATE VIEW AV5200 	--CREATED BY 
			AS '+@sSQL)
ELSE	
	EXEC('ALTER VIEW AV5200 		--CREATED BY 
			AS '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

