var GridPOST2013_VT = null;

function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialFilterPOST0016',
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

        if (typeof window.parent.receiveResultInheritedDeposit === "function") {
            window.parent.receiveResultInheritedDeposit({
                Inherit: true,
                data: item
            });

            ASOFT.asoftPopup.closeOnly();
        }
    }
}

$(document).ready(function () {
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();
    GridPOST2013_VT = $("#GridPOST2013_VT").data('kendoGrid');

    $("#btnChoose").unbind();
    $("#btnChoose").kendoButton({
        "click": SaveCustom_Click,
    });
});


function BtnFilter_Click() {
    GridPOST2013_VT.dataSource.page(1);
}
