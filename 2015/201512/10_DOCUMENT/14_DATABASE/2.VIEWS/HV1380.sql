/****** Object:  View [dbo].[HV1380]    Script Date: 12/16/2010 15:12:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Descriptions: View chet
-- Create by: Dang Le Bao Quynh; Date 13/03/2007
-- Purpose: View quan ly cac quyet dinh thoi viec.

ALTER VIEW [dbo].[HV1380] As
SELECT HT1380.DecidingNo, HT1380.DecidingDate, HT1380.DecidingPerson,
(Select Fullname From HV1400 Where HV1400.EmployeeID = HT1380.DecidingPerson And HV1400.DivisionID = HT1380.DivisionID ) As DecidingPersonName, 
HT1380.DecidingPersonDuty, HT1380.Proposer,
(Select Fullname From HV1400 Where HV1400.EmployeeID = HT1380.Proposer And HV1400.DivisionID = HT1380.DivisionID) As ProposerName, 
HT1380.ProposerDuty, HT1380.EmployeeID, HV1400.FullName, HV1400.IsMaleID, HT1380.DutyName,
HT1380.WorkDate, HT1380.LeaveDate, HT1380.QuitJobID, HT1107.QuitJobName, HT1380.Allowance, HT1380.Notes,
HT1380.DivisionID,
HV1400.Birthday, HV1400.IdentifyCardNo, HV1400.IdentifyDate , HV1400.IdentifyPlace
FROM HT1380 
INNER JOIN HV1400 ON HT1380.EmployeeID = HV1400.EmployeeID AND HT1380.DivisionID = HV1400.DivisionID	
INNER JOIN HT1107 ON HT1380.QuitJobID = HT1107.QuitJobID AND HT1380.DivisionID = HT1107.DivisionID

GO

Select * from  HT1400