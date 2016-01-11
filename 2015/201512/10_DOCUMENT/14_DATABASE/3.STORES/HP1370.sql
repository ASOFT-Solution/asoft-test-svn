

/****** Object:  StoredProcedure [dbo].[HP1370]    Script Date: 11/15/2011 12:30:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1370]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1370]
GO


/****** Object:  StoredProcedure [dbo].[HP1370]    Script Date: 11/15/2011 12:30:16 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



--Create by: Dang Le Bao Quynh; Date: 09/08/2006
--Purpose: Tao view HD1370 de lam record source cho bao cao
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/

CREATE PROCEDURE [dbo].[HP1370] @DivisionID nvarchar(50), 
		@AccidentID nvarchar(50)
AS
DECLARE @sSQL nvarchar(4000)

SET NOCOUNT ON

if exists (SELECT id FROM sysobjects WHERE id=Object_ID('HV1370') AND XTYPE='V')
DROP VIEW HV1370

SET @sSQL='CREATE VIEW HV1370 AS SELECT HV1400.*,(Select top 1 HT1105.ContractTypeName from ht1360 inner join ht1105 on ht1360.ContractTypeID=ht1105.ContractTypeID and ht1360.DivisionID=ht1105.DivisionID
 where ht1360.employeeID=hv1400.employeeID and ht1360.DivisionID = ''' + @DivisionID + ''' order by signDate desc) as ContractTypeName,
		AccidentID,AccidentTime,AccidentDate,AccidentPlace,Wounds,Status01,Status02,Status03,Status04,Status05,Cause01,Cause02,Cause03,Cause04,Cause05,Cause06,Cause07,Cause08,Cause09,OtherCause FROM HV1400
		RIGHT OUTER JOIN HT1370 ON HV1400.EmployeeID=HT1370.EmployeeID and HV1400.DivisionID=HT1370.DivisionID
                       	WHERE HT1370.DivisionID = ''' + @DivisionID + ''' and HT1370.AccidentID=''' + @AccidentID + ''''
EXEC (@sSQL)

SET NOCOUNT ON

GO


