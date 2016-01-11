IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4919]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4919]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Dang Le Bao Quynh.
----  Created Date 21/05/2007
---- Purporse: Xuat du lieu phuc vu bao cao quan tri dang 3.
---------	Edit by: Dang Le Bao Quynh; Date : 11/01/2008 
---------	Purpose: Bo sung dieu kien tim kiem like
---- Modified by on 09/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
-- <Example>
---- 
-- <Summary>

CREATE PROCEDURE [dbo].[AP4919] 
			@DivisionID nvarchar(50),
			@TranMonthFrom as int,
			@TranYearFrom as int,
			@TranMonthTo as int,
			@TranYearTo as int,
			@FromDate as datetime,
			@ToDate as datetime,
			@IsDate as tinyint,
			@ReportCode nvarchar(50),
			@Sel01Type as nvarchar(20),
			@Sel01IDFrom as nvarchar(50),
			@Sel01IDTo as nvarchar(50),
			@Sel02Type as nvarchar(20),
			@Sel02IDFrom as nvarchar(50),
			@Sel02IDTo as nvarchar(50),
			@Sel03Type as nvarchar(20),
			@Sel03IDFrom as nvarchar(50),
			@Sel03IDTo as nvarchar(50),
			@Sel04Type as nvarchar(20),
			@Sel04IDFrom as nvarchar(50),
			@Sel04IDTo as nvarchar(50),
			@Sel05Type as nvarchar(20),
			@Sel05IDFrom as nvarchar(50),
			@Sel05IDTo as nvarchar(50),
			@StrDivisionID AS NVARCHAR(4000) = '',
			@UserID AS VARCHAR(50) = ''

AS

DECLARE 	@ColumnABudget nvarchar(20),
			@ColumnBBudget nvarchar(20),
			@ColumnCBudget nvarchar(20),
			@ColumnDBudget nvarchar(20),
			@ColumnEBudget nvarchar(20),
			@ColumnFBudget nvarchar(20),
			@ColumnGBudget nvarchar(20),
			@ColumnHBudget nvarchar(20),
			@ColumnAPeriodType nvarchar(20),
			@ColumnBPeriodType nvarchar(20),
			@ColumnCPeriodType nvarchar(20),
			@ColumnDPeriodType nvarchar(20),
			@ColumnEPeriodType nvarchar(20),
			@ColumnFPeriodType nvarchar(20),
			@ColumnGPeriodType nvarchar(20),
			@ColumnHPeriodType nvarchar(20),
			@Level01 nvarchar(20),
			@Level02 nvarchar(20),
			@AmountFormat tinyint,
			@IsUsedColA as tinyint,
			@IsUsedColB as tinyint,
			@IsUsedColC as tinyint,
			@IsUsedColD as tinyint,
			@IsUsedColE as tinyint,
			@IsUsedColF as tinyint,
			@IsUsedColG as tinyint,
			@IsUsedColH as TINYINT,
			@StrDivisionID_New AS NVARCHAR(4000)

DECLARE	@strSQL nvarchar(4000),
		@strSQL1 nvarchar(4000),    ---- Di song song voi @strSQL  dung de Union them phan AV4302 (but toan phan bo)
		@Temp nvarchar(500),
		@Temp1 nvarchar(500),
		@ConversionFactor decimal(28,8),
		@AccuSign as nvarchar(5),
		@ParentID as nvarchar(50),
		@CurrentAccuSign as nvarchar(5),
		@CurrentAccumulator as nvarchar(20)
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = V00.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = V00.CreateUserID '
		SET @sWHEREPer = ' AND (V00.CreateUserID = AT0010.UserID
								OR  V00.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	
SET @strSQL = ''
SET @strSQL1 = ''

SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END

SELECT	@ColumnABudget = ColumnABudget,@ColumnBBudget = ColumnBBudget,	@ColumnCBudget = ColumnCBudget,@ColumnDBudget = ColumnDBudget,	@ColumnEBudget = ColumnEBudget,@ColumnFBudget = ColumnFBudget,@ColumnGBudget = ColumnGBudget,@ColumnHBudget = ColumnHBudget,
		@ColumnAPeriodType = ColumnAPeriodType,@ColumnBPeriodType = ColumnBPeriodType,	@ColumnCPeriodType = ColumnCPeriodType,@ColumnDPeriodType = ColumnDPeriodType,	@ColumnEPeriodType = ColumnEPeriodType,@ColumnFPeriodType = ColumnFPeriodType,@ColumnGPeriodType = ColumnGPeriodType,@ColumnHPeriodType = ColumnHPeriodType,				
		@Level01 = Level01,	@Level02 = Level02,
		@IsUsedColA =IsUsedColA, @IsUsedColB =IsUsedColB, @IsUsedColC =IsUsedColC, @IsUsedColD =IsUsedColD, @IsUsedColE =IsUsedColE, @IsUsedColF =IsUsedColF, @IsUsedColG =IsUsedColG, @IsUsedColH =IsUsedColH 
