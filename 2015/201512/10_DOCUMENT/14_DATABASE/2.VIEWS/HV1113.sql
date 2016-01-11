

/****** Object:  View [dbo].[HV1113]    Script Date: 12/20/2011 16:26:00 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV1113]'))
DROP VIEW [dbo].[HV1113]
GO


/****** Object:  View [dbo].[HV1113]    Script Date: 12/20/2011 16:26:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


----- Created by Nguyen Van Nhan, Date 03/04/04
---- Purpose: Loc ra cac muc luong, he so


CREATE VIEW [dbo].[HV1113] as 
Select  HV1112.DivisionID ,BaseSalaryFieldID as ParaID, Description as ParaName, Orders, 0 as Status
From HV1112
		
Union 
Select 	HV1111.DivisionID,CoefficientID as ParaID, Caption as ParaName, Orders, 1 as Status
From HV1111


GO


