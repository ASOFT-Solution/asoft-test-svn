IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7620_ST]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7620_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

  
------------------- Created by Nguyen Van Nhan.  
------------------ Created Date 14/06/2006  
----------------- Purpose: In bao cao bang ket qua kinh doanh. theo ma phan tich  
----------------- Last updated by Van Nhan, date 24/01/2008  
----------------- Edit by: Dang Le Bao Quynh; Date 05/08/2008  
----------------- Sua lai cac quy tac cap nhat dong theo cac toan tu + - * /  
----------------- Edit by: Nguyen Quoc Huy; Date 10/10/2008  
---- Modified by on 11/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID  
---- Modified by on 26/12/2012 by Đặng Lê Bảo Quỳnh : Customize báo cáo LLNBO, lineID = '05.01' cho Sieu Thanh
---- Modified by on 10/03/2015 by Mai Duyen : Fix loi ko len du lieu cho truong hop AnaTypeID=''
---- Modified by on 30/10/2015 by Phuong Thao : Fix loi ko len du lieu truong hop AnaTypeID<>''
     
CREATE PROCEDURE [dbo].[AP7620_ST]   
  @DivisionID AS nvarchar(50),   
  @ReportCode AS nvarchar(50),   
  @FromMonth int,   
  @FromYear  int,   
  @ToMonth int,   
  @ToYear  int,  
  @FromValueID AS nvarchar(50),   
  @ToValueID AS nvarchar(50),  
  @StrDivisionID AS NVARCHAR(4000) = ''  
  
AS  
SET NOCOUNT ON  
Declare @FieldID AS nvarchar(50),  
  @ChildLineID  AS nvarchar(50),  
  @ParLineID  AS nvarchar(50),  
  @ChildSign  AS nvarchar(5),  
  @sSQL AS nvarchar(4000),  
  @FilterMaster AS nvarchar(50),  
  @FilterDetail AS nvarchar(50),  
  @LineID AS nvarchar(50),  
  @LineCode AS nvarchar(50),             
  @LevelID AS int,   
  @LevelID_Pre AS int,   
  @Sign AS nvarchar(5),   
  @AccuLineID AS nvarchar(50),   
  @CaculatorID AS nvarchar(50),   
  @FromAccountID AS nvarchar(50),   
  @ToAccountID AS nvarchar(50),   
  @FromCorAccountID AS nvarchar(50),   
  @ToCorAccountID AS nvarchar(50),    
  @AnaTypeID AS nvarchar(50),    
  @FromAnaID AS nvarchar(50),     
  @ToAnaID AS nvarchar(50),  
  @BudgetID AS nvarchar(50),   
  @Cur_LevelID AS cursor,  
  @Cur_ChildLevelID AS cursor,  
  @Cur AS cursor,  
  @Cur_Ana AS cursor,  
  @Amount01 AS decimal(28,8),  
  @Amount02 AS decimal(28,8),  
  @Amount03 AS decimal(28,8),  
  @Amount04 AS decimal(28,8),  
  @Amount05 AS decimal(28,8),  
  @Amount06 AS decimal(28,8),  
  @Amount07 AS decimal(28,8),  
  @Amount08 AS decimal(28,8),  
  @Amount09 AS decimal(28,8),  
  @Amount10 AS decimal(28,8),  
  @Amount11 AS decimal(28,8),  
  @Amount12 AS decimal(28,8),  
  @Amount13 AS decimal(28,8),  
  @Amount14 AS decimal(28,8),  
  @Amount15 AS decimal(28,8),  
  @Amount16 AS decimal(28,8),  
  @Amount17 AS decimal(28,8),  
  @Amount18 AS decimal(28,8),  
  @Amount19 AS decimal(28,8),  
  @Amount20 AS decimal(28,8),  
  @AnaID AS nvarchar(50),  
  @I  AS INT,  
  @StrDivisionID_New AS NVARCHAR(4000)  
  
  
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' +   
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END  
  
  
SELECT @FieldID = FieldID   
FROM AT7620   
WHERE ReportCode = @ReportCode   
  AND DivisionID = @DivisionID    
  
EXEC AP4700  @FieldID, @FilterMaster output   
  
---Print @FilterMaster  
--- Buoc 1------------------------  
DELETE AT7622
--WHERE DivisionID = @DivisionID  --- Xoa du lieu bang tam  
  