FROM		AT6200
WHERE	ReportCode = @ReportCode  and DivisionID = @DivisionID


DECLARE 	@Sel01IDTo1 AS nvarchar(50),
			@Sel02IDTo1 AS nvarchar(50),
			@Sel03IDTo1 AS nvarchar(50),
			@Sel04IDTo1 AS nvarchar(50),
			@Sel05IDTo1 AS nvarchar(50)

IF @Sel01IDTo IS NULL OR @Sel01IDTo = ''
	SET @Sel01IDTo1 = @Sel01IDFrom
ELSE
	SET @Sel01IDTo1 = @Sel01IDTo

IF @Sel02IDTo IS NULL OR @Sel02IDTo = ''
	SET @Sel02IDTo1 = @Sel02IDFrom
ELSE
	SET @Sel02IDTo1 = @Sel02IDTo

IF @Sel03IDTo IS NULL OR @Sel03IDTo = ''
	SET @Sel03IDTo1 = @Sel03IDFrom
ELSE
	SET @Sel03IDTo1 = @Sel03IDTo

IF @Sel04IDTo IS NULL OR @Sel04IDTo = ''
	SET @Sel04IDTo1 = @Sel04IDFrom
ELSE
	SET @Sel04IDTo1 = @Sel04IDTo

IF @Sel05IDTo IS NULL OR @Sel05IDTo = ''
	SET @Sel05IDTo1 = @Sel05IDFrom
ELSE
	SET @Sel05IDTo1 = @Sel05IDTo




	SET @strSQL = 'SELECT V00.DivisionID, V00.AccountID, V00.CorAccountID, 
			V00.VoucherDate,V00.SignAmount, V00.SignOriginal, V00.SignQuantity, V00.TranMonth, V00.TranYear, V00.TransactionTypeID, BudgetID,V00.D_C '

	----- Lay truong tra ra nhom 
	IF @Level02 <> '' AND @Level02 IS NOT NULL
	    BEGIN
		EXEC AP4700 @Level02, @LevelColumn = @Temp OUTPUT
			SET @strSQL =	@strSQL +  ','  +@Temp + ' AS Level02'
	    END
	ELSE	
	    Begin	   
		 SET @strSQL =	@strSQL +  ', '''' Level02'
	    End

	IF @Level01 <> '' AND @Level01 IS NOT NULL
	    BEGIN
		EXEC AP4700 @Level01, @LevelColumn = @Temp OUTPUT
			SET @strSQL =	@strSQL +  ',' + @Temp + ' AS Level01'
	    END
	ELSE	
	     Begin	
		SET @strSQL =	@strSQL +  ','''' AS Level01'
	    End


SET @strSQL = @strSQL + ' FROM AV4303 V00'
SET @strSQL = @strSQL + @sSQLPer
	
SET @strSQL = @strSQL + ' WHERE V00.DivisionID '+ @StrDivisionID_New +''
SET @strSQL = @strSQL + @sWHEREPer
	
