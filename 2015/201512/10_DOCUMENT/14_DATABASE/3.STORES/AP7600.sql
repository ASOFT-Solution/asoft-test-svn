IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7600]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7600]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



------	Xu ly so lieu; tinh toan len bang ke qua kinh doanh; phan lai+lo. 
------ 	Duoc goi tu AP7604
------ 	Created by Nguyen Van Nhan, Date 20.04.2005

/**********************************************
** Edited by: [GS] [Cáº©m Loan] [30/07/2010]
***********************************************/
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified by on 02/01/2013 by Lê Thị Thu Hiền : Thay đổi INSERT #DivisionID bằng Bảng tạm A00007

CREATE PROCEDURE [dbo].[AP7600]
				@DivisionID AS nvarchar(50),			
				@AccountIDFrom AS nvarchar(50),		
				@AccountIDTo AS nvarchar(50),	
				@CorAccountIDFrom AS nvarchar(50),		
				@CorAccountIDTo AS nvarchar(50),
				@TranMonthFrom AS INT,			@TranYearFrom AS INT,				
				@TranMonthTo AS INT,				@TranYearTo AS INT,	
				@TypeID as nvarchar(50),				
				@OutputAmount AS decimal(28,8) OUTPUT,
				@StrDivisionID AS NVARCHAR(4000) = ''

AS
---- Note  		@TypeID ='BD'  		So du  No
---- Note  		@TypeID ='BC'  			So du  Co
-----			@TypeID ='PD'  		So phat sinh No
-----			@TypeID ='PC'  			So phat sinh Co
		

DECLARE @PeriodFrom INT,	
		@PeriodTo INT

DECLARE	@CorAccountIDFrom1 AS nvarchar(50),
		@CorAccountIDTo1 AS nvarchar(50)
DECLARE	@Amount AS decimal(28,8)

--------------->>>> Chuỗi DivisionID
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
	
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
		
DELETE FROM	A00007 WHERE SPID = @@SPID
INSERT INTO A00007(SPID, DivisionID) 
EXEC('SELECT '''+@@SPID+''', DivisionID FROM AT1101 WHERE DivisionID '+@StrDivisionID_New+'')

---------------------<<<<<<<<<< Chuỗi DivisionID

---Print ' @TypeID =' + @TypeID
SET @PeriodFrom = @TranYearFrom*100+@TranMonthFrom
SET @PeriodTo = @TranYearTo*100+@TranMonthTo


SET @CorAccountIDFrom1 = @CorAccountIDFrom
SET @CorAccountIDTo1 = @CorAccountIDTo
IF (@CorAccountIDTo1 = '' OR @CorAccountIDTo1 IS NULL)
	SET @CorAccountIDTo1 = @CorAccountIDFrom1

SET @Amount = 0

IF @TypeID in ( 'BD', 'BC')  	----- Lay so du No hoac so du Co
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM(V01.ConvertedAmount)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
				(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				( V01.TransactionTypeID='T00' or  (V01.TranYear*100+V01.TranMonth <= @PeriodTo) )
	ELSE
		SELECT 	@Amount = SUM(V01.ConvertedAmount)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
				(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				( V01.TransactionTypeID='T00' or  (V01.TranYear*100+V01.TranMonth <= @PeriodTo) ) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
	If @TypeID ='BC' 
		Set 	@Amount = @Amount*(-1)

	GOTO RETURN_VALUES
    END


IF @TypeID = 'PD'  		-------Lay so phat sinh No
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM(V01.ConvertedAmount)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
				(V01.TransactionTypeID <>'T00') AND
				(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND				
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.D_C = 'D')
	ELSE
		SELECT 	@Amount = SUM(V01.ConvertedAmount)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
				(V01.TransactionTypeID <>'T00') AND
				(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.D_C = 'D') AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
	GOTO RETURN_VALUES
    END

IF @TypeID = 'PC'  		------ Lay so phat sinh co
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM(V01.ConvertedAmount)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
				(V01.TransactionTypeID <>'T00') AND
				(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.D_C = 'C')
	ELSE
		SELECT 	@Amount = SUM(V01.ConvertedAmount)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
				(V01.TransactionTypeID <>'T00') AND
				(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.D_C = 'C') AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
	Set @Amount = @Amount*(-1)

	GOTO RETURN_VALUES
    END


RETURN_VALUES:
SET @OutputAmount = @Amount
RETURN


DELETE FROM	A00007 WHERE SPID = @@SPID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

