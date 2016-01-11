IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4719]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4719]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Van Nhan.
----  Created Date 14/03/2004
---- Purporse: Bao cao phan tich tai chinh dang 2
---- Lasted Update by Van Nhan and Thuy Tuyen. Date 04/08/2006. Adding Distribution
---------	Edit by: Dang Le Bao Quynh; Date : 11/01/2008 
---------	Purpose: Bo sung dieu kien tim kiem like
---- Modified by on 09/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified by on 08/11/2012 by Lê Thị Thu Hiền :
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 11/06/2015 by Bảo Anh : Bổ sung @DivisionID cho AP4714
-- <Example>
---- 
-- <Summary>

CREATE PROCEDURE [dbo].[AP4719] 
			@DivisionID nvarchar(50),
			@TranMonthFrom as int,
			@TranYearFrom as int,
			@TranMonthTo as int,
			@TranYearTo as int,
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
			@Level01 nvarchar(20),
			@Level02 nvarchar(20),
			@AmountFormat tinyint,
			@IsUsedColA as tinyint,
			@IsUsedColB as tinyint,
			@IsUsedColC as tinyint,
			@IsUsedColD as tinyint,
			@IsUsedColE as TINYINT,	
			@StrDivisionID_New AS NVARCHAR(4000)

DECLARE	@strSQL nvarchar(MAX),
		@strSQL1 nvarchar(MAX),    ---- Di song song voi @strSQL  dung de Union them phan AV4302 (but toan phan bo)
		@Temp nvarchar(500),
		@Temp1 nvarchar(500),
		@ConversionFactor decimal(28,8),
		@AccuSign as nvarchar(20),
		@ParentID as nvarchar(50),
		@CurrentAccuSign as nvarchar(20),
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

SELECT TOP 1 @ColumnABudget = ColumnABudget,@ColumnBBudget = ColumnBBudget,	@ColumnCBudget = ColumnCBudget,@ColumnDBudget = ColumnDBudget,	@ColumnEBudget = ColumnEBudget,				
			@Level01 = Level01,	@Level02 = Level02,
			@IsUsedColA =IsUsedColA, @IsUsedColB =IsUsedColB, @IsUsedColC =IsUsedColC, @IsUsedColD =IsUsedColD, @IsUsedColE =IsUsedColE 
FROM	AT6100
WHERE	ReportCode = @ReportCode and DivisionID = @DivisionID 

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




	SET @strSQL = 'SELECT '''+@DivisionID +''' AS DivisionID, V00.AccountID, V00.CorAccountID, 
			V00.SignAmount, V00.SignOriginal, V00.TranMonth, V00.TranYear, V00.TransactionTypeID, BudgetID,V00.D_C '

	SET @strSQL1 = 'SELECT '''+@DivisionID +''' AS DivisionID, V00.AccountID, V00.CorAccountID, 
			V00.SignAmount, V00.SignOriginal, V00.TranMonth, V00.TranYear, V00.TransactionTypeID, BudgetID,V00.D_C '

	----- Lay truong tra ra nhom 
	IF @Level02 <> '' AND @Level02 IS NOT NULL
	    BEGIN
		EXEC AP4700 @Level02, @LevelColumn = @Temp OUTPUT
			SET @strSQL =	@strSQL +  ','  +@Temp + ' AS Level02'
			SET @strSQL1 =@strSQL1 +  ','  +@Temp + ' AS Level02'
	    END
	ELSE	
	    Begin	   
		 SET @strSQL =	@strSQL +  ', '''' Level02'
		 SET @strSQL1 =@strSQL1 +  ', '''' Level02'
	    End

	IF @Level01 <> '' AND @Level01 IS NOT NULL
	    BEGIN
		EXEC AP4700 @Level01, @LevelColumn = @Temp OUTPUT
			SET @strSQL =	@strSQL +  ',' + @Temp + ' AS Level01'
			SET @strSQL1 =	@strSQL1 +  ',' + @Temp + ' AS Level01'
	    END
	ELSE	
	     Begin	
		SET @strSQL =	@strSQL +  ','''' AS Level01'
		SET @strSQL1 = @strSQL1 +  ','''' AS Level01'
 	    End
	
SET @strSQL = @strSQL + ' FROM AV4301 V00'
SET @strSQL = @strSQL + @sSQLPer
SET @strSQL1 = @strSQL1 + ' FROM AV4302 V00'
SET @strSQL1 = @strSQL1 + @sSQLPer

SET @strSQL = @strSQL + ' WHERE V00.DivisionID '+ @StrDivisionID_New +''
SET @strSQL = @strSQL + @sWHEREPer
SET @strSQL1 = @strSQL1 + ' WHERE V00.DivisionID '+ @StrDivisionID_New +''
SET @strSQL1 = @strSQL1 + @sWHEREPer
	
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

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4710' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4710 AS ' + @strSQL+ ' Union all '+@strSQL1)
ELSE
	EXEC ('ALTER VIEW AV4710 AS ' + @strSQL+ ' Union all '+@strSQL1)


SET @strSQL = 'SELECT V00.DivisionID, '
	
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

SET @strSQL = @strSQL + ' FROM AV4710 V00'


SET @strSQL = @strSQL + ' WHERE V00.TranYear*100 + V00.TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''' 
            AND V00.DivisionID = '''+@DivisionID+''''
		

