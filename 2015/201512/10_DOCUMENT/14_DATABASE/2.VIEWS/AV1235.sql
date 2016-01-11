IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1235]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1235]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---Created by : Thuy Tuyen, date: 08/08/2010 , view chet 
---Purpose: tao du lieu ngam  ma chi nhanh man hinh ke thua mau hang , ban hang (AF3026)
---Edit by : Mai Duyen,Date 25/03/2014: Sửa lại font VniTime-> Unicode
---Edit by : Mai Duyen,Date 01/04/2014: bo sung N trước chuỗi
CREATE VIEW dbo.AV1235

AS
SELECT 'ASNB' as TypeID,N'Chi nhánh ASGIT' AS Description, N'Chi nhánh ASGIT' as EDescription
    
UNION
SELECT 'HN' as TypeID,N'Chi nhánh Hà Nội' AS Description, N'Chi nhánh Hà Nội' as EDescription
       
UNION
SELECT 'IPNB' as TypeID,N'Chi nhánh IPAS' AS Description, N'Chi nhánh IPAS' as EDescription

UNION
SELECT 'PRNB' as TypeID,N'Chi nhánh PRINTECH' AS Description, N'Chi nhánh PRINTECH' as EDescription

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

