



$(document).ready(function () {
    $(".VoucherTypeID").parent().prepend($(".VoucherNo"));
    $(".VoucherTypeID").parent().prepend($(".ObjectName"));
    $(".IsConfirm").parent().prepend($(".EmployeeID"));
    
    //var Account = "";
    //var urlpp = window.location.href;
    //urlpp = urlpp.split('?')[1];
    //if (urlpp !== undefined) {
    //    Account = urlpp.split('=')[1];
    //}

    //if (Account != null && Account != "") {
    //    var dropdownlist = $("#CheckListPeriodControl").data("kendoDropDownList");
    //    dropdownlist.dataSource.read();
    //    var listDrop = dropdownlist.options.dataSource;
    //    $($(dropdownlist.list.find('li')[0])).trigger("click");

    //    $("#rdoFilterPeriod").trigger('click');
    //    setTimeout(function () {
    //        refreshGrid();
    //    }, 200)
    //}

    //var btnAddCommit = '<li><a class="k-button k-button-icontext asf-button" id="BtnAddCommit" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="btnAddCommit_Click()"><span class="asf-button-text">Giao hộ</span></a></li>';

    //$(".asf-toolbar").append(btnAddCommit);
})

function onAfterFilter() {
    if ($("#Top_SOF2000").val() == "1")
    {
        $("#Top_SOF2000").val(0)
    }
}

function btnAddCommit_Click(t) {
    if ($(t).attr("aria-disabled") == "true") {
        return;
    }
    var apk = $(t).attr("value");
    var divisionID = $(t).attr("attr-divisionID");
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe("/PopupMasterDetail/Index/SO/SOF2001?PK=" + apk + "&DivisionID=" + divisionID, {});
}


function genCoordi(data) {
    if (data && data.AddCommit != null) {
        if (data.AddCommit == "1") {
            return "k-button k-button-icontext asf-button k-state-disabled";
        }
        return "k-button k-button-icontext asf-button";
    }
    return "k-button k-button-icontext asf-button k-state-disabled";
}

function genCoordiEvent(data) {
    if (data && data.AddCommit != null) {
        if (data.AddCommit == "1") {
            return true;
        }
        return false;
    }
    return false;
}