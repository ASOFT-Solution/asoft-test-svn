//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/03/2014      Chánh Thi        Tạo mới
//####################################################################

var rowNumber = 0;

$(document).ready(function () {

});


function popupClose(event) {
    parent.popupClose();
}
/**
* Xử lý sự kiện click vào nút lưu
*/
function POSF0025Save(event) {
}

function btnClose_Click(event) {

}

function sendDataFilter() {
    var data = {};
    data.APK = $('#APK').val();
    return data;
}

function showPopup(id) {
    var voucherNo =  $('#VoucherNo').val();
    var url = '/POS/POSF0024/POSF0026?InventoryID={0}&VoucherNo={1}'.format(id, voucherNo);
    ASOFT.asoftPopup.showIframe(url);
    return false;
}

/**
* Gen rowNumber
*/
function renderNumber(data) {
    return ++rowNumber;
}

function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

function btnClose_Click() {
    //parent.popupClose();    
    window.history.back();
}
