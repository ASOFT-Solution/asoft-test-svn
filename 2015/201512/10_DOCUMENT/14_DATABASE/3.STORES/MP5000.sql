IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP5000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP5000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------- Created BY Nguyen Van Nhan, Date 03/11/2003
------- Purpose : Phan bo chi phi
------- Edit BY: Dang Le Bao Quynh, Date 23/03/2007
------- Purpose: Sua lai cau truc bang tam MT2222 cho dong nhat voi store MP8002 
----- Modify on 11/06/2014 by Bảo Anh: Nhân thêm tỷ lệ hoàn thành khi tính số lượng SPDD ở bước 1
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/
----- Modify on 02/12/2015 by Phương Thảo: Bỏ điều kiện where theo Đối tượng TPCP (PeriodID), vô từng store con sẽ bổ sung sau


CREATE PROCEDURE [dbo].[MP5000] 
    @DivisionID NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT
AS

DECLARE 
    @DistributionID AS NVARCHAR(50), 
    @sSQL AS NVARCHAR(4000), 
	@sSQL1 AS NVARCHAR(4000) 

------------ Buoc 1 --- Xac dinh ket qua san xuat dở dang và thành phẩm
SET @sSQL = '
SELECT 
    D10.DivisionID, 
    D10.ProductID AS ProductID, 
    AT1302.InventoryTypeID, 
    D10.UnitID, 
	D08.PeriodID,
    ---SUM(D10.Quantity) AS ProductQuantity
    SUM(D10.Quantity*Isnull(D10.PerfectRate,100)/100) AS ProductQuantity
FROM MT1001 D10 
    INNER JOIN MT0810 D08 ON D08.DivisionID = D10.DivisionID AND D08.VoucherID = D10.VoucherID
    INNER JOIN AT1302 ON AT1302.DivisionID = D10.DivisionID AND AT1302.InventoryID = D10.ProductID
WHERE -- D08.PeriodID = N''' + @PeriodID + ''' AND
	D08.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
    AND D08.ResultTypeID IN (''R01'', ''R03'')
GROUP BY D10.DivisionID, D10.ProductID, AT1302.InventoryTypeID, D08.PeriodID, D10.UnitID 
' 

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[MT2222]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
    BEGIN
        CREATE TABLE [dbo].[MT2222] (
        [DivisionID] NVARCHAR (50) NULL, 
        [ProductID] NVARCHAR (50) NULL, 
        [InventoryTypeID] NVARCHAR (50) NULL, 
        [UnitID] NVARCHAR (50) NULL, 
		[PeriodID] NVARCHAR (50) NULL, 
        [ProductQuantity] DECIMAL(28, 8) NULL, 
        [PerfectRate] DECIMAL(28, 8) NULL, 
        [MaterialRate] DECIMAL(28, 8) NULL, 
        [HumanResourceRate] DECIMAL(28, 8) NULL, 
        [OthersRate] DECIMAL(28, 8) NULL 
        ) ON [PRIMARY] 
    END
ELSE
BEGIN 
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT2222' AND col.name = 'PeriodID')
		ALTER TABLE MT2222 ADD PeriodID NVARCHAR(50) NULL
END

DELETE MT2222 --- bang tam 

SET @sSQL1 = '
INSERT MT2222(DivisionID, ProductID, InventoryTypeID, UnitID, PeriodID, ProductQuantity) 

'
EXEC (@sSQL1 + @sSQL)
--Print (@sSQL1 + @sSQL)
------------ Buoc 2 tien hanh phan bo chi phi/ xac dinh phuong phap phan bo
SET @DistributionID = (SELECT DistributionID FROM MT1601 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

------- Phan bo NVL truc tiep
EXEC MP0621 @DivisionID, @PeriodID, @TranMonth, @TranYear, @DistributionID

------- Phan bo Nhan cong truc tiep
EXEC MP0622 @DivisionID, @PeriodID, @TranMonth, @TranYear, @DistributionID

--- Phan bi chi phi san xuat chung
EXEC MP0627 @DivisionID, @PeriodID, @TranMonth, @TranYear, @DistributionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

