var chooSe = null;
var businessAreaALL = null;
var isCAFEPopup = null;

function popupClose1() {
    parent.popupClose1();
}

$(document).ready(function () {
    $(".list").click(function () {
        $(".list-industry").css("background-color", "");
        $(this).parent().css("background-color", "#ddd");
    })
})

function db_Click(businessArea, isCAFE) {
    var url = '';
    if (isCAFE) {
        url = kendo.format('/POS/POSF0010/POSF00101?FormStatus=1&businessArea={0}', businessArea);
    }
    else {
        url = kendo.format('/POS/POSF0010/POSF0068?FormStatus=1&businessArea={0}', businessArea);
    }

    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});

    return false;
}

function img_Click(businessArea, isCAFE) {
    isCAFEPopup = isCAFE;
    businessAreaALL = businessArea;
}

function btnChoose_Click() {
    db_Click(businessAreaALL, isCAFEPopup);
}