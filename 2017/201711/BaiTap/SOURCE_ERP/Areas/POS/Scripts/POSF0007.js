
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm        Tạo mới
//#     02/04/2014      Đam Mơ          Update
//#     16/05/2014      Thai Son        Update
//####################################################################

$(document).ready(function () {
    var comboBoxDivision = $("#DivisionID").data("kendoComboBox");
    // Combobox số dòng trên trang
    var comboBoxPageSizeNumber = $("#PageSizeNumber").data("kendoComboBox");
    // Combobox kỳ kế toán
    var comboBoxMonthYear = $("#MonthYear").data("kendoComboBox");
    // Combobox Kho công ty
    var comboWarehouse = $("#WareHouseID").data("kendoComboBox");

    // Lấy thêm dữ liệu từ form để post lên sever
    // Các dữ liệu mà hàm ASOFT.helper.dataFormToJSON không lấy được như ý muốn
    var additionalData = function () {
        var result = {};  
        var splitted = comboBoxMonthYear.value().split('/');
        result['TranMonth'] = parseInt(splitted[0], 10);
        result['TranYear'] = parseInt(splitted[1], 10);

        if (comboBoxPageSizeNumber.value() != '') {
            var dataItem = comboBoxPageSizeNumber.dataItem();
            if (dataItem) {
                result['PageSizeNumber'] = dataItem.Description;                
                result['PageSizeID'] = dataItem.ID;
            };
        }
        else {
            result['PageSizeNumber'] = '';
            result['PageSizeID'] = '';
        }
        if (comboWarehouse && comboWarehouse.value() != '') {
            var dataItem = comboWarehouse.dataItem();
            if (dataItem) {
                result['WarehouseName'] = dataItem.WareHouseName;
            };
        }

        result['IsNegativeStock'] = ($("#IsNegativeStock").attr("checked") == 'checked');
        result['IsConnectERP'] = ($("#IsConnectERP").is(":checked"));

        return result;
    }

    var reloadPage = function () {
        if (window.parent != window) {
            window.parent.location.reload();
        } else {
            window.location.reload();
        }
    }

    // Lấy dữ liệu cho đơn vị hiện tại
    var loadServerData = function (e) {
        var urlGet = '/POS/POSF0007/GetData';
        var dataItem = comboBoxDivision.dataItem();

        var afterGetData_Handler = function (result) {
            comboBoxPageSizeNumber.value(result.Data.PageSizeID);
            comboBoxMonthYear.value(result.Data.MonthYear);
            comboWarehouse.value(result.Data.WarehouseID);
        }

        var dataSent = { DivisionID: divisionID };

        if (dataItem) {
            var divisionID = dataItem.DivisionID;
            ASOFT.helper.postTypeJson(
                urlGet,
                dataSent,
                afterGetData_Handler);
        } else {
            console.log('TO DO: choose nothing -> clear form;')
        }
      
    }

    // Gán sự kiện cho combobox đơn vị
    // Khi có thay đổi thì load lại thông tin cho đơn vị được chọn
    comboBoxDivision.bind('change', loadServerData);

    // Cấu hình màn hình hiện tại
    ASOFTVIEW.config(
        {
            // URL để lưu/update dữ liệu
            urlSave: '/POS/POSF0007/Save',
            // Mã form (Lấy theo CSS id)
            formID: '#POSF0007',
            // Tên form
            formName: 'POSF0007',
            // Các hàm khác để kiểm tra thay đổi của form
            //additionalChangeDetectors: [],
            // Các dữ liệu mà hàm ASOFT.helper.dataFormToJSON không lấy được như ý muốn
            additionalData: additionalData,
            // Tên (không có dấu #), của các combobox
            remoteDataComboboxIDs: [],
            // Các hàm cần thực thi sau khi lưu dữ liệu
            additionalAfterSaveHandlers: [reloadPage]
        });
});

// Xử lý sự kiện click nút đóng
function btnClose_Click() {
    ASOFTVIEW.btnClose_Click();
}

// Xử lý sự kiện click nút lưu
function btnSave_Click() {
    ASOFTVIEW.btnSave_Click();
};