IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP6511]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP6511]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Create by: Dang Le Bao Quynh, date: 26/07/2011
--Purpose: Xu ly du lieu in bao cao cashflow
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
/**********************************************
** Created by: [GS] [Tấn Phú] [20/07/2011]
***********************************************/
CREATE PROCEDURE AP6511
		@DivisionID AS nvarchar(50), 
		@Date AS datetime, 
		@Type AS tinyint, 
		@ColNumber AS tinyint

AS

Declare @BeginDate AS Datetime,
		@EndDate AS Datetime,
		@i AS tinyint,	
		@sSQL AS nvarchar(4000),
		--Bien xu ly bao cao tong hop
		@BeginAmount AS Decimal(28,8), @DebitAmount AS Decimal(28,8), 
		@CreditAmount AS Decimal(28,8), @EndAmount AS Decimal(28,8),
		@sSQL1 AS nvarchar(1000), @sSQL2 AS nvarchar(1000), @sSQL3 AS nvarchar(1000), @sSQL4 AS nvarchar(1000)
			
Set @sSQL = 'SELECT	AT6510.DivisionID, AT6510.BaseCurrencyID, AT6510.CurrencyID, AT6510.ExchangeRate, 
					AT6510.ObjectID, AT1202.ObjectName, AT6510.DueDate, AT6510.Description, 
					AT6510.FlowType, AT6511.Operator' 

