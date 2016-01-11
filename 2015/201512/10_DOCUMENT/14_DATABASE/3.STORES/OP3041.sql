IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3041]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3041]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by: Vo Thanh Huong, 	date:  18/03/2005
---purpose:  In bao cao tong hop du tru nguyen  vat lieu
---- Modified on 12/03/2014 by Le Thi Thu Hien : Bo sung them 1 so truong 

CREATE PROCEDURE [dbo].[OP3041] 	 
			@DivisionID as nvarchar(50),
			@IsDate as tinyint,
			@TypeDate int,    -- Loai 0 : theo ngay du tru, 1: Theo ngay don hang
			@FromMonth as int,
			@ToMonth as int,
			@FromYear as int,
			@ToYear as int,
			@FromDate as datetime,
			@ToDate as datetime,
			@InventoryTypeID nvarchar(50),
			@FromInventoryID as nvarchar(50),
			@ToInventoryID as nvarchar(50),				
			@IsGroup as tinyint,
			@GroupID nvarchar(50) --GroupID: CI1, CI2, CI3, I01, I02, I03, I04, I05									
 AS
DECLARE @sSQL nvarchar(MAX),
 @sSQL1 nvarchar(MAX),
	@GroupField nvarchar(20), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
SET @sSQL1 = ''
IF @IsGroup = 0 
BEGIN

Set @sSQL =  
	'Select Distinct T01.DivisionID, 
			'''' as GroupID, 
			'''' as GroupName, 
			T00.MaterialID,  
			InventoryName as MaterialName,  
			UnitName,
			Sum(isnull(MaterialQuantity, 0)) as MaterialQuantity,
			T02.S1, T02.S2, T02.S3, 
			S1.SName AS S1Name, S2.SName AS S2Name, S3.SName AS S3Name,
			T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID,
			I01.AnaName AS I01Name,
			I02.AnaName AS I02Name,
			I03.AnaName AS I03Name,
			I04.AnaName AS I04Name,
			I05.AnaName AS I05Name,
			T06.Ana01ID, T06.Ana02ID, T06.Ana03ID, T06.Ana04ID, T06.Ana05ID, 
			T06.Ana06ID, T06.Ana07ID, T06.Ana08ID, T06.Ana09ID, T06.Ana10ID, 
			OT1002_1.AnaName AS AnaName1,
			OT1002_2.AnaName AS AnaName2,
			OT1002_3.AnaName AS AnaName3,
			OT1002_4.AnaName AS AnaName4,
			OT1002_5.AnaName AS AnaName5,
			OT1002_6.AnaName AS AnaName6,
			OT1002_7.AnaName AS AnaName7,
			OT1002_8.AnaName AS AnaName8,
			OT1002_9.AnaName AS AnaName9,
			OT1002_10.AnaName AS AnaName10
			'
SET @sSQL1 = N'
From OT2203 T00	
inner join OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
inner join AT1302 T02 on T02.InventoryID =  T00.MaterialID And T02.DivisionID =  T00.DivisionID
left join  OT2001 T03 on T03.SOrderID = T01.SOrderID And T03.DivisionID = T01.DivisionID
inner join AT1304 T04 on T04.UnitID = T02.UnitID And T04.DivisionID = T02.DivisionID
INNER JOIN OT2202 T06 on T06.EDetailID = T00.EDetailID  And T06.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_1 on OT1002_1.AnaID = T06.Ana01ID and  OT1002_1.AnaTypeID = ''A01'' and  OT1002_1.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_2 on OT1002_2.AnaID = T06.Ana02ID and  OT1002_2.AnaTypeID = ''A02'' and  OT1002_2.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_3 on OT1002_3.AnaID = T06.Ana03ID and  OT1002_3.AnaTypeID = ''A03'' and  OT1002_3.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_4 on OT1002_4.AnaID = T06.Ana04ID and  OT1002_4.AnaTypeID = ''A04'' and  OT1002_4.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_5 on OT1002_5.AnaID = T06.Ana05ID and  OT1002_5.AnaTypeID = ''A05'' and  OT1002_5.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_6 on OT1002_6.AnaID = T06.Ana06ID and  OT1002_6.AnaTypeID = ''A06'' and  OT1002_6.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_7 on OT1002_7.AnaID = T06.Ana07ID and  OT1002_7.AnaTypeID = ''A07'' and  OT1002_7.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_8 on OT1002_8.AnaID = T06.Ana08ID and  OT1002_8.AnaTypeID = ''A08'' and  OT1002_8.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_9 on OT1002_9.AnaID = T06.Ana09ID and  OT1002_9.AnaTypeID = ''A09'' and  OT1002_9.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_10 on OT1002_10.AnaID = T06.Ana10ID and  OT1002_10.AnaTypeID = ''A10'' and  OT1002_10.DivisionID = T06.DivisionID
LEFT JOIN AT1015	I01 on I01.AnaID = T02.I01ID and  I01.AnaTypeID = ''I01'' and  I01.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I02 on I02.AnaID = T02.I02ID and  I02.AnaTypeID = ''I02'' and  I02.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I03 on I03.AnaID = T02.I03ID and  I03.AnaTypeID = ''I03'' and  I03.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I04 on I04.AnaID = T02.I04ID and  I04.AnaTypeID = ''I04'' and  I04.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I05 on I05.AnaID = T02.I05ID and  I05.AnaTypeID = ''I05'' and  I05.DivisionID = T02.DivisionID

