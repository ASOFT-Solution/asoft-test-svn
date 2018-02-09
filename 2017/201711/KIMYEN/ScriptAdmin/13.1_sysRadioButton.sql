--declare @StoreName nvarchar(MAX) declare @StoreParameter nvarchar(MAX) declare @SQLQuery nvarchar(MAX) declare @RadioButtonID nvarchar(MAX) 

--set @StoreName=null 
--set @StoreParameter=null 
--set @SQLQuery=N'Select N''POSF2021.SuggestType0'' as IDLanguage, ''0'' as Value, N''Chi tiền trả cọc'' as Text
--union all select N''POSF2021.SuggestType1'' as IDLanguage, ''1'' as Value, N''Chi tiền trả hàng'' as Text
--union all select N''POSF2021.SuggestType2'' as IDLanguage, ''2'' as Value, N''Chi tiền đổi hàng'' as Text'
--set @RadioButtonID=N'Rdo_SuggestType' 
--If not exists(select top 1 1 from [dbo].[sysRadioButton] where  [RadioButtonID] = N'Rdo_SuggestType')Begin 
--insert into sysRadioButton(StoreName,StoreParameter,SQLQuery,RadioButtonID)values(@StoreName,@StoreParameter,@SQLQuery,@RadioButtonID)
--End
declare @StoreName nvarchar(MAX) declare @StoreParameter nvarchar(MAX) declare @SQLQuery nvarchar(MAX) declare @RadioButtonID nvarchar(MAX) 

set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select N''OOF1051.InformType1'' as IDLanguage, ''0'' as Value, N''Thông báo chung'' as Text
union all select N''OOF1051.InformType2'' as IDLanguage, ''1'' as Value, N''Thông tin nội bộ'' as Text'
set @RadioButtonID=N'Rdo_SuggestType' 
If not exists(select top 1 1 from [dbo].[sysRadioButton] where  [RadioButtonID] = N'Rdo_InformType')Begin 
insert into sysRadioButton(StoreName,StoreParameter,SQLQuery,RadioButtonID)values(@StoreName,@StoreParameter,@SQLQuery,@RadioButtonID)
End

set @StoreName=null 
set @StoreParameter=null 
set @SQLQuery=N'Select N''OOF2101.ProjectType1'' as IDLanguage, ''1'' as Value, N''Dự án'' as Text
union all select N''OOF2101.ProjectType2'' as IDLanguage, ''2'' as Value, N''Nhóm công việc'' as Text'
set @RadioButtonID=N'Rdo_ProjectType' 
If not exists(select top 1 1 from [dbo].[sysRadioButton] where  [RadioButtonID] = N'Rdo_ProjectType')Begin 
insert into sysRadioButton(StoreName,StoreParameter,SQLQuery,RadioButtonID)values(@StoreName,@StoreParameter,@SQLQuery,@RadioButtonID)
End
