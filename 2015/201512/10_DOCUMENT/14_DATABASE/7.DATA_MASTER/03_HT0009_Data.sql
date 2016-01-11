-- <Summary>
---- Add dữ liệu 05/KK-TNCN
-- <History>
---- Create on 15/05/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
DECLARE @sSQL NVARCHAR(1000) = 'INSERT INTO HT0009 (DeclareRationType, OrderNo, OrderText, TagetID, TagetName, UnitName, Person_Amount, ReadOnly, FormulaString) VALUES ',
		@sSQL1 NVARCHAR (2000)
		
DELETE HT0009 WHERE DeclareRationType = '05KK-TNCN'
SET @sSQL1 = '(''05KK-TNCN'', 1, ''1''	, ''[21]'', N'''+N'Tổng số người lao động'+''', N'''+N'Người'+''', 0, 0, '''')'									EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 2, ''1''	, ''[22]'', N'''+N'Trong đó: Cá nhân cư trú có hợp đồng lao đồng'+''', N'''+N'Người'+''', 0, 1, '''')'			EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 3, ''2''	, ''[23]'', N'''+N'Tổng số cá nhân đã khấu trừ thuế [23] = [24] + [25]'+''', N'''+N'Người'+''', 0, 1, ''[24] + [25]'')'		EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 4, ''2.1'', ''[24]'', N'''+N'Cá nhân cư trú'+''', N'''+N'Người'+''', 0, 0, '''')'											EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 5, ''2.2'', ''[25]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'Người'+''', 0, 1, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 6, ''3''	, ''[26]'', N'''+N'Tổng số cá nhân thuộc diện được miễn, giảm thuế theo Hiệp định tránh đánh thuế hai lần'+''', N'''+N'Người'+''', 0, 0, '''')' EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 7, ''4''	, ''[27]'', N'''+N'Tổng thu nhập chịu thuế (TNCN) trả cho cá nhân [27]=[28]+[29]+[30]'+''', N'''+N'VNĐ'+''', 0, 1, ''[28] + [29] + [30]'')' EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 8, ''4.1'', ''[28]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 9, ''4.2'', ''[29]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 10, ''4.3'', ''[30]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 1, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 11, ''5''	, ''[31]'', N'''+N'Tổng TNCT trả cho cá nhân thuộc diện phải khấu trừ thuế [31]=[32]+[33]+[34]'+''', N'''+N'VNĐ'+''', 0, 1, ''[32] + [33] + [34]'')'			   EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 12, ''5.1'', ''[32]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 13, ''5.2'', ''[33]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 14, ''5.3'', ''[34]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 1, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 15, ''6'', ''[35]'', N'''+N'Tổng số thuế thu nhập cá nhân (TNCN) đã khấu trừ [35]=[36]+[37]+[38]'+''', N'''+N'VNĐ'+''', 0, 1, ''[36] + [37] + [38]'')'					   EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 16, ''6.1'', ''[36]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 17, ''6.2'', ''[37]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 18, ''6.3'', ''[38]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 1, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 19, ''7'', ''[39]'', N'''+N'Tổng số thuế được giảm do làm việc tại khu kinh tế [39]=[40]+[41]+[42]'+''', N'''+N'VNĐ'+''', 0, 1, ''[40]+ [41] + [42]'')'					   EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 20, ''7.1'', ''[40]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 21, ''7.2'', ''[41]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 1, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 22, ''7.3'', ''[42]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 0, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 23, ''1'', ''[43]'', N'''+N'Tổng số cá nhân ủy quyền cho tổ chức, cá nhân trả thu nhập quyết toán thay'+''', N'''+N'Người'+''', 0, 1, '''')'			EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 24, ''2'', ''[44]'', N'''+N'Tổng số thuế TNCN đã khấu trừ'+''', N'''+N'Người'+''', 0, 1, '''')'								EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 25, ''3'', ''[45]'', N'''+N'Tổng số thuế TNCN phải nộp'+''', N'''+N'Người'+''', 0, 1, '''')'								EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 26, ''4'', ''[46]'', N'''+N'Tổng số thuế TNCN còn phải nộp NSNN'+''', N'''+N'Người'+''', 0, 1, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''05KK-TNCN'', 27, ''5'', ''[47]'', N'''+N'Tổng số thuế TNCN đã nộp thừa'+''', N'''+N'Người'+''', 0, 1, '''')'								EXEC (@sSQL + @sSQL1)

DELETE HT0009 WHERE DeclareRationType = '02KK-TNCN'
SET @sSQL1 = '(''02KK-TNCN'', 1, ''1''	, ''[21]'', N'''+N'Tổng số người lao động'+''', N'''+N'Người'+''', 0, 0, '''')'									EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 2, ''1''	, ''[22]'', N'''+N'Trong đó: Cá nhân cư trú có hợp đồng lao đồng'+''', N'''+N'Người'+''', 0, 0, '''')'			EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 3, ''2''	, ''[23]'', N'''+N'Tổng số cá nhân đã khấu trừ thuế [23]=[24]+[25]'+''', N'''+N'Người'+''', 0, 1, ''[24] + [25]'')'		EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 4, ''2.1'', ''[24]'', N'''+N'Cá nhân cư trú'+''', N'''+N'Người'+''', 0, 0, '''')'											EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 5, ''2.2'', ''[25]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'Người'+''', 0, 0, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 6, ''3''	, ''[26]'', N'''+N'Tổng thu nhập chịu thuế (TNCN) trả cho cá nhân [26]=[27]+[28]+[29]'+''', N'''+N'VNĐ'+''', 0, 1, ''[27] + [28] + [29]'')' EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 7, ''3.1'', ''[27]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 8, ''3.2'', ''[28]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 9, ''3.3'', ''[29]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 0, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 10, ''4''	, ''[30]'', N'''+N'Tổng TNCT trả cho cá nhân thuộc diện phải khấu trừ thuế [30]=[31]+[32]+[33]'+''', N'''+N'VNĐ'+''', 0, 1, ''[31] + [32] + [33]'')'			   EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 11, ''4.1'', ''[31]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 12, ''4.2'', ''[32]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 13, ''4.3'', ''[33]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 0, '''')'										EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 14, ''5'', ''[34]'', N'''+N'Tổng số thuế thu nhập cá nhân (TNCN) đã khấu trừ [34]=[35]+[36]+[37]'+''', N'''+N'VNĐ'+''', 0, 1, ''[35] + [36] + [37]'')'					   EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 15, ''5.1'', ''[35]'', N'''+N'Cá nhân cư trú có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'						EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 16, ''5.2'', ''[36]'', N'''+N'Cá nhân cư trú không có hợp đồng lao động'+''', N'''+N'VNĐ'+''', 0, 0, '''')'					EXEC (@sSQL + @sSQL1)
SET @sSQL1 = '(''02KK-TNCN'', 17, ''5.3'', ''[37]'', N'''+N'Cá nhân không cư trú'+''', N'''+N'VNĐ'+''', 0, 0, '''')'										EXEC (@sSQL + @sSQL1)




	