----- Created by Nguyen Van Nhan, Date 09/08/2003  
----- Purpose: Khoa so ky ke toan  
----- Edit by Nguyen Quoc Huy, Date 28/02/2004  
----- Edit by Khanh Van, date 08/08/2013: them vao dieu kien divisionid
----- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101  
/********************************************  
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]  
'********************************************/  
  
alter PROCEDURE [dbo].[AP9999] @DivisionID nvarchar(50),   
    @TranMonth as int,   
    @TranYear as int,  
    @BeginDate as datetime,  
    @EndDate as datetime  
   
 AS  
  
  
Declare @Closing As Bit,  
 @NextMonth  TinyInt,  
 @NextYear  Smallint,  
 @PeriodNum  TinyInt,  
 @MaxPeriod Int   
   
   
 Select  @PeriodNum = PeriodNum  
 From AT1101 ---AT0001
 Where  DivisionID = @DivisionID

 If @PeriodNum Is Null   
  Set @PeriodNum = 12
   
  
 Set @NextMonth = @TranMonth % @PeriodNum + 1  
 Set @NextYear = @TranYear + @TranMonth/@PeriodNum  
  
 Select   @Closing = Closing  
 From  AT9999  
 Where  DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear  
    
 Select  @MaxPeriod = Max(TranMonth + TranYear * 100)  
  From AT9999  
 Where DivisionID = @DivisionID  
  
 If  @Closing <> 1   
 Begin  
    
    
  Update  AT9999  
  Set  Closing = 1  
  From  AT9999  
  Where  DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear  
  
  IF @MaxPeriod < (@NextMonth + @NextYear * 100)  
  Begin  
   Insert     AT9999  (TranMonth,TranYear, DivisionID,Closing, BeginDate, EndDate)   
   Values(@NextMonth,@NextYear, @DivisionID,0,@BeginDate, @EndDate)  
  
   If Exists (Select 1 From AT0000 Where DefDivisionID = @DivisionID)  
   Begin  
    Update AT0000  
    Set  DefTranMonth = @NextMonth,  
     DefTranYear = @NextYear 
     Where  DefDivisionID = @DivisionID    
   End  
  
  /*  
   Insert  AT2008  (InventoryID,WarehouseID,TranMonth,TranYear,DivisionID, InventoryAccountID,  
      BeginQuantity, BeginAmount,  
      DebitQuantity, DebitAmount,  
      CreditQuantity, CreditAmount,  
      EndQuantity, EndAmount, UnitPrice)  
   Select  InventoryID,WareHouseID,@NextMonth,@NextYear,DivisionID,  InventoryAccountID,  
      EndQuantity, EndAmount,  
      0,0,  
      0,0,  
      EndQuantity, EndAmount, UnitPrice  
   From  AT2008  
   Where  DivisionID = @DivisionID And   
    TranMonth = @TranMonth And   
    TranYear = @TranYear And   
    (Select Count(*)  From  AT2008 T8  
     Where  T8.TranMonth = @NextMonth And T8.TranYear = @NextYear And   
      T8.DivisionID = AT2008.DivisionID And   
      T8.InventoryID = AT2008.InventoryID And   
      T8.WareHouseID = AT2008.WareHouseID) = 0  
  */  
  
  End  
    
  IF @MaxPeriod >= (@NextMonth + @NextYear * 100)  
  Begin   
   Update  AT9999  
   Set  BeginDate = @BeginDate,  
    EndDate = @EndDate  
   From  AT9999  
   Where  DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear  
  end  
  
  /* Rem by Dang Le Bao Quynh  
  While    @MaxPeriod >= (@NextMonth + @NextYear * 100)  
  Begin  
   Exec  AP9998 @DivisionID, @TranMonth, @TranYear,@NextMonth , @NextYear  
   Select   @TranMonth = @NextMonth, @TranYear = @NextYear  
   Set @NextMonth = @TranMonth % @PeriodNum + 1  
   Set @NextYear = @TranYear + @TranMonth/@PeriodNum     
  End  
  */  
   
 End