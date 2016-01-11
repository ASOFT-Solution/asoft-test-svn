
/****** Object:  StoredProcedure [dbo].[HP1301]    Script Date: 01/05/2012 16:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1301]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1301]
GO

/****** Object:  StoredProcedure [dbo].[HP1301]    Script Date: 01/05/2012 16:16:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Created by: Nguyen Quoc Huy
-- Created date: 25/2/2004
-- Purpose:  Quan ly qua trinh hoc tap
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[HP1301]  @DivisionID nvarchar(50),
				 @EmployeeID nvarchar(50),
				 @Regulartraining nvarchar (50),
				 @Servicetraining nvarchar (50),
				 @Candidate nvarchar (50),
				 @Supplementatrytraining nvarchar (50),
				 @Other nvarchar (50)			 

 AS

Declare  @strSQL as nvarchar(4000)

Set @strSQL = ' Select HT01.DivisionID, HT01.EmployeeID, HT01.HistoryID, 
		HT01.SchoolID, HT03.SchoolName,
		HT01.MajorID, HT04.MajorName, HT01.TypeID ,
		TypeName = Case  HT01.TypeID When  1 then N'''+@Regulartraining+'''
						 When  2 then N'''+@Servicetraining+'''
						 When  3 then N'''+@Candidate+'''
						 When  4 then N'''+@Supplementatrytraining+'''
						 When  9 then N'''+@Other+'''
			         End,
		HT01.FromMonth, HT01.FromYear,
		HT01.ToMonth,HT01.ToYear,
  		HT01.Description, HT01.Notes
From HT1301 as HT01 
		Left Join HT1003 HT03 On HT03.SchoolID = HT01.SchoolID and HT03.DivisionID = HT01.DivisionID
		Left Join HT1004 HT04 On HT04.MajorID = HT01.MajorID and HT04.DivisionID = HT01.DivisionID
Where HT01.EmployeeID = '''+@EmployeeID+''' and HT01.DivisionID = '''+@DivisionID+''''


If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV1301]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV1301 -- TẠO BỞI HP1301
	as ' + @strSQL)
Else
	Exec (' Alter  View HV1301 -- TẠO BỞI HP1301
	as ' + @strSQL)

GO


