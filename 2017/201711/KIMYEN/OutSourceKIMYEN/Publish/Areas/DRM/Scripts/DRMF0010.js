// Document ready
$(document).ready(function () {
    DRMF0010Popup = ASOFT.asoftPopup.castName("DRMF0010Popup");
    //MTF0010Popup.bind("refresh", function () {
    //    comboPeriod = ASOFT.asoftComboBox.castName("Period");
    //    comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
    //    var title = '';
    //    title = $("#mtf0020Title").val();
    //    MTF0010Popup.title(title);
    //});

    $("a#closebook").click(closeBook); 
    $("a#as0001Popup").click(openBook);
    //$("a#mtf0020Popup").click(mtf0020Popup);
});


// Show hide popup
function showPopup(popup, url, data) {
    ASOFT.asoftPopup.show(popup, url, data);
}

function openBook() {
    var data = {};
    var url = $("#UrlUpdateOpenBook").val();
    ASOFT.helper.post(url, data, openCloseBookSuccess);
}

//Khóa sổ kỳ kế toán
function closeBook() {
    DRMF0010Popup.bind("refresh", function () {
        var title = '';
        title = $("#closeBookTitle").val();
        DRMF0010Popup.title(title);
    });

    url = $("#UrlCloseBook").val();
    data = {
        CloseBookFunctionJS: "btnCloseBook",
        CloseFunctionJS: "btnClosePopup"
    };
    showPopup(DRMF0010Popup, url, data);
}

function btnCloseBook() {
    var url = $("#UrlUpdateCloseBook").val();
    var data = ASOFT.helper.getFormData(null, "CloseBook");
    ASOFT.helper.post(url, data, openCloseBookSuccess);
}

function openCloseBookSuccess(result) {
    if (result.Status == 0) {
        if (result.Data) {
            window.location.reload(true);
        }
        else {
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage("A00ML000010"));
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

function btnClosePopup() {
    DRMF0010Popup.close();
}

//Thiết lập hệ thống
//function mtf0020Popup() {
//    url = $("#UrlMtf0020").val();
//    data = {};
//    showPopup(MTF0010Popup, url, data);
//}
