
/****** Object:  StoredProcedure [dbo].[OP6000]    Script Date: 08/04/2010 13:41:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by: Vo Thanh Huong, date : 05/07/2005 
----- Purpose: Tra ra 
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP6000]
		@Level as nvarchar(200),
		@LevelColumn as nvarchar(200) OUTPUT
AS


IF ltrim(rtrim(@Level)) = '' OR @Level IS NULL
    BEGIN
	SELECT @LevelColumn = NULL
	RETURN
    END

IF @Level = 'VT'		-- VoucherTypeID
    BEGIN
	SELECT @LevelColumn = 'VoucherTypeID'
	RETURN
    END

IF @Level = 'CV'		-- Curency IDs
    BEGIN
	SELECT @LevelColumn = 'CurrencyID'
	RETURN
    END

IF @Level = 'DV'	-- DivisionIDs
    BEGIN
	SELECT @LevelColumn = 'DivisionID'
	RETURN
    END

IF @Level = 'OB'		-- Object Codes
    BEGIN
	SELECT @LevelColumn = 'ObjectID'
	RETURN
    END

IF @Level = 'IN'		--  Inventory
    BEGIN
	SELECT @LevelColumn = 'InventoryID'
	RETURN
    END

IF @Level >= 'A01' AND @Level <= 'A03'		---- T - Code
    BEGIN
	SELECT @LevelColumn = 'Ana' + right(@Level,2) + 'ID'
	RETURN
    END
IF @Level >= 'O01' AND @Level <= 'O05'		---- O - Code
    BEGIN
	SELECT @LevelColumn = @Level+ 'ID'
	RETURN
    END

IF @Level >= 'I01' AND @Level <= 'I05'		---- I - Code
    BEGIN
	SELECT @LevelColumn = @Level+ 'ID'
	RETURN
    END

IF @Level >= 'CO1' AND @Level <= 'CO3'		---- O - Classicfy
    BEGIN
	SELECT @LevelColumn = @Level+ 'ID'
	RETURN
    END

IF @Level >= 'CI1' AND @Level <= 'CI3'		---- I - Classicfy
    BEGIN
	SELECT @LevelColumn = @Level+ 'ID'
	RETURN
    END

IF @Level = 'MO'  	---- TranMonth
    BEGIN
	SELECT @LevelColumn = 'MonthYear'
	RETURN
    END

IF @Level = 'QU'  	---- Quarter
    BEGIN
	SELECT @LevelColumn = 'Quarter'
	RETURN
    END

IF @Level = 'YE'  	---- Quarter
    BEGIN
	SELECT @LevelColumn = 'TranYear'
	RETURN
    END

IF @Level = 'CSO' or  @Level = 'CPO'	----ClassifyIDs  Phan loai don hang ban, don hang mua
    BEGIN
	SELECT @LevelColumn = 'ClassifyID'
	RETURN
    END

IF (@Level >= 'S01' AND @Level <= 'S05' )	OR (@Level >= 'P01' AND @Level <= 'P05' ) ---- Ma phan tich don hang
    BEGIN
	SELECT @LevelColumn = 'VAna' + right(@Level,2) + 'ID'
	RETURN
    END

IF @Level = 'EM' --  EmployeeID
    BEGIN
	SELECT @LevelColumn = 'EmployeeID' 
	RETURN
    END

IF @Level = 'SM' --  SalesManID
    BEGIN
	SELECT @LevelColumn = 'SalesManID' 
	RETURN
    END
GO
