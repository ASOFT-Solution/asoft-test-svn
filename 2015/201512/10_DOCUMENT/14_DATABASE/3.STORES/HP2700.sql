/****** Object:  StoredProcedure [dbo].[HP2700]    Script Date: 08/02/2010 14:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----- 	Created Date 14/09/2005
----  	Purpose: Ke thua to khai nop thue thu nhap ca nhan
---

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2700]	@DivisionID as  NVARCHAR(50), 
				@TranMonth as int, 
				@TranYear as int,
				@PITDeclareTypeID as  NVARCHAR(50),
				@PITDeclareID as  NVARCHAR(50),
				@PITDeclareName as nvarchar(250),
				@PitDeclareDate as datetime
				
				
AS
Declare @TaxRate as decimal (28, 8),
	@Type int,
	@sSQL as nvarchar(4000),
	@DivisionReceiveRate as decimal (28, 8),
	@PayOwedLastMonth as decimal (28, 8),
	@Month as int,
	@Year as int

Set @PitDeclareDate=IsNull(@PitDeclareDate,Getdate())
Select @Type=TypeID From HT2700 Where PITDeclareTypeID=@PITDeclareTypeID And DivisionID =@DivisionID
If @Type=0 ---khong co thue suat
	Exec HP2701	@DivisionID , @TranMonth , @TranYear , @PITDeclareTypeID, @PITDeclareID, @PITDeclareName, @PitDeclareDate 

Else 
	Exec HP2702	@DivisionID , @TranMonth , @TranYear , @PITDeclareTypeID, @PITDeclareID, @PITDeclareName, @PitDeclareDate 














