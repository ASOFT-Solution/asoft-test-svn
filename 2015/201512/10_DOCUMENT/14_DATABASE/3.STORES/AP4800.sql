IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4800]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)     
DROP PROCEDURE [DBO].[AP4800]  
GO  
SET QUOTED_IDENTIFIER ON  
GO  
SET ANSI_NULLS ON  
GO  

------ 	Created by Nguyen Van Nhan, Date 14/06/2005.
-----	Purpose:  Bao cao cong no theo ma phan tich, Chi tiet theo hoa don. Truonghop Type = 0
-----	Edit by: Dang Le Bao Quynh; Date 24/07/2008
-----	Purpose: Sua loi khi khong chon nhom
-----	Edit by: Dang Le Bao Quynh; Date 28/03/2008
-----	Purpose: Sua loi bao cao thiet lap 3 nhom
-----	Modified on 09/09/2011 by Le Thi Thu Hien : Sua loi co so du dau ky khong co phat sinh trong ky no khong len
-----	Modified on 08/10/2012 by Bao Anh : Customize cho IPL (goi AP4800_IPL, lay so du theo chung tu)
-----   Modified on 25/08/2015 by Tiểu Mai: Sửa báo cáo group theo đối tượng, không theo chi tiết phiếu.
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP4800] 	
				@DivisionID nvarchar(50), 
				@ReportCode as nvarchar(50),
				@FromMonth as int, 
				@FromYear as int,
				@ToMonth as int, 
				@ToYear as int,
				@FromDate Datetime,
				@ToDate Datetime,
				@IsDate as tinyint,
				@Selection01From nvarchar(20),  
				@Selection01To nvarchar(20),
				@Selection02From nvarchar(20),  
				@Selection02To nvarchar(20),
				@Selection03From nvarchar(20),  
				@Selection03To nvarchar(20),
				@Selection04From nvarchar(20),  
				@Selection04To nvarchar(20)

As

DECLARE @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang IPL khong (CustomerName = 17)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF @CustomerName = 17 --- Customize IPL
	EXEC AP4800_IPL @DivisionID, @ReportCode, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate,
					@Selection01From, @Selection01To, @Selection02From, @Selection02To, @Selection03From, @Selection03To, @Selection04From, @Selection04To
