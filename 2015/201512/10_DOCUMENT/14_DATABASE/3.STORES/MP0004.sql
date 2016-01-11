
/****** Object:  StoredProcedure [dbo].[MP0004]    Script Date: 07/29/2010 17:02:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-----  Created by Nguyen Van Nhan and Nguyen Ngoc My, Date 18/12/2003
----- Purpose: Ket thua bo dinh muc

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
--Last edit by Thiên Huỳnh on 18/05/2012: Lưu bổ sung RateWastage

ALTER PROCEDURE [dbo].[MP0004] 	
					@DivisionID as nvarchar(50), 
					@FromApportionID nvarchar(50), 		--- Bo dinh muc duoc ke thua
					@NewApportionID  as nvarchar(50), 	--- Luu vao bo dinh muc moi
					@TranMonth as int,
					@TranYear as int

 AS
Declare @ApportionProductID as nvarchar(50),
	@App_cur as cursor,
        	@MaterialID nvarchar(50),           
	@ProductID nvarchar(50),            
	@MaterialTypeID nvarchar(50),       
	@Rate decimal(28,8),                  
	@UnitID nvarchar(50),               
	@ExpenseID nvarchar(50),            
	@DiminishPercent      decimal(28,8) ,
	@MaterialAmount decimal(28,8),
	@ProductQuantity Decimal(28,8),                
	@DetailUse nvarchar(250) ,
	@QuantityUnit Decimal(28,8),                  
	@ConvertedUnit Decimal(28,8),                 
	@MaterialQuantity Decimal(28,8),              
	@MaterialUnitID nvarchar(50),      
	@MaterialPrice  Decimal(28,8),                  
	@Description nvarchar(250),
	@CMonth as nvarchar(20) ,
	@CYear as nvarchar(20),
	@RateWastage tinyint
--MA20030000000516
Set @CYear =right(Ltrim(rtrim(str(@TranYear))),4)

SET @App_cur = Cursor Scroll KeySet FOR 

Select
          	MaterialID,
	ProductID,            
	MaterialTypeID,       
	Rate,                  
	UnitID,               
	ExpenseID,            
	DiminishPercent,
	MaterialAmount,
	ProductQuantity,                
	DetailUse,
	QuantityUnit, 
	ConvertedUnit , 
	MaterialQuantity , 
	MaterialUnitID,       
	MaterialPrice,                  
	Description,
	RateWastage 
From MT1603
Where ApportionID =   @FromApportionID
		and DivisionID = @DivisionID
	
OPEN	@App_cur

FETCH NEXT FROM @App_cur INTO  
	@MaterialID,           
	@ProductID,           
	@MaterialTypeID,       
	@Rate,                  
	@UnitID,               
	@ExpenseID,            
	@DiminishPercent,
	@MaterialAmount,
	@ProductQuantity,                
	@DetailUse ,
	@QuantityUnit ,                
	@ConvertedUnit ,                
	@MaterialQuantity ,              
	@MaterialUnitID,      
	@MaterialPrice,                 
	@Description,
	@RateWastage
WHILE @@Fetch_Status = 0
	Begin
		Exec AP0000  @DivisionID, @ApportionProductID  OUTPUT, 'MT1603', 'MA', @CYear ,'',16, 3, 0, '-'	

		Insert MT1603 	(DivisionID, 
				ApportionProductID,
				ApportionID, 
				MaterialID,           
				ProductID,            
				MaterialTypeID,       
				Rate,                  
				UnitID,               
				ExpenseID,            
				DiminishPercent,       
				MaterialAmount,
				ProductQuantity,                
				DetailUse ,
				QuantityUnit ,                  
				ConvertedUnit ,                 
				MaterialQuantity ,              
				MaterialUnitID,       
				MaterialPrice,                  
				Description,
				RateWastage )
		Values (
				@DivisionID,
				@ApportionProductID, 
				@NewApportionID, 
				@MaterialID,           
				@ProductID,           
				@MaterialTypeID,       
				@Rate,                  
				@UnitID,               
				@ExpenseID,            
				@DiminishPercent,       
				@MaterialAmount,
				@ProductQuantity,                
				@DetailUse ,@QuantityUnit ,                
				@ConvertedUnit ,                
				@MaterialQuantity ,              
				@MaterialUnitID,      
				@MaterialPrice,                 
				@Description,
				@RateWastage )		

FETCH NEXT FROM @App_cur INTO  
				@MaterialID,           
				@ProductID,           
				@MaterialTypeID,       
				@Rate,                  
				@UnitID,               
				@ExpenseID,            
				@DiminishPercent,       
				@MaterialAmount,
				@ProductQuantity,                
				@DetailUse ,
				@QuantityUnit ,                
				@ConvertedUnit ,                
				@MaterialQuantity ,              
				@MaterialUnitID,      
				@MaterialPrice,                 
				@Description,
				@RateWastage
End