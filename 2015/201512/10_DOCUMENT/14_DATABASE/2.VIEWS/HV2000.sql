IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV2000]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV2000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- View chết đổ nguồn 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 12/08/2013 by Nguyễn Thanh Sơn
---- 
---- Modified on 12/08/2013 by Nguyễn Thanh Sơn : Đổ nguồn cho Mode, Sex
---- 
-- <Example>
---- 
CREATE VIEW HV2000

AS 

------------>>> DropDownCloumn Mode <<<------------------------
SELECT 'Mode' AS ID , '1' AS Code, N'Ngày vào làm' AS Name, N'WorkDate' AS NameE
UNION ALL
SELECT 'Mode' AS ID , '2' AS Code, N'Ngày sinh' AS Name, N'BirthDay' AS NameE

------------>>> DropDownColumn Sex <<<------------------------
UNION ALL
SELECT 'Sex' AS ID , '0' AS Code, N'Nữ' AS Name, N'Female' AS NameE
UNION ALL
SELECT 'Sex' AS ID , '1' AS Code, N'Nam' AS Name,N'Male' AS NameE



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
