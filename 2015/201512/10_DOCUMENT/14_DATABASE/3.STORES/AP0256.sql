IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0256]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0256]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Danh sach phieu tam ung cua HRM
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 02/12/2011 by Le Thi Thu Hien 
---- 
---- Modified on 02/12/2011 by 
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID

-- <Example>
---- 
CREATE PROCEDURE AP0256
( 
		@DivisionID AS VARCHAR(20),
		@TranMonthFrom AS INT,
		@TranYearFrom AS INT,
		@TranMonthTo AS INT,
		@TranYearTo AS INT,
		@EmployeeID AS VARCHAR(20)
) 
AS 

DECLARE @sSQL AS VARCHAR(8000)		

SET @sSQL = '	
	SELECT	CONVERT(tinyint, 0) AS Selected, 
			AdvanceID,HT2500.EmployeeID,HV1400.FullName,PermanentAddress, 
			HT2500.DepartmentID,HT2500.TeamID,
			TranMonth,TranYear,AdvanceDate,AdvanceAmount,[Description] ,
			ISNULL((	SELECT	SUM(OriginalAmount) 
						FROM	AT9000 
			        	WHERE	TransactionTypeID IN (''T02'',''T22'') 
			        			AND ReVoucherID = AdvanceID),0) AS PaidAmount,
			(AdvanceAmount - ISNULL((	SELECT	SUM(OriginalAmount) 
			                         	FROM	AT9000 
			                         	WHERE	TransactionTypeID IN(''T02'',''T22'') 
			                         			AND ReVoucherID = AdvanceID),0)) AS RemainAmount
	FROM		HT2500 
 	INNER JOIN	HV1400 
 		ON		HT2500.EmployeeID = HV1400.EmployeeID AND HT2500.DivisionID = HV1400.DivisionID
 	WHERE		(TranMonth+TranYear)*100 BETWEEN '+ STR((@TranMonthFrom+@TranYearFrom)*100) + ' AND ' + STR((@TranMonthTo+@TranYearTo)*100) +'
				AND HT2500.EmployeeID like ''' + @EmployeeID + ''''

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

