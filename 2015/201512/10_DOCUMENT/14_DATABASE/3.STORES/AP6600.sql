IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP6600]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP6600]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Create By: Dang Le Bao Quynh; Date : 22/06/2007
----- Purpose: Tao view In bao cao doanh thu va cong no theo doi tuong
---- Modified by on 11/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified by on 05/11/2012 by Lê Thị Thu Hiền : 
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

CREATE PROCEDURE [dbo].[AP6600] 
		@DivisionID as nvarchar(50),
		@FromMonth as int,
		@ToMonth as int,
		@FromYear as int,
		@ToYear as int,
		@FromObjectID as nvarchar(50),
		@ToObjectID as nvarchar(50),
		@FromAccountID as nvarchar(50),
		@ToAccountID as nvarchar(50),
		@GroupID1 as nvarchar(50),
		@GroupID2 as nvarchar(50),
		@DateCal as Datetime,
		
		@O01IDFrom as nvarchar(50),
		@O01IDTo as nvarchar(50),
		@O02IDFrom as nvarchar(50),
		@O02IDTo as nvarchar(50),
		@O03IDFrom as nvarchar(50),
		@O03IDTo as nvarchar(50),
		@O04IDFrom as nvarchar(50),
		@O04IDTo as nvarchar(50),
		@O05IDFrom as nvarchar(50),
		@O05IDTo as nvarchar(50),
		@StrDivisionID AS NVARCHAR(4000) = ''

AS
Declare @sSQL nvarchar(MAX),
		@ConvertedDecimals as tinyint,
		@TurnOverMonth as nvarchar(4000),
		@MaxDebtAge as INT,
		@StrDivisionID_New AS NVARCHAR(4000)


SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END

	Select @ConvertedDecimals = ConvertedDecimals
	FROM AT1101
	WHERE DivisionID = @DivisionID

	Set @ConvertedDecimals = isnull( @ConvertedDecimals,2)

	Set @sSQL = 'SELECT AT1202.*, CountryName,CityName, '
	
			If ISNULL(@GroupID1, '') <> ''
				Begin
					Set @sSQL = @sSQL +
					@GroupID1 + 'ID As GroupID1, (Select AnaName From AT1015 Where AnaTypeID = N''' + @GroupID1 + ''' And AnaID=AT1202.' + @GroupID1 + 'ID) As GroupName1, '
				End
			Else
				Begin
					Set @sSQL = @sSQL +
					''''' As GroupID1, ' + ''''' As GroupName1, '
				End
			
			If ISNULL(@GroupID2, '') <> ''
				Begin
					Set @sSQL = @sSQL +
					@GroupID2 + 'ID As GroupID2, (Select AnaName From AT1015 Where AnaTypeID = N''' + @GroupID2 + ''' And AnaID=AT1202.' + @GroupID2 + 'ID) As GroupName2, '
				End
			Else
				Begin
					Set @sSQL = @sSQL +
					''''' As GroupID2, ' + ''''' As GroupName2, '
				End
			
			--C01
			Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth) + '),0),' + ltrim(@ConvertedDecimals) + '))'
			Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C01,'
			--C02
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=1
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 1) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C02, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C02, '
				End
			--C03
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=2
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 2) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C03, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C03, '
				End
			--C04
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=3
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 3) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C04, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C04, '
				End
			--C05
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=4
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 4) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C05, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C05, '
				End
			--C06
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=5
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 5) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C06, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C06, '
				End
			--C07
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=6
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 6) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C07, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C07, '
				End
			--C08
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=7
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 7) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C08, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C08, '
				End
			--C09
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=8
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 8) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C09, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C09, '
				End
			--C10
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=9
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 9) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C10, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C10, '
				End
			--C11
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=10
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 10) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C11, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C11, '
				End
			--C12
			If (@ToYear*12 + @ToMonth) - (@FromYear*12 + @FromMonth)>=11
				Begin
					Set @TurnOverMonth = '(Select Round(Isnull((Select Sum(Isnull(ConvertedAmount,0)) From AT9000 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TransactionTypeID In (''T04'',''T14'') And TranYear*12 + TranMonth = ' + ltrim(@FromYear*12 + @FromMonth + 11) + '),0),' + ltrim(@ConvertedDecimals) + '))'
					Set @sSQL = @sSQL + ltrim(@TurnOverMonth) + ' as C12, '
				End
			Else
				Begin
					Set @sSQL = @sSQL + '0 as C12, '
				End

			Set @sSQL = @sSQL + 'Round(Isnull((Select Sum(Isnull(SignAmount,0)) From AV4303 Where DivisionID '+@StrDivisionID_New+' And ObjectID = AT1202.ObjectID And TranYear*12 + TranMonth <= ' + ltrim(@ToYear*12 + @ToMonth) + ' And AccountID Between N''' + @FromAccountID + ''' And N''' + @ToAccountID + '''),0),' + ltrim(@ConvertedDecimals) + ') As Debt, ' 
			Set @sSQL = @sSQL + '(Select Top 1 DATEDIFF(day,VoucherDate,''' + ltrim(month(@DateCal)) + '/' + ltrim(Day(@DateCal)) + '/' + ltrim(Year(@DateCal)) + ''') From AT9000 
						Where DivisionID '+@StrDivisionID_New+' And DebitAccountID Between N''' + @FromAccountID + ''' And N''' + @FromAccountID + ''' 
						And ObjectID = AT1202.ObjectID 
						Group by ObjectID,VoucherID,VoucherNo,VoucherDate,DebitAccountID
						Having isnull(Sum(isnull(ConvertedAmount,0)),0) - (Select isnull(sum(isnull(ConvertedAmount,0)),0) From AT0303 Where AccountID = At9000.DebitAccountID And DebitVoucherID = AT9000.VoucherID)>0
						Order by VoucherDate) As MaxDebtAge, '

			Set @sSQL = @sSQL + '(Select Top 1 VoucherNo From AT9000 
						Where DivisionID '+@StrDivisionID_New+' 
								And DebitAccountID Between N''' + @FromAccountID + ''' And N''' + @FromAccountID + ''' 
								And ObjectID = AT1202.ObjectID 
						Group by ObjectID,VoucherID,VoucherNo,VoucherDate,DebitAccountID
						Having isnull(Sum(isnull(ConvertedAmount,0)),0) - (Select isnull(sum(isnull(ConvertedAmount,0)),0) From AT0303 Where AccountID = At9000.DebitAccountID And DebitVoucherID = AT9000.VoucherID)>0
						Order by VoucherDate) As VoucherNo 
			FROM AT1202 
			Left Join AT1001 ON AT1202.CountryID = AT1001.CountryID and AT1202.DivisionID = AT1001.DivisionID
			Left Join AT1002 ON AT1202.CityID = AT1002.CityID and AT1202.DivisionID = AT1002.DivisionID
			WHERE ObjectID Between N''' + @FromObjectID + ''' And N''' + @ToObjectID + '''
			AND AT1202.DivisionID = '''+@DivisionID+'''
			'
			IF @O01IDFrom <> '' And @O01IDTo<>''
			Set @sSQL= @sSQL + ' And O01ID Between N''' + @O01IDFrom + ''' And N''' + @O01IDTo + ''''

			IF @O02IDFrom <> '' And @O02IDTo<>''
			Set @sSQL= @sSQL + ' And O02ID Between N''' + @O02IDFrom + ''' And N''' + @O02IDTo + ''''

			IF @O03IDFrom <> '' And @O03IDTo<>''
			Set @sSQL= @sSQL + ' And O03ID Between N''' + @O03IDFrom + ''' And N''' + @O03IDTo + ''''

			IF @O04IDFrom <> '' And @O04IDTo<>''
			Set @sSQL= @sSQL + ' And O04ID Between N''' + @O04IDFrom + ''' And N''' + @O04IDTo + ''''

			IF @O05IDFrom <> '' And @O05IDTo<>''
			Set @sSQL= @sSQL + ' And O04ID Between N''' + @O05IDFrom + ''' And N''' + @O05IDTo + ''''
/*
Select Top 1 DATEDIFF(day,VoucherDate,getDate()),VoucherNo From AT9000 
Where DivisionID = 'NHT' And DebitAccountID = '1311' And objectid = 'N-C-000001'
Group by ObjectID,VoucherID,VoucherNo,VoucherDate,DebitAccountID
Having isnull(Sum(isnull(ConvertedAmount,0)),0) - (Select isnull(sum(isnull(ConvertedAmount,0)),0) From AT0303 Where AccountID = At9000.DebitAccountID And DebitVoucherID = AT9000.VoucherID)>0
Order by VoucherDate
*/
--print @sSQL
If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV6600')
	Exec ('Create view AV6600 as -- Create by AP6600 
		' + @sSQL)
Else
	Exec ('Alter view AV6600 as -- Create by AP6600 
		' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

