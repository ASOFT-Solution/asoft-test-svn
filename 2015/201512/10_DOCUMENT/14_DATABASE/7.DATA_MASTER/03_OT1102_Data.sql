 -- <Summary>
---- Thêm dữ liệu bảng OT1102
-- <History>
---- Create on 29/10/2014 by Quốc Tuấn
---- Modified on ... by 
INSERT INTO OT1102 (DivisionID,Code, Description, EDescription, TypeID)
	SELECT DivisionID,3,N'Duyệt lần 1','Confirm 1','SO'
	FROM AT1101 PQ
	WHERE	NOT EXISTS(	SELECT TOP 1 1 FROM OT1102 TMP 
	     	           	WHERE TMP.DivisionID = PQ.DivisionID
	     	           			AND TMP.Code = 3)
	     	           			
	     	           			
	     	           	