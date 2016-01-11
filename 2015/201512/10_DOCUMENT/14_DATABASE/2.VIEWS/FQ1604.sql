IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[FQ1604]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[FQ1604]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---View chet ho tro cau SQL load hieu chinh man hinh  phan bo cong cu dung cu
-- Auth: Thuy TUyen
--Date:14/08/2008

CREATE VIEW [dbo].[FQ1604]
as
Select   AT1604.*, AT1603.ToolName  from AT1604  inner join AT1603 on AT1603.ToolID = AT1604.ToolID  and AT1603.DivisionID = AT1604.DivisionID And AT1603.VoucherID = AT1604.ReVoucherID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON