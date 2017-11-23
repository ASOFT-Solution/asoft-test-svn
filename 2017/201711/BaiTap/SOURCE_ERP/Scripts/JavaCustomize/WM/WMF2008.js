//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/01/2017      Văn Tài          Tạo mới
//####################################################################


$(document).ready(function () {
    // Xử lý khi popup hoàn thành hiển thị
    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            WMF2008.btnCancle = $("#" + WMF2008.BUTTON_CANCEL);
            if (WMF2008.btnCancle) {
                WMF2008.btnCancle.unbind('click');
                WMF2008.btnCancle.bind('click', WMF2008.btnCancle_OnClick);
            }
        }
    })
});

WMF2008 = new function () {
    this.BUTTON_CANCEL = "btnCancel";

    this.btnCancle = null;

    this.btnCancle_OnClick = function () {
        window.parent.receiveCancle();
        ASOFT.asoftPopup.closeOnly();
    }
}