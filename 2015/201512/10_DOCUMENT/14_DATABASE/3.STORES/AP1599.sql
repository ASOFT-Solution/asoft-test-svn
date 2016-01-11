
/****** Object:  StoredProcedure [dbo].[AP1599]    Script Date: 07/28/2010 14:04:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1599]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1599]
GO


/****** Object:  StoredProcedure [dbo].[AP1599]    Script Date: 07/28/2010 14:04:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Lasted Updated by Van Nhan.
----- Date 25/10/2007
------Last Edit Van Nhan date 26/10/2007
--- LAst Edit Thuy Tuyen02/05/2008

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1599] @NumGroupID as TINYINT, 
				@DivisionID AS nvarchar(50),			
				@FromAccountID AS nvarchar(50),		@ToAccountID AS nvarchar(50),	
				@FromMonthFrom AS INT,			@TranYearFrom AS INT,				
				 @TranMonthTo AS INT,				@TranYearTo AS INT,	
				@Method as nvarchar(50),	--- BL, BA, PD, PC
				@Cause AS nvarchar(50),	--- '', 'DSD',....
				@TypeValues AS nvarchar(50),  -- CA, RE, DE
				@AssetGroupID AS nvarchar(50),	
				@Sign as nvarchar(5),
				@NowStatusID as nvarchar(50),
				@OutputAmount AS decimal(28,8) OUTPUT
 				

AS

DECLARE 	@PeriodFrom INT,	
		@PeriodTo INT,
		@strSQL as nvarchar(4000),
		@Amount AS Decimal(28,4)
---SET @Amount = 0
Set @PeriodFrom= 100*@TranYearFrom+@FromMonthFrom
Set @PeriodTo= 100*@TranYearTo+@TranMonthTo

Set @Amount =0

IF isnull(@FromAccountID,'')<>'' and @TypeValues in ('DE', 'CA')
Begin 
IF @Method='BL' --- So du ky trc
   Begin	
	--Print ' @PeriodFrom ='+str(@PeriodFrom)+' @NowStatusID ='+@NowStatusID+' @Cause ='+@Cause +'@TypeValues = '+@TypeValues+'@FromAccountID='+@FromAccountID+' @ToAccountID = '+@ToAccountID+' @AssetGroupID ='+@AssetGroupID
	SELECT 	@Amount = Sum(SignAmount)
		FROM		AV1555
		WHERE 	DivisionID =@DivisionID and
				(AccountID >= @FromAccountID AND AccountID <= @ToAccountID) and
				DataTypeID=@TypeValues And
				((Case when @AssetGroupID='' then @AssetGroupID else isnull(AssetGroupID,'') End) = @AssetGroupID)  AND
				((case When isnull(@Cause,'') <>'' then FromStatusID Else @Cause End) = @Cause) and ---  Trang thai hinh thanh
				((Case when @NowStatusID <>'' then NowStatusID Else @NowStatusID End) = @NowStatusID) and  --- Trang thai hien nay				
				AV1555.TranMonth+AV1555.TranYear*100 < @PeriodFrom

		----Print str(@Amount)+'  '+@TypeValues
	End
-----Print @Method+','+ cast (@Amount as nvarchar(50)) +','+@DivisionID+','+@TypeValues+'Nhom:'+@AssetGroupID+'lydo:'+@Cause+'Trangthai:'+@NowStatusID+','---+@PeriodFrom
IF @Method='BA' --- So du TRONG KY
	SELECT 	@Amount = Sum(SignAmount)
	FROM		AV1555
	WHERE 	DivisionID =@DivisionID and
			(AccountID >= AccountID AND AccountID <= AccountID) and
			DataTypeID=@TypeValues And
			((Case when @AssetGroupID='' then @AssetGroupID else isnull(AssetGroupID,'') End) = @AssetGroupID)  AND
			((case When isnull(@Cause,'') <>'' then FromStatusID Else @Cause End) = @Cause) and ---  Trang thai hinh thanh
			((Case when @NowStatusID <>'' then NowStatusID Else @NowStatusID End) = @NowStatusID) and  --- Trang thai hien nay	
			AV1555.TranMonth+AV1555.TranYear*100 <= @PeriodTo

IF @Method='PD' --- Phat sinh no
	SELECT 	@Amount = Sum(ConvertedAmount)
		FROM		AV1555
		WHERE 	DivisionID =@DivisionID and
				(AccountID >= AccountID AND AccountID <= AccountID) and
				DataTypeID=@TypeValues And
				D_C='D' and
				((Case when @AssetGroupID='' then @AssetGroupID else isnull(AssetGroupID,'') End) = @AssetGroupID)  AND				
				((case When isnull(@Cause,'') <>'' then FromStatusID Else @Cause End) = @Cause) and ---  Trang thai hinh thanh
				((Case when @NowStatusID <>'' then NowStatusID Else @NowStatusID End) = @NowStatusID) and  --- Trang thai hien nay	
				(AV1555.TranMonth+AV1555.TranYear*100 between @PeriodFrom and @PeriodTo)


IF @Method='PC' --- Phat sinh co
	SELECT 	@Amount = Sum(ConvertedAmount)
		FROM		AV1555
		WHERE 	DivisionID =@DivisionID and
				(AccountID >= AccountID AND AccountID <= AccountID) and
				DataTypeID=@TypeValues And
				D_C='C' and
				((Case when @AssetGroupID='' then @AssetGroupID else isnull(AssetGroupID,'') End) = @AssetGroupID)  AND
				((case When isnull(@Cause,'') <>'' then FromStatusID  Else @Cause End) = @Cause) and ---  Trang thai hinh thanh
				((Case when @NowStatusID <>'' then NowStatusID Else @NowStatusID End) = 	@NowStatusID) and
				(AV1555.TranMonth+AV1555.TranYear*100 between @PeriodFrom and @PeriodTo)



End

IF @TypeValues in ('RE')
Begin 
IF @Method='BL' --- So du ky trc
  Begin	
	--Print 'Hello'
	SELECT 	@Amount = Sum(SignAmount)
		FROM		AV1555
		WHERE 	DivisionID =@DivisionID and				
				---(AccountID >= @FromAccountID AND AccountID <= @ToAccountID) 
				DataTypeID in ('DE', 'CA')And
				---DataTypeID in ('RE')And
				((Case when @AssetGroupID='' then @AssetGroupID else isnull(AssetGroupID,'') End) = @AssetGroupID)  AND
				((case When isnull(@Cause,'') <>'' then FromStatusID Else @Cause End) = @Cause) and ---  Trang thai hinh thanh
				((Case when @NowStatusID <>'' then NowStatusID Else @NowStatusID End) = @NowStatusID) and  --- Trang thai hien nay				
				AV1555.TranMonth+AV1555.TranYear*100 < @PeriodFrom
	--Print @TypeValues
 End	
IF @Method='BA' --- So du cuoi ky
	SELECT ----	@Amount = Sum(SignAmount) - Sum( isnull (T04.DepAmount,0)) - sum( Isnull(AT1523.AccuDepAmount,0))
			@Amount = Sum(SignAmount) - Sum( isnull (T04.DepAmount,0))  - sum( Isnull(AT1523.RemainAmount,0))
		FROM		AV1555
		Left Join  (Select  sum(DepAmount) as DepAmount , AssetID from AT1504  	Where  TranMonth + TRanYear*100 <= @PeriodTo Group by AssetID) as T04 on t04.AssetID = AV1555.AssetID
		Left Join  AT1523 on  AT1523.AssetID = AV1555.AssetID  and  ReduceMonth + ReduceYear*100 <= @PeriodTo
		WHERE 	AV1555.DivisionID =@DivisionID and				
				---(AccountID >= AccountID AND AccountID <= AccountID) and
				DataTypeID in ('RE') And
				
				((Case when @AssetGroupID='' then @AssetGroupID else isnull(AssetGroupID,'') End) = @AssetGroupID)  AND
				((case When isnull(@Cause,'') <>'' then FromStatusID Else @Cause End) = @Cause) and ---  Trang thai hinh thanh
				((Case when @NowStatusID <>'' then NowStatusID Else @NowStatusID End) = @NowStatusID) and  --- Trang thai hien nay	
				AV1555.TranMonth+AV1555.TranYear*100 <= @PeriodTo


End


If @Sign ='-' 
	Set @OutputAmount =-@Amount
Else
	Set @OutputAmount =@Amount
GO

