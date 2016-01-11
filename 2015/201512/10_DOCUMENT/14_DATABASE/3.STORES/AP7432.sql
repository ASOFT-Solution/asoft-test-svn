/****** Object:  StoredProcedure [dbo].[AP7432]    Script Date: 12/28/2010 16:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



----- Created by Nguyen Van Nhan, Date 25/08/2005
----  Xu ly so lieu len to khai thue GTGT

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7432]  
				@DivisionID  NVARCHAR(50), 
				@ReportCodeID NVARCHAR(50), 
				@TranMonth as int, 
				@TranYear int
AS

Declare @Amount as decimal(28, 8),
	@AT7434_cur as cursor,
	@LineID as NVARCHAR(50),	
	@CalculatorID  as NVARCHAR(50),
	@VATGroup  as NVARCHAR(50),
	@VATTypeID1   as NVARCHAR(50),
	@VATTypeID2   as NVARCHAR(50),
	@VATTypeID3   as NVARCHAR(50),
	@AccumulatorID   as NVARCHAR(50),
	@FromAccountID1   as NVARCHAR(50),
	@ToAccountID1   as NVARCHAR(50),
	@FromCorAccountID1   as NVARCHAR(50),
	@ToCorAccountID1   as NVARCHAR(50),
	@FromAccountID2   as NVARCHAR(50),
	@ToAccountID2   as NVARCHAR(50),
	@FromCorAccountID2   as NVARCHAR(50),
	@ToCorAccountID2   as NVARCHAR(50),
	@FromAccountID3   as NVARCHAR(50),
	@ToAccountID3   as NVARCHAR(50),
	@FromCorAccountID3   as NVARCHAR(50),
	@ToCorAccountID3   as NVARCHAR(50),
	@Type as tinyint,
	@LinkID as NVARCHAR(50),
	@ParrentID  as NVARCHAR(50),
	@Sign as NVARCHAR(50)

Set nocount on
SET @AT7434_cur = Cursor Scroll KeySet FOR 
	Select 	LineID, isnull(CalculatorID,''),   isnull(VATGroup,''), isnull(VATTypeID1,''), isnull(VATTypeID2,''), isnull(VATTypeID3,''), isnull(AccumulatorID,''),
		isnull(FromAccountID1,''), isnull(ToAccountID1,''),  isnull(FromCorAccountID1,''), isnull(ToCorAccountID1,''),
		isnull(FromAccountID2,''), isnull(ToAccountID2, ''), isnull(FromCorAccountID2 ,''), isnull(ToCorAccountID2 ,''),
		isnull(FromAccountID3, ''), isnull(ToAccountID3,''), isnull(FromCorAccountID3,''), isnull(ToCorAccountID3,''), Type, sign
 	 From AT7434
	Where 	ReportCodeID = @ReportCodeID 
	And AT7434.DivisionID = @DivisionID
	Order By Orders, Type


OPEN	@AT7434_cur
FETCH NEXT FROM @AT7434_cur INTO  @LineID, @CalculatorID ,@VATGroup,@VATTypeID1,@VATTypeID2,@VATTypeID3,@AccumulatorID,
		@FromAccountID1, @ToAccountID1, @FromCorAccountID1,@ToCorAccountID1,
		@FromAccountID2, @ToAccountID2, @FromCorAccountID2 , @ToCorAccountID2 ,
		@FromAccountID3,  @ToAccountID3, @FromCorAccountID3, @ToCorAccountID3, @Type, @Sign
WHILE @@Fetch_Status = 0
	Begin	

		--Set @LinkID =''	
		--Set @Amount =0
	----	Print '@CalculatorID = '+@CalculatorID
		if ltrim(rtrim(@CalculatorID))<> ''
		    Begin
			--Print 'TEST ' + @CalculatorID+' Line  '+@LineID+' Frm: '+@FromAccountID1
			Exec 	AP7431 @DivisionID, @TranMonth, @TranYear, 
					@CalculatorID, @VATGroup,@VATTypeID1,@VATTypeID2, @VATTypeID3,@AccumulatorID,
					@FromAccountID1, @ToAccountID1, @FromCorAccountID1,@ToCorAccountID1,
					@FromAccountID2, @ToAccountID2, @FromCorAccountID2 , @ToCorAccountID2 ,
					@FromAccountID3,  @ToAccountID3, @FromCorAccountID3, @ToCorAccountID3,
					@Amount output
			---Print ' Gia tri: '+Str(@Amount)
			IF @Type =0
				Update AT7435 set Amount01 = Amount01+  isnull(@Amount,0) 
				Where LineID = @LineID and ReportCodeID =@ReportCodeID
				And DivisionID = @DivisionID
			Else	
				Update AT7435 set Amount02 = Amount02+ isnull(@Amount,0) 
				Where LineID = @LineID and ReportCodeID =@ReportCodeID		
				And DivisionID = @DivisionID
			Set @LinkID =  @AccumulatorID
			--Set @ParrentID = @LineID
			While  @LinkID<>''
				Begin
					--Print ' link: '+@LinkID
					--if @LinkID = '[40]'	print '@Sign' + @Sign+'abc'
					--if @LinkID
					---if @LinkID = '[40]'	print '@Sign  nhan test:' + @Sign+'abc  @LineID'+@LinkID+' Amount: '+str( isnull(@Amount,0) )
					If @Sign ='+'
						IF @Type =0
							Update AT7435 set Amount01 = Amount01+  isnull(@Amount,0) 
							Where Code01 = @LinkID and ReportCodeID =@ReportCodeID
							And DivisionID = @DivisionID
						Else	
							Update AT7435 set Amount02 = Amount02+ isnull(@Amount,0) 
							Where Code02 = @LinkID and ReportCodeID =@ReportCodeID		
							And DivisionID = @DivisionID
					Else
					
						IF @Type =0
						
							Update AT7435 set Amount01 = Amount01-  isnull(@Amount,0) 
							Where Code01 = @LinkID and ReportCodeID =@ReportCodeID
							And DivisionID = @DivisionID
						Else	
							Begin
							Update AT7435 set Amount02 = Amount02- isnull(@Amount,0) 
							Where Code02 = @LinkID and ReportCodeID =@ReportCodeID	
							And DivisionID = @DivisionID
							--if @LinkID = '[40]'	print '@Sign  nhan test:' + @Sign+'abc  @LineID'+@LineID
							End
					Set @Sign = isnull( (select Sign From AT7434  
							Where ReportCodeID = @ReportCodeID and AmountCode = @LinkID and Type = @Type And DivisionID = @DivisionID)   ,'') 
					Set  @LinkID = isnull( ( Select AccumulatorID   From AT7434  
							Where ReportCodeID = @ReportCodeID and AmountCode = @LinkID and Type = @Type And DivisionID = @DivisionID),'')
					
					
				End
		   End		

		FETCH NEXT FROM @AT7434_cur INTO  @LineID, @CalculatorID,@VATGroup,@VATTypeID1,@VATTypeID2,@VATTypeID3, @AccumulatorID ,
		@FromAccountID1, @ToAccountID1, @FromCorAccountID1,@ToCorAccountID1,
		@FromAccountID2, @ToAccountID2, @FromCorAccountID2 , @ToCorAccountID2 ,
		@FromAccountID3,  @ToAccountID3, @FromCorAccountID3, @ToCorAccountID3, @Type, @Sign


	End

Close @AT7434_cur

Set nocount off