
/****** Object:  View [dbo].[AV1541]    Script Date: 12/16/2010 14:43:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------ View chet
------ Created by Huynh Trung Dung, Date 30/03/2007
------ Purpose : The hien cac ghi giam TSCD.


ALTER VIEW [dbo].[AV1541]
AS
		SELECT     
		AT1507.ReduceID, AT1507.DivisionID, AT1507.AssetID, AT1507.AssetName,AT1507.OldAssetStatusID,
		AT1507.ConvertedAmount, AT1507.ReduceNo,AT1507.ReduceDate,AT1507.ResidualValue,AT1507.EmployeeID,
		AT1507.AccruedDepAmount, AT1507.ConvertedReduceFee, AT1507.DepartmentID,AT1507.AssetUser,AT1507.ConvertedReduceAmount,
		AT1507.AssetStatusID,AT1507.Tranmonth, AT1507.TranYear,AT1507.Description, AT1590.Status
		FROM  AT1507 left join AT1590 on AT1590.VoucherID = AT1507.ReduceID

GO


