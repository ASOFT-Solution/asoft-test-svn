//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/12/2015     Quang Hoàng         Tạo mới
//####################################################################


var pkchild = $("#PKIndex").val();
var id = $("#sysScreenID").val();
var tbchild = $("#TBIndex").val();
var scrchild = $("#ScrIndex").val();
var dttype = $("#dtTypeIndex").val();
var module = $("#Module").val();
var table = $("#sysTable").val();
var key = $("#Key").val();
var urlParent;
var pk = $("#PK").val();
var refresh = Array();
var urledit = $("#Edit").val();
var urldel = $("#urldel").val();
var urladddetail = "";
var grid = $('#Grid' + table).data('kendoGrid');
var typeinput = $("#typeinput").val();

$(document).ready(function () {
    urlParent = $("#urlParent").val() + "/Index/" + $("#Module").val() + "/" + $("#ParentID").val();
    //Nếu màn hình chỉnh sửa ở master là popupmaster detail k cho đc chỉnh sửa
    if (scrchild != "" && typeinput == 1) {
        var tbdemo = ASOFT.helper.dataFormToJSON("ScreenID");
        var tableName = [];
        tableName.push(tbdemo["tableName"]);// Lấy tất cả id lưới
        urladddetail = $("#" + tableName[0] + "urladddetail").val(); //get url detail

        //Xử lý click link trên lưới
        $.each(tableName, function (key, value) {
            var keyPK = $("#" + value + "keyPK").val(); //Khóa chính
            var type = $("#" + value + "type").val(); //Loại màn hình cha
            var idgrid = "#Grid" + value; // ID lưới
            var url = $("#" + value + "url").val(); //
            var grid = $(idgrid).data('kendoGrid');
            grid.bind('dataBound', initGridLinkEvent);
            function initGridLinkEvent() {
                $(idgrid + ' .asf-grid-link').on('click', function (e) {
                    if (type != "2") {
                        var data = {},
						pk = $(e.target).attr('data-pk'),
						urldt = (url + '?PK={0}&Table={1}&key={2}&PKParent={3}').format(pk, value, keyPK, $("#PK").val());

                        ASOFT.asoftPopup.showIframe(urldt, data);
                    }
                });
            }
        });
    }
    $(window).bind('beforeunload', function () {
        for (i = 0; i < refresh.length ; i++) {
            $("#t" + refresh[i]).val('1');
        }
    });

    //Nếu màn hình chỉnh sửa ở master là popupmaster detail thì detail sẽ k cho đc thêm và xóa
    if (scrchild == "" || typeinput == 2) {
        $("#BtnAddNew .asf-i-add-32").hide();
        $("#BtnDeleteDetail .asf-i-page-delete").hide();
    }
    else {
        $("#BtnAddNew .asf-i-add-32").show();
        $("#BtnDeleteDetail .asf-i-page-delete").show();
    }
});

function Change(e) {
    tbchild = ($(e.item).attr("id"));
    scrchild = ($(e.item).attr("name"));
    pkchild = $("#" + tbchild).val();
    dttype = $("#" + "dttype" + tbchild).val();
    urladddetail = $("#" + tbchild + "urladddetail").val();

    //Nếu màn hình chỉnh sửa ở master là popupmaster detail thì detail sẽ k cho đc thêm và xóa
    if (scrchild == "" || typeinput == 2) {
        $("#BtnAddNew .asf-i-add-32").hide();
        $("#BtnDeleteDetail .asf-i-page-delete").hide();
    }
    else {
        $("#BtnAddNew .asf-i-add-32").show();
        $("#BtnDeleteDetail .asf-i-page-delete").show();
    }

    //Load lại lưới 1 lần duy nhất
    if ($("#t" + tbchild).val() == '1') {
        refreshGrid(tbchild);
        $("#t" + tbchild).val('0');
        refresh.push(tbchild);
    }
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};

function ReadTK() {
    //Đọc lưới
    var pkch = pkchild;
    var tbch = tbchild;
    var dttPK = dttype;
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

function refreshGrid(tb) {
    Grid = $('#Grid' + tb).data('kendoGrid');
    Grid.dataSource.page(1);
};

function EditMaster_Click() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urledit, {});
}

function DeleteMaster_Click() {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        var data = [];
        var data1 = [];
        if (typeof DeleteViewMasterDetail === "function") {
            pk = DeleteViewMasterDetail(pk);
        }
        else {
            if ($("#DivisionIDMaster").val() !== undefined) {
                pk = pk + "," + $("#DivisionIDMaster").val();
            }
        }
        data.push(table, key);
        data1.push(pk);
        ASOFT.helper.postTypeJson1(urldel, data, data1, deleteSuccess);
    });
}

function deleteSuccess(result) {

    ASOFT.helper.showErrorSeverOption(1, result, "mtf1042-viewmastercontent", function () {

        //Chuyển hướng hoặc refresh data
        if (urlParent) {
            window.location.href = urlParent; // redirect index
        }
    }, null, null, true, false, "mtf1042-viewmastercontent");
    if (grid) {
        grid.dataSource.page(1);
    }
}

function AddDetail_Click() {
    var urladddetail1 = urladddetail + "/" + module + "/" + scrchild + "?PKParent=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urladddetail1, {});
}

function ReloadPage() {
    location.reload();
}

function DeleteDetail_Click() {
    var urldelete = "/GridCommon/Delete/" + module + "/" + scrchild + "?ParentSrc=" + id;
    if (urldel.toUpperCase().indexOf('DELETEBUSSINESS') != -1) {
        urldelete = "/GridCommon/DeleteBussiness/" + module + "/" + scrchild + "?ParentSrc=" + id;
    }
    var GirdDetail = $("#Grid" + tbchild).data("kendoGrid");
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GirdDetail);
    if (records.length == 0) return;

    var args = [];
    var key = [];

    if (typeof CustomDeleteDetail == "function") {
        args = CustomDeleteDetail(records);
    }
    else {
        for (var i = 0; i < records.length; i++) {
            var valuepk = records[i][pk] + ",";
            if (records[i]["DivisionID"] != undefined) {
                valuepk = valuepk + records[i]["DivisionID"];
            }
            args.push(valuepk);
        }
    }
    key.push(tbchild, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldelete, key, args, deleteDetailSuccess);
    });
}


function deleteDetailSuccess(result) {
    ASOFT.helper.showErrorSeverOption(1, result, "mtf1042-viewmastercontent", function () {
        var GirdDetail = $("#Grid" + tbchild).data("kendoGrid");
        //Chuyển hướng hoặc refresh data
        if (GirdDetail) {
            GirdDetail.dataSource.page(1); // Refresh grid 
        }
    }, null, null, true, false, "mtf1042-viewmastercontent");

}


function GetUrlContentMaster() {
    return urlParent;
}



function BtnPrint_Click() {
    if (typeof PrintClick === "function") {
        PrintClick();
    }
}


function GetUrlViewMasterDetail() {
    return $("#urlParentContent").val();
}

function parseDate(data) {
    //var rtur = kendo.toString(kendo.parseDate(data), "dd/MM/yyyy");
    //if (rtur != null)
    //    return rtur;
    if (data) {
        data = data.split(" ")[0];
        var day = data.split('/')[0];
        var month = data.split('/')[1];
        var year = data.split('/')[2];
        var date = year + '-' + month + '-' + day;
        return kendo.toString(kendo.parseDate(date), "dd/MM/yyyy");
    }
    else {
        return kendo.toString('');
    }
}
