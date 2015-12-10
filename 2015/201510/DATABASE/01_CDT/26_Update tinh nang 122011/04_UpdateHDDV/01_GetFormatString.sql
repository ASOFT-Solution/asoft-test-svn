USE [CDT]
GO

if exists (select top 1 1 from sysobjects where name = 'GetFormatString')
Drop function GetFormatString
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create  Function [dbo].[GetFormatString](@key nvarchar(128))
returns nvarchar(128)
as

begin
declare @FORMAT_NUMBER_STYLE_00 nvarchar(128),
		@FORMAT_NUMBER_STYLE_01 nvarchar(128),
		@FORMAT_NUMBER_STYLE_02 nvarchar(128),
		@FORMAT_NUMBER_STYLE_03 nvarchar(128),
		@FORMAT_NUMBER_STYLE_04 nvarchar(128),
		@FORMAT_NUMBER_STYLE_05 nvarchar(128),
		@FORMAT_NUMBER_STYLE_06 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_00 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_01 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_02 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_03 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_04 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_05 nvarchar(128),
		@FORMAT_NUMBER_ZERO_STYLE_06 nvarchar(128),
		@precision nvarchar(128),
		@displayZero varchar(8),
		@result nvarchar(128)
        
set @FORMAT_NUMBER_STYLE_00 = '##,###,###,###,##0'
set @FORMAT_NUMBER_STYLE_01 = '##,###,###,###,##0.#'
set @FORMAT_NUMBER_STYLE_02 = '##,###,###,###,##0.##'
set @FORMAT_NUMBER_STYLE_03 = '##,###,###,###,##0.###'
set @FORMAT_NUMBER_STYLE_04 = '##,###,###,###,##0.####'
set @FORMAT_NUMBER_STYLE_05 = '##,###,###,###,##0.#####'
set @FORMAT_NUMBER_STYLE_06 = '##,###,###,###,##0.######'
set @FORMAT_NUMBER_ZERO_STYLE_00 = '##,###,###,###,###'
set @FORMAT_NUMBER_ZERO_STYLE_01 = '##,###,###,###,###.#'
set @FORMAT_NUMBER_ZERO_STYLE_02 = '##,###,###,###,###.##'
set @FORMAT_NUMBER_ZERO_STYLE_03 = '##,###,###,###,###.###'
set @FORMAT_NUMBER_ZERO_STYLE_04 = '##,###,###,###,###.####'
set @FORMAT_NUMBER_ZERO_STYLE_05 = '##,###,###,###,###.#####'
set @FORMAT_NUMBER_ZERO_STYLE_06 = '##,###,###,###,###.######'

select top 1 @precision = _Value from sysConfig
where _Key = @key and IsFormatString = 1

select top 1 @displayZero = _Value from sysConfig
where _Key = 'DisplayZero' and IsFormatString = 1

if @displayZero = 'true'
BEGIN
	if @precision = '0'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_00
	END
	else if @precision = '1'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_01
	END
	else if @precision = '2'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_02
	END
	else if @precision = '3'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_03
	END
	else if @precision = '4'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_04
	END
	else if @precision = '5'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_05
	END
	else if @precision = '6'
	BEGIN
		set @result = @FORMAT_NUMBER_STYLE_06
	END
END
else if @displayZero = 'false'
BEGIN
	if @precision = '0'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_00
	END
	else if @precision = '1'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_01
	END
	else if @precision = '2'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_02
	END
	else if @precision = '3'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_03
	END
	else if @precision = '4'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_04
	END
	else if @precision = '5'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_05
	END
	else if @precision = '6'
	BEGIN
		set @result = @FORMAT_NUMBER_ZERO_STYLE_06
	END
END

return @result
end
