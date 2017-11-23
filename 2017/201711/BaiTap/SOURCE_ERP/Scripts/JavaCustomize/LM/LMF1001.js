$(document).ready(function () {
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();

    $('#RelatedToTypeID').val(1);

    if ($('#isUpdate').val() == "True") {
        $('#CreditFormID').prop("readonly", true);
    }
})


function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && action == 1) {
        $('#RelatedToTypeID').val(1);
        $('#IsCommon').prop('checked', false);
    }

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