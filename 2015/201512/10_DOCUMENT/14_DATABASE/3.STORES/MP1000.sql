/****** Object:  StoredProcedure [dbo].[MP1000]    Script Date: 12/06/2010 11:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--Created by Hoang Thi Lan
--Date  Created date  04/12/2003
--Purpose : Kiem tra khoa ngoai  cac bang danh muc
--Edit by Nguyen Quoc Huy, Data 20/08/2008
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP1000] 	@DivisionID as nvarchar(50),					
					@TableID as nvarchar(50),
					@KeyValue as nvarchar(50),
					@ComputerName as nvarchar(50),
					@Language as nvarchar(50)
		
 AS
Declare @Status as tinyint ,
		@Message as nvarchar(250)	

Set nocount on
Delete From MT7777 Where ComputerName = @ComputerName
Set @Status = 0 
--@Status = 0: Cho phep Edit, Delete
--@Status = 1: Thong bao Yes/No Cho phep Edit
--@Status = 2: Khong cho phep Edit, Delete. Thong bao Yes/No Cho phep Xem

--Danh muc Doi tuong THCP
--------------------------------------------------------------------------
If @TableID = 'MT1601'
  If exists ( Select top 1 1  From MT1601  Where PeriodID = @KeyValue )
	Begin		
		If exists (Select top 1 1  From MT1601  Where PeriodID = @KeyValue and IsDistribute =1 )
			Begin
				Set @Status =2
				Set @Message = 'MFML000005' 
			End 
		Else 
			 If exists (Select top 1 1  From MT1601  Where PeriodID = @KeyValue and IsCost  =1 )
				Begin
					Set @Status =2
					Set @Message = 'MFML000005' 
				End 
			Else 
				If exists (Select top 1 1  From MT1601  Where PeriodID= (Select top 1 PeriodID  From MT1609  Where ChildPeriodID= @KeyValue) And isDistribute=1)
					Begin
						Set @Status = 2
						Set @Message = 'MFML000006' 
					End 
				Else
					If  Exists (Select Top 1 1 From MT0400 Where PeriodID = @KeyValue)
						and not exists (Select top 1 1  From MT1601  Where PeriodID = @KeyValue and IsInProcess =1)
						Begin
							Set @Status =1
							Set @Message = 'MFML000007'
						End 
					Else		
						If Exists (Select Top 1 1 From MV9000 Where PeriodID =@KeyValue and DivisionID = @DivisionID)
							Begin
								Set @Status =1
								Set @Message = 'MFML000008' 
							End 
							
		If Not Exists (Select Top 1 1 From MV9000 Where PeriodID =@KeyValue and DivisionID = @DivisionID)
			Begin
				Set @Status =0
				Set @Message = 'MFML000030' 		
			End 
		
		If  Exists (Select Top 1 1 From MT1607 Where PeriodID =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000008' 		
			End 
		
		--Khai bao chi phi ASOFT-T
		If  Exists (Select Top 1 1 From AT1703  Where PeriodID =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009' 
			End 
		
		If  Exists (Select Top 1 1 From AT1503  Where PeriodID01 =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009'		
			End 

		If  Exists (Select Top 1 1 From AT1503  Where PeriodID02 =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009' 
			End 

		If  Exists (Select Top 1 1 From AT1503  Where PeriodID03 =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009' 
			End 

		If  Exists (Select Top 1 1 From AT1503  Where PeriodID04 =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009' 
			End 

		If  Exists (Select Top 1 1 From AT1503  Where PeriodID05 =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009' 
			End 

		If  Exists (Select Top 1 1 From AT1503  Where PeriodID06 =@KeyValue)
			Begin
				Set @Status =1
				Set @Message = 'MFML000009' 
			End 
	End

--Danh muc Bo He So Theo San Pham
--------------------------------------------------------------------------
If @TableID = 'MT1604'
  If  Exists (Select Top  1 1 From MT1604 Where CoefficientID = @KeyValue)
	Begin 
		If Exists (Select Top 1 1 From MT0400 inner join MT1601 on MT0400.PeriodID = MT1601.PeriodID
									  inner join MT5001 on MT1601.DistributionID = MT5001.DistributionID	
					and MT0400.DivisionID = @DivisionID and  MT5001. CoefficientID = @KeyValue
			) 		
			Begin	 
				Set @Status =2
				Set @Message = 'MFML000010' 
			End 
		Else

		If Exists (Select Top  1 1 From MT5001 Where CoefficientID = @KeyValue )
			Begin 
				
				Set @Status =1
				Set @Message = 'MFML000010' 
			End 	
		
		Else
		
		If Not exists (Select Top  1 1 From MT5001 Where CoefficientID = @KeyValue)
			Begin 
				Set @Status =0
				Set @Message = 'MFML000011' 
			End 		
	End
	
--Danh muc Bo he So Theo Doi Tuong
--------------------------------------------------------------------------
If @TableID = 'MT1606'
  If  Exists (Select Top  1 1 From MT1606 Where CoefficientID = @KeyValue)
	Begin 
		If Exists (Select Top 1 1 From MT0400 inner join MT1601 on MT0400.PeriodID = MT1601.PeriodID
									  inner join MT5001 on MT1601.DistributionID = MT5001.DistributionID	
					and MT0400.DivisionID = @DivisionID and  MT5001. CoefficientID = @KeyValue
			) 		
			Begin	 
				Set @Status =2
				Set @Message = 'MFML000012' 
			End 
		Else
			If Exists (Select Top 1 1 From MT1601  Where CoefficientID = @KeyValue And IsForPeriodID=1 And IsDistribute=1)		
				Begin	 
					Set @Status =2
					Set @Message = 'MFML000013' 
				End 
		Else		
			If Exists (Select Top  1 1 From MT5001 Where CoefficientID = @KeyValue )
				Begin 			
					Set @Status =1
					Set @Message = 'MFML000014' 
				End 	
		Else	
			If Not exists (Select Top  1 1 From MT5001 Where CoefficientID = @KeyValue)
				Begin 
					Set @Status =0
					Set @Message = 'MFML000011' 
				End 	
	End
	
--Danh muc Bo Dinh Muc
--------------------------------------------------------------------------
If @TableID = 'MT1602'
  If  Exists (Select Top  1 1 From MT1602 Where ApportionID = @KeyValue)
	Begin 
		If Exists (Select Top 1 1 From MT0400 inner join MT1601 on MT0400.PeriodID = MT1601.PeriodID
									  inner join MT5001 on MT1601.DistributionID = MT5001.DistributionID	
					and MT0400.DivisionID = @DivisionID and  MT5001. ApportionID = @KeyValue
			) 		
			Begin
				Set @Status =2
				Set @Message = 'MFML000015' 
			End 
		Else		
			If Exists ( Select Top  1 1 From MT1618  inner join MT1601 on MT1618.InProcessID = MT1601.InProcessID and MT1601.IsInprocess = 1
					Where MT1618.ApportionID = @KeyValue)
				Begin 
					Set @Status =2
					Set @Message = 'MFML000015' 
				End	
		Else
			If Exists (Select Top  1 1 From MT5001 Where ApportionID = @KeyValue)
				Begin 
					Set @Status =1
					Set @Message = 'MFML000016' 
				End 	
		Else
			If Not exists (Select Top  1 1 From MT5001 Where ApportionID = @KeyValue)
				Begin 
					Set @Status =0
					Set @Message = 'MFML000017' 
				End 	
	End
	
--Danh muc Phuong phap phan bo
--------------------------------------------------------------------------
If @TableID = 'MT5000'
	If Exists (Select Top 1 1 From MT5000 Where DistributionID = @KeyValue )
		Begin
			If Exists (Select Top 1 1 From MT0400 inner join MT1601 on MT0400.PeriodID = MT1601.PeriodID
										  inner join MT5000 on MT1601.DistributionID = MT5000.DistributionID	
						and MT0400.DivisionID = @DivisionID and  MT5000. DistributionID = @KeyValue
				) 		
				Begin	 
					Set @Status =2
					Set @Message = 'MFML000018' 
				End			
			Else
			 If  Exists (Select Top  1 1 From MT1601 Where DistributionID = @KeyValue  )						
				Begin	 

					Set @Status =1
					Set @Message = 'MFML000019' 
				End 
			Else    	
			 If Not Exists (Select Top  1 1 From MT1601 Where DistributionID = @KeyValue )						
				Begin	 

					Set @Status =0
					Set @Message = 'MFML000020' 
				End 	    	   
		End	

--Danh muc Phuong phap xac dinh CPDD
--------------------------------------------------------------------------
If @TableID = 'MT1608' 
	If Exists (Select Top 1 1 From  MT1608 Where InprocessID = @KeyValue )  
		Begin 
			If Exists (Select Top 1 1 From MT1613 inner join MT1601 on MT1613.PeriodID = MT1601.PeriodID
											 and MT1601.InprocessID=@KeyValue and MT1601.IsDistribute = 1 ) 		
				Begin	 			
					Set @Status =2
					Set @Message = 'MFML000021' 
				End			
			Else
				If Exists (Select Top 1 1 From MT1601 Where InProcessID = @KeyValue and MT1601.IsDistribute = 1 )
					Begin 
						Set @Status = 1
						Set @Message ='MFML000022'  
					End		
			Else
				If  Not Exists (Select Top 1 1 From MT1601 Where InProcessID = @KeyValue and MT1601.IsDistribute = 1 )
					Begin 
						Set @Status = 0
						Set @Message ='MFML000023'  
					End		
		End
		
--Danh muc Danh muc quy trinh cong viec
--------------------------------------------------------------------------
If @TableID = 'MT1701' 
	If Exists (Select Top 1 1 From  MT1701 Where WorkID = @KeyValue )  
	Begin 
		If Exists (Select Top 1 1 From MT2002 Where WorkID=@KeyValue ) 		
			Begin	 
				Set @Status =1
				Set @Message ='MFML000024'
			End	
	End
	
	Insert  MT7777 (DivisionID,ComputerName, Status, Message, Language) Values (@DivisionID, @ComputerName ,@Status,@Message,@Language)
	
Set Nocount Off	
Select * From MT7777 Where ComputerName = @ComputerName

--- Modified by Tieu Mai on 07/12/2015
--- Danh muc Bo dinh muc theo quy cach
  If  Exists (Select Top  1 1 From MT0135 Where ApportionID = @KeyValue)
	Begin 
		If Exists (Select Top 1 1 From MT0400 inner join MT1601 on MT0400.PeriodID = MT1601.PeriodID
									  inner join MT5001 on MT1601.DistributionID = MT5001.DistributionID	
					and MT0400.DivisionID = @DivisionID and  MT5001. ApportionID = @KeyValue
			) 		
			Begin
				Set @Status =2
				Set @Message = 'MFML000015' 
			End 
		Else		
			If Exists ( Select Top  1 1 From MT1618  inner join MT1601 on MT1618.InProcessID = MT1601.InProcessID and MT1601.IsInprocess = 1
					Where MT1618.ApportionID = @KeyValue)
				Begin 
					Set @Status =2
					Set @Message = 'MFML000015' 
				End	
		Else
			If Exists (Select Top  1 1 From MT5001 Where ApportionID = @KeyValue)
				Begin 
					Set @Status =1
					Set @Message = 'MFML000016' 
				End 	
		Else
			If Not exists (Select Top  1 1 From MT5001 Where ApportionID = @KeyValue)
				Begin 
					Set @Status =0
					Set @Message = 'MFML000017' 
				End 	
	End
	
