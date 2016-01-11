/****** Object:  StoredProcedure [dbo].[AP4702]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
----- Created by Nguyen Van Nhan, Date 05/11/2003
----- Purpose: Tra ra
-----Added by Vo Thanh Huong, Date 06/07/2005

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP4702] 
		@Level as nvarchar(200),
		@LevelColumn as nvarchar(200) OUTPUT
AS


IF ltrim(rtrim(@Level)) = '' OR @Level IS NULL
    BEGIN
	SELECT @LevelColumn = NULL
	RETURN
    END

IF @Level = 'AC'		-- AccountID
    BEGIN
	SELECT @LevelColumn = 'AccountID'
	RETURN
    END

IF @Level = 'AR'		-- AccountID
    BEGIN
	SELECT @LevelColumn = 'AreaID'
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

IF @Level = 'CO'		-- Cor. AccountID
    BEGIN
	SELECT @LevelColumn = 'CorAccountID'
	RETURN
    END

IF @Level = 'IN'		--  Inventory
    BEGIN
	SELECT @LevelColumn = 'InventoryID'
	RETURN
    END

IF @Level = 'PE'		--  PeriodID
    BEGIN
	SELECT @LevelColumn = 'PeriodID'
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


IF @Level = 'SO'  OR @Level = 'PO'		---- Orders 
    BEGIN

	SELECT @LevelColumn = 'OrderID'
	RETURN
    END

IF @Level = 'MO'  ---- TranMonth
    BEGIN
	SELECT @LevelColumn = 'PeriodID'
	RETURN
    END

IF @Level = 'QU' 	---- Quarter
    BEGIN
	SELECT @LevelColumn = 'Quarter'
	RETURN
    END

IF @Level = 'YE' 	---- Year
    BEGIN
	SELECT @LevelColumn = 'Year'
	RETURN
    END
--------------------------------------Don hang
IF @Level = 'SCO' or @Level = 'PCO' ----ClassifyIDs  Phan loai don hang ban, don hang mua
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
