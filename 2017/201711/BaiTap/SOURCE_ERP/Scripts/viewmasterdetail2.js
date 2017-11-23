
var module;
var id;
var table;
var key;
var pk = null;
var urlcontent;
var urldel = $("#urlDel").val();
var urladddetail = "";
var tbIndex = null;
var typeinput = $("#typeinput").val();

$(document).ready(function () {

    var tableChildren = $(".tableChildren");
         
    for (var i = 0; i < tableChildren.length; i++) {
        var idTb = $(tableChildren[i]).val();
        $("#tb_" + idTb + " .k-link").before($("#tb_" + idTb + " .asf-panel-view-detail"));
        $("#toolBar" + idTb + " .asf-icon-32").css("padding", "0");
        $("#toolBar" + idTb + " ul li").css("margin-right", "6px");
    }

    if ($(".DivisionID").text() == "@@@") {
        $(".DivisionID").css("text-indent", "-1000px");
    }

    module = $("#Module").val();
    id = $("#sysScreenID").val();
    table = $("#sysTable").val();
    key = $("#Key").val();
    pk = $("#PK").val();
    urlcontent = "/Contentmaster/Index/" + module + "/" + $("#ParentID").val();
});

function ReadTK() {
    //Đọc lưới
    var tbch = this.url.split('?')[1].split('=')[1];
    var pkch = $("#" + tbch).val();
    var dttPK = 7;
    var key = Array();
    var value = Array();
    var dtt = Array();

    key.push(pkch, tbch);
    value.push(pk);
    dtt.push(dttPK);

    var datamaster = {};
    datamaster["args.key"] = key;
    datamaster["args.value"] = value;
    datamaster["args.dttype"] = dtt;
    datamaster["args.ftype"] = ["1"];

    var systemInfo = Array();
    systemInfo.push("");
    systemInfo.push($("#Module").val());
    systemInfo.push($("#sysTable").val());
    systemInfo.push($("#sysScreenID").val());
    systemInfo.push($("#DivisionIDMaster").val());
    datamaster["args.systemInfo"] = systemInfo;
    if (typeof CustomRead === 'function') {
        datamaster["args.custormer"] = CustomRead();
    }

    return datamaster;
}


function BtnDelete_Click() {
    var args = [];
    var list = [];
    ASOFT.form.clearMessageBox();
    pk = pk + "," + $(".DivisionID").text() + "," + $("." + $("#RefLink").val()).text();

    if (typeof DeleteViewMasterDetail2 === "function") {
        pk = DeleteViewMasterDetail2(pk);
    }

    args.push(pk);
    list.push(table, key);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });

}

function deleteSuccess(result) {
    //var Message = result.MessageID;
    //ASOFT.form.displayMultiMessageBox('contentMaster', result.status, ASOFT.helper.getMessage(Message));
    ASOFT.helper.showErrorSeverOption(1, result, "contentMaster", function () {
        //Chuyển hướng hoặc refresh data
        if (urlcontent) {
            window.location.href = urlcontent; // redirect index
        }
    }, null, null, true, false, "contentMaster");
};

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};

function BtnEdit_Click() {
    ASOFT.form.clearMessageBox();
    var urlEdit = $("#urlEdit").val();
    if ($(".DivisionID").text() != undefined)
        urlEdit = urlEdit + "&DivisionID=" + $(".DivisionID").text();
    if (typeof urlEditCusTom === "function") {
        urlEdit = urlEditCusTom(urlEdit);
    }
    ASOFT.asoftPopup.showIframe(urlEdit, {});
}

function ReloadPage() {
    location.reload();
}


function GetUrlContentMaster() {
    return $("#urlParentContent").val();
}

function panalSelect_Click(e) {
    var idPanal = e.sender.wrapper.attr('id');
    var tb = idPanal.split('_')[1];
    var gridDT = $("#Grid" + tb).data("kendoGrid");
    var areaChild = $("#mdl" + tb).val();

    if (gridDT == null) {
        var urlGrid = "/GridCommon/GridCommon/";
        var Scr = $("#src" + tb).val();
        if (Scr == "") {
            urlGrid = urlGrid + "?module=" + module + "&id=" + id + "&table=" + tb;
        }
        else {
            urlGrid = urlGrid + "?module=" + areaChild + "&id=" + Scr + "&table=" + tb + "&child=" + Scr + "&typeinput=" + $("#typeinput").val();
        }

        ASOFT.helper.postTypeJson(urlGrid, {}, function (result) {
            $("#" + idPanal + "-1").find('.asf-master-content').append(result);
            $("#" + idPanal + "-1 .asf-master-content").find(".k-pager-nav").css("width", "2em");

            var keyPK = $("#" + tb + "keyPK").val(); //Khóa chính
            var type = $("#" + tb + "type").val(); //Loại màn hình cha
            var url = $("#" + tb + "url").val();

            gridDT = $("#Grid" + tb).data("kendoGrid");
            gridDT.bind('dataBound', initGridLinkEvent);
            function initGridLinkEvent() {
                var lengthGrid = $("#Grid" + tb).data("kendoGrid").dataSource.data().length > 0 ? $("#Grid" + tb).data("kendoGrid").dataSource.data()[0]["TotalRow"] : 0;
                if (lengthGrid == 0) {
                    $("#Grid" + tb).attr("style", "height:auto;");
                    $("#Grid" + tb).find(".k-grid-content").attr("style", "height:auto;");
                }

                if (lengthGrid < 6 && lengthGrid > 0) {
                    $("#Grid" + tb).attr("style", "height:auto;");
                    $("#Grid" + tb).find(".k-grid-content").attr("style", "height:auto;");
                }

                if (lengthGrid > 5) {
                    $("#Grid" + tb).attr("style", "height:300px;");
                    $("#Grid" + tb).find(".k-grid-content").attr("style", "height:232px;");
                }

                if (lengthGrid < 11) {
                    $("#Grid" + tb).find(".k-pager-wrap").css("display", "none");
                }
                else {
                    $("#Grid" + tb).find(".k-pager-wrap").css("display", "inherit");
                }

                $("#Grid" + tb + ' .asf-grid-link').on('click', function (e) {
                    if (type != "2") {
                        if (url.indexOf('?') == -1) {
                            var data = {},
                            pk = $(e.target).attr('data-pk'),
                            urldt = (url + '?PK={0}&Table={1}&key={2}&PKParent={3}').format(pk, value, keyPK, $("#PK").val());

                            ASOFT.asoftPopup.showIframe(urldt, data);
                        }
                        else {
                                url = $(e.target).attr('data-url');
                                ASOFT.asoftPopup.showIframe(url, {});
                        }
                    }
                });
            }

            if (typeof CustomizePanalSelect === "function") {
                CustomizePanalSelect(tb, gridDT);
            }
        });
    }
}

