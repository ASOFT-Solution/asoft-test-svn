/****** Object:  View [dbo].[MV1601]    Script Date: 12/16/2010 15:24:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan 
--Date 
--Purpose: Lay du lieu Danh muc DTTHCP 

ALTER VIEW [dbo].[MV1601] as 
Select
	PeriodID,MT1601.FromMonth, MT1601.FromYear, MT1601.ToMonth, MT1601.ToYear,
	MT1601.Description,
	MT1601.DivisionID,
	MT5000.DistributionName as DistributionName,
	MT1608.Description as InprocesName,
	MT1601.Disabled, IsDistribute, IsCost, IsInprocess, MT1601.IsForPeriodID,
 (Case When  FromMonth <10 then '0'+rtrim(ltrim(str(FromMonth)))+'/'+ltrim(Rtrim(str(FromYear))) 
	Else rtrim(ltrim(str(FromMonth)))+'/'+ltrim(Rtrim(str(FromYear))) End) as FromMonthYear,
(Case When  ToMonth <10 then '0'+rtrim(ltrim(str(ToMonth)))+'/'+ltrim(Rtrim(str(ToYear))) 
	Else rtrim(ltrim(str(ToMonth)))+'/'+ltrim(Rtrim(str(ToYear))) End) as ToMonthYear,

	 MT1601.CreateDate ,                 MT1601.CreateUserID,         MT1601.LastModifyDate,              MT1601.LastModifyUserID  
From MT1601 	Left join MT5000 on MT5000.DistributionID = MT1601.DistributionID And MT5000.DivisionID = MT1601.DivisionID
		Left join MT1608 on MT1608.InProcessID = MT1601.InProcessID And MT1608.DivisionID = MT1601.DivisionID

GO


