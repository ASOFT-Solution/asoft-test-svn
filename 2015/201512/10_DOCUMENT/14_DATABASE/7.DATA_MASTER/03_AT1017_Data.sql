-- <Summary>
---- Bổ sung nhóm Loại phiếu
-- <History>
---- Create on 11/10/2012 by Lê Thị Thu Hiền 
---- Modified on ... by ...
---- <Example>
DECLARE @DivisionID NVarchar(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101

OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID

WHILE @@fetch_status = 0
  BEGIN	
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017 WHERE DivisionID = @DivisionID AND VoucherGroupID = '45')
INSERT INTO AT1017 (DivisionID, VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES (@DivisionID, '45', N'Phiếu tiến độ giao hàng', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017 WHERE DivisionID = @DivisionID AND VoucherGroupID = '46')
INSERT INTO AT1017 (DivisionID, VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES (@DivisionID, '46', N'Lập phiếu yêu cầu mua hàng', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017 WHERE DivisionID = @DivisionID AND VoucherGroupID = '47')
INSERT INTO AT1017 (DivisionID, VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES (@DivisionID, '47', N'Lập phiếu tiến độ nhận hàng', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017 WHERE DivisionID = @DivisionID AND VoucherGroupID = '48')
INSERT INTO AT1017 (DivisionID, VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES (@DivisionID, '48', N'Dự trù kinh phí sản xuất', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017 WHERE DivisionID = @DivisionID AND VoucherGroupID = '49')
INSERT INTO AT1017 (DivisionID, VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES (@DivisionID, '49', N'Phiếu điều chỉnh đơn hàng', 0, 1)
    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
IF EXISTS (SELECT TOP 1 1 FROM AT1017 WHERE VoucherGroupID = 'T25')
DELETE AT1017 WHERE VoucherGroupID = 'T25'
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017 WHERE VoucherGroupID = '25') 
    INSERT INTO AT1017
    (
    	DivisionID,
    	VoucherGroupID,
    	[Description],
    	Disabled,
	IsUsed
    )
SELECT AT1101.DivisionID ,
   VoucherGroupID,
   [Description],
   AT1017STD.Disabled,
   IsUsed
   FROM AT1017STD , AT1101 
   WHERE AT1017STD.VoucherGroupID = '25'
	AND DivisionID Not In (Select Distinct DivisionID From AT1017 Where VoucherGroupID = '25')

