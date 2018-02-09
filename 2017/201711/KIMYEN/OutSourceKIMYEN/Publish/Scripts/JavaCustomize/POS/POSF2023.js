var GridPOST00801 = null;

$(document).ready(function () {
    GridPOST00801 = $("#GridPOST00801").data('kendoGrid');
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();

    $("#btnChoose").unbind();
    $("#btnChoose").kendoButton({
        "click": btnChooseCustom_Click
    });
})


function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialPOST00801?ScreenID=POSF2023',
        success: function (result) {
            $(".asf-quick-search-container").before(result);

            if (typeof parent.getMemberID === "function") {
                //$("#MemberID").attr("readonly", "readonly");
                $("#MemberID").val(parent.getMemberID());
            }
            setTimeout(function () {
                BtnFilter_Click();
            }, 200);

            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
        }
    });
}

function btnChooseCustom_Click() {
    var records = ASOFT.asoftGrid.selectedRecords(GridPOST00801);
    for (var i = 0; i < records.length; i++)
    {
        for (var j = 0; j < records.length; j++) {
            if (records[i].MemberID != records[j].MemberID) {
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('POSFML000105'));
                return false;
            }
        }
    }
    btnChoose_Click();
}

function BtnFilter_Click() {
    GridPOST00801.dataSource.page(1);
}