--- Buoc 2   Insert du lieu vao bang tam------------------------  
INSERT AT7622 (DivisionID, ReportCode, LineID)  
SELECT DivisionID, @ReportCode, LineID   
FROM AT7621   
WHERE ReportCode =@ReportCode ---and IsPrint =1  
  and DivisionID =@DivisionID  
  
----Buoc 3 duyet tung cap tu lon den nho  
  
Set @LevelID_Pre = (Select Top 1 LevelID From AT7621 Where ReportCode =@ReportCode and DivisionID =@DivisionID Order by LevelID Desc)  
  
SET @Cur_LevelID= Cursor Scroll KeySet FOR   
 SELECT   DISTINCT LevelID   
 FROM AT7621  
 WHERE ReportCode = @ReportCode and DivisionID = @DivisionID  
 ORDER BY LevelID Desc  
  
OPEN @Cur_LevelID  
FETCH NEXT FROM @Cur_LevelID INTO  @LevelID  
WHILE @@Fetch_Status = 0  
  Begin   
   
---- Buoc 4  Tinh toan va update du lieu bang bang tam ------------------------  
SET @Cur = Cursor Scroll KeySet FOR   
Select  LineID, Sign, AccuLineID, CaculatorID , FromAccountID, ToAccountID, FromCorAccountID,ToCorAccountID,   
   isnull(AnaTypeID,'') zz, isnull(FromAnaID,'') , isnull(ToAnaID,''),  BudgetID  
 From AT7621
--WHERE LineID IN ('05.03','05.04')
 Where ReportCode = @ReportCode and  LevelID = @LevelID and DivisionID = @DivisionID  
  
OPEN @Cur  
FETCH NEXT FROM @Cur INTO  @LineID, @Sign, @AccuLineID, @CaculatorID ,@FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
   @AnaTypeID,@FromAnaID , @ToAnaID, @BudgetID  
