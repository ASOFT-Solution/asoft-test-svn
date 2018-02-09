$(document).ready(function () {
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": customDelete_Click
    });
   
    $(".RelatedToTypeID").text(31);

});

function customDelete_Click() {
    var args = [],
        list = [];

    ASOFT.form.clearMessageBox();

    if (typeof DeleteViewMasterDetail2 === "function") {
        pk = DeleteViewMasterDetail2(pk);
    }

    pk = pk + "," + $(".DivisionID").text();


    args.push(pk);

    list.push(table, key);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });

}