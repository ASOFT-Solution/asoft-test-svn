IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0310]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0310]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Van Nhan.
---- Created Date 12/02/2004
---- Bao cao doi chieu cong no theo mat hang
/********************************************
'* Edited by: [GS] [To Oanh] [29/07/2010]
'********************************************/


CREATE PROCEDURE [dbo].[AP0310]  @DivisionID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),
				@FromAccountID as nvarchar(50),
				@ToAccountID as nvarchar(50),
				@CurrencyID as nvarchar(50),
				@FromInventoryID as nvarchar(50),
				@ToInventoryID as nvarchar(50),
				@IsDetail as tinyint,
				@IsDate as tinyint,
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,				
				@FromDate as Datetime,
				@ToDate as Datetime
AS


	If @IsDetail = 1 --- Chi tiet theo mat hang cua tung hoa don
		--Print ' P1'
		Exec AP0308 	@DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID,@CurrencyID, @FromInventoryID, @ToInventoryID,
				@IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate
	Else

		Exec AP0309 	@DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID, @FromInventoryID, @ToInventoryID,
				@IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate
		--Print ' P2'

GO


