/****** Object:  View [dbo].[MV8888]    Script Date: 12/16/2010 15:41:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Created by: Vo Thanh Huong, date: 13/06/2005
--Purpose: Quan ly bao cao (view chet)

ALTER VIEW [dbo].[MV8888] 
AS
Select 'G01' as GroupID, 'MFML000247'  as GroupName, DivisionID --'Chi phí phaùt sinh'
FROM AT1101

UNION
Select 'G02' as GroupID,  'MFML000248' as GroupName, DivisionID --'Phaân boå'
FROM AT1101

UNION
Select 'G03' as GroupID,  'MFML000249' as GroupName, DivisionID --'Giaù thaønh saûn phaåm'
FROM AT1101

UNION
Select 'G08' as GroupID, 'MFML000250' as GroupName, DivisionID --'Keát quaû saûn xuaát' 
FROM AT1101

UNION
Select 'G09' as GroupID, 'MFML000251' as GroupName, DivisionID --'Quaûn lyù saûn xuaát' 
FROM AT1101

UNION
Select 'G99' as GroupID, 'MFML000252' as GroupName, DivisionID --'Khaùc' 
FROM AT1101


GO


