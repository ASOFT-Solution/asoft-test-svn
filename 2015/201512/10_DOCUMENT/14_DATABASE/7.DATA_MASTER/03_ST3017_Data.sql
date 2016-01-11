-- <Summary>
---- 
-- <History>
---- Create on 10/03/2015 by Trần Quốc Tuấn
---- Modified on ... by ...
---- <Example>
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ST3017]') AND TYPE IN (N'U'))
BEGIN
	-- xóa dữ liệu insert lại bản nhóm báo cáo
	DELETE FROM ST3017
	-- Insert dữ liệu ngầm phân hệ T
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftT',N'G01',N'SF3017.ASoftT.G01')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftT',N'G03',N'SF3017.ASoftT.G03')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftT',N'G04',N'SF3017.ASoftT.G04')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftT',N'G06',N'SF3017.ASoftT.G06')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftT',N'G07',N'SF3017.ASoftT.G07')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftT',N'G99',N'SF3017.ASoftT.G99')
	-- Insert dữ liệu ngầm phân hệ OP
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G01',N'SF3017.ASoftOP.G01')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G02',N'SF3017.ASoftOP.G02')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G03',N'SF3017.ASoftOP.G03')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G04',N'SF3017.ASoftOP.G04')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G05',N'SF3017.ASoftOP.G05')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G06',N'SF3017.ASoftOP.G06')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G07',N'SF3017.ASoftOP.G07')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftOP',N'G99',N'SF3017.ASoftOP.G99')
	-- Insert dữ liệu ngầm phân hệ WM
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftWM',N'G01',N'SF3017.ASoftWM.G01')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftWM',N'G02',N'SF3017.ASoftWM.G02')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftWM',N'G03',N'SF3017.ASoftWM.G03')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftWM',N'G05',N'SF3017.ASoftWM.G05')
	-- Insert dữ liệu ngầm phân hệ FA
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftFA',N'G02',N'SF3017.ASoftFA.G02')
	-- Insert dữ liệu ngầm phân hệ M
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftM',N'G01',N'SF3017.ASoftM.G01')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftM',N'G02',N'SF3017.ASoftM.G02')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftM',N'G03',N'SF3017.ASoftM.G03')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftM',N'G08',N'SF3017.ASoftM.G08')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftM',N'G09',N'SF3017.ASoftM.G09')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftM',N'G99',N'SF3017.ASoftM.G99')
	-- Insert dữ liệu ngầm phân hệ HRM
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G01',N'SF3017.ASoftHRM.G01')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G02',N'SF3017.ASoftHRM.G02')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G03',N'SF3017.ASoftHRM.G03')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G04',N'SF3017.ASoftHRM.G04')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G05',N'SF3017.ASoftHRM.G05')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G06',N'SF3017.ASoftHRM.G06')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G07',N'SF3017.ASoftHRM.G07')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G08',N'SF3017.ASoftHRM.G08')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G09',N'SF3017.ASoftHRM.G09')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftHRM',N'G19',N'SF3017.ASoftHRM.G19')
	-- Insert dữ liệu ngầm phân hệ CM
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftCM',N'G01',N'SF3017.ASoftCM.G01')
	INSERT INTO ST3017(Module,GroupID,GroupName) VALUES ('ASoftCM',N'G02',N'SF3017.ASoftCM.G02')
END