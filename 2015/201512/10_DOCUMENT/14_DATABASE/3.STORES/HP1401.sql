/****** Object:  StoredProcedure [dbo].[HP1401]    Script Date: 07/29/2010 14:14:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Created by Vo Thanh Huong
----- Created Date 17/05/2003
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[HP1401]	@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TeamID as nvarchar(50),
				@SQLstring as nvarchar(4000),
				@SQLOrderBy as nvarchar(4000)					
 AS 		

Declare @strSQL as nvarchar(4000)

Set @strSQL = 'Select *
FROM HV1400
WHERE DivisionID like ''' + @DivisionID + '''
	and DepartmentID like ''' + @DepartmentID + ''' and ' +
	Case when @SQLstring != '' then @SQLstring + ' and ' else '' end + '
	isnull(TeamID,'''') like ''' + @TeamID + ''''
Set @strSQL = @strSQL +
Case when @SQLOrderBy != '' then 'Order by ' + @SQLOrderBy else '' end

--Print @strSQL

If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV1401]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV1401 as ' + @strSQL)
Else
	Exec (' Alter  View HV1401 as ' + @strSQL)


