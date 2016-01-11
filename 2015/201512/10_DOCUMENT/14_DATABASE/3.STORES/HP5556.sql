IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5556]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5556]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---- Created by Bao Anh		Date: 05/08/2013
---- Purpose: Tinh so cong theo dieu kien

CREATE PROCEDURE [dbo].[HP5556]
       @AbsentAmount decimal(28,8),
       @ConditionCode nvarchar(4000) ,
       @ResultOutput decimal(28,8) OUTPUT
AS

DECLARE @SQL nvarchar(4000)

SET @ConditionCode = REPLACE(@ConditionCode , 'If' , ' Case When ')
SET @ConditionCode = REPLACE(@ConditionCode , '@AbsentAmount' , isnull(@AbsentAmount , 0))

IF EXISTS ( SELECT
                Id
            FROM
                sysobjects
            WHERE
                Id = Object_ID('HV5556') AND XType = 'V' )
   BEGIN
         DROP VIEW HV5556
   END

SET @SQL = 'Create View HV5556 AS Select ' + @ConditionCode + ' As ResultOutput'
EXEC(@SQL)

SET @ResultOutput = ( SELECT TOP 1
                          ResultOutput
                      FROM
                          HV5556 )
                          