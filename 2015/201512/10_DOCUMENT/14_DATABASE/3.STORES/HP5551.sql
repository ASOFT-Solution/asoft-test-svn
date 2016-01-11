IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5551]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5551]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 24/10/2013
---- Purpose : Tính mức hưởng BHXH theo chế độ ốm đau
---- HP5551 'AS',2012,0,0,'02/01/2012',NULL,3000000,1

CREATE PROCEDURE [dbo].[HP5551]
	@DivisionID nvarchar(50),
	@TranYear int,
	@ConditionTypeID nvarchar(50),
	@WorkConditionTypeID nvarchar(50),
	@SBeginDate datetime,
	@ChildBirthDate datetime,
	@LBH decimal(28,8),
    @NN int
AS

DECLARE @SQL nvarchar(4000),
		@ConditionCode nvarchar(4000),
		@TGD int,
		@LTT decimal(28,8),
		@MaxLeaveDays int
		
SELECT top 1 @LTT = MinSalary FROM HT0000 Where DivisionID = @DivisionID
SET @TGD = @TranYear - YEAR(@SBeginDate)

IF @ConditionTypeID = 0	--- ốm ngắn ngày
	SELECT @ConditionCode = ConditionCode, @MaxLeaveDays = MaxLeaveDays FROM HT0306
	WHERE DivisionID = @DivisionID
	AND ConditionTypeID = @ConditionTypeID And Isnull(WorkConditionTypeID,0) = @WorkConditionTypeID
	AND @TranYear - YEAR(@SBeginDate) >= InYearsFrom And @TranYear - YEAR(@SBeginDate) < InYearsTo

ELSE IF @ConditionTypeID = 1 --- ốm dài ngày
	SELECT @ConditionCode = ConditionCode, @MaxLeaveDays = 1800  FROM HT0306
	WHERE DivisionID = @DivisionID
	AND ConditionTypeID = @ConditionTypeID

ELSE --- con ốm
	SELECT @ConditionCode = ConditionCode, @MaxLeaveDays = MaxLeaveDays FROM HT0306
	WHERE DivisionID = @DivisionID
	AND ConditionTypeID = @ConditionTypeID
	AND @TranYear - YEAR(@ChildBirthDate) >= InYearsFrom And @TranYear - YEAR(@ChildBirthDate) < InYearsTo

SET @ConditionCode = REPLACE(@ConditionCode , 'Else If' , 'When ')
SET @ConditionCode = REPLACE(@ConditionCode , 'If' , 'Case When ')
SET @ConditionCode = REPLACE(@ConditionCode , '@NN' , isnull((case when @NN > @MaxLeaveDays then @MaxLeaveDays else @NN end), 0))
SET @ConditionCode = REPLACE(@ConditionCode , '@LBH' , isnull(@LBH , 0))
SET @ConditionCode = REPLACE(@ConditionCode , '@LTT' , isnull(@LTT , 0))
SET @ConditionCode = REPLACE(@ConditionCode , '@TGD' , isnull(@TGD , 0))

IF EXISTS ( SELECT
                Id
            FROM
                sysobjects
            WHERE
                Id = Object_ID('HV5551') AND XType = 'V' )
   BEGIN
         DROP VIEW HV5551
   END

SET @SQL = 'Create View HV5551 AS Select ' + ISNULL(@ConditionCode,0) + ' As ResultOutput'
EXEC (@SQL)

SELECT TOP 1 ResultOutput as Amounts
FROM HV5551