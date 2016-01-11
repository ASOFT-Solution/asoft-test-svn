
/****** Object:  StoredProcedure [dbo].[AP1507]    Script Date: 07/29/2010 09:51:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan, Date 30/09/2003
------ Purpose Xo¸ bót to¸n khÊu hao kÕt chuyÓn

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1507] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int

AS

Delete AT9000
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID and
	TransactionTypeID ='T08' and
	TableID ='AT1504'

--------- Cap nhËt bót to¸n khÊu hao ®· ®­îc chuyÓn
Update AT1504 Set  Status =0
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID




