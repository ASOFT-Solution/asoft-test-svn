IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4701]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4701]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Bao cao 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/10/2003 by Nguyen Van Nhan
---- 
---- Modified on 01/08/2007 by Nguyen Quoc Huy
---- Modified on 19/01/2012 by Le Thi Thu Hien : CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
---- Modified on 05/04/2013 by Le Thi Thu Hien : Loi 2101
---- Modified on 19/07/2013 by Le Thi Thu Hien : Sửa lại CONVERT theo ngày
---- Modified on 19/02/2014 by Le Thi Thu Hien : Bo sung BD, BC, ED, EC
---- Modified on 10/06/2015 by Bảo Anh : Lấy dữ liệu năm từ tháng bắt đầu niên độ TC
-- <Example>
----

CREATE PROCEDURE [dbo].[AP4701]
	@DivisionID NVARCHAR(50), 
	@ReportCode AS varchar(20),
	@ColumnID AS varchar(20),
	@isDate AS int,
	@FromDate AS datetime,
	@ToDate AS datetime,
	@TranMonthFrom AS int,
	@TranYearFrom AS int,
	@TranMonthTo AS int,
	@TranYearTo AS int,
	@ColumnData AS NVARCHAR(MAX) OUTPUT
AS
Declare @Zero AS decimal(28,8)
Set @Zero = 0.00

Declare
	@ColumnType AS varchar(20),
	@ColumnOriginal AS tinyint,
	@ColumnBudget AS varchar(20),
	@FromAccountID AS varchar(20),
	@ToAccountID AS varchar(20),
	@FromCoAccountID AS varchar(20),
	@ToCoAccountID AS varchar(20),
	@IsUsed AS tinyint,
	@Condition AS varchar(500)

--Print @ColumnOriginal
--Print ' @ColumnBudget '+str(@ColumnBudget)
Select  @ColumnType =   ColumnType,
		@ColumnOriginal=  isnull(IsOriginal,1),
		@ColumnBudget = isnull(ColumnBudget,'AA'),
		@FromAccountID = FromAccountID,
		@ToAccountID = ToAccountID,
		@FromCoAccountID = FromCoAccountID,
		@ToCoAccountID = ToCorAccountID,
		@IsUsed  = isnull(IsUsed,0)
From AT4701
Where ColumnID = @ColumnID and
	ReportCode =@ReportCode  and DivisionID = @DivisionID
--Print ' VAN NHAN'

If @IsUsed =0 
BEgin	
	Set 	@ColumnData =' '+ltrim(rtrim(str(@Zero)))+' '
	--Print ' '+@ColumnData
