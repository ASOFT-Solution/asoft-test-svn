

/****** Object:  View [dbo].[HV1111]    Script Date: 01/11/2012 14:45:34 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV1111]'))
DROP VIEW [dbo].[HV1111]
GO



/****** Object:  View [dbo].[HV1111]    Script Date: 01/11/2012 14:45:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Nguyen Van Nhan, Date 03/04/04
----- View Chet hien thi ca he so
CREATE VIEW [dbo].[HV1111] as 
Select 	'SalaryCoefficient' as CoefficientID,
	N'HV1111.SalaryCoefficient' as Caption,
	0 as Orders, DivisionID
From HT0003	
WHere IsUsed =1
Union
Select 	'DutyCoefficient' as CoefficientID,
	N'HV1111.DutyCoefficient' as Caption,
	0 as Orders, DivisionID
From HT0003
WHere IsUsed =1
Union
Select 	'TimeCoefficient' as CoefficientID,
	N'HV1111.TimeCoefficient' as Caption,
	0 as Orders, DivisionID
From HT0003
WHere IsUsed =1
Union
Select CoefficientID ,  Caption,
	1 as Orders, DivisionID
From HT0003
WHere IsUsed =1
GO