LEFT JOIN AT1310 S1 ON S1.STypeID = ''I01'' AND S1.DivisionID = T02.DivisionID AND S1.S = T02.S1
LEFT JOIN AT1310 S2 ON S2.STypeID = ''I02'' AND S2.DivisionID = T02.DivisionID AND S2.S = T02.S2
LEFT JOIN AT1310 S3 ON S3.STypeID = ''I03'' AND S3.DivisionID = T02.DivisionID AND S3.S = T02.S3
	Where T01.DivisionID = ''' + @DivisionID + ''' 
			and T00.MaterialID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' +   
		case when @TypeDate = 0 and @IsDate = 0 then ' T01.TranMonth + T01.TranYear*100 between  ' + @FromMonthYearText  + ' and ' + @ToMonthYearText
			when @TypeDate = 0 and @IsDate = 1 then ' convert(nvarchar(10), T01.VoucherDate, 101) between ''' + @FromDateText + ''' and '''  + @ToDateText + ''''  
			when @TypeDate = 1 and @IsDate = 0 then ' T03.TranMonth + T03.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText
		else ' convert(nvarchar(10), T03.OrderDate, 101) between ''' + @FromDateText + ''' and ''' + @ToDateText + '''' end + ' 
	 Group by T01.DivisionID, MaterialID, InventoryName, UnitName,
			T02.S1, T02.S2, T02.S3, 
			S1.SName, S2.SName, S3.SName,
			T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID,
			I01.AnaName,
			I02.AnaName,
			I03.AnaName,
			I04.AnaName,
			I05.AnaName,
			T06.Ana01ID, T06.Ana02ID, T06.Ana03ID, T06.Ana04ID, T06.Ana05ID, 
			T06.Ana06ID, T06.Ana07ID, T06.Ana08ID, T06.Ana09ID, T06.Ana10ID, 
			OT1002_1.AnaName,
			OT1002_2.AnaName,
			OT1002_3.AnaName,
			OT1002_4.AnaName,
			OT1002_5.AnaName,
			OT1002_6.AnaName,
			OT1002_7.AnaName,
			OT1002_8.AnaName,
			OT1002_9.AnaName,
			OT1002_10.AnaName '
	
END
ELSE
BEGIN
Set @GroupField = (Select Case @GroupID when 'CI1' then 'S1' when 'CI2' then 'S2' when 'CI3' then 'S3' 
				when 'I01' then 'I01ID' when 'I02' then 'I02ID' when 'I03' then 'I03ID' when 'I04' then 'I04ID' when 'I05' then 'I05ID'  end)				

Set @sSQL = 
	'Select T01.DivisionID, 
			T00.MaterialID, 
			T02.InventoryName as MaterialName, 
			UnitName, 
			T02.UnitID, 
			sum(isnull(MaterialQuantity, 0)) as MaterialQuantity, 
			T02.S1, T02.S2, T02.S3, 
			S1.SName AS S1Name, S2.SName AS S2Name, S3.SName AS S3Name,
			T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID,
			I01.AnaName AS I01Name,
			I02.AnaName AS I02Name,
			I03.AnaName AS I03Name,
			I04.AnaName AS I04Name,
			I05.AnaName AS I05Name,
			T06.Ana01ID, T06.Ana02ID, T06.Ana03ID, T06.Ana04ID, T06.Ana05ID, 
			T06.Ana06ID, T06.Ana07ID, T06.Ana08ID, T06.Ana09ID, T06.Ana10ID, 
			OT1002_1.AnaName AS AnaName1,
			OT1002_2.AnaName AS AnaName2,
			OT1002_3.AnaName AS AnaName3,
			OT1002_4.AnaName AS AnaName4,
			OT1002_5.AnaName AS AnaName5,
			OT1002_6.AnaName AS AnaName6,
			OT1002_7.AnaName AS AnaName7,
			OT1002_8.AnaName AS AnaName8,
			OT1002_9.AnaName AS AnaName9,
			OT1002_10.AnaName AS AnaName10		
'
SET @sSQL1 = N'			
From OT2203  T00  
inner join OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
inner join AT1302 T02 on T02.InventoryID =  T00.MaterialID And T02.DivisionID =  T00.DivisionID
left join  OT2001 T03 on T03.SOrderID = T01.SOrderID And T03.DivisionID = T01.DivisionID
inner join AT1304 T04 on T04.UnitID = T02.UnitID And T04.DivisionID = T02.DivisionID
INNER JOIN OT2202 T06 on T06.EDetailID = T00.EDetailID  And T06.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_1 on OT1002_1.AnaID = T06.Ana01ID and  OT1002_1.AnaTypeID = ''A01'' and  OT1002_1.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_2 on OT1002_2.AnaID = T06.Ana02ID and  OT1002_2.AnaTypeID = ''A02'' and  OT1002_2.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_3 on OT1002_3.AnaID = T06.Ana03ID and  OT1002_3.AnaTypeID = ''A03'' and  OT1002_3.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_4 on OT1002_4.AnaID = T06.Ana04ID and  OT1002_4.AnaTypeID = ''A04'' and  OT1002_4.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_5 on OT1002_5.AnaID = T06.Ana05ID and  OT1002_5.AnaTypeID = ''A05'' and  OT1002_5.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_6 on OT1002_6.AnaID = T06.Ana06ID and  OT1002_6.AnaTypeID = ''A06'' and  OT1002_6.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_7 on OT1002_7.AnaID = T06.Ana07ID and  OT1002_7.AnaTypeID = ''A07'' and  OT1002_7.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_8 on OT1002_8.AnaID = T06.Ana08ID and  OT1002_8.AnaTypeID = ''A08'' and  OT1002_8.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_9 on OT1002_9.AnaID = T06.Ana09ID and  OT1002_9.AnaTypeID = ''A09'' and  OT1002_9.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_10 on OT1002_10.AnaID = T06.Ana10ID and  OT1002_10.AnaTypeID = ''A10'' and  OT1002_10.DivisionID = T06.DivisionID
LEFT JOIN AT1015	I01 on I01.AnaID = T02.I01ID and  I01.AnaTypeID = ''I01'' and  I01.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I02 on I02.AnaID = T02.I02ID and  I02.AnaTypeID = ''I02'' and  I02.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I03 on I03.AnaID = T02.I03ID and  I03.AnaTypeID = ''I03'' and  I03.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I04 on I04.AnaID = T02.I04ID and  I04.AnaTypeID = ''I04'' and  I04.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I05 on I05.AnaID = T02.I05ID and  I05.AnaTypeID = ''I05'' and  I05.DivisionID = T02.DivisionID

LEFT JOIN AT1310 S1 ON S1.STypeID = ''I01'' AND S1.DivisionID = T02.DivisionID AND S1.S = T02.S1
LEFT JOIN AT1310 S2 ON S2.STypeID = ''I02'' AND S2.DivisionID = T02.DivisionID AND S2.S = T02.S2
LEFT JOIN AT1310 S3 ON S3.STypeID = ''I03'' AND S3.DivisionID = T02.DivisionID AND S3.S = T02.S3
WHERE T01.DivisionID = ''' + @DivisionID + ''' and		
		T00.MaterialID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' +   
		case when @TypeDate = 0 and @IsDate = 0 then ' T01.TranMonth + T01.TranYear*100 between  ' + @FromMonthYearText  + ' and ' + @ToMonthYearText
			when @TypeDate = 0 and @IsDate = 1 then '  convert(nvarchar(10), T01.VoucherDate, 101) between ''' + @FromDateText + ''' and '''  + @ToDateText + ''''  
			when @TypeDate = 1 and @IsDate = 0 then ' T03.TranMonth + T03.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText
		else ' convert(nvarchar(10), T03.OrderDate, 101) between ''' + @FromDateText + ''' and ''' + @ToDateText + '''' end + ' 
GROUP BY T01.DivisionID, MaterialID, InventoryName,  T02.UnitID,  UnitName,
			T02.S1, T02.S2, T02.S3, 
			S1.SName, S2.SName, S3.SName,
			T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID,
			I01.AnaName,
			I02.AnaName,
			I03.AnaName,
			I04.AnaName,
			I05.AnaName,
			T06.Ana01ID, T06.Ana02ID, T06.Ana03ID, T06.Ana04ID, T06.Ana05ID, 
			T06.Ana06ID, T06.Ana07ID, T06.Ana08ID, T06.Ana09ID, T06.Ana10ID, 
			OT1002_1.AnaName,
			OT1002_2.AnaName,
			OT1002_3.AnaName,
			OT1002_4.AnaName,
			OT1002_5.AnaName,
			OT1002_6.AnaName,
			OT1002_7.AnaName,
			OT1002_8.AnaName,
			OT1002_9.AnaName,
			OT1002_10.AnaName
			'
PRINT(@sSQL)
PRINT(@sSQL1)
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3141')
	Drop view OV3141
EXEC('Create view OV3141---tao boi OP3041
		as ' + @sSQL +@sSQL1)

Set @sSQL = '
Select V00.* , V01.ID as GroupID,	V01.SName  as GroupName
From OV3141 V00  
left join OV1200  V01 on V01.ID = V00.' + @GroupField + ' and V01.TypeID ='''+@GroupID+''''
SET @sSQL1 = N'' 
END
If  exists (Select Top 1 1 From SysObjects Where XType = 'V' and Name = 'OV3041')
	DROP VIEW OV3041
EXEC('Create view OV3041 ---tao boi OP3041
		as ' + @sSQL +@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

