
/****** Object:  StoredProcedure [dbo].[HP5555]    Script Date: 08/05/2010 10:05:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Create by: Dang Le Bao Quynh; Date 26/01/2007
---- Purpose : Tao ma kiem soat dieu kien tinh luong
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP5555]
       @NC decimal(28,8) ,
       @HSC decimal(28,8) ,
       @LCB decimal(28,8) ,
       @ConditionCode nvarchar(4000) ,
       @ResultOutput decimal(28,8) OUTPUT
AS
DECLARE @SQL nvarchar(4000)


SET @ConditionCode = REPLACE(@ConditionCode , 'If' , ' Case When ')
SET @ConditionCode = REPLACE(@ConditionCode , '@NC' , isnull(@NC , 0))
SET @ConditionCode = REPLACE(@ConditionCode , '@HSC' , isnull(@HSC , 1))
SET @ConditionCode = REPLACE(@ConditionCode , '@LCB' , isnull(@LCB , 0))

IF EXISTS ( SELECT
                Id
            FROM
                sysobjects
            WHERE
                Id = Object_ID('HV5555') AND XType = 'V' )
   BEGIN
         DROP VIEW HV5555
   END

SET @SQL = 'Create View HV5555 AS Select ' + @ConditionCode + ' As ResultOutput'
EXEC ( @SQL )

SET @ResultOutput = ( SELECT TOP 1
                          ResultOutput
                      FROM
                          HV5555 )