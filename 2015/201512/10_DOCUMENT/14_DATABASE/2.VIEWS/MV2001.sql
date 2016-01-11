/****** Object:  View [dbo].[MV2001]    Script Date: 12/16/2010 15:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---VIEW CHET ????

ALTER VIEW [dbo].[MV2001] as 
Select  ProductID,UnitID, MT2003.DivisionID, 	
	sum(Case When VoucherDate = Date01 then Quantity else 0 end) as RQuantity01,
	sum(Case When VoucherDate =Date02 then Quantity else 0 end) as RQuantity02,
	sum(Case When VoucherDate =Date03 then Quantity else 0 end) as RQuantity03,
	sum(Case When VoucherDate =Date04 then Quantity else 0 end) as RQuantity04,
	sum(Case When VoucherDate =Date05 then Quantity else 0 end) as RQuantity05,
	sum(Case When VoucherDate =Date06 then Quantity else 0 end) as RQuantity06,
	sum(Case When VoucherDate =Date07 then Quantity else 0 end) as RQuantity07,
	sum(Case When VoucherDate =Date08 then Quantity else 0 end) as RQuantity08,
	sum(Case When VoucherDate =Date09 then Quantity else 0 end) as RQuantity09,
	sum(Case When VoucherDate =Date10 then Quantity else 0 end) as RQuantity10,

	sum(Case When VoucherDate =Date11 then Quantity else 0 end) as RQuantity11,
	sum(Case When VoucherDate =Date12 then Quantity else 0 end) as RQuantity12,
	sum(Case When VoucherDate =Date13 then Quantity else 0 end) as RQuantity13,
	sum(Case When VoucherDate =Date14 then Quantity else 0 end) as RQuantity14,
	sum(Case When VoucherDate =Date15 then Quantity else 0 end) as RQuantity15,
	sum(Case When VoucherDate =Date16 then Quantity else 0 end) as RQuantity16,
	sum(Case When VoucherDate =Date17 then Quantity else 0 end) as RQuantity17,
	sum(Case When VoucherDate =Date18 then Quantity else 0 end) as RQuantity18,
	sum(Case When VoucherDate =Date19 then Quantity else 0 end) as RQuantity19,
	sum(Case When VoucherDate =Date20 then Quantity else 0 end) as RQuantity20,

	sum(Case When VoucherDate =Date21 then Quantity else 0 end) as RQuantity21,
	sum(Case When VoucherDate =Date22 then Quantity else 0 end) as RQuantity22,
	sum(Case When VoucherDate =Date23 then Quantity else 0 end) as RQuantity23,
	sum(Case When VoucherDate =Date24 then Quantity else 0 end) as RQuantity24,
	sum(Case When VoucherDate =Date25 then Quantity else 0 end) as RQuantity25,
	sum(Case When VoucherDate =Date26 then Quantity else 0 end) as RQuantity26,
	sum(Case When VoucherDate =Date27 then Quantity else 0 end) as RQuantity27,
	sum(Case When VoucherDate =Date28 then Quantity else 0 end) as RQuantity28,
	sum(Case When VoucherDate =Date29 then Quantity else 0 end) as RQuantity29,
	sum(Case When VoucherDate =Date30 then Quantity else 0 end) as RQuantity30,

	sum(Case When VoucherDate =Date31 then Quantity else 0 end) as RQuantity31,
	sum(Case When VoucherDate =Date32 then Quantity else 0 end) as RQuantity32,
	sum(Case When VoucherDate =Date33 then Quantity else 0 end) as RQuantity33,
	sum(Case When VoucherDate =Date34 then Quantity else 0 end) as RQuantity34,
	sum(Case When VoucherDate =Date35 then Quantity else 0 end) as RQuantity35,
	sum(Case When VoucherDate =Date36 then Quantity else 0 end) as RQuantity36,
	sum(Case When VoucherDate =Date37 then Quantity else 0 end) as RQuantity37,
	sum(Case When VoucherDate =Date38 then Quantity else 0 end) as RQuantity38,
	sum(Case When VoucherDate =Date39 then Quantity else 0 end) as RQuantity39,
	sum(Case When VoucherDate =Date40 then Quantity else 0 end) as RQuantity40


From 	MT2003, MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID
			
Where  ResultTypeID ='R01' and
	PlanID = 'MP20040000000021' and
	MT1001.DivisionID ='ABC' and
	MT0810.DepartmentID ='ACC' 
Group by ProductID,UnitID, MT2003.DivisionID

GO


