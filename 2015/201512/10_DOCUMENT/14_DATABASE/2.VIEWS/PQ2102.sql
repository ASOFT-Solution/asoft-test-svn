IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[PQ2102]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[PQ2102]
GO
/****** Object:  View [dbo].[PQ2102]    Script Date: 12/16/2010 15:37:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*Create By: Dang Le Bao Quynh; Date 23/04/2009.
Purpose: View chet loc danh sach detail don hang san xuat.



*/
CREATE VIEW [dbo].[PQ2102]
AS
SELECT     	T2.DivisionID,Q1.VoucherID, Q1.TranMonth, Q1.TranYear, Q1.VoucherTypeID, Q1.VoucherNo, Q1.VoucherDate, Q1.OrderStatus, Q1.OrderStatusName, Q1.ObjectID, Q1.ObjectName, 
		Q1.VATNo, Q1.Address, Q1.ContractNo, Q1.ContractDate, Q1.ShipDate, Q1.DeliveryAddress, Q1.Transport, Q1.Contact, 
		Q1.SalesManID, Q1.SalesManName, Q1.EmployeeID, Q1.Notes, 
		Q1.Disabled, Q1.CreateDate, Q1.CreateUserID, Q1.LastModifyUserID, Q1.LastModifyDate , 
		T2.TransactionID , T2.Orders , T2.OrderGroup , T2.StyleID , T7.StyleName , 
		T7.StyleGroupID , T6.StyleGroupName , T2.UnitID , T2.Quantity , T2.PaletteID, 
		T4.PaletteName, T2.ColorID, T5.ColorName, T5.Color, T2.Breadth, T2.Weight, 
		T2.WeightUnit, T2.Quality, T2.ProgressID, T2.Description, T2.Ana01ID, T2.Ana02ID, 
		T2.Ana03ID, T2.Ana04ID, T2.Ana05ID,
		T2.IsPlan, T2.FactoryID, T2.MacTypeID, T12.MacTypeName, T2.MacQuantity, T2.RawQuantity, T2.BeginDate, T2.PlanFinishedDate, T2.PlanDescription
FROM            
		dbo.PT2102 T2 LEFT JOIN
		dbo.PT1104 T4 ON T2.PaletteID = T4.PaletteID LEFT JOIN
		dbo.PT1105 T5 ON T2.ColorID = T5.ColorID AND T2.PaletteID = T5.PaletteID LEFT JOIN
		dbo.PT1107 T7 ON T2.StyleID = T7.StyleID LEFT JOIN
		dbo.PT1106 T6 ON T7.StyleGroupID = T6.StyleGroupID LEFT JOIN
		dbo.PQ2101 Q1 ON T2.VoucherID = Q1.VoucherID LEFT JOIN
		PT1102 T12 ON T2.MacTypeID = T12.MacTypeID

GO