End
Else
Begin
	IF @ToAccountID IS NOT NULL AND @ToAccountID <> ''
		Set @Condition ='( AccountID between '''+@FromAccountID+''' and '''+@ToAccountID+''') '
	Else
		Set @Condition = ' ( AccountID = AccountID) ' 

	IF @ToCoAccountID IS NOT NULL AND @ToCoAccountID <> ''
		Set @Condition = @Condition+ ' and ( CorAccountID between '''+@FromCoAccountID+''' and '''+@ToCoAccountID+''') '
	Else
		Set @Condition  = @Condition+ ' and  ( CorAccountID = CorAccountID ) ' 

	---Print '	@Condition '+@Condition+' @ColumnOriginal =' +str(@ColumnOriginal)



IF @ColumnType = 'PA'  ---- Hieäu soá phaùt sinh Nôï - phaùt sinh Coù trong kyø
    BEGIN
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10), CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21),101),101) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''T00'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)  >= ''' +  CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' +  CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND (TransactionTypeID <>''T00'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
		IF @ColumnOriginal = 0	
			Begin
				If @isDate =0
					SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''' + 'T00' + ''' OR TransactionTypeID IS NULL)  AND (BudgetID = ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else '+str(@Zero)+' end)'
				If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''' + 'T00' + ''' OR TransactionTypeID IS NULL)  AND (BudgetID = ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else '+str(@Zero)+' end)'
				If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (TransactionTypeID <>''' + 'T00' + ''' OR TransactionTypeID IS NULL)  AND (BudgetID = ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else '+str(@Zero)+' end)'
			end
		ELSE		
			Begin	
				If @isDate =0
					SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''' + 'T00' + ''' OR TransactionTypeID IS NULL) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''' + 'T00' + ''' OR TransactionTypeID IS NULL) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)    + ''' AND (TransactionTypeID <>''' + 'T00' + ''' OR TransactionTypeID IS NULL) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
			End
	END
	RETURN
    END


IF @ColumnType = 'PC' ---- Laáy soá phaùt sinh Coù trong kyø
    BEGIN
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			-- Tấn Phú cập nhật trường hợp nhập số lượng âm 19/07/2011
			--SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''C'')  and '+@Condition+'  then abs(Quantity) else  '+str(@Zero)+' end)'
			SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''C'')  and '+@Condition+'  then Quantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' +  CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''C'')  and '+@Condition+'  then abs(Quantity) else  '+str(@Zero)+' end)'
			SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21) + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' +  CONVERT(VARCHAR(10),@ToDate,21) + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''C'')  and '+@Condition+'  then Quantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(varchar(10), @FromDate,21)   + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''C'')  and '+@Condition+'  then abs(Quantity) else  '+str(@Zero)+' end)'
			SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''C'')  and '+@Condition+'  then Quantity else  '+str(@Zero)+' end)'
		
	End
	ELSE
	BEGIN
		IF @ColumnOriginal = 0	
			Begin
				If @isDate =0
					SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')   and '+@Condition+'  then -SignAmount else  '+str(@Zero)+' end)'
				If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')   and '+@Condition+'  then -SignAmount else  '+str(@Zero)+' end)'
				If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')   and '+@Condition+'  then -SignAmount else  '+str(@Zero)+' end)'
			end

		ELSE			
			Begin	
				If @isDate =0
					SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'') AND (BudgetID =  ''' + @ColumnBudget +''') AND (D_C = ''C'')    and '+@Condition+'  then -SignOriginal else  '+str(@Zero)+' end)'
				If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''T00'') AND (BudgetID =  ''' + @ColumnBudget +''') AND (D_C = ''C'')    and '+@Condition+'  then -SignOriginal else  '+str(@Zero)+' end)'
				If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)    + ''' AND (TransactionTypeID <>''T00'') AND (BudgetID =  ''' + @ColumnBudget +''') AND (D_C = ''C'')    and '+@Condition+'  then -SignOriginal else  '+str(@Zero)+' end)'
			End
	END
	RETURN
    END



