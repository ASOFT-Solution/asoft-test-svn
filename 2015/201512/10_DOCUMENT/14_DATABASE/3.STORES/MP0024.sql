
/****** Object:  StoredProcedure [dbo].[MP0024]    Script Date: 07/29/2010 17:18:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

------ Bo Chiet tinh gia thanh theo quy trinh san xuat.
---- Created by Nguyen Van Nhan, date 03/06/2008

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0024]  	
					@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,
					@ProcedureID as nvarchar(50)--- Kiem
 AS

Update MT1630 Set IsDetailCost =0
Where ProcedureID=@ProcedureID AND DivisionID = @DivisionID

Delete  MT1632 Where ProcedureID=@ProcedureID AND DivisionID = @DivisionID
---GO
