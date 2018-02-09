
$(document).ready(function () {
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
    if ($(".Percentage").text() != "") {
        $(".Percentage").text(formatPercent(kendo.parseFloat($(".Percentage").text())));
    }
});
function formatPercent(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    args.push($(".TargetsDictionaryID").text());
    key.push(table, "TargetsDictionaryID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, key, args, deleteSuccess);
    });
}
