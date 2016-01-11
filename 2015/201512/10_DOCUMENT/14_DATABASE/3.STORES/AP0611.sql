IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0611]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0611]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- 	Created by Nguyen Van Nhan, Date 16/10/2003.
---- 	Purpose: In Doanh so hang mua theo mat hµng
----	Edited by Nguyen Thi Ngoc Minh, Date 26/11/2004
---	Purppose: cho phep nhom theo 2 cap va cho phep chon nhom theo doi tuong
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
CREATE PROCEDURE [dbo].[AP0611] 
				@DivisionID nvarchar(50),
				@Group1ID AS tinyint , 	---- = 0 la theo loai mat hang.
										---  = 1 la theo tai khoan doanh so
										---  = 2 la theo doi tuong
				@Group2ID AS tinyint , 	---- = 0 la theo loai mat hang.
										---  = 1 la theo tai khoan doanh so
										---  = 2 la theo doi tuong
				@IsDetail AS tinyint,	---- = 1 la chi tiet theo hoa don
										---- = 0 la tong hop 

				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate AS datetime,
				@ToDate AS Datetime,
				@IsDate AS tinyint,
				@IsCondition AS tinyint,
				@FromInventoryID AS nvarchar(50),
				@ToInventoryID AS nvarchar(50)

AS
 

Declare @sSQLWhere AS nvarchar(4000),
		---@GroupField AS nvarchar(4000),
		@FromPeriod AS int,	
		@ToPeriod AS int,
		@CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

set	@FromPeriod =(@FromMonth+@FromYear*100)
set	@ToPeriod=(@ToMonth+@ToYear*100)

If @IsDate = 1 -- theo ngay
	Set @sSQLWhere ='CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101) between  '''+CONVERT(varchar(10),@FromDate,101)+''' and '''+CONVERT(varchar(10),@ToDate,101)+''''
Else  -- theo ky
 	Set @sSQLWhere ='AT9000.TranMonth + AT9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+' '

IF @IsCondition = 1 
	Set @sSQLWhere =@sSQLWhere  + ' and  AT9000.InventoryID Between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+'''  '	
If @IsDetail = 1 		--- Chi tiet theo hoa don
Begin
	IF @CustomerName = 15 --- Customize 2T
	EXEC AP06011 @DivisionID, @sSQLWhere, @Group1ID, @Group2ID
	ELSE

	Exec AP0601 @DivisionID, @sSQLWhere, @Group1ID, @Group2ID
End
Else			-----  Tong hop theo tung doi tuong
	Exec AP0602 @DivisionID, @sSQLWhere, @Group1ID, @Group2ID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