Set @BeginDate	= @Date 	
Set @i = 1		
While @i<=20
Begin
	If @i<=@ColNumber 
		Begin
			If @Type = 0
				Begin
					Set @EndDate = DATEADD(d,7,@BeginDate)
				End
			If @Type = 1
				Begin
					Set @EndDate = DATEADD(d,14,@BeginDate)
				End
			If @Type = 2
				Begin
					Set @EndDate = DATEADD(m,1,@BeginDate)
				End
				
			Set @sSQL = @sSQL + ', (CASE WHEN AT6510.DueDate>=''' + rtrim(Month(@BeginDate)) + '/' + rtrim(Day(@BeginDate)) + '/' + rtrim(Year(@BeginDate)) + ''' 
											   AND AT6510.DueDate<''' + rtrim(Month(@EndDate)) + '/' + rtrim(Day(@EndDate)) + '/' + rtrim(Year(@EndDate)) + ''' Then AT6510.Amount Else 0 End) AS Col' + ltrim(@i) + ' '
											   	
			Set @BeginDate = @EndDate 	
		End
		
	Else
		Begin
			Set @sSQL = @sSQL + ', 0 AS Col' + ltrim(@i) + ' '
		End
	
	Set @i = @i + 1
End	

Set @sSQL = @sSQL + ' 
					FROM	AT6510 
					LEFT JOIN AT1202 On AT6510.ObjectID = AT1202.ObjectID and AT6510.DivisionID = AT1202.DivisionID
					LEFT JOIN AT6511 On AT6510.CurrencyID = AT6511.CurrencyID And AT6510.DivisionID = AT6511.DivisionID 
					WHERE AT6510.DivisionID = ''' + @DivisionID + ''''

					
IF EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE ID = OBJECT_ID('AV6510') AND XTYPE = 'V')
EXEC ('DROP VIEW AV6510')

EXEC ('CREATE VIEW AV6510 -- CREATE BY: AP6511
		AS ' + @sSQL)					
					 
--Xử lý in báo cáo tổng hợp
--Xac dinh tien ton dau ky

Set @EndAmount = ISNULL((SELECT SUM(ISNULL(ConvertedAmount,0)) From AT9000 WHERE DivisionID = @DivisionID AND DebitAccountID 
						Like '11%' And CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) < CONVERT(VARCHAR(10),@Date,101)), 0)
				- ISNULL((	Select Sum(isnull(ConvertedAmount,0)) From AT9000 WHERE DivisionID = @DivisionID AND CreditAccountID 
						Like '11%' And CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) < CONVERT(VARCHAR(10),@Date,101)),0)

Select @sSQL1 = '', @sSQL2 = '', @sSQL3 = '', @sSQL4 = ''
Set @i = 1

While @i<=20
Begin
	Set @BeginAmount = @EndAmount
	Set @DebitAmount = isnull(
					Case @i 
					WHEN 1 THEN
					(SELECT SUM(
						CASE WHEN FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col1*ExchangeRate,0) Else ROUND(Col1/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 2 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col2*ExchangeRate,0) Else ROUND(Col2/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 3 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col3*ExchangeRate,0) Else ROUND(Col3/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 4 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col4*ExchangeRate,0) Else ROUND(Col4/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 5 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col5*ExchangeRate,0) Else ROUND(Col5/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 6 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col6*ExchangeRate,0) Else ROUND(Col6/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 7 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col7*ExchangeRate,0) Else ROUND(Col7/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 8 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col8*ExchangeRate,0) Else ROUND(Col8/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 9 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col9*ExchangeRate,0) Else ROUND(Col9/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 10 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col10*ExchangeRate,0) Else ROUND(Col10/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 11 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col11*ExchangeRate,0) Else ROUND(Col11/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 12 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col12*ExchangeRate,0) Else ROUND(Col12/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 13 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col13*ExchangeRate,0) Else ROUND(Col13/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 14 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col14*ExchangeRate,0) Else ROUND(Col14/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 15 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col15*ExchangeRate,0) Else ROUND(Col15/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 16 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col16*ExchangeRate,0) Else ROUND(Col16/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 17 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col17*ExchangeRate,0) Else ROUND(Col17/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 18 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col18*ExchangeRate,0) Else ROUND(Col18/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 19 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col19*ExchangeRate,0) Else ROUND(Col19/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 20 Then
					(Select SUM(
						Case When FlowType In(1,5,6) Then  
						isnull((Case When Operator = 0 Then ROUND(Col20*ExchangeRate,0) Else ROUND(Col20/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
				End,0)																					
	Set @CreditAmount = isnull(
					Case @i 
					When 1 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col1*ExchangeRate,0) Else ROUND(Col1/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 2 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col2*ExchangeRate,0) Else ROUND(Col2/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 3 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col3*ExchangeRate,0) Else ROUND(Col3/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 4 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col4*ExchangeRate,0) Else ROUND(Col4/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 5 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col5*ExchangeRate,0) Else ROUND(Col5/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 6 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col6*ExchangeRate,0) Else ROUND(Col6/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 7 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col7*ExchangeRate,0) Else ROUND(Col7/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 8 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col8*ExchangeRate,0) Else ROUND(Col8/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 9 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col9*ExchangeRate,0) Else ROUND(Col9/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 10 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col10*ExchangeRate,0) Else ROUND(Col10/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 11 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col11*ExchangeRate,0) Else ROUND(Col11/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 12 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col12*ExchangeRate,0) Else ROUND(Col12/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 13 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col13*ExchangeRate,0) Else ROUND(Col13/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 14 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col14*ExchangeRate,0) Else ROUND(Col14/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 15 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col15*ExchangeRate,0) Else ROUND(Col15/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 16 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col16*ExchangeRate,0) Else ROUND(Col16/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 17 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col17*ExchangeRate,0) Else ROUND(Col17/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 18 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col18*ExchangeRate,0) Else ROUND(Col18/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 19 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then  
						isnull((Case When Operator = 0 Then ROUND(Col19*ExchangeRate,0) Else ROUND(Col19/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
					When 20 Then
					(Select SUM(
						Case When FlowType In(2,3,4) Then 
						isnull((Case When Operator = 0 Then ROUND(Col20*ExchangeRate,0) Else ROUND(Col20/ExchangeRate,0) End),0) 
						Else 0 
						End) From AV6510)
				End,0)
	Set @EndAmount = @BeginAmount + @DebitAmount - @CreditAmount
	If @i < 20
		Begin
			Set @sSQL1 = @sSQL1 + LTRIM(@BeginAmount) + ' AS Col' + ltrim(@i) + ', '
			Set @sSQL2 = @sSQL2 + LTRIM(@DebitAmount) + ' AS Col' + ltrim(@i) + ', '
			Set @sSQL3 = @sSQL3 + LTRIM(@CreditAmount) + ' AS Col' + ltrim(@i) + ', '
			Set @sSQL4 = @sSQL4 + LTRIM(@EndAmount) + ' AS Col' + ltrim(@i) + ', '
		End
	Else
		Begin
			Set @sSQL1 = @sSQL1 + LTRIM(@BeginAmount) + ' AS Col' + ltrim(@i) + ''
			Set @sSQL2 = @sSQL2 + LTRIM(@DebitAmount) + ' AS Col' + ltrim(@i) + ''
			Set @sSQL3 = @sSQL3 + LTRIM(@CreditAmount) + ' AS Col' + ltrim(@i) + ''
			Set @sSQL4 = @sSQL4 + LTRIM(@EndAmount) + ' AS Col' + ltrim(@i) + ''
		End
	Set @i = @i + 1
End

If exists (Select Top 1 1 From sysObjects Where id = OBJECT_ID('AV6511') And xtype = 'V')
EXEC ('Drop View AV6511')

EXEC ('Create View AV6511 -- Create by: AP6511
		As ' + 'Select 1 AS Type, ' + @sSQL1 + ' Union All
			Select 2 AS Type, ' + @sSQL2 + ' Union All
			Select 3 AS Type, ' + @sSQL3 + ' Union All
			Select 4 AS Type, ' + @sSQL4 + ' ')					

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

