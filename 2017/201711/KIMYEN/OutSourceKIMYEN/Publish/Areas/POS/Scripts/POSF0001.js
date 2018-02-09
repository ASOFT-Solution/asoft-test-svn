//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm        Tạo mới
//#     02/04/2014      Đam Mơ          Update
//#     05/05/2014      Thai Son        Update
//####################################################################

$(document).ready(function () {
    var cboShopTypeID = $('#ShopTypeID').data('kendoComboBox')
    if (ASOFTEnvironment.CustomerIndex.isPhucLong()) {
        cbGroupInventoryID = $('#GroupInventoryID').data('kendoComboBox')
    }    
    ;

    function init() {
        cboShopTypeID.bind('change', cboShopTypeID_Select);
        if (ASOFTEnvironment.CustomerIndex.isPhucLong()) {
            cbGroupInventoryID.bind('change', cboGroupInventoryTypeID_Select);
            cbGroupInventoryID.bind('dataBound', cboGroupInventoryTypeID_DataBound);
        }
    }

    function cboGroupInventoryTypeID_DataBound() {
        var dataSource = this.dataSource;
        console.log(dataSource);
    }

    //// Xử lý khi chọn combo mã phân tích
    function cboShopTypeID_Select() {
        var dataItem = this.dataItem(this.selectedIndex);
        if (!dataItem) {
            return null;
        };
        $('#ShopTypeName').val(dataItem.UserName);
    }


    /// Xử lý khi chọn combo GroupInventoryTypeID
    function cboGroupInventoryTypeID_Select() {
        var dataItem2 = this.dataItem(this.selectedIndex);
        if (!dataItem2) {
            return null;
        };
        $('#GroupInventoryName').val(dataItem2.UserName);
    }

    ASOFTVIEW.config(
        {
            urlSave: '/POS/POSF0001/Save',
            formID: '#POSF0001',
            formName: 'POSF0001',
            remoteDataComboboxIDs: ["ShopTypeID"],
            hasLastModifyDate: true,
            additionalAfterSaveHandlers: [],
            getMessageParameter: function () { return $('label[for="ShopTypeID"]').text() },
            excludeKendoInputTextWidget: false
            //getMessageParameter: function (result) { return result.MessageID }
        });

    init()
});

function btnClose_Click() {
    ASOFTVIEW.btnClose_Click();
}

function btnSave_Click() {
    ASOFTVIEW.btnSave_Click();
};


