
/****** Object:  View [dbo].[AV1508]    Script Date: 12/16/2010 14:41:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--View chet
ALTER VIEW [dbo].[AV1508] as 
select AssetID,DivisionID,AssetName,AssetStatus
from AT1503

GO