IF @ColumnType = 'PD' --- Laáy soá phaùt sinh Nôï trong kyø
BEGIN

	/* Customize lay gia von noi bo cho SieuThanh
	Add by: Dang Le Bao Quynh; Date 25/04/2013
	*/
	Declare @AP4444 Table(CustomerName Int, Export Int)
	Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')
	
	IF @ReportCode = 'UNITSALEREPORT' And @DivisionID = 'STH' And @FromAccountID Like '632%' AND (Select CustomerName From @AP4444)=16
	BEGIN
			IF  @ColumnBudget ='AQ'
			Begin	
				If @isDate =0
					SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
				If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
					SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND (TransactionTypeID <>''T00'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
				If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
					SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (TransactionTypeID <>''T00'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
			End
			ELSE
			BEGIN
				IF @ColumnOriginal = 0	
					Begin
						If @isDate =0
							SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID = ''' + @ColumnBudget +''')  and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
						If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
							SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID = ''' + @ColumnBudget +''')  And '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
						If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
							SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)    + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID = ''' + @ColumnBudget +''')  And '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
					end
				ELSE			
					Begin	
						If @isDate =0
							SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''') And '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
						If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
							SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,101)  + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''') And '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
						If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
							SET @ColumnData = ' sum(case  when isnull(Level01,'''') <> '''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)    + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''') And '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
					End
			END
		RETURN
	END
	ELSE
		BEGIN
			IF  @ColumnBudget ='AQ'
			Begin	
				If @isDate =0
					SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''D'')  and '+@Condition+'  then abs(Quantity) else  '+str(@Zero)+' end)'
				If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''D'')  and '+@Condition+'  then abs(Quantity) else  '+str(@Zero)+' end)'
				If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
					SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (TransactionTypeID <>''T00'')  AND (D_C = ''D'')  and '+@Condition+'  then abs(Quantity) else  '+str(@Zero)+' end)'
			End
			ELSE
			BEGIN
				IF @ColumnOriginal = 0	
					Begin
						If @isDate =0
							SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')   and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
						If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
							SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')   and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
						If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
							SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)    + ''' AND (TransactionTypeID <>''T00'')  AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')   and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
					end
				ELSE			
					Begin	
						If @isDate =0
							SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''') AND (D_C = ''D'')   and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
						If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
							SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,101)  + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''') AND (D_C = ''D'')   and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
						If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
							SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@FromDate,21)    + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''') AND (D_C = ''D'')   and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
					End
			END
		RETURN
		END
	
END

IF @ColumnType = 'BA'  ---- So du trong ky
    BEGIN
	
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + '''  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)   + '''  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + '''  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
	IF @ColumnOriginal = 0	
		Begin
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)   + ''' AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
		end
	ELSE			
		Begin	
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
		End
	END
	RETURN
    END


IF @ColumnType = 'BL' ---- So du no ky truoc
    BEGIN
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''')   and '+@Condition+' then SignQuantity  else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''')   and '+@Condition+'  then SignQuantity  else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''')   and '+@Condition+'  then SignQuantity  else  '+str(@Zero)+' end)'
	End
	ELSE	
	BEGIN
		IF @ColumnOriginal = 0	
		Begin
			If @isDate =0
				SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''')  AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''')  AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''')  AND BudgetID =  ''' + @ColumnBudget +'''  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
		end
		ELSE			
		Begin	
			If @isDate =0
				SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''') AND BudgetID = ''' + @ColumnBudget +'''  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''') AND BudgetID = ''' + @ColumnBudget +'''  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN (TranYear*100+TranMonth <= ''' + str(@TranYearFrom*100+@TranMonthFrom - 1) + ''' OR TransactionTypeID = ''' + 'T00' + ''') AND BudgetID = ''' + @ColumnBudget +'''  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
		End
	END
	RETURN
    END
--------------------------->>>>>>>> SO DU DAU KY

IF @ColumnType = 'BD'  ---- SO DU DAU KY (BEN NO)
    BEGIN
	
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth < ''' + str(@TranYearTo*100+@TranMonthFrom)  + ''' AND (D_C = ''D'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (D_C = ''D'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND (D_C = ''D'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
	IF @ColumnOriginal = 0	
		Begin
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth < ''' + str(@TranYearTo*100+@TranMonthFrom) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
		end
	ELSE			
		Begin	
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth < ''' + str(@TranYearTo*100+@TranMonthFrom) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
		End
	END
	RETURN
    END
IF @ColumnType = 'BC'  ---- SO DU DAU KY (BEN CO)
    BEGIN
	
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth < ''' + str(@TranYearTo*100+@TranMonthFrom) + ''' AND (D_C = ''C'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND (D_C = ''C'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND (D_C = ''C'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
	IF @ColumnOriginal = 0	
		Begin
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth < ''' + str(@TranYearTo*100+@TranMonthFrom) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)  + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21)   + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
		end
	ELSE			
		Begin	
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth < ''' + str(@TranYearTo*100+@TranMonthFrom) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) < ''' + CONVERT(VARCHAR(10),@FromDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
		End
	END
	RETURN
    END
---------------------------<<<<<<<< SO DU DAU KY


--------------------->>>>>>>> SO DU CUOI KY
IF @ColumnType = 'ED'  ---- SO DU CUOI KY (BEN NO)
    BEGIN
	
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo)  + ''' AND (D_C = ''D'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)   + ''' AND (D_C = ''D'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (D_C = ''D'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
	IF @ColumnOriginal = 0	
		Begin
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)   + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
		end
	ELSE			
		Begin	
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''D'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
		End
	END
	RETURN
    END
IF @ColumnType = 'EC'  ---- SO DU CUOI KY (BEN CO)
    BEGIN
	
	IF  @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (D_C = ''C'')  and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)   + ''' AND (D_C = ''C'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND (D_C = ''C'') and '+@Condition+'  then SignQuantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
	IF @ColumnOriginal = 0	
		Begin
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)  + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21)   + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+' then SignAmount else  '+str(@Zero)+' end)'
		end
	ELSE			
		Begin	
			If @isDate = 0
				SET @ColumnData = ' SUM(CASE WHEN TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				SET @ColumnData = ' SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(VARCHAR(10),@ToDate,21) + ''' AND BudgetID =  ''' + @ColumnBudget +''' AND (D_C = ''C'') and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
		End
	END
	RETURN
    END
