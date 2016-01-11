/****** Object:  StoredProcedure [dbo].[AP7199]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
--- Created by Van Nhan, Date .
--- Purpose: In so tai khoan ngoai bang. Tong hop, chi tiet.

ALTER PROCEDURE  [dbo].[AP7199] 	@DivisionID varchar(20), 
					@FromAccountID as varchar(20),
					@ToAccountID as varchar(20),
					@FromInventoryID as varchar(20),
					@ToInventoryID as varchar(20),	
					@FromMonth int, 
					@FromYear int, 
					@ToMonth int, 
					@ToYear int, 
					@FromDate Datetime, 
					@ToDate Datetime,
					@IsDate as tinyint,
					@IsDetail as tinyint
 AS

If @IsDetail =0  --- Tong hop, tra ra View AV7198 de link trc tiep voi bao cao
	Exec AP7198 @DivisionID, @FromAccountID, @ToAccountID, @FromInventoryID, @ToInventoryID,@FromMonth,@FromYear,@toMonth, @ToYear, @FromDate, @ToDate ,@IsDate
Else   -- Chi tiet , tra ra View AV7195 de link trc tiep voi bao cao
	Exec AP7195  @DivisionID, @FromAccountID, @ToAccountID, @FromInventoryID, @ToInventoryID,@FromMonth,@FromYear,@toMonth, @ToYear, @FromDate, @ToDate ,@IsDate
GO
