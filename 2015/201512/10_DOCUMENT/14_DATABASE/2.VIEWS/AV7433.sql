
/****** Object:  View [dbo].[AV7433]    Script Date: 12/16/2010 14:53:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Nguyen Van Nhan .
----- Date 25/08/2005
----- Purpose: In to khai thue GTGT

ALTER VIEW [dbo].[AV7433] as
Select 	AT7435.DivisionID, AT7434.ReportCodeID, AT7435.LineID, 	Amount01, Amount02, Code01, Code02,
	OrderNo, Orders, IsNotPrint, LineDescription,
	IsBold, IsGray,  IsAmount
    From AT7435 inner join AT7434 on AT7434.LineID = AT7435.LineID and
				 AT7434.ReportCodeID = AT7435.ReportCodeID and
				AT7434.Type =0

GO


