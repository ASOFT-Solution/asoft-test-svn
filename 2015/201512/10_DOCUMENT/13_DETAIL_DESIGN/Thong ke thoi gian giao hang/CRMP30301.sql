IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP30301]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP30301]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
----In báo cáo thống kê thời gian giao hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng By on 29/01/2016
-- <Example>
----    EXEC CRMP30301 'AS','AS','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP30301] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@FromAccountID       Varchar(50),
		@ToAccountID         Varchar(50),
		@UserID  VARCHAR(50)
		
)
AS
DECLARE
        @sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX)
		      

SET @sWhere = ''

--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere = @sWhere + '  A.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere = @sWhere + ' A.DivisionID IN ('''+@DivisionIDList+''')'
	IF (@FromAccountID is not null and @FromAccountID not like '')
		SET @sWhere = @sWhere +' AND (A.ObjectID between N'''+@FromAccountID+N''' and N'''+@ToAccountID+N''')'
	
SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),A.CreateDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
 SET @sSQL = N'
	 Select x.Division, x.DivisionName, x.TDate, 
		 Sum(x.CTime1) as CTime1, Sum(x.CTime2) As CTime2, Sum(x.CTime3) as CTime3, Sum(x.CTime4) as CTime4, Sum(x.CTime5) as CTime5,
		 Sum(x.DTime1) as DTime1, Sum(x.DTime2) as DTime2, Sum(x.DTime3) as DTime3, Sum(x.DTime4) as DTime4, Sum(x.DTime5) as DTime5, Sum(x.DTime6) as DTime6,
		 Sum(x.RTime1) as RTime1, Sum(x.RTime2) as RTime2, Sum(x.RTime3) as RTime3, Sum(x.RTime4) as RTime4, Sum(x.RTime5) as RTime5, Sum(x.RTime6) as RTime6,
		 Sum(x.STime1) as STime1, Sum(x.STime2) as STime2, Sum(x.STime3) as STime3, Sum(x.STime4) as STime4, Sum(x.STime5) as STime5, Sum(x.STime6) as STime6
	From
	(Select A.DivisionID as Division, C.DivisionName,Day(A.OrderDate) As TDate, Month(A.OrderDate)As TMonth, YEAR(A.OrderDate) As TYear, A.CreateDate, A.ConfirmDate, B.OutTime, B.CashierTime,
		Case 
			When ((Datediff(MINUTE,A.CreateDate, A.ConfirmDate) ) >=0 And (Datediff(MINUTE,A.CreateDate, A.ConfirmDate) )<=15 ) then 1 
			Else 0
		end As CTime1,
		Case
			When ((Datediff(MINUTE,A.CreateDate, A.ConfirmDate) ) >=16 And (Datediff(MINUTE,A.CreateDate, A.ConfirmDate) )<=30 ) then 1 
			Else 0
		end As CTime2,
		Case
			When ((Datediff(MINUTE,A.CreateDate, A.ConfirmDate) ) >=31 And (Datediff(MINUTE,A.CreateDate, A.ConfirmDate) )<=60 ) then 1
			Else 0
		end As CTime3,
		Case
			When ((Datediff(MINUTE,A.CreateDate, A.ConfirmDate) ) >=61 And (Datediff(MINUTE,A.CreateDate, A.ConfirmDate) )<=120 ) then 1
			Else 0
		end As CTime4,
		Case
			When ((Datediff(MINUTE,A.CreateDate, A.ConfirmDate) ) >120 ) then 1 
		Else 0
		end As CTime5,
	 
		Case 
			When ((Datediff(MINUTE,B.OutTime, B.CashierTime) ) >=0 And (Datediff(MINUTE,B.OutTime, B.CashierTime) )<=30 ) then 1 
			Else 0
		end As DTime1,
		Case
			When ((Datediff(MINUTE,B.OutTime, B.CashierTime) ) >=31 And (Datediff(MINUTE,B.OutTime, B.CashierTime) )<=60) then 1 
			Else 0
		end As DTime2,
		Case
			When ((Datediff(MINUTE,B.OutTime, B.CashierTime) ) >=61 And (Datediff(MINUTE,B.OutTime, B.CashierTime) )<=120 ) then 1
			Else 0
		end As DTime3,
		Case
			When ((Datediff(MINUTE,B.OutTime, B.CashierTime) ) >=121 And (Datediff(MINUTE,B.OutTime, B.CashierTime) )<=180 ) then 1
			Else 0
		end As DTime4,
		Case
			When ((Datediff(MINUTE,B.OutTime, B.CashierTime) ) >181 And (Datediff(MINUTE,B.OutTime, B.CashierTime) )<=240 ) then 1 
		Else 0
		end As DTime5,
		Case
			When ((Datediff(MINUTE,B.OutTime, B.CashierTime) ) >240 ) then 1 
		Else 0
		end As DTime6,
 
		 Case 
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >=0 And (Datediff(MINUTE,A.ConfirmDate, B.CashierTime) )<=30 ) then 1 
			Else 0
		end As RTime1,
		Case
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >=31 And (Datediff(MINUTE,A.ConfirmDate, B.CashierTime) )<=60) then 1 
			Else 0
		end As RTime2,
		Case
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >=61 And (Datediff(MINUTE,A.ConfirmDate, B.CashierTime) )<=120 ) then 1
			Else 0
		end As RTime3,
		Case
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >=121 And (Datediff(MINUTE,A.ConfirmDate, B.CashierTime) )<=180 ) then 1
			Else 0
		end As RTime4,
		Case
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >181 And (Datediff(MINUTE,A.ConfirmDate, B.CashierTime) )<=240 ) then 1 
		Else 0
		end As RTime5,
		Case
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >240 ) then 1 
		Else 0
		end As RTime6,

		Case 
			When ((Datediff(MINUTE,A.CreateDate, B.CashierTime) ) >=0 And (Datediff(MINUTE,A.CreateDate, B.CashierTime) )<=30 ) then 1 
			Else 0
		end As STime1,
		Case
			When ((Datediff(MINUTE,A.CreateDate, B.CashierTime) ) >=31 And (Datediff(MINUTE,A.CreateDate, B.CashierTime) )<=60) then 1 
			Else 0
		end As STime2,
		Case
			When ((Datediff(MINUTE,A.CreateDate, B.CashierTime) ) >=61 And (Datediff(MINUTE,A.CreateDate, B.CashierTime) )<=120 ) then 1
			Else 0
		end As STime3,
		Case
			When ((Datediff(MINUTE,A.CreateDate, B.CashierTime) ) >=121 And (Datediff(MINUTE,A.CreateDate, B.CashierTime) )<=180 ) then 1
			Else 0
		end As STime4,
		Case
			When ((Datediff(MINUTE,A.CreateDate, B.CashierTime) ) >181 And (Datediff(MINUTE,A.CreateDate, B.CashierTime) )<=240 ) then 1 
		Else 0
		end As STime5,
		Case
			When ((Datediff(MINUTE,A.ConfirmDate, B.CashierTime) ) >240 ) then 1 
		Else 0
		end As STime6
	From OT2001 A
	Inner Join AT2006 B On A.DivisionID = B.DivisionID And A.SOrderID =B.OrderID
	Inner Join AT1101 C On C.DivisionID = A.DivisionID
	where '+@sWhere+'
	AND B.KindVoucherID =3 and B.IsWeb=1
	--Xác định thời gian giao hàng của nhân viên
	)x
	Group by x.TDate, x.TMonth, x.TYear, x.Division, x.DivisionName
	--Xác định số lượng giao hàng theo ngày

 ' 

 EXEC (@sSQL)

GO