---SET @strSQL = @strSQL + ' AND V00.TranYear*100+V00.TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''''
----- Loc theo tieu thuc 1	
IF @Sel01Type IS NOT NULL AND @Sel01Type <> ''
    BEGIN
	EXEC AP4700 @Sel01Type, @LevelColumn = @Temp OUTPUT
	IF @Sel01IDFrom IS NOT NULL AND @Sel01IDFrom <> '' AND PatIndex('%[%]%',@Sel01IDFrom) = 0
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel01IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel01IDTo,'[]','') + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel01IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel01IDTo,'[]','') + ''''	
		End
	Else
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel01IDFrom + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel01IDFrom + ''''	
		End 
    END
----- Loc theo tieu thuc 2	

IF @Sel02Type IS NOT NULL AND @Sel02Type <> ''
    BEGIN
	EXEC AP4700 @Sel02Type, @LevelColumn = @Temp OUTPUT
	IF @Sel02IDFrom IS NOT NULL AND @Sel02IDFrom <> '' AND PatIndex('%[%]%',@Sel02IDFrom) = 0
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel02IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel02IDTo,'[]','') + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel02IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel02IDTo,'[]','') + ''''	
		End
	Else
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel02IDFrom + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel02IDFrom + ''''	
		End 
    END
----- Loc theo tieu thuc 3	
IF @Sel03Type IS NOT NULL AND @Sel03Type <> ''
    BEGIN
	EXEC AP4700 @Sel03Type, @LevelColumn = @Temp OUTPUT
	IF @Sel03IDFrom IS NOT NULL AND @Sel03IDFrom <> '' AND PatIndex('%[%]%',@Sel03IDFrom) = 0
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel03IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel03IDTo,'[]','') + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel03IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel03IDTo,'[]','') + ''''	
		End
	Else
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel03IDFrom + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel03IDFrom + ''''	
		End 
    END
----- Loc theo tieu thuc 4	
IF @Sel04Type IS NOT NULL AND @Sel04Type <> ''
    BEGIN
	EXEC AP4700 @Sel04Type, @LevelColumn = @Temp OUTPUT
	IF @Sel04IDFrom IS NOT NULL AND @Sel04IDFrom <> '' AND PatIndex('%[%]%',@Sel04IDFrom) = 0
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel04IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel04IDTo,'[]','') + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel04IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel04IDTo,'[]','') + ''''	
		End
	Else
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel04IDFrom + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel04IDFrom + ''''	
		End 
    END
----- Loc theo tieu thuc 5	
IF @Sel05Type IS NOT NULL AND @Sel05Type <> ''
    BEGIN
	EXEC AP4700 @Sel05Type, @LevelColumn = @Temp OUTPUT
	IF @Sel05IDFrom IS NOT NULL AND @Sel05IDFrom <> '' AND PatIndex('%[%]%',@Sel05IDFrom) = 0
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel05IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel05IDTo,'[]','') + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') >= ''' + Replace(@Sel05IDFrom,'[]','') + ''' AND Isnull(' + @Temp + ','''') <= ''' + Replace(@Sel05IDTo,'[]','') + ''''	
		End
	Else
		Begin
			SET @strSQL = @strSQL + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel05IDFrom + ''''	
			SET @strSQL1 = @strSQL1 + ' AND Isnull(' + @Temp + ','''') like ''' + @Sel05IDFrom + ''''	
		End 
    END

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4910' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4910 AS ' + @strSQL) 
ELSE
	EXEC ('ALTER VIEW AV4910 AS ' + @strSQL) 


	SET @strSQL = 'SELECT '''+@DivisionID +''' AS DivisionID, '
	
		SET @strSQL =	@strSQL + ' sum(SignAmount) AS SignAmount'
	
	
	IF @Level02 <> '' AND @Level02 IS NOT NULL
			SET @strSQL =	@strSQL + ' ,V00.Level02 AS Level02'
	ELSE
			SET @strSQL =	@strSQL + ' , '''' AS Level02'
	
	IF @Level01 <> '' AND @Level01 IS NOT NULL
			SET @strSQL =	@strSQL + ' ,V00.Level01 AS Level01'
	ELSE
			SET @strSQL =	@strSQL + ' , '''' AS Level01'
	
		SET @strSQL =	@strSQL + ''

SET @strSQL = @strSQL + ' FROM AV4910 V00'


SET @strSQL = @strSQL + ' WHERE V00.TranYear*100 + V00.TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''''
		

SET @strSQL =	@strSQL + ' GROUP BY V00.Level02, V00.Level01'


---Print @strSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4911' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4911 AS ' + @strSQL)
ELSE
	EXEC ('ALTER VIEW AV4911 AS ' + @strSQL)

DELETE AT4925

DECLARE 	@CursorAV4911 AS CURSOR,
			@Level01ID AS nvarchar(50),
			@Level02ID AS nvarchar(50),
			@ColumnA AS decimal(28,8),
			@ColumnB AS decimal(28,8),
			@ColumnC AS decimal(28,8),
			@ColumnD AS decimal(28,8),
			@ColumnE AS decimal(28,8),
			@ColumnF AS decimal(28,8),
			@ColumnG AS decimal(28,8),
			@ColumnH AS decimal(28,8)
	

