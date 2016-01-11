/****** Object:  StoredProcedure [dbo].[HP9999]    Script Date: 02/17/2012 10:22:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP9999]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP9999]
GO

/****** Object:  StoredProcedure [dbo].[HP9999]    Script Date: 02/17/2012 10:22:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Nguyen Van Nhan, Date 08/05/2004  
----- Purpose: Khoa so ky ke toan  
---- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101   
  
/********************************************  
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]  
'********************************************/  
  
  
CREATE PROCEDURE [dbo].[HP9999]   
  @DivisionID nvarchar(50),   
  @TranMonth as int,   
  @TranYear as int,  
  @BeginDate as datetime,  
  @EndDate as datetime   
   
 AS  
  
  
Declare @Closing As tinyint,  
 @NextMonth  TinyInt,  
 @NextYear  Smallint,  
 @PeriodNum  TinyInt,  
 @MaxPeriod Int   
   
   
 Select  @PeriodNum = PeriodNum  
 From AT1101 ---HT9000
 where DivisionID=@DivisionID

 If @PeriodNum Is Null   
  Set @PeriodNum = 12  
  
 Set @NextMonth = @TranMonth % @PeriodNum + 1  
 Set @NextYear = @TranYear + @TranMonth/@PeriodNum  
  
 Select   @Closing = Closing  
 From  HT9999  
 Where  DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear  
    
 Select  @MaxPeriod = Max(TranMonth + TranYear * 100)  
  From HT9999  
 Where DivisionID = @DivisionID  
  
 If  @Closing <> 1   
 Begin  
    
    
  Update  HT9999  
  Set  Closing = 1  
  From  HT9999  
  Where  DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear  
  
  IF @MaxPeriod < (@NextMonth + @NextYear * 100)  
  Begin  
   Insert     HT9999  (TranMonth,TranYear, DivisionID,Closing,BeginDate,EndDate)   
   Values(@NextMonth,@NextYear, @DivisionID,0,@BeginDate,@EndDate)  
   If Exists (Select 1 From HT0000 Where DivisionID = @DivisionID)  
   Begin  
    Update HT0000 Set  TranMonth = @NextMonth,  TranYear = @NextYear  
     Where  DivisionID = @DivisionID   
   End  
  
  End  
  IF @MaxPeriod >= (@NextMonth + @NextYear * 100)  
  Begin   
   Update  HT9999  Set  BeginDate = @BeginDate,  EndDate = @EndDate  
   From  HT9999  
   Where  DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear  
  end     
   
   
 End


