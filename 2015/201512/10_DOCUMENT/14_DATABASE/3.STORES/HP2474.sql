IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2474]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2474]
GO
/****** Object: StoredProcedure [dbo].[HP2474] Script Date: 09/27/2011 08:37:11 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by : Dang Le Bao Quynh
---Created date: 15/07/2006
---purpose: Luu cham cong san pham

CREATE PROCEDURE [dbo].[HP2474] 
    @TimesID NVARCHAR(50), 
    @DivisionID NVARCHAR(50),
    @DepartmentID NVARCHAR(50),
    @TeamID NVARCHAR(50),
    @TranMonth INT,
    @TranYear INT,
    @CreateUserID NVARCHAR(50),			
    @ProductID NVARCHAR(50),
    @Quantity DECIMAL(28, 8),
    @TrackingDate DATETIME
AS

-- XÓA CÁC SẢN PHẨM KHI CHẤM CÔNG KHÔNG CÓ TRACKING DATE HAY CÓ TRACKING DATE
IF (ISNULL(@TrackingDate,'1-JAN-1900') = '1-JAN-1900')
	BEGIN
		DELETE FROM HT2413 
			WHERE TimesID = @TimesID 
				AND TranMonth = @TranMonth AND TranYear = @TranYear 
				AND DivisionID = @DivisionID 
				AND TrackingDate IS NOT NULL
	END
ELSE
	BEGIN
		DELETE FROM HT2413 
			WHERE TimesID = @TimesID 
				AND TranMonth = @TranMonth AND TranYear = @TranYear 
				AND DivisionID = @DivisionID 
				AND ISNULL(TrackingDate,'1-JAN-1900') = '1-JAN-1900'
	END

DECLARE 
    @DepartmentID1 NVARCHAR(20),
    @TeamID1 NVARCHAR(20)

IF NOT EXISTS (SELECT 1 FROM HT2413 WHERE TeamID = @TeamID AND TimesID = @TimesID AND TranMonth = @TranMonth AND TranYear = @TranYear AND ProductID = @ProductID AND DivisionID = @DivisionID AND ISNULL(TrackingDate,'1-JAN-1900') = ISNULL(@TrackingDate,'1-JAN-1900'))
    BEGIN
        INSERT HT2413(TimesID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, ProductID, Quantity, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, TrackingDate) 
        VALUES (@TimesID, @TranMonth, @TranYear, @DivisionID, @DepartmentID, @TeamID, @ProductID, @Quantity, @CreateUserID, GETDATE(), @CreateUserID, GETDATE(), @TrackingDate) 
    END
ELSE
    UPDATE HT2413 
	SET Quantity = @Quantity,
		LastModifyUserID = @CreateUserID,
		LastModifyDate = GETDATE()		
    WHERE TeamID = @TeamID 
		AND TimesID = @TimesID 
		AND TranMonth = @TranMonth 
		AND TranYear = @TranYear 
		AND ProductID = @ProductID 
		AND DivisionID = @DivisionID
		AND ISNULL(TrackingDate,'1-JAN-1900') = ISNULL(@TrackingDate,'1-JAN-1900')
GO
