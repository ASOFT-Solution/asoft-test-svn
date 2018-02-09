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

--------ComboBox-WorkID
set @DisplayMember=N'WorkName'
set @ValueMember=N'WorkID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select Top 100 APK,DivisionID, WorkID, WorkName, Description,  PlanTime,  Orders From OOT2110 WITH (NOLOCK)
WHERE DivisionID =''@@DivisionID'''
set @VViewTable=N'VViewWorkID'
set @ComboBoxID=N'CB_WorkID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_WorkID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--------- ComboBox màn hình OOF2100-------
-----CB LeaderID
set @DisplayMember=N'LeaderName'
set @ValueMember=N'LeaderID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select EmployeeID as LeaderID, FullName as LeaderName 
FROM AT1103 WITH (NOLOCK)
WHERE DivisionID in (''@@DivisionID'',''@@@'')'
set @VViewTable=N'VViewLeaderID'
set @ComboBoxID=N'CB_LeaderID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_LeaderID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

------ CB ContractID

set @DisplayMember=N'ContractName'
set @ValueMember=N'ContractID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select ContractID, ContractNo, ContractName 
FROM AT1020 WITH (NOLOCK)
WHERE DivisionID = ''@@DivisionID'''
set @VViewTable=N'VViewContractID'
set @ComboBoxID=N'CB_ContractID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_ContractID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

------- CB StatusID

set @DisplayMember=N'StatusName'
set @ValueMember=N'StatusID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select StatusID, StatusName FROM OOT1040 WITH (NOLOCK)
WHERE DivisionID In (''@@DivisionID'',''@@@'') and StatusType in (0, 2)'
set @VViewTable=N'VViewStatusID'
set @ComboBoxID=N'CB_StatusID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_StatusID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

------CB DepartmentID-OOF2100

set @DisplayMember=N'DepartmentName'
set @ValueMember=N'DepartmentID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select DepartmentID, DepartmentName 
FROM AT1102 WITH (NOLOCK)
WHERE DivisionID in (''@@DivisionID'',''@@@'')'
set @VViewTable=N'VViewDepartmentID_OOF2100'
set @ComboBoxID=N'CB_DepartmentID_OOF2100'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_DepartmentID_OOF2100')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

-----CB TaskSampleID - OOF2101

set @DisplayMember=N'TasKSampleName'
set @ValueMember=N'TasKSampleID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select TasKSampleID, TasKSampleName 
FROM OOT2090 WITH (NOLOCK)
WHERE DivisionID = ''@@DivisionID'''
set @VViewTable=N'VViewTaskSampleID_OOF2100'
set @ComboBoxID=N'CB_TaskSampleID_OOF2100'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_TaskSampleID_OOF2100')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

----- CB DepartmentID
set @DisplayMember=N'DepartmentName'
set @ValueMember=N'DepartmentID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=null
set @VViewTable=N'VViewDepartmentID'
set @ComboBoxID=N'CB_DepartmentID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_DepartmentID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End

------ CB AssignedToUserID
set @DisplayMember=N'AssignedToUserName'
set @ValueMember=N'AssignedToUserID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=null
set @VViewTable=N'VViewAssignedToUserID'
set @ComboBoxID=N'CB_AssignedToUserID'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_AssignedToUserID')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End 
----- CB LeaderID
set @DisplayMember=N'LeaderName'
set @ValueMember=N'LeaderID'
set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=null
set @VViewTable=N'VViewLeaderID'
set @ComboBoxID=N'CB_LeaderName'
If not exists(select top 1 1 from [dbo].[sysComboBox] where  [ComboBoxID] = N'CB_LeaderName')Begin 
insert into sysComboBox(DisplayMember,ValueMember,StoreName,StoreParameter,SQLQuery,VViewTable,ComboBoxID)values(@DisplayMember,@ValueMember,@StoreName,@StoreParameter,@SQLQuery,@VViewTable,@ComboBoxID)
End 