/****** Object:  StoredProcedure [dbo].[AP3055]    Script Date: 07/29/2010 10:33:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Quoc Huy, Date 04/10/2005
------ Purpose:Hang ban tra lai
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3055]
		@DivisionID as nvarchar(50),
		@FromDate as datetime,
		@ToDate as datetime,
		@FromMonth as int,
		@FromYear as int,
		@ToMonth as int,
		@ToYear as int,
		@IsDate as int,
		@IsDetail as tinyint, ---- = 0 tong hop; = 1 la chi tiet.
		@IsCustomer as tinyint --- = 0 la theo mat hang; = 1 theo khach hang	

as
Declare
        @sSQL as nvarchar(4000),
	@sSQLWhere as nvarchar(4000),
	@FromPeriod as int,
	@ToPeriod as int

set	@FromPeriod =(@FromMonth+@FromYear*100)
set	@ToPeriod=(@ToMonth+@ToYear*100)

If @IsDate = 1 -- theo ngay
	Set @sSQLWhere ='AT9000.VoucherDate between  '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''''
Else  -- theo ky
 	Set @sSQLWhere ='AT9000.TranMonth + AT9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+' '

--------------------- Xu ly chi tiet cac truong hop

If @IsDetail = 1 and @IsCustomer =0  --- chi tiet tung mat hang
	Exec AP3051 	@DivisionID, @sSQLWhere
If @IsDetail = 1 and @IsCustomer =1  --- chi tiet tung khach hang
	Exec AP3052 @DivisionID, @sSQLWhere
If @IsDetail =0 and @IsCustomer =0  --- Tong hop  mat hang
	Exec AP3053 @DivisionID, @sSQLWhere, @FromMonth, @FromYear
If @IsDetail =0 and @IsCustomer =1  --- Tong hop  khach hang
	Exec AP3054 @DivisionID, @sSQLWhere