function AddDetail_Click() {
    var idBtn = $(this)[0].wrapper.attr('id');
    var screenID = idBtn.split('_')[1];
    var tb = idBtn.split('_')[2];

    var urladddetail1 = $("#" + tb + "urladddetail").val() + "/" + module + "/" + screenID + "?PKParent=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urladddetail1, {});
}

function DeleteDetail_Click() {
    var idBtn = $(this)[0].wrapper.attr('id');
    var screenID = idBtn.split('_')[1];
    var tb = idBtn.split('_')[2];
    var pkChild = $("#PKChild" + tb).val();
    var sysBussiness = $("#sysBusiness" + tb).val();
    var areaChild = $("#mdl" + tb).val();
    var refLink = $("#refLink" + tb).val();
    tbIndex = tb;

    var urldelete = "/GridCommon/DeleteViewMaster2/" + areaChild + "/" + screenID + "?ParentSrc=" + id + "&Type=" + sysBussiness + "&TbParent=" + table;

    var GirdDetail = $("#Grid" + tb).data("kendoGrid");
    if (GirdDetail == null)
    {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }

    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GirdDetail);
    if (records.length == 0) return;

    var args = [];
    var key = [];
    var history = [];

    if (typeof CustomDeleteDetail == "function") {
        args = CustomDeleteDetail(records);
    }
    else {
        for (var i = 0; i < records.length; i++) {
            var valuepk = records[i][pkChild] + ",";
            if ($(".DivisionID").text() != undefined) {
                valuepk = valuepk + $(".DivisionID").text();
            }
            if (records[i][refLink] != undefined) {
                history.push(records[i][refLink]);
            }
            args.push(valuepk);
        }
    }
    key.push(tb, pkChild, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson3(urldelete, { cl: key, dt: args, historyDelete: history }, deleteDetailSuccess);
    });
}

function deleteDetailSuccess(result) {
    ASOFT.helper.showErrorSeverOption(1, result, "contentMaster", function () {
        var GirdDetail = $("#Grid" + tbIndex).data("kendoGrid");
        //Chuyển hướng hoặc refresh data
        if (GirdDetail) {
            GirdDetail.dataSource.page(1); // Refresh grid 
        }
        var GridHistory = $("#GridCRMT00003").data("kendoGrid");
        if (GridHistory) {
            GridHistory.dataSource.page(1); // Refresh grid 
        }

    }, null, null, true, false, "contentMaster");

}

function BtnPrint_Click() {
    if (typeof CustomerPrint === "function")
    {
        CustomerPrint();
    }
}

function DeleteCMNF9005_Click() {
    var GirdDetail = $("#GridCMNT90051").data("kendoGrid");
    ASOFT.form.clearMessageBox();
    if (GirdDetail == null) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }
    var records = ASOFT.asoftGrid.selectedRecords(GirdDetail);
    if (records.length == 0) return;
    tbIndex = "CMNT90051";
    var urldelete = "/SendMail/Delete";
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(urldelete, records, deleteDetailSuccess);
    });
}

function DeleteCMNF9006_Click() {
    var GirdDetail = $("#GridCRMT00002").data("kendoGrid");
    ASOFT.form.clearMessageBox();
    if (GirdDetail == null) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }
    var records = ASOFT.asoftGrid.selectedRecords(GirdDetail);
    if (records.length == 0) return;
    tbIndex = "CRMT00002";
    var urldelete = "/AttachFile/Delete";
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(urldelete, records, deleteDetailSuccess);
    });
}

function refreshGrid(tb) {
    Grid = $('#Grid' + tb).data('kendoGrid');
    if (Grid != null) {
        Grid.dataSource.page(1);
    }
    var GridHistory = $("#GridCRMT00003").data("kendoGrid");
    if (GridHistory) {
        GridHistory.dataSource.page(1); // Refresh grid 
    }
};

function parseDate(data) {
    if (data != "" && data != null) {
        if (data.indexOf("Date") != -1) {
            var str = kendo.toString(kendo.parseDate(data), "dd/MM/yyyy hh:mm:ss");
            return str;
        }
        else {
            return data;
        }
    }
    return null;
}


function BtnChoose_Click() {
    var idBtn = $(this)[0].wrapper.attr('id');
    var tb = idBtn.split('_')[2];
    if (typeof BtnChoose_Custom === "function")
    {
        BtnChoose_Custom(tb);
    }
}

function GetTableParent() {
    return { TBParent : table, VLParent: $("#PK").val() };
}


function genLanguageHistory(e) {
    var str;
    ASOFT.helper.postTypeJson('/GridCommon/GenHistory', { args: e }, function (result) {
        str = result;
    });
    return str;
}

function nofunction() { }
