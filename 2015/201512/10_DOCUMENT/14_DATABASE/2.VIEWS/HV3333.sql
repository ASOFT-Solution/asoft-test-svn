/****** Object:  View [dbo].[HV3333]    Script Date: 01/12/2012 14:03:19 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV3333]'))
DROP VIEW [dbo].[HV3333]
GO

/****** Object:  View [dbo].[HV3333]    Script Date: 01/12/2012 14:03:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Created by: Nguyen Quoc Huy
-- Created date: 13/2/2004
-- Purpose: Insert vao chi tieu muon thong ke

CREATE VIEW [dbo].[HV3333] As 
Select 'IsMale' as FieldID, N'Nam' as Description, N'Male' as DescriptionE , 1 as Value ,1 as Type
Union
Select 'IsMale' as FieldID, N'Nữ' as Description, N'FeMale' as DescriptionE , 0 as Value, 1 as Type
Union 
Select 'IsSingle' as FieldID, N'Độc thân' as Description, N'Single' as DescriptionE, 1 as Value, 2 as Type 	
Union 
Select 'IsSingle' as FieldID, N'Đã lập gia đình' as Description, N'Married' as DescriptionE, 0 as Value, 2 as Type


GO


