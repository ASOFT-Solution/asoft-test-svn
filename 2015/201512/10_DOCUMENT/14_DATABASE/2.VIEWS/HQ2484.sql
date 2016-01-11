
/****** Object:  View [dbo].[HQ2484]    Script Date: 11/24/2011 17:20:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HQ2484]'))
DROP VIEW [dbo].[HQ2484]
GO



/****** Object:  View [dbo].[HQ2484]    Script Date: 11/24/2011 17:20:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[HQ2484]  
AS  
-- Create by: Dang Le Thanh Tra; Date: 09/05/2011  
-- Purpose: View chet xac nhan che do trong con om  
  
SELECT HT84.*, HV00.FullName, HV00.BirthDay, HV00.SoInsuranceNo, HT04.RelationDate  
FROM HT2484 HT84 INNER JOIN HV1400 HV00 ON HT84.EmployeeID = HV00.EmployeeID  and HT84.DivisionID = HV00.DivisionID  
    LEFT JOIN HT1404 HT04 ON HT84.EmployeeID = HT04.EmployeeID AND HT04.RelationName = HT84.ChildName  and HT04.DivisionID = HT84.DivisionID  
GO