---------------------<<<<<<<< SO DU CUOI KY

Declare @BeginMonth as int
SELECT @BeginMonth = Month(StartDate) FROM AT1101 WHERE DivisionID = @DivisionID
IF Isnull(@BeginMonth,0) = 0
	SET @BeginMonth = 1

IF @ColumnType = 'YA' --- Laáy soá hieäu soá phaùt sinh trong naêm
    BEGIN
	IF @ColumnOriginal = 0	
	Begin	
		If @isDate =0
			SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)>= ''' + CONVERT(varchar(10), @FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
	End
	ELSE			
		
		Begin
			If @isDate =0
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' +  CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
		end
	RETURN
    END


IF @ColumnType = 'YC' --- Laáy soá phaùt sinh coù trong naêm
    BEGIN
	IF @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			-- TanPhu cập nhất bug khi khách hàng nhập số lượng âm
			-- SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+1) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''C'')   and '+@Condition+' then abs(Quantity) else  '+str(@Zero)+' end)'
			SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''C'')   and '+@Condition+' then Quantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)>= ''' + CONVERT(varchar(10), @FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			-- SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+1) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''C'')   and '+@Condition+' then abs(Quantity) else  '+str(@Zero)+' end)'
			SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''C'')   and '+@Condition+' then Quantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			-- SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+1) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''C'')   and '+@Condition+' then abs(Quantity) else  '+str(@Zero)+' end)'
			SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''C'')   and '+@Condition+' then Quantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
		IF @ColumnOriginal = 0	
		Begin
			If @isDate =0
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')   and '+@Condition+' then abs(SignAmount) else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')   and '+@Condition+' then abs(SignAmount) else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' +  CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')   and '+@Condition+' then abs(SignAmount) else  '+str(@Zero)+' end)'
		end
		ELSE			
		Begin
			If @isDate =0
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')    and '+@Condition+' then abs(SignOriginal) else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')    and '+@Condition+' then abs(SignOriginal) else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' +  CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  AND (D_C = ''C'')    and '+@Condition+' then abs(SignOriginal) else  '+str(@Zero)+' end)'
		end
	END
	RETURN
    END

IF @ColumnType = 'YD' --- Lay so phat sinh no trong nam
    BEGIN
	IF @ColumnBudget ='AQ'
	Begin	
		If @isDate =0
			-- TanPhu cập nhất bug khi khách hàng nhập số lượng âm
			-- SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+1) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''D'')   and '+@Condition+' then abs(Quantity) else  '+str(@Zero)+' end)'
			SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''D'')   and '+@Condition+' then Quantity else  '+str(@Zero)+' end)'
		If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)>= ''' + CONVERT(varchar(10), @FromDate,21)   + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			-- SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+1) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''D'')   and '+@Condition+' then abs(Quantity) else  '+str(@Zero)+' end)'
			SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''D'')   and '+@Condition+' then Quantity else  '+str(@Zero)+' end)'
		If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
			--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			-- SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+1) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''D'')   and '+@Condition+' then abs(Quantity) else  '+str(@Zero)+' end)'
			SET  @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (D_C = ''D'')   and '+@Condition+' then Quantity else  '+str(@Zero)+' end)'
	End
	ELSE
	BEGIN
		IF @ColumnOriginal = 0	
		Begin
			If @isDate =0
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' +  CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' ) AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')  and '+@Condition+'  then SignAmount else  '+str(@Zero)+' end)'
		end
		ELSE			
		Begin
			If @isDate =0
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')  and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =1  --CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,21),21) <= ''' + CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')  and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
			If @isDate =2 --CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21)
				--SET @ColumnData = ' sum(case  when CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) >= ''' + CONVERT(varchar(10), @FromDate,21)    + ''' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),InvoiceDate,21),21) <= ''' +  CONVERT(varchar(10), @ToDate,21)  + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID =  ''' + @ColumnBudget +''')  and '+@Condition+' then SignOriginal else  '+str(@Zero)+' end)'
				SET @ColumnData = ' sum(case  when TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@BeginMonth) + ''' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' AND (TransactionTypeID <>''T00'' )  AND (BudgetID = ''' + @ColumnBudget +''')  AND (D_C = ''D'')  and '+@Condition+'  then SignOriginal else  '+str(@Zero)+' end)'
		end
	END
	RETURN
    END

END


--Print @ColumnData



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON