//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     02/04/2014      Chánh Thi         Tạo mới
//####################################################################

$(document).ready(function () {

});

/**
* Đóng popup
*/
function popupClose(event) {
    parent.popupClose(event);
}

function filterData() {
    var data = {};
    var inventoryID = $('#InventoryID').val();
    if (ASOFTVIEW.helpers.isNullEmptyWhiteSpace(inventoryID)) {
        return false;
    }
    data['InventoryID'] = inventoryID;
    return data;
}