IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1591]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1591]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



------ View chet
------ Created by Nguyen Quoc Huy, Date 23/03/2007
------ Purpose : The hien cac TSCD thay doi nguyen gia.


CREATE VIEW [dbo].[AV1591]
AS
		SELECT     
		AT1506.RevaluateID, AT1506.DivisionID, AT1506.AssetID, AT1506.AssetName,
		AT1506.ConvertedOldAmount, AT1506.ConvertedNewAmount, AT1506.ResidualOldValue,
		AT1506.DepOldAmount, AT1506.DepNewAmount, AT1506.DepOldPeriods,
		AT1506.DepNewPeriods, AT1506.Tranmonth, AT1506.TranYear,
		AT1506.RevaluateNo,AT1506.Description, AT1590.Status, AT1590.VoucherNo, AT1506.CreateUserID
		

		FROM        AT1506 left join AT1590 on AT1590.VoucherID = AT1506.RevaluateID And AT1590.DivisionID = AT1506.DivisionID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

