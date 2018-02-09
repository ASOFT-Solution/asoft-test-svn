$(document).ready(function () {

    $(".Note").after($(".IsCommon"));
    $(".IsCommon").after($(".Disabled"));
    $("#HRMF1001 .container_12 .asf-filter-main .grid_6 .line-left").removeClass('grid_6');
    $("#HRMF1001 .container_12 .asf-filter-main .grid_6").removeClass('grid_6');
    $("#HRMF1001 .container_12 .asf-filter-main .grid_6").addClass('grid_12');
    if ($("#isUpdate").val() == "True") {
        $("#ResourceID").attr("readonly", "readonly");        
        $(".IsCommon").css('display', 'none');
    } else {
        $(".Disabled").css('display', 'none');
    }
})