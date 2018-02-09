//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     16/04/2014      Minh Lâm         Khóa sổ/ mở sổ
//####################################################################

var popup = null;// biến cho màn hình popup.
var url = "";
var data = {};

$(document).ready(function () {
      

    popup = ASOFT.asoftPopup.castName("PeriodPopup");
    // Show Popup con POSF0001
    $('#posf0001Popup').on("click", function (e) {
        e.preventDefault();
        ASOFT.asoftPopup.showIframe('/POS/POSF0001', {});
    });

    $('#posf0007Popup').on("click", function (e) {
        e.preventDefault();
        ASOFT.asoftPopup.showIframe('/POS/POSF0007', {});
    });

    // Show Popup con POSF0004
    $('#posf0004Popup').on("click", function (e) {
        e.preventDefault();
        ASOFT.asoftPopup.showIframe('/POS/POSF0004', {});
    });

    // Show Popup con POSF0005
    $('#posf0006Popup').on("click", function (e) {
        e.preventDefault();
        ASOFT.asoftPopup.showIframe('/POS/POSF0006', {});
    });

    // Show Popup con POSF0002 
    $('#posf0002Popup').on("click", function (e) {
        e.preventDefault();
        ASOFT.asoftPopup.showIframe('/POS/POSF0002', {});
    });

    $('#posf0003Popup').on("click", function (e) {
        e.preventDefault();
        ASOFT.asoftPopup.showIframe('/POS/POSF0003', {});
    });

    var closing = $('#Closing').val();
    if (closing == 0) {
        // Show Popup con periodClosePopup
        $('#periodClosePopup').click(closeBook);
    }
    if (closing == 1) {
        // Show Popup con periodOpenPopup
        $('#periodOpenPopup').click(openBook);
    }



});


/**** Begin POSF00000 *****/
/**
* Mở sổ
*/
function openBook() {
    var data = {};
    var url = "/CloseOpenBook/OpenBook";
    ASOFT.helper.post(url, data, openCloseBookSuccess);
}

/**
* Khóa sổ kỳ kế toán
*/
function closeBook() {
    //popup.bind("refresh", function () {
    //    var title = '';
    //    title = $("#closeBookTitle").val();
    //    popup.title(title);
    //});

    url = "/CloseOpenBook";
    data = {
        CloseBookFunctionJS: "btnCloseBook",
        CloseFunctionJS: "btnClosePopup"
    };
    ASOFT.asoftPopup.showIframe(url, {});
    //showPopup(popup, url, data);
}

/**
* Khóa sổ
*/
function btnCloseBook() {
    var url = "/CloseOpenBook/CloseBook";
    var data = ASOFT.helper.getFormData(null, "CloseBook");
    ASOFT.helper.post(url, data, openCloseBookSuccess);
}
/**
* Close popup
*/
function btnClosePopup() {
    popup.close();
}

/**
* show popup
*/
// Show hide popup
function showPopup(sender, url, data) {
    ASOFT.asoftPopup.show(sender, url, data);
}

/**
* Mở/ khóa sổ thành công
*/
function openCloseBookSuccess(result) {
    if (result.Status == 0) {
        if (result.Data) {
            window.location.reload(true);
        }
        else {
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage("00ML000046"));
            window.location.reload(true);
        }
    }
    else {
        if (result.Data) {
            result.Mesage = ASOFT.helper.getMessage("A00ML000009");
        }
        else {
            result.Mesage = ASOFT.helper.getMessage("A00ML000011");
        }
        ASOFT.helper.showErrorSever(result.Mesage);
    }
}


// Lưu thiết lập
function POSF0001Save(event) {
    ASOFT.asoftPopup.hideIframe();
}

// Đóng Popup
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}


/**** End POSF00001 *****/

