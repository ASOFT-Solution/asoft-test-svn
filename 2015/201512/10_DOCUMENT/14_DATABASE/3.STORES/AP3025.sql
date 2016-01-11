IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3025]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3025]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Hoang Thi Lan, Date 16/10/2003.
------ Doanh so ban hang
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
---- Modified on 28/08/2013 by Khanh Van: Bo sung customize cho 2T
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP3025]
		@DivisionID AS nvarchar(50),
		@FromDate AS datetime,
		@ToDate AS datetime,
		@FromMonth AS int,
		@FromYear AS int,
		@ToMonth AS int,
		@ToYear AS int,
		@IsDate AS int,
		@IsDetail AS tinyint, ---- = 0 tong hop; = 1 la chi tiet.
		@IsCustomer AS TINYINT, --- = 0 la theo mat hang; = 1 theo khach hang	
		@UserID AS VARCHAR(50) = ''

as
DECLARE
    @sSQL AS nvarchar(4000),
	@sSQLWhere AS nvarchar(4000),
	@FromPeriod AS int,
	@ToPeriod AS int,
	@CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

SET @FromPeriod =(@FromMonth+@FromYear*100)
SET @ToPeriod=(@ToMonth+@ToYear*100)

If @IsDate = 1 -- theo ngay
	Set @sSQLWhere ='CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101) BETWEEN  '''+convert(nvarchar(10),@FromDate,101)+''' AND '''+convert(nvarchar(10),@ToDate,101)+''''
Else  -- theo ky
 	Set @sSQLWhere ='AT9000.TranMonth + AT9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+' '

--------------------- Xu ly chi tiet cac truong hop

If @IsDetail = 1 and @IsCustomer =0  --- chi tiet tung mat hang
Begin
	IF @CustomerName = 15 --- Customize 2T
		Exec AP3021_2T @DivisionID, @sSQLWhere
	Else
		Exec AP3021 @DivisionID, @sSQLWhere, @UserID
End
If @IsDetail = 1 and @IsCustomer =1  --- chi tiet tung khach hang
Begin
	IF @CustomerName = 15 --- Customize 2T
		Exec AP3022_2T @DivisionID, @sSQLWhere
	Else
		Exec AP3022 @DivisionID, @sSQLWhere, @UserID
End
If @IsDetail =0 and @IsCustomer =0  --- Tong hop  mat hang
		Exec AP3023 @DivisionID, @sSQLWhere, @FromMonth, @FromYear, @UserID
If @IsDetail =0 and @IsCustomer =1  --- Tong hop  khach hang
		Exec AP3024 @DivisionID, @sSQLWhere, @UserID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

