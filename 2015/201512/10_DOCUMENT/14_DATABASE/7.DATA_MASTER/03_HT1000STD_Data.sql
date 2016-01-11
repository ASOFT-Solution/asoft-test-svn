-- <Summary>
---- 
-- <History>
---- Create on 29/03/2011 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
If not exists (Select Top 1 1 From HT1000STD Where MethodID = 'P06')
Insert Into HT1000STD(MethodID,SystemName,UserName,Description,IsDivision,IsUsed) 
Values (N'P06',N'Lương công trình',N'Lương công trình',N'Lương công trình',0,1)
If not exists (Select Top 1 1 From HT1000STD Where MethodID = 'P05')
Insert Into HT1000STD(MethodID,SystemName,UserName,Description,IsDivision,IsUsed) 
Values (N'P05',N'Lương sản phẩm ngày',N'Lương sản phẩm ngày',N'Sum lương khoán sản phẩm theo tổ từng ngày',0,1)
DECLARE @DivisionID NVarchar(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID
WHILE @@fetch_status = 0
  BEGIN	
If not exists (Select Top 1 1 From HT1000 Where MethodID = 'P05' And DivisionID = @DivisionID)
Insert Into HT1000(DivisionID,MethodID,SystemName,UserName,Description,IsDivision,IsUsed) 
Values (@DivisionID,N'P05',N'Lương sản phẩm ngày',N'Lương sản phẩm ngày',N'Sum lương khoán sản phẩm theo tổ từng ngày',0,1)
	FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
--DECLARE @DivisionID NVarchar(50)

DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101

OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID

WHILE @@fetch_status = 0
  BEGIN	
If not exists (Select Top 1 1 From HT1000 Where MethodID = 'P06' And DivisionID = @DivisionID)
Insert Into HT1000(DivisionID,MethodID,SystemName,UserName,Description,IsDivision,IsUsed) 
Values (@DivisionID,N'P06',N'Lương công trình',N'Lương công trình',N'Lương công trình',0,1)
	
    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