ELSE
	BEGIN
		Declare 	@Column as nvarchar(20),
					@join1 as nvarchar(4000),
					@join2 as nvarchar(4000),
					@join3 as nvarchar(4000),
					@join4 as nvarchar(4000),
					@sSQL as nvarchar(max),
					@sSQLBalance as nvarchar(4000),
					@sSQLGroup as  nvarchar(4000),
					@sGroup  nvarchar(4000),
					@FromAccountID as nvarchar(50),
					@ToAccountID as nvarchar(50),
					@Selection01ID   as nvarchar(50),      
					@Selection02ID  as nvarchar(50),       
					@Selection03ID   as nvarchar(50),      
					@Selection04ID   as nvarchar(50),             		
					@Level01   as nvarchar(20),                   
					@Level02   as nvarchar(20),                   
					@Level03    as nvarchar(20),                  
					@Level04  as nvarchar(20),
					@I as int,
					@ColumnType as nvarchar(20),
					@ColumnData as nvarchar(20),
					@sSQLColumn as nvarchar(4000)

		Select 	top 1  @FromAccountID = FromAccountID, @ToAccountID = ToAccountID,
			@Selection01ID = Selection01ID, @Selection02ID = Selection02ID,
			@Selection03ID = Selection03ID, @Selection04ID = Selection04ID,
			@Level01 = Level01, @Level02 = Level02, 	
			@Level03 = Level03, @Level04 = Level04
		From AT4801
		Where ReportCode = @ReportCode and DivisionID = @DivisionID
		 --SELECT * FROM AT4801
		---------1------------------- Xu ly Group-----------------------------------------------
		Set @sSQLGroup = 'Group by V31.DivisionID, V31.ObjectID'
		Set @sSQL = ' Select  V31.DivisionID, V31.AccountID, V31.CorAccountID ,V31.ObjectID as ObjectID, VoucherID, Cast(Convert(nvarchar(10),VoucherDate,101) as DateTime) As VoucherDate, VoucherNo, Serial, InvoiceDate, InvoiceNo, DueDate, Description as VDescription , CurrencyIDCN   '
		If @IsDate =0
		Set @sSQLBalance ='Select 	V31.DivisionID, V31.ObjectID,sum(Case when TranMonth+100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  or  TransactionTypeID =''T00'' then isnull(SignAmount,0) else 0 end ) as BeginAmount,
						sum(Case when TranMonth+100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  or  TransactionTypeID =''T00'' then isnull(SignOriginal,0) else 0 end ) as BeginOriginalAmount,
						sum(Case when TranMonth+100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+' then isnull(SignAmount,0) else 0 end ) as EndAmount,
						sum(Case when TranMonth+100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+' then isnull(SignOriginal,0) else 0 end ) as EndOriginalAmount   '
					
		Else
		Set @sSQLBalance ='Select V31.DivisionID, V31.ObjectID,sum(Case when VoucherDate < '''+Convert(nvarchar(10),@FromDate,101)+'''  or  TransactionTypeID =''T00''  then isnull(SignAmount,0) else 0 end ) as BeginAmount,
						sum(Case when VoucherDate < '''+Convert(nvarchar(10),@FromDate,101)+'''  or  TransactionTypeID =''T00''  then isnull(SignOriginal,0) else 0 end ) as BeginOriginalAmount,
						sum(Case when VoucherDate <='''+Convert(nvarchar(10),@ToDate,101)+''' then isnull(SignAmount,0) else 0 end ) as EndAmount,
						sum(Case when VoucherDate <='''+Convert(nvarchar(10),@ToDate,101)+''' then isnull(SignOriginal,0) else 0 end ) as EndOriginalAmount  '
					



		Set @sGroup ='  Group by  V31.DivisionID, V31.AccountID, V31.CorAccountID, V31.ObjectID, VoucherID, VoucherDate, VoucherNo, Serial, InvoiceDate, InvoiceNo, DueDate, Description, CurrencyIDCN, D_C '
		If isnull(@Level01,'') <>'' 
		   Begin	
			Exec AP4700 @Level01 ,  @Column  output
			Set @sSQL = @sSQL+ ' ,'+@Column+'  as Group01ID, '
			Set @sSQLBalance = @sSQLBalance+' , '+@Column+'  as Group01ID '
			Set @sSQLGroup = @sSQLGroup + ' ,'+@Column+' '
			Set @sGroup = @sGroup+', '+@Column+' '
				--Print @sSQLBalance
		  End
			Else
			  Begin
	    			Set @sSQL = @sSQL+ ', '''' as Group01ID, '
				Set @sSQLBalance = @sSQLBalance+ ', '''' as Group01ID '
			  End


		Set  @Column =''     
		If isnull(@Level02,'') <>'' 
		   Begin
			Exec AP4700 @Level02 ,  @Column  output
			Set @sSQL = @sSQL+ ' '+@Column+'  as Group02ID, '
			Set @sSQLBalance = @sSQLBalance+' , '+@Column+'  as Group02ID '
			Set @sGroup = @sGroup+', '+@Column+' '
			Set @sSQLGroup = @sSQLGroup+',  '+@Column+' '
		   End	
		Else
			Begin
			   Set @sSQL = @sSQL+ ' ''''  as Group02ID, '
			   Set @sSQLBalance = @sSQLBalance+ ', '''' as Group02ID '
			End

		Set  @Column =''     
		If isnull(@Level03,'') <>'' 
		   Begin
			Exec AP4700 @Level03 ,  @Column  output
			Set @sSQL = @sSQL+ ' '+@Column+'  as Group03ID, '
			Set @sSQLBalance = @sSQLBalance+' , '+@Column+'  as Group03ID '
			Set @sGroup = @sGroup+', '+@Column+' '
			Set @sSQLGroup = @sSQLGroup+',  '+@Column+' '
		 End	
		Else
			   Begin	
			Set @sSQL = @sSQL+ ' ''''  as Group03ID, '
			 Set @sSQLBalance = @sSQLBalance+ ', '''' as Group03ID  '
			   End	

		If isnull(@Level04,'') <>'' 
		   Begin
			Exec AP4700 @Level04 ,  @Column  output
			Set @sSQL = @sSQL+ ' '+@Column+'  as Group04ID, '
			Set @sSQLBalance = @sSQLBalance+' , '+@Column+'  as Group04ID '
			Set @sGroup = @sGroup+', '+@Column+' '
			Set @sSQLGroup = @sSQLGroup+',  '+@Column+' '
		 End	
		Else
			  Begin	
			Set @sSQL = @sSQL+ ' ''''  as Group04ID,   '
			Set @sSQLBalance = @sSQLBalance+ ', '''' as Group04ID '
			 End


		Set @sSQL = @sSQL+' 	D_C, 
						Sum(Case when  D_C =''D''  then OriginalAmountCN else 0 end) as DebitOriginalAmount,  
						sum(Case when  D_C=''D''  then ConvertedAmount else 0 End ) as DebitConvertedAmount,
						Sum(Case when  D_C=''C''   then OriginalAmountCN else 0 end) as CreditOriginalAmount,  
						sum(Case when   D_C=''C''  then ConvertedAmount else 0 End)  as CreditConvertedAmount,
						Sum(Quantity) as Quantity 
		  From AV4301 V31 
					Where  DivisionID = DivisionID  and  TransactionTypeID<>''T00''	and 		
						AccountID between '''+isnull(@FromAccountID,'')+''' and '''+isnull(@ToAccountID,'')+''' '

		If @IsDate =0 
		  Set @sSQL =@sSQL+' and  (TranMonth + 100*TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) '
		Else
		  Set @sSQL =@sSQL+' and ( VoucherDate  between  '''+Convert(nvarchar(10),@FromDate,101)+''' and  '''+Convert(nvarchar(10),@ToDate,101)+''')  '

		--Print @sSQL (TranMonth + 100*TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) and
			
		Set @sSQLBalance = @sSQLBalance+' From AV4301 V31
					Where  DivisionID ='''+@DivisionID+'''  and
						AccountID between '''+isnull(@FromAccountID,'')+''' and '''+isnull(@ToAccountID,'')+''' '

		---print @sSQL
		---print @sSQLBalance		

		If isnull(@Selection01ID,'') <>'' 
		   Begin
			Exec AP4700 @Selection01ID ,  @Column  output
			Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+isnull(@Selection01From,'')+''' and '''+isnull(@Selection01To,'')+''' ) '
			Set @sSQLBalance = @sSQLBalance+' and ( '+@Column+' Between '''+isnull(@Selection01From,'')+''' and '''+isnull(@Selection01To,'')+''' ) '
		  End 


		If isnull(@Selection02ID,'') <>'' 
		   Begin
			Exec AP4700 @Selection02ID ,  @Column  output
			Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+isnull(@Selection02From,'')+''' and '''+isnull(@Selection02To,'')+''' ) '
			Set 	 @sSQLBalance = @sSQLBalance+' and ( '+@Column+' Between '''+isnull(@Selection02From,'')+''' and '''+isnull(@Selection02To,'')+''' ) '
		  End 


		If isnull(@Selection03ID,'') <>'' 
		   Begin
			Exec AP4700 @Selection03ID ,  @Column  output
			Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+isnull(@Selection03From,'')+''' and '''+isnull(@Selection03To,'')+''' ) '
			Set  @sSQLBalance = @sSQLBalance+ ' and ( '+@Column+' Between '''+isnull(@Selection03From,'')+''' and '''+isnull(@Selection03To,'')+''' ) ' 
		  End 


		If isnull(@Selection04ID,'') <>'' 
		   Begin
			Exec AP4700 @Selection04ID ,  @Column  output
			Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+isnull(@Selection04From,'')+''' and '''+isnull(@Selection04To,'')+''' )  '
			Set @sSQLBalance = @sSQLBalance+ ' and ( '+@Column+' Between '''+isnull(@Selection04From,'')+''' and '''+isnull(@Selection04To,'')+''' )  '
		  End 

		Set @sSQL = @sSQL+@sGroup
		Set @sSQLBalance = @sSQLBalance+@sSQLGroup 

		--Print @sSQLBalance
		--Print @sSQL

		If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4810')
			Exec('Create view AV4810 	--Created by AP4800
					as '+@sSQL)
		Else	
			Exec('Alter view AV4810 		--Created by AP4800
					as '+@sSQL)

		If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4820')
			Exec('Create view AV4820 	--Created by AP4800
					as '+@sSQLBalance)
		Else	
			Exec('Alter view AV4820 		--Created by AP4800
					as '+@sSQLBalance)

		Set @sSQLBalance ='
		Select DivisionID, ObjectID,Group01ID, Group02ID, Group03ID, Group04ID, 
			Case when BeginAmount >0 then abs(BeginAmount) else 0 End as BeginDebitAmount,
			Case when BeginOriginalAmount >0 then abs(BeginOriginalAmount) else 0 End as BeginDebitOriginalAmount,

			Case when BeginAmount <0 then abs(BeginAmount) else 0 End as BeginCreditAmount,
			Case when BeginOriginalAmount <0 then abs(BeginOriginalAmount) else 0 End as BeginCreditOriginalAmount,

			Case when EndAmount > 0  then abs(EndAmount) else 0 End as EndDebitAmount,
			Case when EndOriginalAmount > 0  then abs(EndOriginalAmount) else 0 End as EndDebitOriginalAmount,

			Case when EndAmount < 0  then abs(EndAmount) else 0 End as EndCreditAmount,
			Case when EndOriginalAmount < 0  then abs(EndOriginalAmount) else 0 End as EndCreditOriginalAmount
		From	AV4820  
		--Where BeginAmount<>0 or EndAmount<>0 '


		If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4821')
			Exec('Create view AV4821 	--Created by AP4800
					as '+@sSQLBalance)
		Else	
			Exec('Alter view AV4821 		--Created by AP4800
					as '+@sSQLBalance)

		Set @sSQL =' 	
		Select 	ISNULL(V21.DivisionID, V10.DivisionID) AS DivisionID, 
				Isnull (T02.ObjectName,T03.ObjectName)as ObjectName,  
				V10.AccountID, V10.CorAccountID, Isnull(V10.ObjectID,V21.ObjectID) as ObjectID, V10.VoucherID, V10.VoucherDate, V10.VoucherNo, 
				V10.Serial, V10.InvoiceDate, V10.InvoiceNo,
				V10.DueDate, V10.VDescription, V10.CurrencyIDCN, 
				Isnull (V10.Group01ID, V21.Group01ID) as Group01ID,
				Isnull (V10.Group02ID,V21.Group02ID) as Group02ID, 
				Isnull (V10.Group03ID, V21.Group03ID) as Group03ID ,
				Isnull (V10.Group04ID,V21.Group04ID) as Group04ID,
				V10.D_C, 
				isnull (V10.DebitOriginalAmount,0) as  DebitOriginalAmount,
				Isnull (V10.DebitConvertedAmount,0) as DebitConvertedAmount, 
				Isnull (V10.CreditOriginalAmount,0) as CreditOriginalAmount,
				Isnull (V10.CreditConvertedAmount,0) as CreditConvertedAmount,

				V10.Quantity,		
				isnull(BeginDebitAmount,0) as BeginDebitAmount,
				isnull(BeginDebitOriginalAmount,0) as BeginDebitOriginalAmount,

				isnull(BeginCreditAmount,0) as BeginCreditAmount,
				isnull(BeginCreditOriginalAmount,0) as BeginCreditOriginalAmount,

				isnull(EndDebitAmount,0) as EndDebitAmount,
				isnull(EndDebitOriginalAmount,0) as EndDebitOriginalAmount,
				
				isnull(EndCreditAmount,0) as EndCreditAmount,
				isnull(EndCreditOriginalAmount,0) as EndCreditOriginalAmount  '


		If isnull(@Level01,'') <>'' 
  			Set @sSQL =@sSQL +',  V61.SelectionName as GroupName01 '
		Else
			Set @sSQL =@sSQL +',  ''''  GroupName01 '	

		if left( isnull(@Level01,''),2) ='A0'
			Begin
			
			   Set @join1 =' 
					Left join	AT1011 T1 
						on 		T1.AnaID =  Isnull (V10.Group01ID, V21.Group01ID)  
								and T1.AnaTypeID ='''+@Level01+''' '
			  Set @sSQL= @sSQL+', isnull(T1.Amount01,cast(0 as decimal)) as G1Amount01, isnull(T1.Amount02,cast(0 as decimal)) as G1Amount02,isnull(T1.Amount03,cast(0 as decimal)) as G1Amount03,isnull(T1.Amount04,cast(0 as decimal)) as G1Amount04,isnull(T1.Amount05,cast(0 as decimal)) as G1Amount05,
						isnull(T1.Note01,'''') as G1Note01,isnull(T1.Note02,'''') as G1Note02,isnull(T1.Note03,'''') as G1Note03,isnull(T1.Note04,'''') as G1Note04,isnull(T1.Note05,'''') as G1Note05  '
			End
		Else
			Begin
				Set @Join1 =' '
				Set @sSQL= @sSQL+', cast(0 as decimal) as  G1Amount01, cast(0 as decimal) as  G1Amount02, cast(0 as decimal) as  G1Amount03, cast(0 as decimal) as  G1Amount04, cast(0 as decimal) as G1Amount05,
						N'''' as G1Note01, N'''' as  G1Note02, N'''' as  G1Note03, N'''' as  G1Note04, N'''' as  G1Note05  '

			End
		 

		 
		If isnull(@Level02,'') <>'' 
		  Set @sSQL =@sSQL +',   V62.SelectionName as GroupName02 '		
		Else
			Set @sSQL =@sSQL +' , ''''  GroupName02 '	


		if left( isnull(@Level02,''),2) ='A0'
			Begin
			   Set @join2 =' 
					Left join	AT1011 T2 
						on 		T2.AnaID =  Isnull (V10.Group02ID, V21.Group02ID)  
								and T2.AnaTypeID ='''+@Level02+''' '
			  Set @sSQL= @sSQL+', isnull(T2.Amount01,cast(0 as decimal)) as G2Amount01, isnull(T2.Amount02,cast(0 as decimal)) as G2Amount02,isnull(T2.Amount03,cast(0 as decimal)) as G2Amount03,isnull(T2.Amount04,cast(0 as decimal)) as G2Amount04,isnull(T2.Amount05,cast(0 as decimal)) as G2Amount05,
						isnull(T2.Note01,'''') as G2Note01,isnull(T2.Note02,'''') as G2Note02,isnull(T2.Note03,'''') as G2Note03,isnull(T2.Note04,'''') as G2Note04,isnull(T2.Note05,'''') as G2Note05  '
			End
		Else
			Begin
				Set @Join2 =' '
				Set @sSQL= @sSQL+', cast(0 as decimal) as  G2Amount01, cast(0 as decimal) as  G2Amount02, cast(0 as decimal) as  G2Amount03, cast(0 as decimal) as  G2Amount04, cast(0 as decimal) as G2Amount05,
						N'''' as G2Note01, N'''' as  G2Note02, N'''' as  G2Note03, N'''' as  G2Note04, N'''' as  G2Note05  '

			End


		If isnull(@Level03,'') <>'' 
		  Set @sSQL =@sSQL +',   V63.SelectionName as GroupName03 '		
		Else
		  Set @sSQL =@sSQL +',  ''''  GroupName03 '	

		if left( isnull(@Level03,''),2) ='A0'
			Begin
			   Set @join3 =' Left join  AT1011 T3 on 	T3.AnaID =  Isnull (V10.Group03ID, V21.Group03ID)  and 
								T3.AnaTypeID ='''+@Level03+''' '
			  Set @sSQL= @sSQL+', isnull(T3.Amount01,cast(0 as decimal)) as G3Amount01, isnull(T3.Amount02,cast(0 as decimal)) as G3Amount02,isnull(T3.Amount03,cast(0 as decimal)) as G3Amount03,isnull(T3.Amount04,cast(0 as decimal)) as G3Amount04,isnull(T3.Amount05,cast(0 as decimal)) as G3Amount05,
						isnull(T3.Note01,'''') as G3Note01,isnull(T3.Note02,'''') as G3Note02,isnull(T3.Note03,'''') as G3Note03,isnull(T3.Note04,'''') as G3Note04,isnull(T3.Note05,'''') as G3Note05  '
			End
		Else
			Begin
				Set @Join3 =' '
				Set @sSQL= @sSQL+', cast(0 as decimal) as  G3Amount01, cast(0 as decimal) as  G3Amount02, cast(0 as decimal) as  G3Amount03, cast(0 as decimal) as  G3Amount04, cast(0 as decimal) as G3Amount05,
						N'''' as G3Note01, N'''' as  G3Note02, N'''' as  G3Note03, N'''' as  G3Note04, N'''' as  G3Note05  '

			End


		If isnull(@Level04,'') <>'' 
		  Set @sSQL =@sSQL +',   V64.SelectionName as GroupName04 '		
		Else
		  Set @sSQL =@sSQL +',  ''''  GroupName04 '	

		if left( isnull(@Level04,''),2) ='A0'
			Begin
			   Set @join4 =' Left join  AT1011 T4 on 	T4.AnaID =  Isnull (V10.Group04ID, V21.Group04ID)  and 
								T4.AnaTypeID ='''+@Level04+''' '
			  Set @sSQL= @sSQL+', isnull(T4.Amount01,cast(0 as decimal)) as G4Amount01, isnull(T4.Amount02,cast(0 as decimal)) as G4Amount02,isnull(T4.Amount03,cast(0 as decimal)) as G4Amount03,isnull(T4.Amount04,cast(0 as decimal)) as G4Amount04,isnull(T4.Amount05,cast(0 as decimal)) as G4Amount05,
						isnull(T4.Note01,'''') as G4Note01,isnull(T4.Note02,'''') as G4Note02,isnull(T4.Note03,'''') as G4Note03,isnull(T3.Note04,'''') as G4Note04,isnull(T3.Note05,'''') as G4Note05  '
			End
		Else
			Begin
				Set @Join4 =' '
				Set @sSQL= @sSQL+', cast(0 as decimal) as  G4Amount01, cast(0 as decimal) as  G4Amount02, cast(0 as decimal) as  G4Amount03, cast(0 as decimal) as  G4Amount04, cast(0 as decimal) as G4Amount05,
						N'''' as G4Note01, N'''' as  G4Note02, N'''' as  G4Note03, N'''' as  G4Note04, N'''' as  G4Note05  '

			End



		Set @sSQL =@sSQL+'
			From AV4821 V21 
			LEFT join AV4810 V10  
					on V21.Group01ID = V10.Group01ID and
					V21.Group02ID = V10.Group02ID and
					V21.Group03ID = V10.Group03ID and
					V21.Group04ID = V10.Group04ID and
					V21.ObjectID = V10.ObjectID
			left join AT1202 T02 On T02.ObjectID = V10.ObjectID 
			Left Join At1202 T03 on T03.ObjectID = V21.ObjectID '
		--print @sSQL

		If isnull(@Level01,'') <>''  
		Begin
			Set @sSQL = @sSQL +' left join AV6666 V61 on 	V61.SelectionType ='''+@Level01+''' And
									V61.SelectionID = isnull(V10.Group01ID,V21.Group01ID) 
													 '
			Set @sSQL=@sSQL+' '+@join1

		End

		If isnull(@Level02,'') <>'' 
		begin
			Set @sSQL = @sSQL +' left join AV6666 V62 on 	V62.SelectionType ='''+@Level02+''' And
									V62.SelectionID =  isnull(V10.Group02ID,V21.Group02ID)  '

			Set @sSQL=@sSQL+' '+@join2
		end

		If isnull(@Level03,'') <>'' 
		begin
			Set @sSQL = @sSQL +' left join AV6666 V63 on 	V63.SelectionType ='''+@Level03+''' And
									V63.SelectionID =  isnull(V10.Group03ID,V21.Group03ID)   '

			Set @sSQL=@sSQL+' '+@join3
		end

		If isnull(@Level04,'') <>'' 
		begin
			Set @sSQL = @sSQL +' left join AV6666 V64 on 	V64.SelectionType ='''+@Level04+''' And
									V64.SelectionID = isnull(V10.Group04ID,V21.Group04ID)   '

			Set @sSQL=@sSQL+' '+@join4
		END

		SET @sSQL = @sSQL + '
		WHERE	isnull (V10.DebitOriginalAmount,0)	<> 0
				OR Isnull (V10.DebitConvertedAmount,0) <> 0 
				OR Isnull (V10.CreditOriginalAmount,0) <> 0
				OR Isnull (V10.CreditConvertedAmount,0) <> 0
				OR isnull(BeginDebitAmount,0) <> 0
				OR isnull(BeginDebitOriginalAmount,0) <> 0
				OR isnull(BeginCreditAmount,0) <> 0
				OR isnull(BeginCreditOriginalAmount,0) <> 0
				OR isnull(EndDebitAmount,0) <> 0
				OR isnull(EndDebitOriginalAmount,0) <> 0		
				OR isnull(EndCreditAmount,0) <> 0
				OR isnull(EndCreditOriginalAmount,0) <> 0  '
				

		--print @sSQL

		If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4800')
			Exec('Create view AV4800 	--Created by  AP4800
					as '+@sSQL)
		Else	
			Exec('Alter view AV4800 		--Created by AP4800 
					as '+@sSQL)
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

