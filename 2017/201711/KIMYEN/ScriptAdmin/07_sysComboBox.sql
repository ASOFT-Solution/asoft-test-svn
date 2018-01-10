declare @DisplayMember nvarchar(MAX) declare @ValueMember nvarchar(MAX) declare @StoreName nvarchar(MAX) declare @StoreParameter nvarchar(MAX) declare @SQLQuery nvarchar(MAX) declare @VViewTable nvarchar(MAX) declare @ComboBoxID nvarchar(MAX) declare @sysTableID nvarchar(MAX) 

--set @DisplayMember=N'Description'
--set @ValueMember=N'ID'
--set @StoreName=null 
--set @StoreParameter=null 
--set @SQLQuery=N'Select CodeMaster, ID, Description, DescriptionE 
--from POST0099 With (NOLOCK) where CodeMaster = ''POS000014'' and [Disabled] = 0 order by ID'
--set @VViewTable=N'VViewDataMaster'
--set @ComboBoxID=N'CB_StatusPOS'
--If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_StatusPOS')Begin 
--insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
--End

---------- ComboBox-DivisionID
set @DisplayMember=N'DivisionName'
set @ValueMember=N'DivisionID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'SELECT DISTINCT PermissionDivisionID AS DivisionID , AT1101.DivisionName AS DivisionName FROM AT1411 INNER JOIN AT1101 ON AT1101.DivisionID = AT1411.PermissionDivisionID LEFT JOIN AT1402 ON AT1402.DivisionID = AT1411.DivisionID AND AT1402.GroupID = AT1411.GroupID WHERE AT1402.UserID = @@UserID'
set @VViewTable=N'VViewDivision'
set @ComboBoxID=N'CB_0004'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_0004')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End
--------- ComboBox-DepartmentID
set @DisplayMember=N'DepartmentID'
set @ValueMember=N'DepartmentID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select DepartmentID, DepartmentName From AT1102 With (NOLOCK) Where DivisionID in (@DivisionID, ''@@@'') and Disabled = 0 Order by DepartmentID'
set @VViewTable=N'VViewDepartmentID'
set @ComboBoxID=N'CB_DepartmentID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_DepartmentID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

-------- ComboBox-InformType
set @DisplayMember=N'Description'
set @ValueMember=N'ID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select CodeMaster, ID, Description, DescriptionE from AT0099 WITH (NOLOCK) where CodeMaster = ''AT00000045'' and [Disabled] = 0 order by OrderNo'
set @VViewTable=N'VViewInformType'
set @ComboBoxID=N'CB_InformType'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_InformType')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

--set @DisplayMember=N'Description'
--set @ValueMember=N'ID'
--set @StoreName=null 
--set @StoreParameter=null 
--set @SQLQuery=N'Select CodeMaster, ID, Description, DescriptionE from AT0099 WITH (NOLOCK) where CodeMaster = AT00000045 and [Disabled] = 0 order by OrderNo'
--set @VViewTable=N'VViewDisabled'
--set @ComboBoxID=N'CB_Disabled'
--If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_Disabled')Begin 
--insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
--End

--set @DisplayMember=N'Description'
--set @ValueMember=N'ID'
--set @StoreName=null 
--set @StoreParameter=null 
--set @SQLQuery=N'Select CodeMaster, ID, Description, DescriptionE from AT0099 where CodeMaster = ''AT00000004'' and [Disabled] = 0 order by OrderNo'
--set @VViewTable=N'VVCRMF2010_OderStatus'
--set @ComboBoxID=N'CB_0012'
--If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_0012')Begin 
--insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
--End
---------- ComboBox-Disabled
set @DisplayMember=N'Description'
set @ValueMember=N'ID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select CodeMaster, ID, Description, DescriptionE from AT0099 WITH (NOLOCK) where CodeMaster = ''AT00000004'' and [Disabled] = 0 order by OrderNo'
set @VViewTable=N'VVCRMF2010_OderStatus'
set @ComboBoxID=N'CB_0012'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_0012')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End
-----------
----------- ComboBox-IsCommon
-----------
set @DisplayMember=N'Description'
set @ValueMember=N'ID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select CodeMaster, ID, Description, DescriptionE from AT0099 WITH (NOLOCK) where CodeMaster = ''AT00000004'' and [Disabled] = 0 order by OrderNo'
set @VViewTable=N'VViewIsCommon'
set @ComboBoxID=N'CB_VViewIsCommon'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_VViewIsCommon')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End
--------- ComboBox-ProcessID
set @DisplayMember=N'ProcessID'
set @ValueMember=N'ProcessID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'SELECT ProcessID, ProcessName FROM OOT1020 WITH (NOLOCK) WHERE DivisionID = ''@@DivisionID'' and Isnull(Disabled,0) = 0'
set @VViewTable=N'VViewProcessID'
set @ComboBoxID=N'CB_ProcessID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_ProcessID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

-------- ComboBox-StatusType
set @DisplayMember=N'StatusTypeName'
set @ValueMember=N'StatusTypeID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select cast(ID as Tinyint) as StatusTypeID, Description as StatusTypeName, DescriptionE as StatusTypeNameE
From OOT0099 WITH (NOLOCK) 
where CodeMaster = ''OOT00000001'''
set @VViewTable=N'VViewStatusType'
set @ComboBoxID=N'CB_StatusType'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_StatusType')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End