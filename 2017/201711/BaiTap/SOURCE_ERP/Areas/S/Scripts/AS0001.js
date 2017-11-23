var MODULE_CI = 'CI';
var MODULE_DRM = 'DRM';
var moduleID = null;

var MODULE = 'S';

// Document ready
$(document).ready(function () {
    AS0001Popup = ASOFT.asoftPopup.castName("AS0001Popup");
   
    //MTF0010Popup.bind("refresh", function () {
    //    comboPeriod = ASOFT.asoftComboBox.castName("Period");
    //    comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
    //    var title = '';
    //    title = $("#mtf0020Title").val();
    //    MTF0010Popup.title(title);
    //});

    $("a#closeBook_CI").click(function () {
        moduleID = MODULE_CI;
        closeBook(moduleID);
    });

    $("a#closeBook_DRM").click(function () {
        moduleID = MODULE_DRM;
        closeBook(moduleID);
    });

    $("a#openBook_CI").click(function () {
        moduleID = MODULE_CI;
        openBook(moduleID);
    });
    $("a#openBook_DRM").click(function () {
        moduleID = MODULE_DRM;
        openBook(moduleID);
    });

    $("a#drf0020Popup").click(function () {
        url = $('#UrlDRF0020').val();
        showDRFPopup(url);
    });

    $("a#drf0060Popup").click(function () {
        url = $('#UrlDRF0060').val();
        showDRFPopup(url);
    });

    $("a#drf0070Popup").click(function () {
        url = $('#UrlDRF0070').val();
        showDRFPopup(url);
    });

    $("a#drf0080Popup").click(function () {
        url = $('#UrlDRF0080').val();
        showDRFPopup(url);
    });

    $("a#drf0090Popup").click(function () {
        url = $('#UrlDRF0090').val();
        showDRFPopup(url);
    });

    $("a#drf0100Popup").click(function () {
        url = $('#UrlDRF0100').val();
        showDRFPopup(url);
    });

    $("a#drf0110Popup").click(function () {
        url = $('#UrlDRF0110').val();
        showDRFPopup(url);
    });

    $("a#drf0120Popup").click(function () {
        url = $('#UrlDRF0120').val();
        showDRFPopup(url);
    });

    $("a#drf0160Popup").click(function () {
        url = $('#UrlDRF0160').val();
        showDRFPopup(url);
    });

    $("a#drf0170Popup").click(function () {
        url = $('#UrlDRF0170').val();
        showDRFPopup(url);
    });

    $("a#drf0180Popup").click(function () {
        url = $('#UrlDRF0180').val();
        showDRFPopup(url);
    });

    $("a#drf0130Popup").click(function () {
        url = $('#UrlDRF0130').val();
        showDRFPopup(url);
    });

    $("a#drf0220Popup").click(function () {
        url = $('#UrlDRF0220').val();
        showDRFPopup(url);
    });

    $("a#drf0230Popup").click(function () {
        url = $('#UrlDRF0230').val();
        showDRFPopup(url);
    });

    $("a#cif0001Popup").click(function () {
        url = $('#UrlCIF0001').val();
        showDRFPopup(url);
    });

    $("a#cif0010Popup").click(function () {
        url = $('#UrlCIF0010').val();
        showDRFPopup(url);
    });

    $("a#cif0020Popup").click(function () {
        url = $('#UrlCIF0020').val();
        showDRFPopup(url);
    });

    $("a#sf0001Popup").click(function () {
        url = $('#UrlSF0001').val();
        showSFPopup(url);
    });

    $("a#sf0002Popup").click(function () {
        url = $('#UrlSF0002').val();
        showSFPopup(url);
    });
    $("a#sf0003Popup").click(function () {
        url = $('#UrlSF0003').val();
        showSFPopup(url);
    });
    $("a#sf0004Popup").click(function () {
        url = $('#UrlSF0004').val();
        showSFPopup(url);
    });
    $("a#sf0006Popup").click(function () {
        url = $('#UrlSF0006').val();
        showSFPopup(url);
    });
    $("a#sf1052Popup").click(function () {
        url = $('#UrlSF1052').val();
        showSFPopup(url);
    });

    $("a#sf1040Popup").click(function () {
        url = $('#UrlSF1040').val();
        window.open(url);
    });
    $("a#sf1050Popup").click(function () {
        url = $('#UrlSF1050').val();
        //window.open(url);
        window.location.href = url;
    });
    // Chốt số liệu chỉ tiêu
    $("a#transactionEnding").click(function () {
        endTransaction();
    });

    $("a#drf0200Popup").click(function () {
        url = $('#UrlDRF0200').val();
        showDRFPopup(url);
    });

    $("a#cif0030Popup").click(function () {
        url = $('#UrlCIF0030').val();
        showSFPopup(url);
    });


    $("a#oof0010Popup").click(function () {
        url = $('#UrlOOF0010').val();
        showSFPopup(url);
    });

    $("a#oof0020Popup").click(function () {
        url = $('#UrlOOF0020').val();
        showSFPopup(url);
    });

    $("a#hf0390Popup").click(function () {
        url = $('#UrlHF0390').val();
        showSFPopup(url);
    });

    $("a#CRMF0000Popup").click(function () {
        url = $("#UrlCRMF0000").val();
        showSFPopup(url);
    });

    $("a#CRMF0001Popup").click(function () {
        url = $("#UrlCRMF0001").val();
        ASOFT.asoftPopup.showIframe(url, {});
    });

    $("a#SOF0000Popup").click(function () {
        url = $("#UrlSOF0000").val();
        showSFPopup(url);
    });

    $("a#cif1330Popup").click(function () {
        url = $("#UrlCIF1330").val();
        showSFPopup(url);
    });

    $("a#cif1340Popup").click(function () {
        url = $("#UrlCIF1340").val();
        showSFPopup(url);
    });

    $("a#sf1000Popup").click(function () {
        url = $("#UrlSF1000").val();
        //showSFPopup(url);
        //window.open(url, '_blank');
        window.location.href = url;
    });
    $("a#sf1010Popup").click(function () {
        url = $("#UrlSF1010").val();
        //showSFPopup(url);
        //window.open(url, '_blank');
        window.location.href = url;
    });

    //POS
    $("a#posf0007Popup").click(function () {
        url = $("#UrlPOSF0007").val();
        showSFPopup(url);
    });
    $("a#posf0001Popup").click(function () {
        url = $("#UrlPOSF0001").val();
        showSFPopup(url);
    });
    $("a#posf0006Popup").click(function () {
        url = $("#UrlPOSF0006").val();
        showSFPopup(url);
    });
    $("a#posf0003Popup").click(function () {
        url = $("#UrlPOSF0003").val();
        showSFPopup(url);
    });
    $("a#posf0004Popup").click(function () {
        url = $("#UrlPOSF0004").val();
        //showSFPopup(url);
        window.open(url, '_blank');
    });

    $("a#pof0001Popup").click(function () {
        url = $("#UrlPOF0001").val();
        showSFPopup(url);
    });
});
function showSFPopup(url) {
    var data = {};
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
};
function showDRFPopup(url) {
    var data = {};
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
};

