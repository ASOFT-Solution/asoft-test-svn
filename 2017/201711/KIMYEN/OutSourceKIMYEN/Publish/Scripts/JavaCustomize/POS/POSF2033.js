var GridPOST0016 = null;

$(document).ready(function () {
    GridPOST0016 = $("#GridPOST0016").data('kendoGrid');
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();
})


function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialPOST00801?ScreenID=POSF2033',
        success: function (result) {
            $(".asf-quick-search-container").before(result);
            if (typeof parent.getVATObjectID === "function") {
                $("#MemberID").attr("readonly", "readonly");
                $("#MemberID").val(parent.getVATObjectID());
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

function BtnFilter_Click() {
    GridPOST0016.dataSource.page(1);
}
