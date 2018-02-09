
var module;
var id;
var table;
var key;
var pk;
var urldel = "/GridCommon/Delete/" + module + "/" + id;
var urlcontent;
$(document).ready(function () {
    if ($(".DivisionID").text() == "@@@") {
        $(".DivisionID").css("text-indent", "-1000px");
    }

    module = $("#Module").val();
    id = $("#sysScreenID").val();
    table = $("#sysTable").val();
    key = $("#Key").val();
    pk = $("#PK").val();
    urldel = "/GridCommon/Delete/" + module + "/" + id;
    urlcontent = "/Contentmaster/Index/" + module + "/" + $("#ParentID").val();
});

function BtnEdit_Click() {
    ASOFT.form.clearMessageBox();
    var urlEdit = $("#urlEdit").val();
    if ($(".DivisionID").text() != undefined)
        urlEdit = urlEdit + "&DivisionID=" + $(".DivisionID").text();
    if (typeof urlEditCusTom === "function")
    {
        urlEdit = urlEditCusTom(urlEdit);
    }
    ASOFT.asoftPopup.showIframe(urlEdit, {});
}

function BtnDelete_Click() {
    var args = [];
    var list = [];
    ASOFT.form.clearMessageBox();

    if (typeof DeleteViewNoDetail === "function")
    {
        pk = DeleteViewNoDetail(pk);
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
//function refreshGrid(tb) {
//    Grid = $('#Grid' + tb).data('kendoGrid');
//    Grid.dataSource.page(1);
//};

function ReloadPage() {
    location.reload();
}

function GetUrlContentMaster() {
    return $("#urlParentContent").val();
}