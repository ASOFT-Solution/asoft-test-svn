$(document).ready(function () {
    ////$(".line_left").remove();
    //$(".grid_6").addClass("form-content");
    //$(".grid_6").removeClass();
    var $classGrid_6 = $("body").find(".grid_6");

    if (typeof $classGrid_6 !== "undefined") {
        $classGrid_6.removeClass().addClass("grid_12");
    }
    if ($("#isUpdate").val() == "False") {
        refreshModel();
    }
});

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
