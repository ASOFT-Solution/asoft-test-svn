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
* Đóng popup
*/
function popupClose(event) {
    parent.popupClose(event);
}
/**
* Xử lý sự kiện click vào nút kế thừa
*/
function inherit_Click(e) {
    var data = {};
    ASOFT.asoftPopup.showIframe("/POS/POSF00152", data);
    return false;
}
/**
* Đóng popup
*/
function InheritPopupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}
