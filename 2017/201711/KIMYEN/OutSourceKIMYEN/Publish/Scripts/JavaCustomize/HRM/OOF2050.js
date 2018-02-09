//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/01/2016     Quang Chiến       Tạo mới
//####################################################################

var IsCheckExecute = false;
$(document).ready(function () {
    $("#Status_OOF2050").data("kendoComboBox").select(0);
    OOF2050.grid = $('#GridOOT9000').data('kendoGrid');
    OOF2050.grid.bind("dataBound", OOF2050.RowGrid_ChangeColor);

    setTimeout(function () {
        var urlpp = window.location.href;
        urlpp = urlpp.split('?')[1];
        if (urlpp !== undefined) {
            urlpp = urlpp.split('&');
            var apk = urlpp[0].split('=')[1];
            var type = urlpp[1].split('=')[1];
            OOF2050.ChooseType_Click(apk, type);
        }
    }, 300)

    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter', JSON.stringify(datamaster));
})

OOF2050 = new function () {
    this.grid = null;

    //Đổi màu cho row theo IsColor(0:bình thường;1:vàng;2:đỏ)
    this.RowGrid_ChangeColor = function (e) {
        
        //lấy giá trị của lưới
        var item = e.sender._data;

        //lấy tất cả các dòng grid
        var rows = $('div.k-grid-content table tr');

        for (var i = 0; i < item.length; i++) {
            if (item[i].IsColor == 1) {
                $(rows[i]).css('background', 'yellow');
            } else if (item[i].IsColor == 2) {
                $(rows[i]).css('background', 'red');
            }
        }
        
    }

    //link dưới field StatusName
    this.ChooseType_Click = function (apk, type) {
        var url = null;
        switch (type) {
            case 'BPC':
                url = '/PopupMasterDetail/Index/HRM/OOF2051?PK=' + apk + '&Table=OOT9000&key=APK&Type=' + type;
                break;
            case 'DXP':
                url = '/PopupMasterDetail/Index/HRM/OOF2052?PK=' + apk + '&Table=OOT9000&key=APK&Type=' + type;
                break;
            case 'DXRN':
                url = '/PopupMasterDetail/Index/HRM/OOF2053?PK=' + apk + '&Table=OOT9000&key=APK&Type=' + type;
                break;
            case 'DXLTG':
                url = '/PopupMasterDetail/Index/HRM/OOF2054?PK=' + apk + '&Table=OOT9000&key=APK&Type=' + type;
                break;
            case 'DXBSQT':
                url = '/PopupMasterDetail/Index/HRM/OOF2055?PK=' + apk + '&Table=OOT9000&key=APK&Type=' + type;
                break;
            case 'DXDC':
                url = '/PopupMasterDetail/Index/HRM/OOF2057?PK=' + apk + '&Table=OOT9000&key=APK&Type=' + type;
                break;
        }

        ASOFT.asoftPopup.showIframe(url, {});

    }

    //link dưới field ID
    this.ShowDetail_Click = function (apkMaster,type) {
        var url = null;
        switch (type) {
            case 'BPC':
                url = '/ViewMasterDetail/Index/HRM/OOF2002?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXP':
                url = '/ViewMasterDetail/Index/HRM/OOF2012?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXRN':
                url = '/ViewMasterDetail/Index/HRM/OOF2022?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXLTG':
                url = '/ViewMasterDetail/Index/HRM/OOF2032?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXBSQT':
                url = '/ViewMasterDetail/Index/HRM/OOF2042?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXDC':
                url = '/ViewMasterDetail/Index/HRM/OOF2072?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
        }

        window.open(url);

    }
}


function CustomConfirmAll() {
    ASOFT.form.clearMessageBox();
    IsCheckExecute = true;
    var args = [];
    var records = ASOFT.asoftGrid.selectedRecords(OOF2050.grid, 'FormFilter');
    if (records.length == 0) return;
    
    ASOFT.asoftPopup.showIframe("/PopupLayout/Index/HRM/OOF2056?StatusOOF2056=" + records[0].Status, {});
}

function onAfterFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    var cboStatus = $('#Status_OOF2050').data("kendoComboBox");
    cboStatus.select(0);

    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = OOF2050.grid.pager.options.buttonCount;
    var CurPage = OOF2050.grid.pager.page();
    if (IsCheckExecute) {
        OOF2050.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        OOF2050.grid.dataSource.page(1);
    }
}

