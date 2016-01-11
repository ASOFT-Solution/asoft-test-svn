IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4801]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4801]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------ 	Created by Nguyen Van Nhan, Date 14/06/2005.
-----	Purpose:  Bao cao cong no theo ma phan tich, nhom theo ngay. Truonghop Type = 1
---- Modified on 30/10/2012 by Lê Thị Thu Hiền : Bổ sung 1 số trường

CREATE PROCEDURE [dbo].[AP4801] 	
		@DivisionID nvarchar(50), 
		@ReportCode AS nvarchar(50),
		@FromMonth AS int, 
		@FromYear AS int,
		@ToMonth AS int, 
		@ToYear AS int,
		@FromDate Datetime,
		@ToDate Datetime,
		@IsDate AS tinyint,
		@Selection01From nvarchar(20),  
		@Selection01To nvarchar(20),
		@Selection02From nvarchar(20),  
		@Selection02To nvarchar(20),
		@Selection03From nvarchar(20),  
		@Selection03To nvarchar(20),
		@Selection04From nvarchar(20),  
		@Selection04To nvarchar(20)
AS
Declare @Column AS nvarchar(20),
		@sSQL AS nvarchar(4000),
		@sGroup  nvarchar(4000),
		@FromAccountID AS nvarchar(50),
		@ToAccountID AS nvarchar(50),
		@Selection01ID   AS nvarchar(50),      
		@Selection02ID  AS nvarchar(50),       
		@Selection03ID   AS nvarchar(50),      
		@Selection04ID   AS nvarchar(50),             		
		@Level01   AS nvarchar(20),                   
		@Level02   AS nvarchar(20),                   
		@Level03    AS nvarchar(20),                  
		@Level04  AS nvarchar(20),
		@I AS int,
		@ColumnType AS nvarchar(20),
		@ColumnData AS nvarchar(20),
		@sSQLColumn AS nvarchar(4000)

Select 	top 1 @ToAccountID = ToAccountID, @FromAccountID = FromAccountID,
	@Selection01ID = Selection01ID, @Selection02ID = Selection02ID,
	@Selection03ID = Selection03ID, @Selection04ID = Selection04ID,
	@Level01 = Level01, @Level02 = Level02, 	
	@Level03 = Level03, @Level04 = Level04
From AT4801
Where ReportCode = @ReportCode and DivisionID = @DivisionID

---------1------------------- Xu ly Group-----------------------------------------------
SET @sSQL = ' SELECT  DivisionID, VoucherDate   '
SET @sGroup =' GROUP BY   DivisionID, VoucherDate  '

If isnull(@Level01,'') <>'' 
   Begin
	Exec AP4700 @Level01 ,  @Column  output
	SET @sSQL = @sSQL+ ',  '+@Column+'  AS Group01ID '
	SET @sGroup =@sGroup+', ' +@Column+'  '
  End
  Else
  Begin
	SET @sSQL = @sSQL+ ', '''' AS Group01ID '
  End		
SET  @Column =''     
If isnull(@Level02,'') <>'' 
   Begin
	Exec AP4700 @Level02 ,  @Column  output
	SET @sSQL = @sSQL+ ',  '+@Column+'  AS Group02ID '
	SET @sGroup = @sGroup+',  ' +@Column
 End	
Else
	SET @sSQL = @sSQL+ ', ''''  AS Group02ID '

SET  @Column =''     
If isnull(@Level03,'') <>'' 
   Begin
	Exec AP4700 @Level03 ,  @Column  output
	SET @sSQL = @sSQL+ ',  '+@Column+'  AS Group03ID '
	SET @sGroup = @sGroup+' ,  ' +@Column
 End	
Else
	SET @sSQL = @sSQL+ ', ''''  AS Group03ID '

If isnull(@Level04,'') <>'' 
   Begin
	Exec AP4700 @Level04 ,  @Column  output
	SET @sSQL = @sSQL+ ', '+@Column+'  AS Group04ID '
	SET @sGroup = @sGroup+' ,  ' +@Column
 End	
Else
	SET @sSQL = @sSQL+ ',  ''''  AS Group04ID  '


