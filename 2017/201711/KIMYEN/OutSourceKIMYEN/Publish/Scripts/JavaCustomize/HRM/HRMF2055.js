// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    24/10/2017  Kim Vu         Create New
// ##################################################################

var DivTag2block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";
$(document)
    .ready(function () {
        $(".TrialTime").css('display', 'none');
        $(".TrialFromDate").css('display', 'none');
        $(".TrialToDate").css('display', 'none');
        $("#HRMF2055 .asf-filter-main").css('display', 'none');

        $("#HRMF2055 .asf-form-button").before(kendo.format(DivTag2block, "divTrialTime"));
        $('#divTrialTime .block-left .asf-filter-label').append($(".TrialTime").children()[0]);
        $('#divTrialTime .block-left .asf-filter-input').append($($(".TrialTime").children()[0]).children());

        $("#divTrialTime").after(kendo.format(DivTag2block, "divFromToDate"));
        $('#divFromToDate .block-left .asf-filter-label').append($(".TrialFromDate").children()[0]);
        $('#divFromToDate .block-left .asf-filter-input').append($($(".TrialFromDate").children()[0]).children());
        $('#divFromToDate .block-right .asf-filter-label').append($(".TrialToDate").children()[0]);
        $('#divFromToDate .block-right .asf-filter-input').append($($(".TrialToDate").children()[0]).children());
        $('#divFromToDate').css('width', '80%');
        $('#divFromToDate').css('margin-left', '10%');

        $(".CandidateName .asf-td-caption").css('display', 'none');
        //$(".CandidateName .asf-td-field").css('width', '100%');
        $(".Description .asf-td-caption").css('display', 'none');
        //$(".Description .asf-td-field").css('width', '100%');
        $(".RecruitPeriodName .asf-td-caption").css('display', 'none');
        //$(".RecruitPeriodName .asf-td-field").css('width', '100%');

        $("#HRMF2055 .omega.float_right").removeClass('line_left_with_grid');        
    });

function CustomerCheck() {
    var fromdatestr = $("#TrialFromDate").val(), date1 = fromdatestr.split("/");
    var todatestr = $("#TrialToDate").val(), date2 = todatestr.split("/");
    var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
    var todate = new Date(date2[2], date2[1] - 1, date2[0]);
    if (fromdate > todate) {
        ASOFT.form.displayError('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage('OOFML000022'));
        return true;
    }
}