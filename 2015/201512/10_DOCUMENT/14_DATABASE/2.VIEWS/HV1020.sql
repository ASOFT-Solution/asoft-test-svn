IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV1020]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV1020]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Create by Dang Le Bao Quynh; Date: 11/10/2007
-- Purpose: View chet tra ve thong tin ca lam viec
--- Modify on 14/08/2013 by Bao Anh: Bo sung TypeID

CREATE VIEW [dbo].[HV1020]
AS
SELECT     HT1020.ShiftID, HT1020.DivisionID, HT1020.ShiftName, HT1020.BeginTime, HT1020.EndTime, HT1020.WorkingTime, HT1020.Notes, 
                      HT1021.AbsentTypeID, HT1021.FromMinute, HT1021.ToMinute, HT1021.IsNextDay, HT1021.IsOvertime, HT1021.RestrictID, 
                      HT1021.Orders, HT1021.DateTypeID, HT1013.TypeID
FROM       HT1020 INNER JOIN HT1021 ON HT1020.ShiftID = HT1021.ShiftID and HT1020.DivisionID = HT1021.DivisionID
                  LEFT JOIN HT1013 On HT1021.DivisionID = HT1013.DivisionID And HT1021.AbsentTypeID = HT1013.AbsentTypeID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

