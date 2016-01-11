/****** Object:  StoredProcedure [dbo].[AP7431]    Script Date: 08/02/2010 10:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created By Nguyen Van Nhan.
----- Date 25/08/2005
---- Purpose: Tinh toan so lieu

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE  	[dbo].[AP7431] 
					@DivisionID  NVARCHAR(50), 
					@TranMonth int, 
					@TranYear int, 
					@CalculatorID   NVARCHAR(50), 
					@VATGroup   NVARCHAR(50), 
					@VATTypeID1   NVARCHAR(50),
					@VATTypeID2   NVARCHAR(50), 
					@VATTypeID3   NVARCHAR(50),
					@AccumulatorID  NVARCHAR(50),
					@FromAccountID1   NVARCHAR(50), 
					@ToAccountID1   NVARCHAR(50), 
					@FromCorAccountID1   NVARCHAR(50), 
					@ToCorAccountID1   NVARCHAR(50),
					@FromAccountID2   NVARCHAR(50), 
					@ToAccountID2   NVARCHAR(50), 
					@FromCorAccountID2   NVARCHAR(50),
					@ToCorAccountID2   NVARCHAR(50),
					@FromAccountID3   NVARCHAR(50), 
					@ToAccountID3   NVARCHAR(50), 
					@FromCorAccountID3   NVARCHAR(50), 
					@ToCorAccountID3   NVARCHAR(50),
					@Amount decimal (28, 8) output

AS

Declare @TempAmount as decimal (28, 8),
	@sSQL as  NVARCHAR(4000)

------------SO DU NO CUOI KY TRUOC----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 If @CalculatorID ='LD'  
 BEGIN
	Set @sSQL ='	 Select AV4300.DivisionID, sum (SignAmount)  as Amount
		           From AV4300  
		        Where  (DivisionID = '''+@DivisionID+''' and  ( ( TranMonth+ TranYear*100< '+str(@TranMonth)+'+100*'+str(@TranYear)+' ) or TransactionTypeID =''T00'' ) ) '
	---- Nhom thue
	If @VATGroup<> '' 
		Set @sSQL =@sSQL + ' and ( VATGroupID like '''+@VATGroup+'''  ) '	
	---- Loai hoa don
	If @VATTypeID1<>''
                     Begin
		Set @sSQL =@sSQL + ' and (  ( VATTypeID =  '''+@VATTypeID1+'''  ) '	
		If @VATTypeID2<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID2+'''  ) '	
		If @VATTypeID3<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID3+'''  ) '	
	             Set @sSQL = @sSQL +') ' 
	        End

	Set @sSQL =@sSQL +'   And (
				 ( ( AccountID between '''+@FromAccountID1+''' and '''+@ToAccountID1+''')  '
	
	if @FromCorAccountID1<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID1+'''  and '''+@ToCorAccountID1+''' )) '
                 Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	----- Khoang 2
	 If @FromAccountID2<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID2+''' and '''+@ToAccountID2+''')  '
		if @FromCorAccountID2<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID2+'''  and '''+@ToCorAccountID2+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
           ------ Khoang 3

  Set @sSQL = @sSQL+' ) '					  
	 If @FromAccountID3<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID3+''' and '''+@ToAccountID3+''')  '
		if @FromCorAccountID3<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID3+'''  and '''+@ToCorAccountID3+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
          End	
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------PHAT SINH NO KY NAY-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 If  @CalculatorID ='PD'  
 BEGIN
	Set @sSQL ='	 Select 
					AV4300.DivisionID,sum (SignAmount)  as Amount
		           From AV4300  
		        Where  (DivisionID = '''+@DivisionID+''' and TranMonth+ TranYear*100 = '+str(@TranMonth)+'+100*'+str(@TranYear)+')  and D_C =''D'' '
	---- Nhom thue
	If @VATGroup<> '' 
		Set @sSQL =@sSQL + ' and ( VATGroupID like '''+@VATGroup+'''  ) '	
	---- Loai hoa don
	If @VATTypeID1<>''
                     Begin
		Set @sSQL =@sSQL + ' and (  ( VATTypeID =  '''+@VATTypeID1+'''  ) '	
		If @VATTypeID2<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID2+'''  ) '	
		If @VATTypeID3<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID3+'''  ) '	
	             Set @sSQL = @sSQL +') ' 
	        End

	Set @sSQL =@sSQL +'   And  (
				 ( ( AccountID between '''+@FromAccountID1+''' and '''+@ToAccountID1+''')  '
	
	if @FromCorAccountID1<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID1+'''  and '''+@ToCorAccountID1+''' )) '
                 Else 					  
		 Set @sSQL = @sSQL+' ) '					  

	----- Khoang 2
	 If @FromAccountID2<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID2+''' and '''+@ToAccountID2+''')  '
		if @FromCorAccountID2<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID2+'''  and '''+@ToCorAccountID2+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
           ------ Khoang 3
 
	 If @FromAccountID3<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID3+''' and '''+@ToAccountID3+''')  '
		if @FromCorAccountID3<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID3+'''  and '''+@ToCorAccountID3+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
 Set @sSQL = @sSQL+' ) '					  
END
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------- PHAT SINH CO ----------------------------------------------------------------------------------------------------------------------------------------
If  @CalculatorID ='PC'  
 BEGIN
	Set @sSQL ='	 Select AV4300.DivisionID, sum (-SignAmount)  as Amount
		           From AV4300  
		        Where  (DivisionID = '''+@DivisionID+''' and TranMonth+ TranYear*100 = '+str(@TranMonth)+'+100*'+str(@TranYear)+')  and D_C =''C'' '
	---- Nhom thue
	If @VATGroup<> '' 
		Set @sSQL =@sSQL + ' and ( VATGroupID like '''+@VATGroup+'''  ) '	
	---- Loai hoa don
	If @VATTypeID1<>''
                     Begin
		Set @sSQL =@sSQL + ' and (  ( VATTypeID =  '''+@VATTypeID1+'''  ) '	
		If @VATTypeID2<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID2+'''  ) '	
		If @VATTypeID3<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID3+'''  ) '	
	             Set @sSQL = @sSQL +') ' 
	        End

	Set @sSQL =@sSQL +'   And (
				 ( ( AccountID between '''+@FromAccountID1+''' and '''+@ToAccountID1+''')  '
	
	if @FromCorAccountID1<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID1+'''  and '''+@ToCorAccountID1+''' )) '
                 Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	----- Khoang 2
	 If @FromAccountID2<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID2+''' and '''+@ToAccountID2+''')  '
		if @FromCorAccountID2<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID2+'''  and '''+@ToCorAccountID2+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
           ------ Khoang 3

	 If @FromAccountID3<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID3+''' and '''+@ToAccountID3+''')  '
		if @FromCorAccountID3<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID3+'''  and '''+@ToCorAccountID3+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
  Set @sSQL = @sSQL+' ) '	
END
-----------------------------------------------------	 SO DU NO TRONG KY --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If  @CalculatorID ='BD'  --- So du no trong ky
 BEGIN
	Set @sSQL ='	 Select AV4300.DivisionID, sum (SignAmount)  as Amount
		           From AV4300  
		        Where  (DivisionID = '''+@DivisionID+''' and TranMonth+ TranYear*100 = '+str(@TranMonth)+'+100*'+str(@TranYear)+') '
	---- Nhom thue
	If @VATGroup<> '' 
		Set @sSQL =@sSQL + ' and ( VATGroupID like '''+@VATGroup+'''  ) '	
	---- Loai hoa don
	If @VATTypeID1<>''
                     Begin
		Set @sSQL =@sSQL + ' and (  ( VATTypeID =  '''+@VATTypeID1+'''  ) '	
		If @VATTypeID2<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID2+'''  ) '	
		If @VATTypeID3<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID3+'''  ) '	
	             Set @sSQL = @sSQL +') ' 
	        End

	Set @sSQL =@sSQL +'   And (
				 ( ( AccountID between '''+@FromAccountID1+''' and '''+@ToAccountID1+''')  '
	
	if @FromCorAccountID1<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID1+'''  and '''+@ToCorAccountID1+''' )) '
                 Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	----- Khoang 2
	 If @FromAccountID2<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID2+''' and '''+@ToAccountID2+''')  '
		if @FromCorAccountID2<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID2+'''  and '''+@ToCorAccountID2+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
           ------ Khoang 3
				  
	 If @FromAccountID3<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID3+''' and '''+@ToAccountID3+''')  '
		if @FromCorAccountID3<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID3+'''  and '''+@ToCorAccountID3+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
  Set @sSQL = @sSQL+' ) '	
END
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------- SO DU CO  TRONG KY ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If  @CalculatorID ='BC'  --- So du Co trong ky
 BEGIN
	Set @sSQL ='	 Select AV4300.DivisionID, sum (-SignAmount)  as Amount
		           From AV4300  
		        Where  (DivisionID = '''+@DivisionID+''' and TranMonth+ TranYear*100 = '+str(@TranMonth)+'+100*'+str(@TranYear)+') '
	---- Nhom thue
	If @VATGroup<> '' 
		Set @sSQL =@sSQL + ' and ( VATGroupID like '''+@VATGroup+'''  ) '	
	---- Loai hoa don
	If @VATTypeID1<>''
                     Begin
		Set @sSQL =@sSQL + ' and (  ( VATTypeID =  '''+@VATTypeID1+'''  ) '	
		If @VATTypeID2<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID2+'''  ) '	
		If @VATTypeID3<>''			
		 Set @sSQL =@sSQL + ' Or  ( VATTypeID =  '''+@VATTypeID3+'''  ) '	
	             Set @sSQL = @sSQL +') ' 
	        End

	Set @sSQL =@sSQL +'   And (
				 ( ( AccountID between '''+@FromAccountID1+''' and '''+@ToAccountID1+''')  '
	
	if @FromCorAccountID1<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID1+'''  and '''+@ToCorAccountID1+''' )) '
                 Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	----- Khoang 2
	 If @FromAccountID2<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID2+''' and '''+@ToAccountID2+''')  '
		if @FromCorAccountID2<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID2+'''  and '''+@ToCorAccountID2+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
           ------ Khoang 3
				  
	 If @FromAccountID3<>'' 
                   Begin
		Set @sSQl =@sSQL + '  Or (  ( AccountID between '''+@FromAccountID3+''' and '''+@ToAccountID3+''')  '
		if @FromCorAccountID3<>''
		Set @sSQL = @sSQL+'		And (CorAccountID between '''+@FromCorAccountID3+'''  and '''+@ToCorAccountID3+''' )) '
                         Else 					  
		 Set @sSQL = @sSQL+' ) '					  
	
	     End	
  Set @sSQL = @sSQL+' ) '	
END
Set @ssql = @ssql + ' group by AV4300.DivisionID'

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV7431')
	Exec('Create View AV7431 as '+@ssql)Else
	Exec('Alter View AV7431 as '+@ssql)
--Print @ssql
Set @Amount = isnull(( Select   isnull(Amount,0) From AV7431 ),0)
--Set @TempAmount =
---Print @sSQL 
---Exec(@sSQL)





