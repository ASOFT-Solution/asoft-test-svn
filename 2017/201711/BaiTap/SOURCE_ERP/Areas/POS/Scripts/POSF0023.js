//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################

$(document).ready(function () {

});
/**
* Xử lý sự kiện click vào Mã voucher
*/
function voucherDetail_Click(e) {
    var data = {};
    ASOFT.asoftPopup.showIframe("/POS/POSF0023/POSF00231", data);
    return false;
}

/**
* Đóng popup
*/
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