DECLARE 	@CursorAT6201 AS CURSOR,
			@LineID as nvarchar(50),
			@LineCode AS nvarchar(50),
			@AccountIDFrom AS nvarchar(50),
			@AccountIDTo AS nvarchar(50),
			@CorAccountIDFrom AS nvarchar(50),
			@CorAccountIDTo AS nvarchar(50),
			@AmountSign AS tinyint,
			@LineType as nvarchar(20),
			@IsAccount as tinyint,
			@Accumulator1 as nvarchar(20),
			@Accumulator2 as nvarchar(20)
		


		SET @CursorAT6201 = CURSOR SCROLL KEYSET FOR
			SELECT	LineID, LineCode, AccountIDFrom, AccountIDTo,	CorAccountIDFrom, CorAccountIDTo,
					isnull(AmountSign, 0) ,  LineType
			FROM		AT6201
			WHERE	ReportCode = @ReportCode AND DivisionID = @DivisionID

		OPEN @CursorAT6201

		SET @CursorAV4911 = CURSOR SCROLL KEYSET FOR
			SELECT	Level01, Level02	FROM AV4911
		OPEN @CursorAV4911

		FETCH NEXT FROM @CursorAV4911 INTO	@Level01ID,	@Level02ID
		WHILE @@FETCH_STATUS = 0
 		  BEGIN			
			SET @ColumnA = 0	
			SET @ColumnB = 0	
			SET @ColumnC = 0	
			SET @ColumnD = 0	
			SET @ColumnE = 0
			SET @ColumnF = 0
			SET @ColumnG = 0
			SET @ColumnH = 0	
			----- Insert Level
			EXEC AP4911 @DivisionID, @ReportCode, @Level01,	@Level01ID,@Level02,	@Level02ID			
			
			FETCH FIRST FROM @CursorAT6201 INTO	@LineID,@LineCode,@AccountIDFrom,	@AccountIDTo,	@CorAccountIDFrom,	@CorAccountIDTo, @AmountSign, @LineType
			
			WHILE @@FETCH_STATUS = 0
 			  BEGIN	

				
				--Print ' @IsUsedColA '+str(@IsUsedColA)
			      IF @IsUsedColA <>0
			          BEGIN				
				---Print ' AP4914 '+ @ColumnABudget+' @LineType '+@LineType

				EXEC AP4914 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
						@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
						@Level01ID, 		@Level02ID,
						@ColumnABudget ,	@ColumnAPeriodType, @LineType ,  @AmountSign , @ColumnA OUTPUT , @StrDivisionID 
		

				IF @ColumnA IS NULL
					SET @ColumnA = 0
		                     END
			        
			      IF @IsUsedColB <>0
			          BEGIN

				 EXEC AP4914 	@DivisionID,@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 		@Level02ID,
							@ColumnBBudget,	@ColumnBPeriodType, @LineType,   @AmountSign, 	
							@ColumnB OUTPUT  , @StrDivisionID 
				IF @ColumnB IS NULL
					SET @ColumnB = 0
		                     END
	
			      IF @IsUsedColC <>0
			          BEGIN
				EXEC AP4914 	@DivisionID, @AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 		@Level02ID, 
							@ColumnCBudget,	@ColumnCPeriodType, @LineType, 	@AmountSign,
							@ColumnC OUTPUT  , @StrDivisionID 
				IF @ColumnC IS NULL
					SET @ColumnC = 0
		                     END

			      IF @IsUsedColD <>0
			          BEGIN
				EXEC AP4914 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 		@Level02ID,
							@ColumnDBudget,	@ColumnDPeriodType, @LineType, 	@AmountSign,
							@ColumnD OUTPUT   , @StrDivisionID 
				IF @ColumnD IS NULL
					SET @ColumnD = 0
		                    END

			      IF @IsUsedColE <>0
			          BEGIN
				EXEC AP4914 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 		@Level02ID,
							@ColumnEBudget,	@ColumnEPeriodType, @LineType, 	@AmountSign,
							@ColumnE OUTPUT  , @StrDivisionID 
				IF @ColumnE IS NULL
					SET @ColumnE = 0
		                     END
				
			      IF @IsUsedColF <>0
			          BEGIN
				EXEC AP4914 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 		@Level02ID,
							@ColumnFBudget,	@ColumnFPeriodType, @LineType, 	@AmountSign,
							@ColumnF OUTPUT  , @StrDivisionID 
				IF @ColumnF IS NULL
					SET @ColumnE = 0
		                     END	

			       IF @IsUsedColG <>0
			          BEGIN
				EXEC AP4914 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 		@Level02ID,
							@ColumnGBudget,	@ColumnGPeriodType, @LineType, 	@AmountSign,
							@ColumnG OUTPUT  , @StrDivisionID 
				IF @ColumnG IS NULL
					SET @ColumnE = 0
		                     END

			       IF @IsUsedColH <>0
			          BEGIN
				EXEC AP4914 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo, @FromDate, @ToDate, @IsDate, 
							@Level01ID, 	@Level02ID,
							@ColumnHBudget,	@ColumnHPeriodType, @LineType, 	@AmountSign,
							@ColumnH OUTPUT  , @StrDivisionID 
				IF @ColumnH IS NULL
					SET @ColumnE = 0
		                     END 	

				EXEC AP4913	@DivisionID, @ReportCode,	@LineID ,	@Level01ID,	@Level02ID,
						@ColumnA,	@ColumnB,	@ColumnC,	@ColumnD,
						@ColumnE,@ColumnF,@ColumnG,@ColumnH,'+'
					
				FETCH NEXT FROM @CursorAT6201 INTO @LineID, @LineCode,@AccountIDFrom,@AccountIDTo,@CorAccountIDFrom,@CorAccountIDTo, @AmountSign, @LineType

			  END

			FETCH NEXT FROM @CursorAV4911 INTO @Level01ID,	@Level02ID

		  END

		CLOSE @CursorAV4911
		DEALLOCATE @CursorAV4911

		CLOSE @CursorAT6201
		DEALLOCATE @CursorAT6201




		SET @CursorAT6201 = CURSOR SCROLL KEYSET FOR
			SELECT	LineID,  Accumulator1, Accumulator2 , AccuSign

			FROM		AT6201
			WHERE	ReportCode = @ReportCode and IsAccount =0 and isnull(AccuSign,'')<>'' AND DivisionID = @DivisionID


		OPEN @CursorAT6201


		FETCH FIRST FROM @CursorAT6201 INTO	@LineID,  @Accumulator1, @Accumulator2 , @AccuSign

		WHILE @@FETCH_STATUS = 0
 		  BEGIN		
	

			if ltrim(rtrim(@AccuSign)) ='+'
				Update AT25 
				SET		ColumnA = (Select ColumnA From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01 ) +  (Select ColumnA From AT4925  WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnB = (Select ColumnB From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnB  From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnC = (Select ColumnC From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnC  From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnD = (Select ColumnD From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnD From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnE = (Select ColumnE From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnE From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnF = (Select ColumnF From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnF From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnG = (Select ColumnG From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnG From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01),
						ColumnH = (Select ColumnH From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnH From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)            
				From  AT4925 AT25
				WHERE	LineID = @LineID AND AT25.DivisionID = @DivisionID
			Else 
			if ltrim(rtrim(@AccuSign)) ='/'
				Update AT25 
				SET		ColumnA =  ( Case   When (Select ColumnA From AT4925  WHere  LineID = @Accumulator2  and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'')) <>0 then   
						                   (Select ColumnA From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  /  (Select ColumnA From AT4925  WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') )  
								Else 0 End) ,
						ColumnB =  ( Case when (Select ColumnB From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) <>0 then 
								(Select ColumnB From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnB From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End) ,													
						ColumnC = ( Case when  (Select ColumnC From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnC From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnC From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End) ,
						ColumnD = ( Case when  (Select ColumnD From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnD From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnD From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End)  ,
						ColumnE = ( Case when  (Select ColumnE From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnE From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnE From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End)  ,
						ColumnF = ( Case when  (Select ColumnF From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnF From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnF From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End) ,
						ColumnG = ( Case when  (Select ColumnG From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnG From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnG From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End) ,
						ColumnH = ( Case when  (Select ColumnH From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnH From AT4925 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnH From AT4925 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End)
 
				From  AT4925 AT25
				WHERE	LineID = @LineID AND AT25.DivisionID = @DivisionID
			Else
				Update   AT25
				SET		ColumnA = (Select ColumnA From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnA From AT4925  WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) ,
						ColumnB = (Select ColumnB From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnB From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnC = (Select ColumnC From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnC From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnD = (Select ColumnD From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnD From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnE = (Select ColumnE From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnE From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) ,
						ColumnF = (Select ColumnF From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnF From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) ,
						ColumnG = (Select ColumnG From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnG From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) ,
						ColumnH = (Select ColumnH From AT4925 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnH From AT4925 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)   
				From  AT4925 AT25
				WHERE	LineID = @LineID AND AT25.DivisionID = @DivisionID


		
			FETCH NEXT FROM @CursorAT6201 INTO	@LineID,  @Accumulator1 , @Accumulator2 , @AccuSign
		 END

		CLOSE @CursorAT6201
		DEALLOCATE @CursorAT6201



---LineType

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

