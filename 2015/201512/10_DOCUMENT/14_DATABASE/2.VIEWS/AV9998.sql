
/****** Object:  View [dbo].[AV9998]    Script Date: 12/16/2010 16:05:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--view chet
ALTER VIEW [dbo].[AV9998] as
Select 
	'00:00' as HourMinute,
	0 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'00:30' as HourMinute,
	0 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'01:00' as HourMinute,
	1 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'01:30' as HourMinute,
	1 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'02:00' as HourMinute,
	2 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'02:30' as HourMinute,
	2 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'03:00' as HourMinute,
	3 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'03:30' as HourMinute,
	3 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'04:00' as HourMinute,
	4 as Hour,
	00 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'04:30' as HourMinute,
	4 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'05:00' as HourMinute,
	5 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'05:30' as HourMinute,
	5 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'06:00' as HourMinute,
	6 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'06:30' as HourMinute,
	6 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'07:00' as HourMinute,
	7 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'07:30' as HourMinute,
	7 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'08:00' as HourMinute,
	8 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
	
Union
Select
	'08:30' as HourMinute,
	8 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'09:00' as HourMinute,
	9 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'09:30' as HourMinute,
	9 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'10:00' as HourMinute,
	10 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'10:30' as HourMinute,
	10 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'11:00' as HourMinute,
	11 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'11:30' as HourMinute,
	11 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'12:00' as HourMinute,
	12 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'12:30' as HourMinute,
	12 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'13:00' as HourMinute,
	13 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'13:30' as HourMinute,
	13 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'09:00' as HourMinute,
	9 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'14:30' as HourMinute,
	14 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'15:00' as HourMinute,
	15 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'15:30' as HourMinute,
	15 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'16:00' as HourMinute,
	16 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'16:30' as HourMinute,
	16 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'17:00' as HourMinute,
	17 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'17:30' as HourMinute,
	17 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'18:00' as HourMinute,
	18 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'18:30' as HourMinute,
	18 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'19:00' as HourMinute,
	19 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'19:30' as HourMinute,
	19 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	

Union
Select
	'20:00' as HourMinute,
	20 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'20:30' as HourMinute,
	20 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'21:00' as HourMinute,
	21 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'21:30' as HourMinute,
	21 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'22:00' as HourMinute,
	22 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'22:30' as HourMinute,
	22 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'23:00' as HourMinute,
	23 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'23:30' as HourMinute,
	23 as Hour,
	30 as Minute,
	DivisionID
FROM AT1101	
Union
Select
	'24:00' as HourMinute,
	24 as Hour,
	0 as Minute,
	DivisionID
FROM AT1101	

GO


