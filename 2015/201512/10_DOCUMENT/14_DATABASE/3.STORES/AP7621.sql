IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7621]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7621]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------------------- Created by Dang Le Bao Quynh.
------------------ Created Date 18/10/2006
----------------- Purpose: In bao cao bang ket qua kinh doanh. theo ngan sach
----- Modified on 19/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
----- Modified on 22/07/2014 by Bảo Anh : Truyền thêm @AnaID để in theo 1 MPT (ví dụ in KQKD theo ngân sách của 1 bộ phận)

CREATE PROCEDURE [dbo].[AP7621]	 
				@DivisionID as nvarchar(50), 
				@ReportCode as nvarchar(50), 
				@ToMonth int, 
				@ToYear  int,
				@AmountUnit as INT,
				@StrDivisionID AS NVARCHAR(4000) = '',
				@AnaID as nvarchar(50) = ''

AS

Declare @FieldID as nvarchar(50),
		@ParLineID  as nvarchar(50),
		@ParSign  as nvarchar(50),
		@sSQL as nvarchar(4000),
		@FilterMaster as nvarchar(50),
		@FilterDetail as nvarchar(50),
		@LineID   as nvarchar(50),              
		@LineCode     as nvarchar(50),
		@LineDescription     as nvarchar(250), 
		@LevelID as int, 
		@Sign as nvarchar(5), 
		@AccuLineID            as nvarchar(50), 
		@CaculatorID           as nvarchar(50), 
		@FromAccountID         as nvarchar(50), 
		@ToAccountID           as nvarchar(50), 
		@FromCorAccountID      as nvarchar(50), 
		@ToCorAccountID       as nvarchar(50),  
		@AnaTypeID            as nvarchar(50),  
		@FromAnaID           as nvarchar(50),   
		@ToAnaID              as nvarchar(50),
		@BudgetID     as nvarchar(50),
		@Cur as cursor,
		@Cur_Ana as cursor
		
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + REPLACE(@StrDivisionID, ',',''',''') + ''')' END
	
--- Khai bao bo sung mot so bien
Declare
	 @PeriodID as nvarchar(50) ,
	 @Index  as int,
	 @Amount decimal(28,8),
	 @AmountB decimal(28,8),
	 @ActualAmount decimal(28,8),
	 @BudgetAmount decimal(28,8),
	 @RemainBudgetAmount decimal(28,8),
	 @BudgetOfYearAmount	decimal(28,8),
	 @ConvertAmountUnit AS decimal(28,8)
Set Nocount On

IF @AmountUnit = 1
	SET @ConvertAmountUnit =1
IF @AmountUnit = 2
	SET @ConvertAmountUnit =10
IF @AmountUnit = 3
	SET @ConvertAmountUnit =1000
IF @AmountUnit = 4
	SET @ConvertAmountUnit =10000
IF @AmountUnit = 5
	SET @ConvertAmountUnit =100000
 
SELECT @FieldID =FieldID FROM AT7620 WHERE ReportCode = @ReportCode AND DivisionID = @DivisionID

Exec AP4702  @FieldID, @FilterMaster output 

---Print @FilterMaster
--- Buoc 1------------------------
    Delete AT7623   --- Xoa du lieu bang tam

--- Buoc 2   Insert du lieu vao bang tam------------------------
Insert AT7623 (DivisionID, ReportCode, LineID, LineCode, LineDescription, AccuLineID, [Sign],LevelID, IsPrint)
SELECT	@DivisionID, @ReportCode, LineID, LineCode, LineDescription, AccuLineID, [Sign], LevelID, IsPrint 
From	AT7621 
Where	ReportCode =@ReportCode AND DivisionID = @DivisionID-- and IsPrint =1


---- Buoc 3  TInh toan va UPDATE du lieu bang bang tam ------------------------
SET @Cur = Cursor Scroll KeySet FOR 
	SELECT 	LineID, @LineCode, @LineDescription, [Sign], AccuLineID, CaculatorID , FromAccountID, ToAccountID, FromCorAccountID,ToCorAccountID, isnull(AnaTypeID,''), isnull(FromAnaID,'') , isnull(ToAnaID,''),  BudgetID
	From AT7621
	Where ReportCode =@ReportCode AND DivisionID = @DivisionID

OPEN	@Cur
FETCH NEXT FROM @Cur INTO  @LineID, @LineCode, @LineDescription, @Sign, @AccuLineID, @CaculatorID ,@FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,@AnaTypeID,@FromAnaID , @ToAnaID, @BudgetID
WHILE @@Fetch_Status = 0
Begin					
	If @BudgetID='AA'
	Begin
		Set @Index = 1
		Set @ActualAmount = 0
		Set @BudgetAmount = 0
		Set @RemainBudgetAmount = 0
		Set @BudgetOfYearAmount = 0
		
		WHILE @Index <=@ToMonth
			     Begin
				Set @PeriodID = CASE WHEN @Index<10 then '0' + ltrim(@Index) + '/' + ltrim(@ToYear) else ltrim(@Index) + '/' + ltrim(@ToYear) end
					
				Exec AP7622 @DivisionID, @PeriodID, @CaculatorID, 
							@FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,@FilterMaster,@AnaID,
							@AnaTypeID, @FromAnaID , @ToAnaID, @BudgetID, @Amount OUTPUT,@StrDivisionID 
				SET @sSQL = '
					UPDATE AT7623 
					SET Amount' + ltrim(@Index) + ' = ' + ltrim(cast(isnull(@Amount/@ConvertAmountUnit,0) as Numeric))+ ' 
					WHERE LineID = ''' + @LineID + ''' and DivisionID = '''+@DivisionID+''''
				---PRINT(@sSQL)
				EXEC (@sSQL)

				Exec AP7622 @DivisionID, @PeriodID, @CaculatorID, 
						  @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,@FilterMaster,@AnaID,
						  @AnaTypeID, @FromAnaID , @ToAnaID,'M', @AmountB output,@StrDivisionID 

				Set @ActualAmount =  @ActualAmount + isnull(@Amount/@ConvertAmountUnit,0)
				Set @BudgetAmount = @BudgetAmount + isnull(@AmountB/@ConvertAmountUnit,0)
				Set @Index = @Index + 1
			     End
				Set @BudgetOfYearAmount = @BudgetAmount	
				
		WHILE @Index <= 12
			 BEGIN		
				Set @PeriodID = CASE WHEN @Index<10 then '0' + ltrim(@Index) + '/' + ltrim(@ToYear) else ltrim(@Index) + '/' + ltrim(@ToYear) end
				Exec AP7622 @DivisionID, @PeriodID, @CaculatorID, 
						  @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,@FilterMaster,@AnaID,
						  @AnaTypeID, @FromAnaID , @ToAnaID,'M', @Amount output,@StrDivisionID 

				SET @sSQL = '	UPDATE	AT7623 
								SET		Amount' + ltrim(@Index) + ' = ' + ltrim(cast(isnull(@Amount/@ConvertAmountUnit,0) as Numeric)) + ' 
				             	WHERE	LineID = ''' + @LineID + ''' 
				             			AND DivisionID = '''+@DivisionID+''''
				---PRINT(@sSQL)
				Exec (@sSQL)
				Set @RemainBudgetAmount = @RemainBudgetAmount + isnull(@Amount/@ConvertAmountUnit,0)
				Set @BudgetOfYearAmount = @BudgetOfYearAmount + isnull(@Amount/@ConvertAmountUnit,0)
				Set @Index = @Index + 1
			     End

			UPDATE	AT7623 
			SET		Actual = @ActualAmount, 
					Budget = @BudgetAmount, 
					RemainBudget = @RemainBudgetAmount, 
					BudgetOfYear = @BudgetOfYearAmount
			WHERE	LineID = @LineID 
					AND DivisionID = @DivisionID
	End
	
	Else If @BudgetID='B1'
	Begin
		Set @Index = 1
		Set @ActualAmount = 0
		Set @BudgetAmount = 0
		Set @RemainBudgetAmount = 0
		Set @BudgetOfYearAmount = 0
					
		WHILE @Index <=@ToMonth
			Begin
				Set @PeriodID = CASE WHEN @Index<10 then '0' + ltrim(@Index) + '/' + ltrim(@ToYear) else ltrim(@Index) + '/' + ltrim(@ToYear) end
				
				Exec AP7622 @DivisionID, @PeriodID, @CaculatorID, 
							@FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,@FilterMaster,@AnaID,
							@AnaTypeID, @FromAnaID , @ToAnaID,'M', @Amount OUTPUT,@StrDivisionID 
				SET @sSQL = '
					UPDATE AT7623 
					SET Amount' + ltrim(@Index) + ' = ' + ltrim(cast(isnull(@Amount/@ConvertAmountUnit,0) as Numeric))+ ' 
					WHERE LineID = ''' + @LineID + ''' and DivisionID = '''+@DivisionID+''''
				---PRINT(@sSQL)
				EXEC (@sSQL)
				
				Set @Index = @Index + 1
			End
	End
	
	FETCH NEXT FROM @Cur INTO  @LineID, @LineCode, @LineDescription, @Sign, @AccuLineID, @CaculatorID ,@FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,@AnaTypeID, @FromAnaID , @ToAnaID, @BudgetID
  End
Close @Cur

Declare @ParentLineID nvarchar(50),
	@ChildLineID nvarchar(50)

SET @Cur = Cursor Scroll KeySet FOR 
	SELECT 	LineID, Sign, AccuLineID
	From	AT7623 
	WHERE	AccuLineID is not null 
			AND LEN(AccuLineID)>0 
			AND LEN([Sign])>0 
			AND DivisionID = @DivisionID
	Order By LineCode
	
OPEN	@Cur
FETCH NEXT FROM @Cur INTO  @LineID, @Sign, @AccuLineID
WHILE @@Fetch_Status = 0
Begin
	Set @Index = 1
	While @Index<=12
	Begin
		Set @ChildLineID = @LineID
		Set @ParentLineID = @AccuLineID
		--While len(@ParentLineID)>0
			--Begin
				SET @sSQL = 'UPDATE AT7623 SET Amount' + ltrim(@Index) + ' = isnull(Amount' +  ltrim(@Index)
							+ ',0) ' + isnull(@Sign,'+') + 
							CASE WHEN @Sign = '/' then
							' isnull((SELECT CASE WHEN Amount' + ltrim(@Index) +' = 0 then 1 else Amount' + ltrim(@Index) + ' end From At7623 Where LineID = ''' + @LineID + '''),0) ' 
							else
							' isnull((SELECT Amount' + ltrim(@Index) +' FROM AT7623 WHERE LineID = ''' + @LineID + '''),0) ' 
							end
							+ ' Where LineID = ''' + @ParentLineID + ''' and DivisionID = '''+@DivisionID+''''
				Print @sSQL
				Exec(@sSQL)
				--Cap nhat cho cac chi tieu tong
				IF @Index=12
					Begin
						SET @sSQL = 'UPDATE AT7623 SET Actual = isnull(Actual'   
										+ ',0) ' + isnull(@Sign,'+') + 
										CASE WHEN @Sign = '/' then
										' isnull((SELECT CASE WHEN Actual=0 then 1 else Actual end From At7623 Where LineID = ''' + @LineID + '''),1) '
										else 
										' isnull((SELECT Actual From At7623 Where LineID = ''' + @LineID + '''),0) ' 
										end
								+ ' Where LineID = ''' + @ParentLineID + ''' and DivisionID = '''+@DivisionID+''''
							PRINT(@sSQL)
							Exec(@sSQL)
						SET @sSQL = 'UPDATE AT7623 SET Budget = isnull(Budget'   
										+ ',0) ' + isnull(@Sign,'+') + 
										CASE WHEN @Sign = '/' then
										' isnull((SELECT CASE WHEN Budget=0 then 1 else Budget end From At7623 Where LineID = ''' + @LineID + '''),1) '
										else 
										' isnull((SELECT Budget From At7623 Where LineID = ''' + @LineID + '''),0) ' 
										end
										+ ' Where LineID = ''' + @ParentLineID + ''' and DivisionID = '''+@DivisionID+''''
							PRINT(@sSQL)
							Exec(@sSQL)
						SET @sSQL = 'UPDATE AT7623 SET RemainBudget = isnull(RemainBudget'   
										+ ',0) ' + isnull(@Sign,'+') + 
										CASE WHEN @Sign = '/' then
										' isnull((SELECT CASE WHEN RemainBudget=0 then 1 else RemainBudget end From At7623 Where LineID = ''' + @LineID + '''),1) '
										else 
										' isnull((SELECT RemainBudget From At7623 Where LineID = ''' + @LineID + '''),0) ' 
										end
										+ ' Where LineID = ''' + @ParentLineID + ''' and DivisionID = '''+@DivisionID+''''
							PRINT(@sSQL)
							Exec(@sSQL)
						SET @sSQL = 'UPDATE AT7623 SET BudgetOfYear = isnull(BudgetOfYear'   
										+ ',0) ' + isnull(@Sign,'+') + 
										CASE WHEN @Sign = '/' then
										' isnull((SELECT CASE WHEN BudgetOfYear=0 then 1 else BudgetOfYear end From At7623 Where LineID = ''' + @LineID + '''),1) '
										else 
										' isnull((SELECT BudgetOfYear From At7623 Where LineID = ''' + @LineID + '''),0) ' 
										end
										+ ' Where LineID = ''' + @ParentLineID + ''' and DivisionID = '''+@DivisionID+''''
							PRINT(@sSQL)
							Exec(@sSQL)
					End
				/*Set @ChildLineID = @ParentLineID
				If exists (SELECT AccuLineID From AT7623 Where
						LineID = @ChildLineID And 
						AccuLineID is not null and len(AccuLineID)>0)

					 SELECT @ParentLineID = AccuLineID, @Sign = [Sign] From AT7623 
						Where LineID = @ChildLineID And AccuLineID is not null and len(AccuLineID)>0
				Else
					Set @ParentLineID = ''
			End
			*/
		Set @Index = @Index + 1
	End

	FETCH NEXT FROM @Cur INTO  @LineID, @Sign, @AccuLineID
End

Set Nocount Off

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

