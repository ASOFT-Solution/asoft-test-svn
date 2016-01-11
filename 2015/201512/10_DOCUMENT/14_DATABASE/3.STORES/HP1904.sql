IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1904]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1904]
GO

/****** Object:  StoredProcedure [dbo].[HP1904]    Script Date: 10/04/2011 11:12:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/


CREATE PROCEDURE [dbo].[HP1904] @sSQL nvarchar (4000)
AS
If not exists (Select id From Sysobjects Where ID = Object_ID('HV1904') And XType = 'V')
	Exec ('Create View HV1904 As ' + @sSQL)
Else
	Exec ('Alter View HV1904 As ' + @sSQL)
GO


