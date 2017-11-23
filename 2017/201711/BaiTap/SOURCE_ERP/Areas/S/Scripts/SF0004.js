//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     26/11/2014      Hoàng Tú        Tạo mới
//####################################################################
//Hàm: Khởi tạo khi form load
$(document).ready(function () {
    SF0004.SF0004Grid = ASOFT.asoftGrid.castName('SF0004Grid');
    SF0004.comboGroupID = ASOFT.asoftComboBox.castName('GroupID');
    SF0004.comboModuleID = ASOFT.asoftComboBox.castName('ModuleID');
    SF0004.comboDataTypeID = ASOFT.asoftComboBox.castName('DataTypeID');
    //Bound dữ liệu vào lưới khi nó load
    SF0004.SF0004Grid.bind('dataBound', function () {
    SF0004.rowNum = 0; 
    //Focus vào dòng đầu tiên
     SF0004.SF0004Grid.focus(0); 
    });
});
var FORM_ID = 'SF0004';
SF0004 = new function () { 
    //Khai báo các biến
    this.isChanged = false; //false: trạng thái form ko bị thay đổi ---- true: trạng thái form bị thay đổi
    this.rowNum = 0;
    this.comboNames = ['GroupID', 'ModuleID','DataTypeID']; 
    this.SF0004Grid = null;
    this.moduleID = null;
    this.groupID = null;
    this.dataTypeID = null;
    this.comboGroupID = null;
    this.comboModuleID = null;
    this.comboDataTypeID = null;
    this.SF0004GridData = [];
    // Sự kiện: Nhấn nút đóng
    this.btnClose_Click = function () { 
        SF0004.closePopup();
    };
    // Hàm: Đóng
    this.closePopup = function () {
        if (SF0004.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                SF0004.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        SF0004.rowNum = 0;
    };
   //Hàm: Thay đổi lưới khi change ModuleID
    this.moduleID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, FORM_ID);
        var combobox = this;
        var item = combobox.dataItem(combobox.selectedIndex);
        if (!item || item == null) return; //không cho load lại lưới
        SF0004.SF0004Grid.dataSource.read(); 
    };
    //Hàm: Thay đổi lưới khi change GroupID 
    this.groupID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, FORM_ID);
        var combobox = this;
        var item = combobox.dataItem(combobox.selectedIndex);
        if (!item || item == null) return; //không cho load lại lưới
        SF0004.SF0004Grid.dataSource.read();
    };
   
    //Hàm: Thay đổi lưới khi change dataTypeID 
    this.dataTypeID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, FORM_ID);
        var combobox = this;
        var item = combobox.dataItem(combobox.selectedIndex);
        if (!item || item == null) return; //không cho load lại lưới
        SF0004.SF0004Grid.dataSource.read();
    };
    
    //Hàm: Gởi dữ liệu từ form lên server
    this.gridSendData = function () {
        var data = ASOFT.helper.dataFormToJSON(FORM_ID); 
        return data;
    };

    //Sự kiện: Check vào checkbox
    this.checkBox_Changed = function (tag) {
        var currentRecord = ASOFT.asoftGrid.selectedRecord(SF0004.SF0004Grid);
        currentRecord[tag.id] = $(tag).prop('checked') ? 1 : 0;
        SF0004.isChanged = true;
    };
    // Sự kiện: Lưu
    this.btnSave_Click = function () {
        SF0004.updateData();
        return 1;
    };
    //Hàm:Lấy dữ liệu từ form và post lên server
    this.updateData = function () {
        if (ASOFT.form.checkRequiredAndInList(FORM_ID, SF0004.comboNames)) {
            return;
        } 
        var data = SF0004.getDataFromForm();
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, SF0004.updateSuccess);
    }; 
    this.GetdataSuccess = function (result) {
        SF0004.SF0004GridData = result;
    };
    //Hàm: Lấy dữ liệu từ form
    this.getDataFromForm = function () { 
        var data = ASOFT.helper.dataFormToJSON(FORM_ID, 'List', SF0004.SF0004Grid);
        for (var i = 0; i < data.List.length ; i++) {
            data.List[i].ModuleID = data.ModuleID;
            data.List[i].GroupID = data.GroupID;
            data.List[i].DataType = data.DataTypeID;
        }  
        return data;
    };
    //Hàm: Trả về kết quả từ server khi lưu thành công
    this.updateSuccess = function (result) { 
        ASOFT.form.updateSaveStatus(FORM_ID, result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, FORM_ID, function () {  
            SF0004.isChanged = false;
        }, null, null, true);
    };

};
