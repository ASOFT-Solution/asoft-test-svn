//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     13/07/2014      Thai Son        Tạo mới
//####################################################################
$(document).ready(function () {
    $('#btnClose').on('click', ASOFT.asoftPopup.closeOnly);
});
var rowNumber = 0;

function SendDataMaster() {
    var apk = window.parent
            && window.parent.posViewModel
            && window.parent.posViewModel.TempAPKMaster;
    if (apk) {
        return { apk: apk };
    }
    return {};
}

/**
* Gen rowNumber
*/
function renderNumber(data) {
    return ++rowNumber;
}