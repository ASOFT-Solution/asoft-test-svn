$(document).ready(function () {
   var grid6First = $(".grid_6")[0];
    $(grid6First).removeClass("grid_6").addClass("grid_12");
    $(".IsCommon").appendTo($(grid6First).find("table"));
    $(".Disabled").appendTo($(grid6First).find("table"));

    $("#ShopID").val(ASOFTEnvironment.ShopID | "");

    $("#RelatedToTypeID").val(31);

    var numerics = ["FromIncome", "ToIncome", "CommissionRate"];

    numerics.forEach(function (val, index) {
        var current = $("#" + val.toString()).data("kendoNumericTextBox");
        if (current) {
            current.min(0);
            current.setOptions({ format: "#.###", decimals: 3 });
        }
    });
       

})


function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}
