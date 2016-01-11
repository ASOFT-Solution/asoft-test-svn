IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0303]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0303]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: Load dữ liệu combo Đợt xét duyệt (HF0314, HF0344)
--- EXEC HP0303 'AS',3,2012,'01/2012',0,''

CREATE PROCEDURE [dbo].[HP0303] 
				@DivisionID nvarchar(50),			
				@TranMonth int,
				@TranYear int,
				@Quarter nvarchar(7),
				@IsQuarter tinyint,
				@FormID nvarchar(10)
				
AS
Declare @SQL nvarchar(max),
		@TableID nvarchar(10)
	
IF @FormID = 'HF0302' SET @TableID = 'HT0301'
IF @FormID = 'HF0310' SET @TableID = 'HT0310'
IF @FormID = 'HF0312' SET @TableID = 'HT0312'
IF @FormID = 'HF0315' SET @TableID = 'HT0315'
IF @FormID = 'HF0308' SET @TableID = 'HT0308'

IF @IsQuarter = 1	--- hiển thị dữ liệu quý
	BEGIN
		IF Isnull(@FormID,'') <> ''
			SET @SQL = 'SELECT Distinct TimesNo From ' + @TableID + '
						WHERE 	DivisionID = ''' + @DivisionID + ''' And TranYear = ' + str(@TranYear) + ' And
								TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')	
						ORDER BY TimesNo'
		ELSE
			SET @SQL = 'SELECT Distinct TimesNo From (
						SELECT TimesNo From HT0301
						WHERE 	DivisionID = ''' + @DivisionID + ''' And TranYear = ' + str(@TranYear) + ' And
								TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')	
						UNION
						SELECT TimesNo From HT0310
						WHERE 	DivisionID = ''' + @DivisionID + ''' And TranYear = ' + str(@TranYear) + ' And
								TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')	
						UNION
						SELECT TimesNo From HT0312
						WHERE 	DivisionID = ''' + @DivisionID + ''' And TranYear = ' + str(@TranYear) + ' And
								TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')
						UNION
						SELECT TimesNo From HT0315
						WHERE 	DivisionID = ''' + @DivisionID + ''' And TranYear = ' + str(@TranYear) + ' And
								TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')
						UNION
						SELECT TimesNo From HT0308
						WHERE 	DivisionID = ''' + @DivisionID + ''' And TranYear = ' + str(@TranYear) + ' And
								TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')
						) A
						ORDER BY TimesNo'
	END
ELSE	--- hiển thị dữ liệu tháng
	BEGIN
		IF Isnull(@FormID,'') <> ''
			SET @SQL = 'SELECT Distinct TimesNo From ' + @TableID + '
						WHERE 	DivisionID = ''' + @DivisionID + ''' And
								TranMonth = ' + str(@TranMonth) + ' AND TranYear = ' + str(@TranYear) + '
						ORDER BY TimesNo'
		ELSE
			SET @SQL = 'SELECT Distinct TimesNo From (
						SELECT TimesNo From HT0301
						WHERE 	DivisionID = ''' + @DivisionID + ''' And
								TranMonth = ' + str(@TranMonth) + ' AND TranYear = ' + str(@TranYear) + '
						UNION
						SELECT TimesNo From HT0310
						WHERE 	DivisionID = ''' + @DivisionID + ''' And
								TranMonth = ' + str(@TranMonth) + ' AND TranYear = ' + str(@TranYear) + '
						UNION
						SELECT TimesNo From HT0312
						WHERE 	DivisionID = ''' + @DivisionID + ''' And
								TranMonth = ' + str(@TranMonth) + ' AND TranYear = ' + str(@TranYear) + '
						UNION
						SELECT TimesNo From HT0315
						WHERE 	DivisionID = ''' + @DivisionID + ''' And
								TranMonth = ' + str(@TranMonth) + ' AND TranYear = ' + str(@TranYear) + '
						UNION
						SELECT TimesNo From HT0308
						WHERE 	DivisionID = ''' + @DivisionID + ''' And
								TranMonth = ' + str(@TranMonth) + ' AND TranYear = ' + str(@TranYear) + '	
						) A
						ORDER BY TimesNo'
						
	END

EXEC(@SQL)