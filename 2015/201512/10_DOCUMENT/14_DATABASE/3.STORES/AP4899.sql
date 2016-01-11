IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4899]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4899]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Van Nhan, Date  13/06/2005
----- Purpose: Tinh toan so du
---- Modified on 17/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP4899]
		@FromMonth as int,
		@FromYear as int,
		@ToMonth as int,
		@ToYear as int,
		@FromDate Datetime,
		@ToDate Datetime,
		@IsDate as tinyint,
		@ColumnType as nvarchar(20),
		@ColumnData as nvarchar(20), 
		@sSQL as nvarchar(500) OUTPUT
AS
Declare @Zero as decimal(28,8),
	@FieldAmount as nvarchar(20)

Set @Zero = 0.00

If @ColumnType ='AQ'
  Set @FieldAmount ='SignQuantity'
Else
 Set @FieldAmount ='SignAmount'


If @ColumnData ='PC' ---- Phat sinh Co
  Begin
	If @IsDate =0 --- theo thang
		Set @sSQL ='  SUM( CASE WHEN  TransactionTypeID<>''T00''  and  (TranMonth + 100*TranYear Between '+str(@FromMonth)+'+ 100*'+str(@FromYear)+'   And  '+str(@ToMonth)+'+ 100*'+str(@ToYear)+' )  and  D_C =''C''  then - isnull('+@FieldAmount+' ,0) else 0 End ) '
	Else
		Set @sSQL ='  SUM( CASE WHEN  TransactionTypeID<>''T00''  and  (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) Between '''+Convert(nvarchar(10),@FromDate,101)+ '''  and '''+Convert(nvarchar(10),@ToDate,101) +''') and  D_C =''C''  then - isnull('+@FieldAmount+' ,0) else 0 End ) '

 End

IF @ColumnData ='PD' ---- Phat sinh No
 Begin
	If @IsDate =0
		Set @sSQL ='  SUM( CASE WHEN  TransactionTypeID<>''T00''  and   (TranMonth + 100*TranYear Between '+str(@FromMonth)+'+ 100*'+str(@FromYear)+'   and '+str(@ToMonth)+'+ 100*'+str(@ToYear)+' )  and  D_C =''D''  then  isnull( '+@FieldAmount+' ,0) else 0 End ) '
	Else	
		Set @sSQL ='  SUM( CASE WHEN  TransactionTypeID<>''T00''  and  (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) Between '''+Convert(nvarchar(10),@FromDate,101)+ ''' and '''+Convert(nvarchar(10),@ToDate,101) +''') and  D_C =''D''  then  isnull('+@FieldAmount+' ,0) else 0 End ) '
  End

IF @ColumnData ='BD' ----  So du No trong ky
  Begin
	If @IsDate =0
		Set @sSQL ='  SUM( CASE WHEN  (TranMonth + 100*TranYear <=   '+str(@ToMonth)+'+ 100*'+str(@ToYear)+' )  then  isnull('+@FieldAmount+' ,0) else 0 End ) '
	Else
		Set @sSQL ='  SUM( CASE WHEN   (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) <=  '''+Convert(nvarchar(10),@ToDate,101) +''') then  isnull('+@FieldAmount+' ,0) else 0 End ) '	
  End

IF @ColumnData ='BC' ----  So du Co trong ky
  Begin
	If @IsDate =0
		Set @sSQL ='  - SUM( CASE WHEN  (TranMonth + 100*TranYear <=   '+str(@ToMonth)+'+ 100*'+str(@ToYear)+' )  then   isnull('+@FieldAmount+',0)  else 0 End ) '
	Else
		Set @sSQL ='  - SUM( CASE WHEN   (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) <=  '''+Convert(nvarchar(10),@ToDate,101) +''') then  isnull('+@FieldAmount+' ,0) else 0 End ) '	

  End


IF @ColumnData ='LD' ----  So du no ky truoc
 Begin
	If @IsDate =0
		Set @sSQL ='  SUM( CASE WHEN  (TranMonth + 100*TranYear <   '+str(@FromMonth)+'+ 100*'+str(@FromYear)+'  OR TransactionTypeID =''T00'' )  then  isnull('+@FieldAmount+',0)  else 0 End ) '
	Else
		Set @sSQL ='  SUM( CASE WHEN   (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) <  '''+Convert(nvarchar(10),@FromDate,101) +''' OR TransactionTypeID =''T00'' ) then  isnull('+@FieldAmount+' ,0) else 0 End ) '		
  End

IF @ColumnData ='LC' ----  So du Co ky truoc
  Begin
	If @IsDate =0
		Set @sSQL =' - SUM( CASE WHEN  (TranMonth + 100*TranYear <   '+str(@FromMonth)+'+ 100*'+str(@FromYear)+' OR TransactionTypeID =''T00'')  then  isnull('+@FieldAmount+',0)  else 0 End ) '
	Else
		Set @sSQL =' - SUM( CASE WHEN   (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) <  '''+Convert(nvarchar(10),@FromDate,101) +''' OR TransactionTypeID =''T00'' ) then  isnull('+@FieldAmount+' ,0) else 0 End ) '		
  End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

