// Document ready
$(document).ready(function () {
    MTF0010Popup = ASOFT.asoftPopup.castName("MTF0010Popup");
    MTF0090Popup = ASOFT.asoftPopup.castName("MTF0090Popup");

    MTF0010Popup.bind("refresh", function () {//Event popup loaded
        comboPeriod = ASOFT.asoftComboBox.castName("Period");
        comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");

        //Set title for popup
        var title = '';
        title = $("#mtf0020Title").val() ? $("#mtf0020Title").val() : $("#mtf0090Title").val();
        MTF0010Popup.title(title);
    });

    MTF0010Popup.bind("close", function () {
        $("#MTF0010Popup").html('');
    });

    $("a#mtf0040Popup").click(closeBook); 
    $("a#as0001Popup").click(openBook);
    $("a#mtf0020Popup").click(mtf0020Popup);
    $("a#mtf0090Popup").click(mtf0090Popup);
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
    //MTF0010Popup.bind("refresh", function () {
    //    var title = '';
    //    title = $("#closeBookTitle").val();
    //    MTF0010Popup.title(title);
    //});

    url = $("#UrlCloseBook").val();
    data = {
        CloseBookFunctionJS: "btnCloseBook",
        CloseFunctionJS: "btnClosePopup"
    };

    ASOFT.asoftPopup.showIframe(url, {});
    //showPopup(MTF0010Popup, url, data);
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
    MTF0010Popup.close();
}

//Thiết lập hệ thống
function mtf0020Popup() {
    url = $("#UrlMtf0020").val();
    data = {};
    showPopup(MTF0010Popup, url, data);
}

//Thiết lập hệ thống
function mtf0090Popup() {
    url = $("#UrlMtf0090").val();
    data = {};
    showPopup(MTF0090Popup, url, data);
}


//function btnSaveSystem(e) {
//    if (ASOFT.form.checkRequired("MTF0020")) {
//        return;
//    }

//    //Lấy tháng và năm của kỳ kế toán từ combo kỳ kế toán
//    //comboPeriod = ASOFT.asoftComboBox.castName("Period");
//    dataPeriod = comboPeriod.dataItem(comboPeriod.selectedIndex);

//    if (dataPeriod == undefined) {
//        ASOFT.form.displayMessageBox("form#MTF0020", [ASOFT.helper.getMessage("A00ML000012")], null);
//        return;
//    }

//    var url = $('#UrlMtf0020Update').val();
//    var data = ASOFT.helper.getFormData(null, "MTF0020");
//    data.push({ name: "TranMonth", value: dataPeriod.TranMonth });
//    data.push({ name: "TranYear", value: dataPeriod.TranYear });
//    ASOFT.helper.post(url, data, mtf0020SaveSuccess);
//}

////Đóng popup
//function btnCloseSystemPopup() {
//    MTF0010Popup.close();
//}

//function mtf0020SaveSuccess(result) {
//    if (result.Status == 0) {
//        MTF0010Popup.close();
//        window.location.reload(true);
//    }
//    else {
//        result.Mesage = [ASOFT.helper.getMessage("A00ML000013")];
//        ASOFT.helper.showErrorSever(result.Mesage, "MTF0020");
//    }
//}