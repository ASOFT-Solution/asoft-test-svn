IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2418]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP2418]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by: Trần Quốc Tuấn, date: 06/11/2015
---Purpose:  Insert vào HT2406 tu Table tam của db quét thẻ chấm công
---Edit by: Dang Le Bao Quynh, date 05/10/2007

/********************************************
'* Edited by: 
'********************************************/
-- Ex: HP2418 @TableID='112015', @DbTemp='HRMTK'

CREATE PROCEDURE [dbo].[HP2418] 
(
	@TableID VARCHAR(50),
	@DbTemp VARCHAR(50)
)				
AS

DECLARE @sSQL NVARCHAR(MAX)

SET @sSQL='
IF EXISTS (SELECT TOP 1 1 FROM '+@DbTemp+'.dbo.sysobjects WHERE NAME='''+@TableID+''' AND xtype =''U'')

	INSERT INTO HT2406(DivisionID, TranMonth, Tranyear, AbsentCardNo, AbsentDate,
				AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod)
            
	SELECT DISTINCT H.DivisionID,H.TranMonth,H.Tranyear,H.AbsentCardNo,H.AbsentDate,
		   H.AbsentTime,H.MachineCode,H.IVerifyMethod,H.IAttState,H.IAttState
	FROM '+@DbTemp+'.dbo.['+@TableID+'] H
	LEFT JOIN HT2406  H6 ON H6.AbsentCardNo=H.AbsentCardNo AND H6.AbsentDate =H.AbsentDate 
						 AND H6.AbsentTime=H.AbsentTime AND H6.DivisionID=H.DivisionID
						 AND H6.TranMonth=H.TranMonth AND H6.Tranyear=H.TranYear
	WHERE H6.APK IS NULL
'
EXEC (@sSQL)
PRINT (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
