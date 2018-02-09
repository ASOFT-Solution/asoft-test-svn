//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/03/2014      Thai Son        New
//####################################################################



$(document).ready(function () {
    // Đặt tooltip cho các control (Thông tin chỉ được đọc, không được sửa)
    $('input').attr('title', ASOFT.helper.getMessage('POSM000029'))
});

var closeWindow = function () {
    if (window.parent.popupClose
                    && typeof (window.parent.popupClose) === 'function') {
        window.parent.popupClose();
    }
};

function btnClose_Click() {
    closeWindow();
}


function test() {
    var items = function () {
        data = [];
        this.add = function (id, url, routeData) {
            data.push({
                id: id,
                url: url,
                routeData: routeData
            });
        };
    }

    items.add('#posf0001Popup', '/POS/POSF0001');
    items.add('#posf0002Popup', '/POS/POSF0002');
    items.add('#posf0003Popup', '/POS/POSF0003');
    items.add('#posf0006Popup', '/POS/POSF0006');
    items.add('#posf0007Popup', '/POS/POSF0007');


}