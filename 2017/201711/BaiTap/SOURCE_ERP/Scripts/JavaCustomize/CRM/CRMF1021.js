var changeLengthFieldGroup = function () {
    var $classGrid_6 = $("body").find(".grid_6");

    if (typeof $classGrid_6 !== "undefined") {
        $classGrid_6.removeClass().addClass("grid_12");
    }

    return false;
}

$(document).ready(function () {
    changeLengthFieldGroup();
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

function AddValueComboboxCustom() { // set value thêm nhanh của combo nguồn đầu mối
    localStorage.setItem("ValueCombobox", $("#LeadTypeID").val());
}