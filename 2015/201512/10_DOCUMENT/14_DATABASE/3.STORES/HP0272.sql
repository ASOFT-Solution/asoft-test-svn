IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0272]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0272]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đổ nguồn màn hình Đơn giá phương án lương
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/05/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 10/04/2013 by Lê Thi Thu Hiền
---- Modified on 12/06/2013 by Lê Thị Thu Hiền : Bổ sung DatePrice, WaitPrice
---- Modiefied on 14/11/2013 by Thanh Sơn: Bổ sung Kết PSV0001 where PSV0001.TypeID = 'WorkType'
-- <Example>
---- EXEC HP0272 'SAS', 'ADMIN', 'BG05'
CREATE PROCEDURE HP0272
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@PriceID AS NVARCHAR(50)
) 
AS 


SELECT  HT0272.PriceID,
		HT0272.Orders AS Orders,
		HT0272.APK,
		HT0271.Description,
		HT0271.FromDate, HT0271.ToDate,
		HT0271.DatePrice,HT0271.WaitPrice,
		HT0272.InventoryTypeID, AT1301.InventoryTypeName , 
		HT0272.InventoryID , AT1302.InventoryName ,
		HT0272.PlanID , PST1000.PlanName ,
		HT0272.UnitID, AT1304.UnitName,
		HT0272.Price, 
		HT0272.WorkID,HT0267.WorkName,
		HT0272.SubPlanID,PST2080.SubPlanName,
		HT0272.SalaryPlanID, HT0269.SalaryPlanName,
		HT0272.WorkTypeID, PSV0001.[Description] AS WorkTypeName
FROM HT0272 
LEFT JOIN HT0271 ON HT0271.DivisionID = HT0272.DivisionID AND HT0271.PriceID = HT0272.PriceID
LEFT JOIN AT1301 ON AT1301.DivisionID = HT0272.DivisionID AND AT1301.InventoryTypeID = HT0272.InventoryTypeID
LEFT JOIN AT1302 ON AT1302.DivisionID = HT0272.DivisionID AND AT1302.InventoryTypeID = AT1301.InventoryTypeID 
					AND HT0272.InventoryID = AT1302.InventoryID
LEFT JOIN PST1000 ON PST1000.DivisionID = HT0272.DivisionID AND PST1000.PlanID = HT0272.PlanID
LEFT JOIN AT1304 ON AT1304.DivisionID = HT0272.DivisionID AND AT1304.UnitID = HT0272.UnitID
LEFT JOIN HT0267 ON HT0267.DivisionID = HT0272.DivisionID AND HT0267.WorkID = HT0272.WorkID
LEFT JOIN PST2080 ON PST2080.DivisionID = HT0272.DivisionID AND PST2080.SubPlanID = HT0272.SubPlanID
LEFT JOIN HT0269 ON HT0269.DivisionID = HT0272.DivisionID AND HT0269.SalaryPlanID = HT0272.SalaryPlanID
LEFT JOIN PSV0001 ON PSV0001.Code = HT0272.WorkTypeID AND PSV0001.TypeID = 'WorkType'

WHERE HT0272.DivisionID = @DivisionID
		AND HT0272.PriceID = @PriceID
		
UNION
SElECT	NULL AS PriceID,
		(Select max(Orders) from HT0272 Where DivisionID = @DivisionID and PriceID = @PriceID) + 1 AS Orders,
		NULL AS APK,
		NULL AS Description,
		NULL AS FromDate, NULL AS ToDate,
		0 AS DatePrice,0 AS WaitPrice,
		HT0269.InventoryTypeID, AT1301.InventoryTypeName , 
		HT0269.InventoryID , AT1302.InventoryName ,
		HT0269.PlanID , PST1000.PlanName ,
		AT1302.UnitID, AT1304.UnitName,
		NULL AS Price, 
		HT0269.WorkID,HT0267.WorkName,
		HT0269.SubPlanID,PST2080.SubPlanName,
		HT0269.SalaryPlanID, HT0269.SalaryPlanName,
		HT0269.WorkTypeID, PSV0001.[Description] AS WorkTypeName
FROM HT0269
--FULL JOIN (SELECT Code, [Description], @DivisionID AS DivisionID FROM PSV0001 WHERE TypeID = 'WorkType') A
--	ON HT0269.DivisionID = A.DivisionID
LEFT JOIN AT1301 ON AT1301.DivisionID = HT0269.DivisionID AND AT1301.InventoryTypeID = HT0269.InventoryTypeID
LEFT JOIN AT1302 ON AT1302.DivisionID = HT0269.DivisionID AND AT1302.InventoryID = HT0269.InventoryID
LEFT JOIN PST1000 ON PST1000.DivisionID = HT0269.DivisionID AND PST1000.PlanID = HT0269.PlanID
LEFT JOIN AT1304 ON AT1304.DivisionID = AT1302.DivisionID AND AT1304.UnitID = AT1302.UnitID
LEFT JOIN HT0267 ON HT0267.DivisionID = HT0269.DivisionID AND HT0267.WorkID = HT0269.WorkID
LEFT JOIN PST2080 ON PST2080.DivisionID = HT0269.DivisionID AND PST2080.SubPlanID = HT0269.SubPlanID
LEFT JOIN PSV0001 ON PSV0001.Code = HT0269.WorkTypeID AND PSV0001.TypeID= 'WorkType'

WHERE	HT0269.SalaryPlanID not in (Select SalaryPlanID from HT0272 Where DivisionID = @DivisionID and PriceID = @PriceID)
		AND ISNULL(HT0269.InventoryTypeID,'') <> ''
ORDER BY Orders

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