SET @strSQL =	@strSQL + ' GROUP BY V00.DivisionID, V00.Level02, V00.Level01'


---Print @strSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4711' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4711 AS ' + @strSQL)
ELSE
	EXEC ('ALTER VIEW AV4711 AS ' + @strSQL)



DELETE AT4725


DECLARE 	@CursorAV4711 AS CURSOR,
			@Level01ID AS nvarchar(50),
			@Level02ID AS nvarchar(50),
			@ColumnA AS decimal(28,8),
			@ColumnB AS decimal(28,8),
			@ColumnC AS decimal(28,8),
			@ColumnD AS decimal(28,8),
			@ColumnE AS decimal(28,8)
	

DECLARE 	@CursorAT6101 AS CURSOR,
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
		


		SET @CursorAT6101 = CURSOR SCROLL KEYSET FOR
			SELECT	LineID, LineCode, AccountIDFrom, AccountIDTo,	CorAccountIDFrom, CorAccountIDTo,
					isnull(AmountSign, 0) ,  LineType
			FROM		AT6101
			WHERE	ReportCode = @ReportCode AND DivisionID = @DivisionID 

		OPEN @CursorAT6101

		SET @CursorAV4711 = CURSOR SCROLL KEYSET FOR
			SELECT	Level01, Level02	FROM AV4711
		OPEN @CursorAV4711

		FETCH NEXT FROM @CursorAV4711 INTO	@Level01ID,	@Level02ID
		WHILE @@FETCH_STATUS = 0
 		  BEGIN			
			SET @ColumnA = 0	SET @ColumnB = 0	SET @ColumnC = 0	SET @ColumnD = 0	SET @ColumnE = 0	
			----- Insert Level
			EXEC AP4711 @DivisionID, @ReportCode, @Level01,	@Level01ID,@Level02,	@Level02ID			
			

			FETCH FIRST FROM @CursorAT6101 INTO	@LineID,@LineCode,@AccountIDFrom,	@AccountIDTo,	@CorAccountIDFrom,	@CorAccountIDTo, @AmountSign, @LineType
			
			WHILE @@FETCH_STATUS = 0
 			  BEGIN	

				
				--Print ' @IsUsedColA '+str(@IsUsedColA)
			      IF @IsUsedColA <>0
			          BEGIN				
				---Print ' AP4714 '+ @ColumnABudget+' @LineType '+@LineType

				If @ColumnABudget ='AU' --- Xac dinh so luy ke
				EXEC AP4715 	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
						@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
						@Level01ID, 		@Level02ID,
						@ColumnABudget ,	@LineType ,  @AmountSign , @OutputAmount = @ColumnA OUTPUT  				
				ELSE 
				EXEC AP4714 @DivisionID,	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
						@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
						@Level01ID, 		@Level02ID,
						@ColumnABudget ,	@LineType ,  @AmountSign , @OutputAmount = @ColumnA OUTPUT  
		

				IF @ColumnA IS NULL
					SET @ColumnA = 0
		                   END
				
			      IF @IsUsedColB <>0
			          BEGIN

				If @ColumnBBudget ='AU' --- Xac dinh so luy ke
				  EXEC AP4715 	@AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
						@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
						@Level01ID, 		@Level02ID,
						@ColumnBBudget ,	@LineType ,  @AmountSign , @OutputAmount = @ColumnB OUTPUT  
				ELSE
				  EXEC AP4714 	@DivisionID, @AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
							@Level01ID, 		@Level02ID,
							@ColumnBBudget,	@LineType,   @AmountSign, 	
							@OutputAmount = @ColumnB OUTPUT  
				IF @ColumnB IS NULL
					SET @ColumnB = 0
		                   END
	
			      IF @IsUsedColC <>0
			          BEGIN
				EXEC AP4714 	@DivisionID, @AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
							@Level01ID, 		@Level02ID,
							@ColumnCBudget,	@LineType, 	@AmountSign,
							@OutputAmount = @ColumnC OUTPUT  
				IF @ColumnC IS NULL
					SET @ColumnC = 0
		                   END

			      IF @IsUsedColD <>0
			          BEGIN
				EXEC AP4714 	@DivisionID, @AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
							@Level01ID, 		@Level02ID,
							@ColumnDBudget,	@LineType, 	@AmountSign,
							@OutputAmount = @ColumnD OUTPUT  
				IF @ColumnD IS NULL
					SET @ColumnD = 0
		                   END

			      IF @IsUsedColE <>0
			          BEGIN
				EXEC AP4714 	@DivisionID, @AccountIDFrom, 	@AccountIDTo, 	@CorAccountIDFrom, 	@CorAccountIDTo,
							@TranMonthFrom,	@TranYearFrom, 	@TranMonthTo, 	@TranYearTo,
							@Level01ID, 		@Level02ID,
							@ColumnEBudget,	@LineType, 	@AmountSign,
							@OutputAmount = @ColumnE OUTPUT  
				IF @ColumnE IS NULL
					SET @ColumnE = 0
		                   END



				    EXEC AP4713	@ReportCode,	@LineID ,	@Level01ID,	@Level02ID,
						@ColumnA,	@ColumnB,	@ColumnC,	@ColumnD,
						@ColumnE,	'+'
					
				FETCH NEXT FROM @CursorAT6101 INTO @LineID, @LineCode,@AccountIDFrom,@AccountIDTo,@CorAccountIDFrom,@CorAccountIDTo, @AmountSign, @LineType

			  END

			FETCH NEXT FROM @CursorAV4711 INTO @Level01ID,	@Level02ID

		  END

		CLOSE @CursorAV4711
		DEALLOCATE @CursorAV4711

		CLOSE @CursorAT6101
		DEALLOCATE @CursorAT6101




		SET @CursorAT6101 = CURSOR SCROLL KEYSET FOR
			SELECT	LineID,  Accumulator1, Accumulator2 , AccuSign

			FROM		AT6101
			WHERE	ReportCode = @ReportCode and IsAccount =0 and isnull(AccuSign,'')<>'' AND DivisionID = @DivisionID


		OPEN @CursorAT6101


		FETCH FIRST FROM @CursorAT6101 INTO	@LineID,  @Accumulator1, @Accumulator2 , @AccuSign

		WHILE @@FETCH_STATUS = 0
 		  BEGIN		
	

			if ltrim(rtrim(@AccuSign)) ='+'
				Update AT25 
				SET		ColumnA = (Select ColumnA From AT4725 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01 ) +  (Select ColumnA From AT4725  WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnB = (Select ColumnB From AT4725 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnB From AT4725 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnC = (Select ColumnC From AT4725 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) +  (Select ColumnC From AT4725 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  
				From  AT4725 AT25
				WHERE	LineID = @LineID AND AT25.DivisionID = @DivisionID
			Else 
			if ltrim(rtrim(@AccuSign)) ='/'
				Update AT25 
				SET		ColumnA =  ( Case   When (Select ColumnA From AT4725  WHere  LineID = @Accumulator2  and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'')) <>0 then   
						                   (Select ColumnA From AT4725 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  /  (Select ColumnA From AT4725  WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') )  
								Else 0 End) ,
						ColumnB =  ( Case when (Select ColumnB From AT4725 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) <>0 then 
								(Select ColumnB From AT4725 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnB From AT4725 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End) ,													
						ColumnC = ( Case when  (Select ColumnC From AT4725 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,''))  <>0 then 
								(Select ColumnC From AT4725 WHere  LineID = @Accumulator1 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) /  (Select ColumnC From AT4725 WHere  LineID = @Accumulator2 and isnull(Level02 ,'') = isnull(AT25.Level02,'') and   isnull(Level01,'')  = isnull(AT25.Level01,'') ) 
								Else 0 End)  
				From  AT4725 AT25
				WHERE	LineID = @LineID AND AT25.DivisionID = @DivisionID
			Else
				Update   AT25
				SET		ColumnA = (Select ColumnA From AT4725 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnA From AT4725  WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnB = (Select ColumnB From AT4725 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnB From AT4725 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  ,
						ColumnC = (Select ColumnC From AT4725 WHere  LineID = @Accumulator1 and Level02  = AT25.Level02 and   Level01  = AT25.Level01) -  (Select ColumnC From AT4725 WHere  LineID = @Accumulator2 and Level02  = AT25.Level02 and   Level01  = AT25.Level01)  
				From  AT4725 AT25
				WHERE	LineID = @LineID AND AT25.DivisionID = @DivisionID


		
			FETCH NEXT FROM @CursorAT6101 INTO	@LineID,  @Accumulator1 , @Accumulator2 , @AccuSign
		 END

		CLOSE @CursorAT6101
		DEALLOCATE @CursorAT6101



---LineType

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

