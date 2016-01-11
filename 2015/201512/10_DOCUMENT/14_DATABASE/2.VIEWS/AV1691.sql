if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AV1691]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[AV1691]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


------ View chet
------ Created by Nguyen Quoc Huy, Date 06/07/2009.
------ Purpose : The hien cac CCDC thay doi nguyen gia.


CREATE VIEW [dbo].[AV1691]
AS
		SELECT     
		AT1606.RevaluateID, AT1606.DivisionID, AT1606.ToolID, AT1606.ToolName,
		AT1606.ConvertedOldAmount, AT1606.ConvertedNewAmount, AT1606.ResidualOldValue,
		AT1606.DepOldAmount, AT1606.DepNewAmount, AT1606.DepOldPeriods,
		AT1606.DepNewPeriods, AT1606.Tranmonth, AT1606.TranYear,
		AT1606.RevaluateNo,AT1606.Description, AT1690.Status, AT1690.VoucherNo,AT1690.CreateUserID
		

		FROM        AT1606 left join AT1690 on AT1690.VoucherID = AT1606.RevaluateID

GO


