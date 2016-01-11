-- <Summary>
---- Insert dữ liệu thiết lập chế độ ốm đau mặc định
-- <History>
---- Create on 21/10/2013 by Bảo Anh
---- Modify on 16/12/2013 By Bảo Anh: Bổ sung trường hợp phụ cấp khu vực 0.7
---- <Example>

DELETE FROM HT0306
GO
--- bản thân ốm đau, điều kiện làm việc bình thường
INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,0,15,0,30,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,15,30,0,40,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,30,NULL,0,60,'@LBH*0.75*@NN/26'
FROM AT1101

--- bản thân ốm đau, điều kiện làm việc nặng nhọc độc hại
INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,0,15,1,40,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,15,30,1,50,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,30,NULL,1,70,'@LBH*0.75*@NN/26'
FROM AT1101

--- bản thân ốm đau, phụ cấp khu vực từ 0.7 trở lên
INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,0,15,2,40,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,15,30,2,50,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,0,30,NULL,2,70,'@LBH*0.75*@NN/26'
FROM AT1101

--- Bản thân bệnh dài ngày
INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,1,NULL,NULL,NULL,180,
N'If @NN <= 180 then
	@LBH*75/100
Else
	@LBH*75/100 + (If (If @TGD < 15 then @LBH*45/100
					Else If @TGD < 30 then @LBH*55/100
					Else @LBH*65/100 End) < @LTT then @LTT else (If @TGD < 15 then @LBH*45/100
																	Else If @TGD < 30 then @LBH*55/100
																	Else @LBH*65/100 End) End)
End'
FROM AT1101
--- Con ốm
INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,2,0,3,NULL,20,'@LBH*0.75*@NN/26'
FROM AT1101

INSERT INTO HT0306 (APK,DivisionID,ID,[Description],FromDate,ToDate,ConditionTypeID,InYearsFrom,InYearsTo,WorkConditionTypeID,MaxLeaveDays,ConditionCode)
SELECT NEWID(),DivisionID,'SR',N'Chế độ ốm đau','06/29/2006',NULL,2,3,7,NULL,15,'@LBH*0.75*@NN/26'
FROM AT1101