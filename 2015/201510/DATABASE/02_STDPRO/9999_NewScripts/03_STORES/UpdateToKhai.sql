IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateToKhai]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateToKhai]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  procedure [dbo].[UpdateToKhai]
	@thang int
as
declare @c14 decimal(28,6)
declare @c15 decimal(28,6)
declare @c16 decimal(28,6)
declare @c17 decimal(28,6)
declare @c26 decimal(28,6)
declare @c29 decimal(28,6)
declare @c30 decimal(28,6)
declare @c31 decimal(28,6)
declare @c32 decimal(28,6)
declare @c33 decimal(28,6)

select @c14 = sum(ttien) from vatin where month(ngayct) = @thang and mact <> 'PNK'
select @c15 = sum(thue) from vatin where month(ngayct) = @thang and mact <> 'PNK'

select @c16 = sum(ttien) from vatin where month(ngayct) = @thang and mact = 'PNK'
select @c17 = sum(thue) from vatin where month(ngayct) = @thang and mact = 'PNK'

select @c26 = sum(ttien) from mt32 where month(ngayct) = @thang and mathue = 'KT'

select @c29 = sum(ttien) from vatout where month(ngayct) = @thang and mathue = '00'

select @c30 = sum(ttien) from vatout where month(ngayct) = @thang and mathue = '05'
select @c31 = sum(thue) from vatout where month(ngayct) = @thang and mathue = '05'

select @c32 = sum(ttien) from vatout where month(ngayct) = @thang and mathue = '10'
select @c33 = sum(thue) from vatout where month(ngayct) = @thang and mathue = '10'

if (@c14 is null) set @c14 = 0
if (@c15 is null) set @c15 = 0
if (@c16 is null) set @c16 = 0
if (@c17 is null) set @c17 = 0
if (@c26 is null) set @c26 = 0
if (@c29 is null) set @c29 = 0
if (@c30 is null) set @c30 = 0
if (@c31 is null) set @c31 = 0
if (@c32 is null) set @c32 = 0
if (@c33 is null) set @c33 = 0

update tokhai set GTHHDV = @c14, ThueGTGT = @c15 where CodeGT = 14
update tokhai set GTHHDV = @c16, ThueGTGT = @c17 where CodeGT = 16
update tokhai set GTHHDV = @c26 where CodeGT = 26
update tokhai set GTHHDV = @c29 where CodeGT = 29
update tokhai set GTHHDV = @c30, ThueGTGT = @c31 where CodeGT = 30
update tokhai set GTHHDV = @c32, ThueGTGT = @c33 where CodeGT = 32

update tokhai set GTHHDV = @c14 + @c16, ThueGTGT = @c15 + @c17 where CodeGT = 12

update tokhai set ThueGTGT = 
(select ThueGTGT from ToKhai where CodeThue = 13)
+ (select ThueGTGT from ToKhai where CodeThue = 19)
- (select ThueGTGT from ToKhai where CodeThue = 21)
where CodeThue = 22 or CodeThue = 23

update tokhai set GTHHDV = 
(select GTHHDV from ToKhai where CodeGT = 29)
+ (select GTHHDV from ToKhai where CodeGT = 30)
+ (select GTHHDV from ToKhai where CodeGT = 32)
where CodeGT = 27

update tokhai set ThueGTGT = 
(select ThueGTGT from ToKhai where CodeThue = 31)
+ (select ThueGTGT from ToKhai where CodeThue = 33)
where CodeThue = 28 or CodeThue = 25

update tokhai set GTHHDV = 
(select GTHHDV from ToKhai where CodeGT = 26)
+ (select GTHHDV from ToKhai where CodeGT = 27)
where CodeGT = 24

update tokhai set GTHHDV = 
(select GTHHDV from ToKhai where CodeGT = 24)
+ (select GTHHDV from ToKhai where CodeGT = 34)
- (select GTHHDV from ToKhai where CodeGT = 36)
where CodeGT = 38

update tokhai set ThueGTGT = 
(select ThueGTGT from ToKhai where CodeThue = 25)
+ (select ThueGTGT from ToKhai where CodeThue = 35)
- (select ThueGTGT from ToKhai where CodeThue = 37)
where CodeThue = 39

update tokhai set ThueGTGT = 
(select ThueGTGT from ToKhai where CodeThue = 39)
- (select ThueGTGT from ToKhai where CodeThue = 23)
- (select ThueGTGT from ToKhai where CodeThue = 11)
where CodeThue = 40 or CodeThue = 41

update tokhai set ThueGTGT = 
(select ThueGTGT from ToKhai where CodeThue = 41)
- (select ThueGTGT from ToKhai where CodeThue = 42)
where CodeThue = 43