---------2------------------- Xu ly Detail  -----------------------------------------------
SET @sSQL = @sSQL+ '	, 	Sum(Case when V31.D_C =''D'' then ConvertedAmount else 0 end) AS DebitAmount,Sum(Case when V31.D_C =''D'' then OriginalAmount else 0 end) AS DebitOriginalAmount,
						 	Sum(Case when V31.D_C =''C'' then ConvertedAmount else 0 end) AS CreditAmount,Sum(Case when V31.D_C =''C'' then OriginalAmount else 0 end) AS CreditOriginalAmount ,
						 	Sum(Case when V31.D_C =''D'' then VATConvertedAmount else 0 end) AS VATDebitAmount,Sum(Case when V31.D_C =''D'' then VATOriginalAmount else 0 end) AS VATDebitOriginalAmount,
						 	Sum(Case when V31.D_C =''C'' then VATConvertedAmount else 0 end) AS VATCreditAmount,Sum(Case when V31.D_C =''C'' then VATOriginalAmount else 0 end) AS VATCreditOriginalAmount,
							Max(ISNULL(InvoiceNo,'''')) AS  InvoiceNo,
							MAX(ISNULL(Ana02Amount01,0)) AS Ana02Amount01, 
							MAX(ISNULL(Ana02Amount02,0))  AS Ana02Amount02, 
							MAX(ISNULL(Ana02Amount03,0))  AS Ana02Amount03, 
							MAX(ISNULL(Ana02Note01,'''')) AS Ana02Note01,
							MAX(ISNULL(Ana02Note02,''''))  AS Ana02Note02, 
							MAX(ISNULL(Ana02Note03,''''))  AS Ana02Note03,
							MAX(ISNULL(Ana02RefDate,'''')) AS Ana02RefDate '
SET @sSQL = @sSQL +'  
			FROM    AV4301 V31 
			WHERE	DivisionID = '''+@DivisionID+'''  
					AND AccountID  Between '''+@FromAccountID+''' AND '''+@ToAccountID+''' '

If isnull(@Selection01ID,'') <>'' 
   Begin
	Exec AP4700 @Selection01ID ,  @Column  output
	SET @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection01From+''' and '''+@Selection01To+''' ) '
  End 

If isnull(@Selection02ID,'') <>'' 
   Begin
	Exec AP4700 @Selection02ID ,  @Column  output
	SET @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection02From+''' and '''+@Selection02To+''' ) '
  End 

If isnull(@Selection03ID,'') <>'' 
   Begin
	Exec AP4700 @Selection03ID ,  @Column  output
	SET @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection03From+''' and '''+@Selection03To+''' ) '
  End 


If isnull(@Selection04ID,'') <>'' 
   Begin
	Exec AP4700 @Selection04ID ,  @Column  output
	SET @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection04From+''' and '''+@Selection04To+''' ) '

  End 

SET @sSQL = @sSQL + @sGroup


--PRINT(@sSQL)
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV4811')
	EXEC('CREATE VIEW AV4811 	--CREATED BY AP4801
			as '+@sSQL)
ELSE	
	EXEC('ALTER VIEW AV4811 		--CREATED BY AP4801
			AS '+@sSQL)


SET @sSQL =' 	Select V11.* '
If isnull(@Level01,'') <>'' 
  	SET @sSQL =@sSQL +',   V61.SelectionName AS GroupName01 '
Else
	SET @sSQL =@sSQL +',  ''''  GroupName01 '	

If isnull(@Level02,'') <>'' 
  SET @sSQL =@sSQL +',   V62.SelectionName AS GroupName02 '		
Else
	SET @sSQL =@sSQL +' , ''''  GroupName02 '	

If isnull(@Level03,'') <>'' 
  SET @sSQL =@sSQL +',   V63.SelectionName AS GroupName03 '		
Else
  SET @sSQL =@sSQL +',  ''''  GroupName03 '	

If isnull(@Level04,'') <>'' 
  SET @sSQL =@sSQL +',   V64.SelectionName AS GroupName04 '		
Else
  SET @sSQL =@sSQL +',  ''''  GroupName04 '	

SET @sSQL =@sSQL+'
	FROM AV4811 V11 '

If isnull(@Level01,'') <>'' 
SET @sSQL = @sSQL +' LEFT JOIN AV6666 V61 on 	V61.SelectionType ='''+@Level01+''' And
						V61.SelectionID = V11.Group01ID and V61.DivisionID = V11.DivisionID '

If isnull(@Level02,'') <>'' 
SET @sSQL = @sSQL +' LEFT JOIN AV6666 V62 on 	V62.SelectionType ='''+@Level02+''' And
						V62.SelectionID = V11.Group02ID and V62.DivisionID = V11.DivisionID '

If isnull(@Level03,'') <>'' 
SET @sSQL = @sSQL +' LEFT JOIN AV6666 V63 on 	V63.SelectionType ='''+@Level03+''' And
						V63.SelectionID = V11.Group03ID and V63.DivisionID = V11.DivisionID  '

If isnull(@Level04,'') <>'' 
SET @sSQL = @sSQL +' LEFT JOIN AV6666 V64 on 	V64.SelectionType ='''+@Level04+''' And
						V64.SelectionID = V11.Group04ID and V64.DivisionID = V11.DivisionID '

SET @sSQL = @sSQL +' Where 	DebitAmount<>0 or CreditAmount<>0  '



IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV4801')
	EXEC('CREATE VIEW AV4801 	--CREATED BY AP4801
			as '+@sSQL)
ELSE	
	EXEC('ALTER VIEW AV4801 		--CREATED BY AP4801
			AS '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

