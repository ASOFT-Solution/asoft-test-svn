USE [CDT]

---1. Tiếng việt trước tiếng anh----------------
---1.1. Tên Tài Khoản
UPDATE sysField
SET    TabIndex = 2
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMTK')
       AND FieldName = N'TenTK' 
---1.2. Bậc tài khoản
UPDATE sysField
SET    TabIndex = 3
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMTK')
       AND FieldName = N'GradeTK' 
---1.3. Tên Tài Khoản 2
UPDATE sysField
SET    TabIndex = 4
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMTK')
       AND FieldName = N'TenTK2'        

---1.4. Tài khoản công nợ
UPDATE sysField
SET    TabIndex = 5
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMTK')
       AND FieldName = N'TKCongNo'               

---1.5. Tài khoản Sổ Cái
UPDATE sysField
SET    TabIndex = 6
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMTK')
       AND FieldName = N'TKSoCai'     