// Show hide popup
function showPopup(popup, url, data) {
    //ASOFT.asoftPopup.show(popup, url, data);

    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

function openBook(moduleID) {
    var data = {
        ModuleID: moduleID
    };
    var url = $("#UrlUpdateOpenBook").val();
    ASOFT.helper.post(url, data, openCloseBookSuccess);
}

//Khóa sổ kỳ kế toán
function closeBook(moduleID) {
    //AS0001Popup.bind("refresh", function () {
    //    var title = '';
    //    title = $("#closeBookTitle").val();
    //    AS0001Popup.title(title);
    //});

    url = $("#UrlCloseBook").val();
    data = {
        ModuleID: moduleID,
        CloseBookFunctionJS: "btnCloseBook",
        CloseFunctionJS: "btnClosePopup"
    };
    showPopup(AS0001Popup, url, data);
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
            result.MessageID = ASOFT.helper.getMessage("A00ML000009");
        }
        else {
            if (result.MessageID == '' || result.MessageID == null) {
                result.MessageID = ASOFT.helper.getMessage("A00ML000011");
            }
            else {
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage(result.MessageID));
                return;
            }
        }
        ASOFT.helper.showErrorSever(result.MessageID);
    }
}

function btnClosePopup() {
    AS0001Popup.close();
}


// Chốt số liệu
// TransactionEnding click
function endTransaction() {
    var url = $("#UrlEndTransaction").val();
    ASOFT.helper.post(url, {}, endTransactionSuccess);
}

function endTransactionSuccess(result) {
    if (result.Status == 0) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage("DRFML000027"));
    }
}

//Thiết lập hệ thống
//function mtf0020Popup() {
//    url = $("#UrlMtf0020").val();
//    data = {};
//    showPopup(MTF0010Popup, url, data);
//}


function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}