
/****** Object:  StoredProcedure [dbo].[AP1607]    Script Date: 07/28/2010 14:43:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1607]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1607]
GO

/****** Object:  StoredProcedure [dbo].[AP1607]    Script Date: 07/28/2010 14:43:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, Date 25.12.2004
--- Purpose : Bo Ket chuyen but toan phan bo cong cu dung cu vao so cai.

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1607] @DivisionID as nvarchar(50), @TranMonth as int, @TranYear as int, @UserID as nvarchar(50)
		
 AS

Delete AT9000
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID and
	TransactionTypeID ='T18' and
	TableID ='AT1604'

--------- Cap nhËt bót to¸n khÊu hao ®· ®­îc chuyÓn
Update AT1604 Set  Status =0
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID




GO

