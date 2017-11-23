var GridPOST01101 = null;

$(document).ready(function () {
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();
    GridPOST01101 = $("#GridPOST01101").data('kendoGrid');

    $("#btnChoose").unbind();
    $("#btnChoose").kendoButton({
        "click": SaveCustom_Click,
    });
})

function SaveCustom_Click() {
    var checkedRadio = $('input[name=radio-check]:checked');
    if (checkedRadio.length == 0) {
        console.log('NO MEMEBER CHOOSEN');
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));//ASOFT.helper.getMessage("00ML000066"));
    } else {
        var item = {};
        var ListColumn = $("#ListColumn").val();
        ListColumn = ListColumn.split(',');
        for (i = 0; i < ListColumn.length - 1; i++) {
            item[ListColumn[i]] = checkedRadio.attr("radio_" + ListColumn[i]);
        }
        ASOFT.helper.postTypeJson("/POS/POSF00162/GetDataPOST01102", { APK: checkedRadio.attr("radio_apk") }, function (result) {
            window.parent.receiveResultCustom(item, result);
            ASOFT.asoftPopup.closeOnly();
        });
    }
}


function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialFilterPOST01101',
        success: function (result) {
            $(".asf-quick-search-container").before(result);
            BtnFilter_Click();
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
        }
    });
}

function BtnFilter_Click() {
    GridPOST01101.dataSource.page(1);
}