declare @sysTable nvarchar(MAX) declare @AllowNull nvarchar(MAX) declare @ReadOnly nvarchar(MAX) declare @sysComboBoxID nvarchar(MAX) declare @Type nvarchar(MAX) declare @TabIndex nvarchar(MAX) declare @TabIndexGrid nvarchar(MAX) declare @TabIndexPopup nvarchar(MAX) declare @TabIndexView nvarchar(MAX) declare @MinValue nvarchar(MAX) declare @MaxValue nvarchar(MAX) declare @DefaultValue nvarchar(MAX) declare @Visible nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @sysRegularID nvarchar(MAX) declare @sysDataTypeID nvarchar(MAX) declare @GridVisible nvarchar(MAX) declare @FieldVisible nvarchar(MAX) declare @PopupVisible nvarchar(MAX) declare @ViewVisible nvarchar(MAX) declare @UniqueField nvarchar(MAX) declare @RefTable nvarchar(MAX) declare @GroupID nvarchar(MAX) declare @sysEditorTemplateID nvarchar(MAX) declare @MaxLenght nvarchar(MAX) declare @SpecialControl nvarchar(MAX) declare @RefDisplayField nvarchar(MAX) declare @RefValueField nvarchar(MAX) declare @RefViewTable nvarchar(MAX) declare @sysClientTemplateID nvarchar(MAX) declare @FieldID nvarchar(MAX) declare @GridWidth nvarchar(MAX) declare @sysRadioButtonID nvarchar(MAX) declare @LanguageID nvarchar(MAX) declare @IsImport nvarchar(MAX) declare @RefTableComboboxID nvarchar(MAX) declare @GroupOnGrid nvarchar(MAX) declare @CountOnGrid nvarchar(MAX) declare @SumOnGrid nvarchar(MAX) declare @AverageOnGrid nvarchar(MAX) declare @MaxOnGrid nvarchar(MAX) declare @MinOnGrid nvarchar(MAX) declare @LayoutPosition nvarchar(MAX) declare @IsNoUpdate nvarchar(MAX) declare @GridOneTable nvarchar(MAX) 


--set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
--set @sysRegularID=null
--set @sysEditorTemplateID=null
--set @sysClientTemplateID=null
--set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='SOF2002.ThongTinDonHang') 
--set @sysTable=N'OT2001'
--set @AllowNull=N'0'
--set @ReadOnly=N'0'
--set @Type=N'4'
--set @TabIndex=N'2'
--set @TabIndexGrid=N'1'
--set @TabIndexPopup=N'1'
--set @TabIndexView=N'1'
--set @MinValue=null 
--set @MaxValue=null 
--set @DefaultValue=null 
--set @Visible=N'1'
--set @ColumnName=N'DivisionID'
--set @sysDataTypeID=N'7'
--set @GridVisible=N'1'
--set @FieldVisible=N'1'
--set @PopupVisible=N'1'
--set @ViewVisible=N'1'
--set @UniqueField=N'0'
--set @RefTable=null 
--set @MaxLenght=null 
--set @SpecialControl=null 
--set @RefDisplayField=null 
--set @RefValueField=null 
--set @RefViewTable=null 
--set @FieldID=N'Field0013'
--set @GridWidth=N'100'
--If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Field0013')Begin 
--insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
--End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'APK'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'0'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'APK_OOT1040'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'APK_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1042.XemChiTietTrangThai') 
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'4'
set @TabIndex=N'1'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DivisionID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'DivisionID_OOT1040'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DivisionID_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1042.XemChiTietTrangThai') 
set @sysTable=N'OOT1040'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'2'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StatusID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'1'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StatusID_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StatusID_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1042.XemChiTietTrangThai') 
set @sysTable=N'OOT1040'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'3'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StatusName'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StatusName_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StatusName_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1042.XemChiTietTrangThai') 
set @sysTable=N'OOT1040'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'4'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Orders'
set @sysDataTypeID=N'5'
set @GridVisible=N'1'
set @FieldVisible=N'0'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'Orders_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Orders_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'5'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Color'
set @sysDataTypeID=N''
set @GridVisible=N'1'
set @FieldVisible=N'0'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'Color_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Color_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'RelatedToTypeID'
set @sysDataTypeID=N'5'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'0'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'RelatedToTypeID_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'RelatedToTypeID_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_VViewIsCommon')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1042.XemChiTietTrangThai') 
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'2'
set @TabIndex=N'8'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'IsCommon'
set @sysDataTypeID=N'6'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'IsCommon_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'IsCommon_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0012')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1042.XemChiTietTrangThai') 
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'2'
set @TabIndex=N'7'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Disabled'
set @sysDataTypeID=N'6'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'Disabled_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Disabled_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'3'
set @TabIndex=N'6'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StatusType'
set @sysDataTypeID=N'6'
set @GridVisible=N'0'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StatusType_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StatusType_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong')
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'9'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CreateDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'CreateDate_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateDate_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong')
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'10'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CreateUserID'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'CreateUserID_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateUserID_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong')
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'10'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LastModifyUserID'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'LastModifyUserID_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyUserID_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong')
set @sysTable=N'OOT1040'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'12'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LastModifyDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'LastModifyDate_OOT1040'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyDate_OOT1040')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End