WHILE @@Fetch_Status = 0  
  Begin   
 
 If isnull(@AnaTypeID,'')<>''  
 Begin  
 Exec AP4700  @AnaTypeID, @FilterDetail output   
 set @sSQL =' Select Ana01ID, Ana02ID, Ana03ID, ObjectID, PeriodID, TranMonth, TranYear,   
   DivisionID, AccountID, CorAccountID, D_C, SignAmount,   
   SignQuantity, BudgetID, TransactionTypeID,  
   '+@FilterMaster+' AS FilterMaster,  
   '+@FilterDetail+' AS FilterDetail  
   From AV9090  
    '  
 End  
 Else  
 set @sSQL =' Select Ana01ID, Ana02ID, Ana03ID, ObjectID, PeriodID, TranMonth, TranYear,   
   DivisionID, AccountID, CorAccountID, D_C, SignAmount,   
   SignQuantity, BudgetID, TransactionTypeID,  
   '+@FilterMaster+' AS FilterMaster,  
   '''' AS FilterDetail  
   From AV9090  
    '  
 --Print @sSQL  
 If not exists (Select 1 from sysobjects Where Name = 'AV9091' and Xtype ='V')  
       Exec ('  Create View AV9091 AS ' + @sSQL)  
 Else  
       Exec ('  Alter View AV9091  AS ' + @sSQL)  
  
 
 Set @I =1  
 Set @Amount01 =0  set @Amount02 =0 set  @Amount03 =0  set  @Amount04 =0  set  @Amount05 =0  set  @Amount06 =0  set  @Amount07 =0  set  @Amount08 =0  set  @Amount09 =0  set  @Amount10 =0   
 Set @Amount11 =0  set  @Amount12 =0  set  @Amount13 =0  set  @Amount14 =0  set  @Amount15 =0  set  @Amount16 =0  set   @Amount17 =0  set  @Amount18 =0  set  @Amount19 =0  set  @Amount20 =0   
   
  
 SET @Cur_Ana = Cursor Scroll KeySet FOR    
 Select SelectionID From AV6666  
 Where SelectionType= @FieldID   
 --and SelectionID between @FromValueID and @ToValueID   
 AND CONVERT(VARCHAR(4),right(SelectionID,4)) + CONVERT(VARCHAR(2),LEFT(SelectionID,2))  
 BETWEEN CONVERT(VARCHAR(4),right(@FromValueID,4)) + CONVERT(VARCHAR(2),LEFT(@FromValueID,2))  
 AND CONVERT(VARCHAR(4),right(@ToValueID,4)) + CONVERT(VARCHAR(2),LEFT(@ToValueID,2))  
 and DivisionID =@DivisionID  
 order by CONVERT(VARCHAR(4),right(SelectionID,4)) + CONVERT(VARCHAR(2),LEFT(SelectionID,2))  
 Open @Cur_Ana  
 FETCH NEXT FROM @Cur_Ana INTO  @AnaID  
 ---Khoi tao gia tri dau  
 WHILE @@Fetch_Status = 0 and @I<=20  
 Begin  
  /*
  If @ReportCode in ('LLONB','LLONB01','LLONBYTD') And @LineID IN ('05.01','05.02','05.03','05.04','05.05','05.06','05.07')
  Begin
		Select @AnaTypeID = 'A01',@FromAnaID = @AnaID,@ToAnaID = @AnaID
		Select @AnaID = @DivisionID
 end
	*/   
  
  If @ReportCode in ('LLONB','LLONB01','LLONBYTD') And @LineID IN ('05.01') 
	  Begin
		Select @AnaTypeID = 'A01',@FromAnaID = @AnaID,@ToAnaID = @AnaID
		Select @AnaID = @DivisionID
	   end
	eLSE		
		If isnull(@AnaTypeID,'')<>'' 
			Select @AnaTypeID = @AnaTypeID,@FromAnaID = @FromAnaID,@ToAnaID = @ToAnaID
		Else
			Select @AnaTypeID = '',@FromAnaID = '',@ToAnaID = ''
			--Select @AnaID = @DivisionID
			
  
  If @i = 1   
   Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount01 OUTPUT, @StrDivisionID  
  If @i = 2  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount02 output, @StrDivisionID   
  If @i = 3   
   Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount03 output, @StrDivisionID  
  If @i = 4  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount04 output, @StrDivisionID   
  If @i = 5   
 Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount05 output, @StrDivisionID  
  If @i = 6  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount06 output, @StrDivisionID   
  If @i = 7  
   Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount07 output, @StrDivisionID  
  If @i = 8  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount08 output, @StrDivisionID    
  If @i = 9  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount09 output, @StrDivisionID     
  If @i = 10  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount10 output, @StrDivisionID     
  If @i = 11  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount11 output, @StrDivisionID     
  If @i = 12  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount12 output, @StrDivisionID     
  If @i = 13  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount13 output, @StrDivisionID     
  If @i = 14  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount14 output, @StrDivisionID     
  If @i = 15  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount15 output, @StrDivisionID     
  If @i = 16  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount16 output, @StrDivisionID     
  If @i = 17  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount17 output, @StrDivisionID     
  If @i = 18  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount18 output, @StrDivisionID     
If @i = 19  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount19 output, @StrDivisionID     
  If @i = 20  Exec AP7619 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @CaculatorID,   
    @FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
    @AnaTypeID, @FromAnaID , @ToAnaID, @FieldID, @AnaID,@BudgetID,  
    @Amount20 output, @StrDivisionID     
      
  
  Set  @i = @i+1   
  FETCH NEXT FROM @Cur_Ana INTO  @AnaID  
      End  
  Close  @Cur_Ana 

  Update AT7622  set    
    Amount01 = isnull(Amount01,0)+ @Amount01,   
    Amount02 = isnull(Amount02,0)+ @Amount02,  
    Amount03 = isnull(Amount03,0)+ @Amount03,  
    Amount04 = isnull(Amount04,0)+ @Amount04,  
    Amount05 = isnull(Amount05,0)+ @Amount05,  
    Amount06 = isnull(Amount06,0)+ @Amount06,  
    Amount07 = isnull(Amount07,0)+ @Amount07,  
    Amount08 = isnull(Amount08,0)+ @Amount08,  
    Amount09 = isnull(Amount09,0)+ @Amount09,  
    Amount10 = isnull(Amount10,0)+ @Amount10,  
    Amount11 = isnull(Amount11,0)+ @Amount11,  
    Amount12 = isnull(Amount12,0)+ @Amount12,  
    Amount13 = isnull(Amount13,0)+ @Amount13,  
    Amount14 = isnull(Amount14,0)+ @Amount14,  
    Amount15 = isnull(Amount15,0)+ @Amount15,  
    Amount16 = isnull(Amount16,0)+ @Amount16,  
    Amount17 = isnull(Amount17,0)+ @Amount17,  
    Amount18 = isnull(Amount18,0)+ @Amount18,  
    Amount19 = isnull(Amount19,0)+ @Amount19,  
    Amount20 = isnull(Amount20,0)+ @Amount20  
  Where ReportCode=@ReportCode and LineID = @LineID and DivisionID =@DivisionID
    
 --Set @ChildLineID = @AccuLineID  
  --Set @ChildSign = @Sign  
      
  While @LevelID_Pre <> @LevelID and isnull(@LevelID,0)<>0  
   Begin  
      
    --Neu co chi tieu con duoc tinh vao chi tieu nay.  
    SET @Cur_ChildLevelID= Cursor Scroll KeySet FOR   
    SELECT   AT7621.LineID, AT7621.Sign, AT7621.AccuLineID,   
      isnull(Amount01,0), isnull(Amount02,0), isnull(Amount03,0), isnull(Amount04,0), isnull(Amount05,0),   
      isnull(Amount06,0), isnull(Amount07,0), isnull(Amount08,0), isnull(Amount09,0), isnull(Amount10,0),  
      isnull(Amount11,0), isnull(Amount12,0), isnull(Amount13,0), isnull(Amount14,0), isnull(Amount15,0),   
      isnull(Amount16,0), isnull(Amount17,0), isnull(Amount18,0), isnull(Amount19,0), isnull(Amount20,0)  
    FROM AT7621   
    INNER JOIN AT7622 on AT7622.LineID = AT7621.LineID and AT7622.ReportCode = AT7621.ReportCode and AT7622.DivisionID = AT7621.DivisionID  
    WHERE AT7621.DivisionID = @DivisionID and AT7621.ReportCode =@ReportCode and AT7621.LevelID >= @LevelID_Pre  
      and AT7621.AccuLineID in (Select LineID From AT7621 Where ReportCode =@ReportCode and  LevelID= @LevelID AND DivisionID = @DivisionID)  
      
    OPEN @Cur_ChildLevelID  
    FETCH NEXT FROM @Cur_ChildLevelID INTO  @ChildLineID, @ChildSign, @ParLineID,  
          @Amount01, @Amount02, @Amount03, @Amount04, @Amount05, @Amount06, @Amount07, @Amount08, @Amount09, @Amount10,  
          @Amount11, @Amount12, @Amount13, @Amount14, @Amount15, @Amount16, @Amount17, @Amount18, @Amount19, @Amount20  
    WHILE @@Fetch_Status = 0  
      Begin   
     /*  
      if @ChildSign = '/'  
     Begin  
      print '@ChildLineID:' + @ChildLineID  
      print '@ParLineID:' + @ParLineID  
      print '@Amount01:' + str(@Amount01)  
     end   
  
     if @ChildLineID = '600'  
     Begin  
      print '@ChildLineID:' + @ChildLineID  
      print '@ParLineID:' + @ParLineID  
      print '@Amount01:' + str(@Amount01)  
      print '@ChildSign:' + @ChildSign  
     end   
     */  
  
     If @ChildSign =  '+'   
        Update AT7622  Set    
        Amount01 = isnull(Amount01,0)+ @Amount01,   
      Amount02 = isnull(Amount02,0)+ @Amount02,  
        Amount03 = isnull(Amount03,0)+ @Amount03,  
        Amount04 = isnull(Amount04,0)+ @Amount04,  
        Amount05 = isnull(Amount05,0)+ @Amount05,  
        Amount06 = isnull(Amount06,0)+ @Amount06,  
        Amount07 = isnull(Amount07,0)+ @Amount07,  
        Amount08 = isnull(Amount08,0)+ @Amount08,  
        Amount09 = isnull(Amount09,0)+ @Amount09,  
        Amount10 = isnull(Amount10,0)+ @Amount10,  
        Amount11 = isnull(Amount11,0)+ @Amount11,  
        Amount12 = isnull(Amount12,0)+ @Amount12,  
        Amount13 = isnull(Amount13,0)+ @Amount13,  
        Amount14 = isnull(Amount14,0)+ @Amount14,  
        Amount15 = isnull(Amount15,0)+ @Amount15,  
        Amount16 = isnull(Amount16,0)+ @Amount16,  
        Amount17 = isnull(Amount17,0)+ @Amount17,  
        Amount18 = isnull(Amount18,0)+ @Amount18,  
        Amount19 = isnull(Amount19,0)+ @Amount19,  
        Amount20 = isnull(Amount20,0)+ @Amount20  
        Where LineID = @ParLineID and ReportCode = @ReportCode and DivisionID = @DivisionID  
     If @ChildSign =  '-'   
        Update AT7622   set    
        Amount01 = isnull(Amount01,0) - @Amount01,   
        Amount02 = isnull(Amount02,0)- @Amount02,  
        Amount03 = isnull(Amount03,0)- @Amount03,  
        Amount04 = isnull(Amount04,0)- @Amount04,  
        Amount05 = isnull(Amount05,0)- @Amount05,  
        Amount06 = isnull(Amount06,0)- @Amount06,  
        Amount07 = isnull(Amount07,0)- @Amount07,  
        Amount08 = isnull(Amount08,0)- @Amount08,  
        Amount09 = isnull(Amount09,0) - @Amount09,  
        Amount10 = isnull(Amount10,0) - @Amount10,  
        Amount11 = isnull(Amount11,0)- @Amount11,  
        Amount12 = isnull(Amount12,0)- @Amount12,  
        Amount13 = isnull(Amount13,0)- @Amount13,  
        Amount14 = isnull(Amount14,0)- @Amount14,  
        Amount15 = isnull(Amount15,0)- @Amount15,  
        Amount16 = isnull(Amount16,0)- @Amount16,  
        Amount17 = isnull(Amount17,0)- @Amount17,  
        Amount18 = isnull(Amount18,0)- @Amount18,  
        Amount19 = isnull(Amount19,0)- @Amount19,  
        Amount20 = isnull(Amount20,0)- @Amount20  
        Where LineID = @ParLineID and ReportCode = @ReportCode and DivisionID = @DivisionID  
     If @ChildSign =  '*'   
        Update AT7622   set    
        Amount01 = (Case when  isnull(Amount01,0) =0 then 1 else  Amount01 End) * @Amount01,   
        Amount02 = (Case when  isnull(Amount02,0) =0 then 1 else  Amount02 End) * @Amount02,  
        Amount03 = (Case when  isnull(Amount03,0) =0 then 1 else  Amount03 End) * @Amount03,  
        Amount04 = (Case when  isnull(Amount04,0) =0 then 1 else  Amount04 End) * @Amount04,  
        Amount05 = (Case when  isnull(Amount05,0) =0 then 1 else  Amount05 End) * @Amount05,  
        Amount06 = (Case when  isnull(Amount06,0) =0 then 1 else  Amount06 End) * @Amount06,  
        Amount07 = (Case when  isnull(Amount07,0) =0 then 1 else  Amount07 End) * @Amount07,  
        Amount08 = (Case when  isnull(Amount08,0) =0 then 1 else  Amount08 End) * @Amount08,  
        Amount09 = (Case when  isnull(Amount09,0) =0 then 1 else  Amount09 End) * @Amount09,  
        Amount10 = (Case when  isnull(Amount10,0) =0 then 1 else  Amount10 End) * @Amount10,  
        Amount11 = (Case when  isnull(Amount11,0) =0 then 1 else  Amount11 End) * @Amount11,  
        Amount12 = (Case when  isnull(Amount12,0) =0 then 1 else  Amount12 End) * @Amount12,  
        Amount13 = (Case when  isnull(Amount13,0) =0 then 1 else  Amount13 End) * @Amount13,  
        Amount14 = (Case when  isnull(Amount14,0) =0 then 1 else  Amount14 End) * @Amount14,  
        Amount15 = (Case when  isnull(Amount15,0) =0 then 1 else  Amount15 End) * @Amount15,  
        Amount16 = (Case when  isnull(Amount16,0) =0 then 1 else  Amount16 End) * @Amount16,  
      Amount17 = (Case when  isnull(Amount17,0) =0 then 1 else  Amount17 End) * @Amount17,  
        Amount18 = (Case when  isnull(Amount18,0) =0 then 1 else  Amount18 End) * @Amount18,  
        Amount19 = (Case when  isnull(Amount19,0) =0 then 1 else  Amount19 End) * @Amount19,  
        Amount20 = (Case when  isnull(Amount20,0) =0 then 1 else  Amount20 End) * @Amount20  
        Where LineID = @ParLineID and ReportCode = @ReportCode and DivisionID = @DivisionID  
     If @ChildSign =  '/'   
        Update AT7622   set    
        Amount01 = Case When isnull(@Amount01,0) <> 0 Then   
                  Case When isnull(Amount01,0) <> 0 Then   
                   Amount01 / @Amount01   
                  Else 1/ @Amount01 End  
                Else 0 End,   
        Amount02 = Case When isnull(@Amount02,0) <> 0 Then Case When isnull(Amount02,0) <> 0 Then   
                   Amount02 / @Amount02   
                  Else 1/ @Amount02 End  
               Else 0 End,  
        Amount03 = Case When isnull(@Amount03,0) <> 0 Then isnull(Amount03,0) / @Amount03 Else 0 End,  
        Amount04 = Case When isnull(@Amount04,0) <> 0 Then isnull(Amount04,0) / @Amount04 Else 0 End,  
        Amount05 = Case When isnull(@Amount05,0) <> 0 Then isnull(Amount05,0) / @Amount05 Else 0 End,  
        Amount06 = Case When isnull(@Amount06,0) <> 0 Then isnull(Amount06,0) / @Amount06 Else 0 End,  
        Amount07 = Case When isnull(@Amount07,0) <> 0 Then isnull(Amount07,0) / @Amount07 Else 0 End,  
        Amount08 = Case When isnull(@Amount08,0) <> 0 Then isnull(Amount08,0) / @Amount08 Else 0 End,  
        Amount09 = Case When isnull(@Amount09,0) <> 0 Then isnull(Amount09,0) / @Amount09 Else 0 End,  
        Amount10 = Case When isnull(@Amount10,0) <> 0 Then isnull(Amount10,0) / @Amount10 Else 0 End,  
        Amount11 = Case When isnull(@Amount11,0) <> 0 Then isnull(Amount11,0) / @Amount11 Else 0 End,  
        Amount12 = Case When isnull(@Amount12,0) <> 0 Then isnull(Amount12,0) / @Amount12 Else 0 End,  
        Amount13 = Case When isnull(@Amount13,0) <> 0 Then isnull(Amount13,0) / @Amount13 Else 0 End,  
        Amount14 = Case When isnull(@Amount14,0) <> 0 Then isnull(Amount14,0) / @Amount14 Else 0 End,  
        Amount15 = Case When isnull(@Amount15,0) <> 0 Then isnull(Amount15,0) / @Amount15 Else 0 End,  
        Amount16 = Case When isnull(@Amount16,0) <> 0 Then isnull(Amount16,0) / @Amount16 Else 0 End,  
        Amount17 = Case When isnull(@Amount17,0) <> 0 Then isnull(Amount17,0) / @Amount17 Else 0 End,  
        Amount18 = Case When isnull(@Amount18,0) <> 0 Then isnull(Amount18,0) / @Amount18 Else 0 End,  
        Amount19 = Case When isnull(@Amount19,0) <> 0 Then isnull(Amount19,0) / @Amount19 Else 0 End,  
        Amount20 = Case When isnull(@Amount20,0) <> 0 Then isnull(Amount20,0) / @Amount20 Else 0 End  
        Where LineID = @ParLineID and ReportCode = @ReportCode and DivisionID = @DivisionID  
      
  
     FETCH NEXT FROM @Cur_ChildLevelID INTO  @ChildLineID, @ChildSign, @ParLineID,   
        @Amount01, @Amount02, @Amount03, @Amount04, @Amount05, @Amount06, @Amount07, @Amount08, @Amount09, @Amount10,  
        @Amount11, @Amount12, @Amount13, @Amount14, @Amount15, @Amount16, @Amount17, @Amount18, @Amount19, @Amount20  
  
    End  
    Set @LevelID_Pre = @LevelID  
   End  
     
     
     
 FETCH NEXT FROM @Cur INTO  @LineID, @Sign, @AccuLineID, @CaculatorID ,@FromAccountID, @ToAccountID, @FromCorAccountID,@ToCorAccountID,  
      @AnaTypeID, @FromAnaID , @ToAnaID, @BudgetID  
  End  
Close @Cur  
  
FETCH NEXT FROM @Cur_LevelID INTO  @LevelID  
End  
Close @Cur_LevelID  
  
Set nocount off  
  

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

