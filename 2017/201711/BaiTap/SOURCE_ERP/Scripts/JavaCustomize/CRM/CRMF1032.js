var length = null;

$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();

    var btnToolbar = '<div class="asf-panel-view-detail" id="toolBarCRMT20301"><div class="asfbtn asfbtn-right-3"><ul class="asf-toolbar"><li style="margin-right: 10px;"><a class="asfbtn-item-32  k-button k-button-icon" id="BtnSearch_CRMF9016" style="" title="Kế thừa" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="k-sprite asf-icon asf-icon-32 asf-i-search-24" style="padding: 0px;"></span></a></li><li style="margin-right: 6px;"><a class="asfbtn-item-32  k-button k-button-icon" id="BtnDeleteDetail_CRMF9016" style="" title="Xóa" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="k-sprite asf-icon asf-icon-32 asf-i-page-delete" style="padding: 0px;"></span></a></li></ul></div></div>';

    $("#tb_CRMT20301").before(btnToolbar);

    $("#BtnDeleteDetail_CRMF9016").kendoButton({
        "click": CustomDeleteDetail_Click,
    });

    $("#BtnSearch_CRMF9016").kendoButton({
        "click": CustomAddDetail_Click,
    });

    $("#BtnDeleteDetail").unbind();
    $("#BtnDeleteDetail").kendoButton({
        "click": customDelete_Click
    });

    $(".content-label").css({
        "width":"40%"
    });
});

function CustomizePanalSelect(tb, gridDT) { //Hoán đổi vị trí cột STT và cột check
    if (tb == "CRMT20301") {
        gridDT.reorderColumn(0, gridDT.columns[1]);
    }
}

function customDelete_Click() {
    var args = [],
        list = [],
        requestID = $(".GroupReceiverID ").text();
    ASOFT.form.clearMessageBox();
    pk = pk + "," + $(".DivisionID").text();

    if (typeof DeleteViewMasterDetail2 === "function") {
        pk = DeleteViewMasterDetail2(pk);
    }
    args.push(pk);
    list.push(table, key);
    args.push(requestID);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });

}

function receiveResult(result) {
    length = result.length;
    for (var i = 0; i < result.length; i++) {
        var data = [];
        data.push($("#PK").val())
        data.push(result[i]["APK"])
        data.push(result[i]["RelatedToTypeID"])
        data.push(result[i]["ReceiverID"])
        ASOFT.helper.postTypeJson("/CRM/CRMF1030/InsertReceiver", data, function () {
            if (i == length - 1)
                deleteDetailSuccessCustom();
        });
    }
}

function CustomAddDetail_Click() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CRM/CRMF9016?Type=1&DivisionID=" + $("#DivisionIDMaster").val(), {});
};

function CustomDeleteDetail_Click() {
    var GridKendo = $('#GridCRMT20301').data('kendoGrid');

    if (GridKendo == null) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    records[0].PKParent = $("#PK").val();

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson("/CRM/CRMF1030/DeleteReceiver", records, deleteDetailSuccessCustom);
    });
};

function deleteDetailSuccessCustom(result) {
    refreshGrid("CRMT20301");
};


function DeleteViewMasterDetail2(pk) {
    pk = $(".GroupReceiverID").text();
    return pk;
}


function genPopupLink(e) {
    var row = $(e).parent().closest('tr');
    var selectitem = $('#GridCRMT20301').data('kendoGrid').dataItem(row);

    var urlCus = "/PopupLayout/Index/CRM/";
    if (selectitem.RelatedToTypeID == 1)
    {
        urlCus = urlCus + "CRMF2031?PK=" + selectitem.RelatedToID + "&Table=CRMT20301&key=APK"
    }
    if (selectitem.RelatedToTypeID == 2) {
        urlCus = urlCus + "CRMF1001?PK=" + selectitem.RelatedToID + "&Table=CRMT10001&key=APK&DivisionID=" + selectitem.DivisionID;
    }
    if (selectitem.RelatedToTypeID == 3) {
        urlCus = urlCus + "CRMF1011?PK=" + selectitem.RelatedToID + "&Table=CRMT10101&key=APK"
    }
    ASOFT.asoftPopup.showIframe(urlCus, {});
}
