-- Thêm field [Xuất giá trị âm]
if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFormReport'  and col.name = 'XuatGiaTriAm')
BEGIN
	ALTER TABLE sysFormReport ADD  XuatGiaTriAm [bit] NULL 
END
