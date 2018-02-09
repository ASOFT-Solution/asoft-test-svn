
$(document).ready(function () {
    $("#CheckListPeriodControl").parent().parent().remove();
    $("#rdoFilterPeriod").parent().parent().remove();
    $("#rdoFilterDate").remove();
    $(".TitleID").before($(".DepartmentName"));
    $(".TitleID").before($(".DutyID"));
    $(".ToI").before($(".FromD"));
    $(".ToI").before($(".ToD"));
    $(".ToI").before($(".FromI"));
    $(".FromD").append($(".ToD").find('td'));
    $(".FromI").append($(".ToI").find('td'));
    $(".FromS").append($(".ToS").find('td'));
    $(".FromC").append($(".ToC").find('td'));
    $(".ToD").remove();
    $(".ToI").remove();
    $(".ToS").remove();
    $(".ToC").remove();
    $($(".FromD").find('td')).removeAttr('colspan');
    $($(".FromI").find('td')).removeAttr('colspan');
    $($(".FromS").find('td')).removeAttr('colspan');
    $($(".FromC").find('td')).removeAttr('colspan');
    $($(".col3").find('.asf-td-caption')).attr("style", "width: 20%");
    $($(".col3").find('.asf-td-field')).attr("style", "width: 30%");
    $($(".col3").find('td')).removeAttr('class');
    $("#Nature_D_HRMF2110").remove();
    $("#Nature_I_HRMF2110").remove();
    $("#Nature_S_HRMF2110").remove();
    $("#Nature_C_HRMF2110").remove();
    $("#Adaptive_D_HRMF2110").remove();
    $("#Adaptive_I_HRMF2110").remove();
    $("#Adaptive_S_HRMF2110").remove();
    $("#Adaptive_C_HRMF2110").remove();
})