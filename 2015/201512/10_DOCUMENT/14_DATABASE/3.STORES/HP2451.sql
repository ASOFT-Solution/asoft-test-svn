IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2451]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2451]
GO
 -------Create by: Dang Le Bao Quynh; Date: 14/12/2006  
-------Purpose: Chuyen so lieu tu dong cho tung cong doan.  
-------Ma cong doan  
------- SPR : Cong doan In  
------- SZN: Cong doan kem hay len bang  
------- SFA: Cong doan xu ly be mat  
------- SPL: Cong doan ma  
------- SSH: Cong doan be  
------- SPA: Cong doan dan  
  
CREATE PROCEDURE HP2451  
 @DivisionID nvarchar(50),  
 @PeriodID nvarchar(50),  
 @TranMonth int,  
 @TranYear int,  
 @FileType int, -- Loai bao bi  
 @ToStepID nvarchar(50),  
 @UserID nvarchar(50)  
AS  
  
Declare @sSQL varchar(4000)  
If @FileType = 1  
 Begin  
  If @ToStepID = 'SZN'  
   Begin  
    UPDATE HT2450  
    SET SZN_Amount = isnull(SZN_UnitPrice,0) * Color  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And  (SZN_Amount = 0 Or SZN_Amount Is Null)  
   End  
  If @ToStepID = 'SFA'  
   Begin  
    UPDATE HT50 Set SFA_UnitPrice = OT05.UnitPrice05  
     FROM HT2450 HT50 Inner Join OT1305 OT05 On HT50.ObjectID = OT05.ObjectID And HT50.InventoryID = OT05.ProductID  And HT50.DivisionID = OT05.DivisionID  
    Where HT50.SFA_UnitPrice = 0 or HT50.SFA_UnitPrice Is null  
    And HT50.TranMonth = @TranMonth  
    And HT50.TranYear = @TranYear  
    And HT50.FileType = @FileType  
    and HT50.DivisionID = @DivisionID
  
    UPDATE HT2450  
    SET SFA_RQuantity =  Case When SFA_UnitPrice>0 Then  
        SPR_CQuantity  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SFA_RQuantity = 0 Or SFA_RQuantity is Null)  
  
    UPDATE HT2450  
    SET SFA_CQuantity =  SFA_RQuantity  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SFA_CQuantity = 0 Or SFA_CQuantity is Null)  
  
    UPDATE HT2450  
    SET SFA_LossRate =  Case When SFA_RQuantity>0 Then  
        ((SFA_RQuantity - isnull(SFA_CQuantity,0))/SFA_RQuantity)*100  
       Else  
        0  
       End  
	Where DivisionID = @DivisionID
	
    UPDATE HT2450  
    SET SFA_AQuantity = Case When SFA_UnitPrice>0 Then  
         isnull((Select AValue From HT2452 Where StepID = 'SFA' And DivisionID = @DivisionID And SFA_CQuantity Between FromCValue And ToCValue),SFA_CQuantity)  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SFA_AQuantity = 0 Or SFA_AQuantity is Null)  
  
    UPDATE HT2450  
    SET SFA_Amount = isnull(SFA_UnitPrice,0) * isnull(SFA_AQuantity,0)  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And  (SFA_Amount = 0 Or SFA_Amount Is Null)  
   End    
  If @ToStepID = 'SPL'  
   Begin  
    UPDATE HT50 Set SPL_UnitPrice = OT05.UnitPrice03  
     FROM HT2450 HT50 Inner Join OT1305 OT05 On HT50.ObjectID = OT05.ObjectID And HT50.InventoryID = OT05.ProductID And HT50.DivisionID = OT05.DivisionID  
    Where HT50.SPL_UnitPrice = 0 or HT50.SPL_UnitPrice Is null  
    And HT50.TranMonth = @TranMonth  
    And HT50.TranYear = @TranYear  
    And HT50.FileType = @FileType  
  
    UPDATE HT2450  
    SET SPL_RQuantity =  Case When SPL_UnitPrice>0 Then  
        Case When SFA_UnitPrice > 0 Then  
         SFA_CQuantity * ProductNumber  
        Else  
         SPR_CQuantity * ProductNumber  
        End  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SPL_RQuantity = 0 Or SPL_RQuantity is Null)   
  
    UPDATE HT2450  
    SET SPL_CQuantity =  SPL_RQuantity  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SPL_CQuantity = 0 Or SPL_CQuantity is Null)  
  
    UPDATE HT2450  
    SET SPL_LossRate =  Case When SPL_RQuantity>0 Then  
        ((SPL_RQuantity - isnull(SPL_CQuantity,0))/SPL_RQuantity)*100  
       Else  
        0  
       End  
    Where DivisionID = @DivisionID
  
    UPDATE HT2450  
    SET SPL_AQuantity = Case When SPL_UnitPrice>0 Then  
         isnull((Select AValue From HT2452 Where StepID = 'SPL' and DivisionID = @DivisionID And SPL_CQuantity Between FromCValue And ToCValue),SPL_CQuantity)  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SPL_AQuantity = 0 Or SPL_AQuantity is Null)  
  
    UPDATE HT2450  
    SET SPL_Amount = isnull(SPL_UnitPrice,0) * isnull(SPL_AQuantity,0)  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And  (SPL_Amount = 0 Or SPL_Amount Is Null)  
   End  
  If @ToStepID = 'SSH'  
   Begin  
    UPDATE HT50 Set SSH_UnitPrice = OT05.UnitPrice01  
     FROM HT2450 HT50 Inner Join OT1305 OT05 On HT50.ObjectID = OT05.ObjectID And HT50.InventoryID = OT05.ProductID And HT50.DivisionID = OT05.DivisionID 
    Where HT50.SSH_UnitPrice = 0 or HT50.SSH_UnitPrice Is null  
    And HT50.TranMonth = @TranMonth  
    And HT50.TranYear = @TranYear  
    And HT50.FileType = @FileType  
    And HT50.DivisionID = @DivisionID
  
    UPDATE HT2450  
    SET SSH_RQuantity =  Case When SSH_UnitPrice>0 Then  
        Case When SPL_UnitPrice > 0 Then  
         SPL_CQuantity  
        Else  
         Case When SFA_UnitPrice > 0 Then  
          SFA_CQuantity * ProductNumber  
         Else  
          SPR_CQuantity * ProductNumber  
         End  
        End  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SSH_RQuantity = 0 Or SSH_RQuantity is Null)  
  
    UPDATE HT2450  
    SET SSH_CQuantity =  SSH_RQuantity  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SSH_CQuantity = 0 Or SSH_CQuantity is Null)  
  
    UPDATE HT2450  
    SET SSH_LossRate =  Case When SSH_RQuantity>0 Then  
        ((SSH_RQuantity - isnull(SSH_CQuantity,0))/SSH_RQuantity)*100  
       Else  
        0  
       End  
    WHERE  DivisionID = @DivisionID  
  
    UPDATE HT2450  
    SET SSH_AQuantity = Case When SSH_UnitPrice>0 Then  
         isnull((Select AValue From HT2452 Where StepID = 'SSH' And DivisionID = @DivisionID And SSH_CQuantity Between FromCValue And ToCValue),SSH_CQuantity)  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SSH_AQuantity = 0 Or SSH_AQuantity is Null)  
  
    UPDATE HT2450  
    SET SSH_Amount = isnull(SSH_UnitPrice,0) * isnull(SSH_AQuantity,0)  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And  (SSH_Amount = 0 Or SSH_Amount Is Null)  
   End  
  If @ToStepID = 'SPA'  
   Begin  
    UPDATE HT50 Set SPA_UnitPrice = OT05.UnitPrice02  
     FROM HT2450 HT50 Inner Join OT1305 OT05 On HT50.ObjectID = OT05.ObjectID And HT50.InventoryID = OT05.ProductID And HT50.DivisionID = OT05.DivisionID  
    Where HT50.SPA_UnitPrice = 0 or HT50.SPA_UnitPrice Is null  
    And HT50.TranMonth = @TranMonth  
    And HT50.TranYear = @TranYear  
    And HT50.FileType = @FileType  
    And HT50.DivisionID = @DivisionID
  
    UPDATE HT2450  
    SET SPA_RQuantity =  Case When SPA_UnitPrice>0 Then  
        Case When SSH_UnitPrice>0 Then  
         SSH_CQuantity  
        Else  
         Case When SPL_UnitPrice > 0 Then  
          SPL_CQuantity  
         Else  
          Case When SFA_UnitPrice > 0 Then  
           SFA_CQuantity * ProductNumber  
          Else  
           SPR_CQuantity * ProductNumber  
          End  
         End  
        End  
       Else  
        NULL  
       End  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SPA_RQuantity = 0 Or SPA_RQuantity is Null)  
  
    UPDATE HT2450  
    SET SPA_CQuantity =  SPA_RQuantity  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SPA_CQuantity = 0 Or SPA_CQuantity is Null)  
  
    UPDATE HT2450  
    SET SPA_LossRate =  Case When SPA_RQuantity>0 Then  
        ((SPA_RQuantity - isnull(SPA_CQuantity,0))/SPA_RQuantity)*100  
       Else  
        0  
       End  
	WHERE  DivisionID = @DivisionID  
  
    UPDATE HT2450  
    SET SPA_AQuantity = Case When SPA_UnitPrice>0 Then  
         isnull((Select AValue From HT2452 Where StepID = 'SPA' And DivisionID = @DivisionID And SPA_CQuantity Between FromCValue And ToCValue),SPA_CQuantity)  
       Else  
        NULL  
       End         
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And (SPA_AQuantity = 0 Or SPA_AQuantity is Null)  
  
    UPDATE HT2450  
    SET SSH_Amount = isnull(SSH_UnitPrice,0) * isnull(SSH_AQuantity,0)  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And  (SPA_Amount = 0 Or SPA_Amount Is Null)  
   End     
 End  
Else  
 Begin  
  If @ToStepID = 'SZN'  
   Begin  
    UPDATE HT2450  
    SET SZN_Amount = isnull(SZN_UnitPrice,0) * Color  
    WHERE  DivisionID = @DivisionID  
    And PeriodID = @PeriodID  
    And TranMonth =@TranMonth  
    And TranYear = @TranYear   
    And  FileType = @FileType  
    And  (SZN_Amount = 0 Or SZN_Amount Is Null)  
   End    
 End  