
var comboBoxFromPeriod;
var comboBoxToPeriod;
var comboBoxFromQuarter;
var comboBoxToQuarter;
var comboBoxFromYear;
var comboBoxToYear;
var isPeriod = 0;

$(document).ready(function () {
    var GroupReport = "<fieldset id='OOR' style = 'margin-top:20px; margin-bottom:10px;'><legend><label>" + $("#GroupTitle1").html() + "</label></legend></fieldset>";
    var GroupFilter = "<fieldset id='OORFilter' style = 'margin-top:10px; margin-bottom:10px;'><legend><label>" + $("#GroupTitle2").html() + "</label></legend></fieldset>";
    var table = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='Table'> </table> </div> </div>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var DivTag = "<div class='asf-filter-main' id='{0}'></div>";
    var DivTagblock = "<div class='block-{0}'> <div class='asf-filter-label'></div><div class='asf-filter-input'></div></div>";
    var DivTagblock1 = "<div class='block-{0}'> <div class='asf-filter-input'></div></div>";

    $("#FormReportFilter").prepend(GroupFilter);
    $("#FormReportFilter").prepend(GroupReport);
    $("#FormReportFilter").prepend(table);
    $("#Table").append($(".DivisionID"));    
    $("#OORFilter").append($("#TimeFilter_1"));

    $(".ReportID").css('display', 'none');
    $(".ReportName").css('display', 'none');

    
    $("#OOR").append(kendo.format(DivTag, 'DPeriod'));
    $("#OOR").append(tableOO);
    $("#OOR").append(kendo.format(DivTag, 'DOther'));
    $("#OOR").append(kendo.format(DivTag, 'DOther1'));

    $('#DPeriod').append(kendo.format(DivTagblock, "left"));
    $('#DPeriod .block-left .asf-filter-label').append($(".ReportCode_AF3003").children()[0]);
    $('#DPeriod .block-left .asf-filter-input').append($(".ReportCode_AF3003").children()[0]);
    $('#DPeriod').append(kendo.format(DivTagblock1, "right"));
    $('#DPeriod .block-right .asf-filter-input').append($(".ReportName").children()[1]);
    $('#DPeriod .block-right .asf-filter-input').css('width', '100%');
    $('#DPeriod .block-right .asf-filter-input .asf-td-field').css('width', '50%');

    $('.PeopleCreate .asf-td-caption').css('width', '19%');

    $('#DOther').append(kendo.format(DivTagblock, "left"));
    $('#DOther .block-left .asf-filter-label').append($(".AmountUnit").children()[0]);
    $('#DOther .block-left .asf-filter-input').append($(".AmountUnit").children()[0]);
    $('#DOther').append(kendo.format(DivTagblock, "right"));
    $('#DOther .block-right .asf-filter-label').append($(".Part").children()[0]);
    $('#DOther .block-right .asf-filter-input').append($(".Part").children()[0]);
    $('#DOther1').append(kendo.format(DivTagblock, "left"));
    $('#DOther1 .block-left .asf-filter-label').append($(".DateCreate").children()[0]);
    $('#DOther1 .block-left .asf-filter-input').append($(".DateCreate").children()[0]);

    var cboReportCode = $("#ReportCode_AF3003").data("kendoComboBox");
    if (cboReportCode) {
        cboReportCode.select(0);
        var data = cboReportCode.dataItem();
        $("#ReportName").val(data.ReportName1);
        cboReportCode.bind('change', function () {
            var data = cboReportCode.dataItem();
            $("#ReportName").val(data.ReportName1);
        });
    }

    var cboAmountUnit = $("#AmountUnit").data("kendoComboBox");
    if (cboAmountUnit) {
        cboAmountUnit.select(0);
    }

    comboBoxFromPeriod = $("#fromPeriod").data("kendoComboBox");
    comboBoxToPeriod = $("#toPeriod").data("kendoComboBox");
    comboBoxFromQuarter = $("#fromQuarter").data("kendoComboBox");
    comboBoxToQuarter = $("#toQuarter").data("kendoComboBox");
    comboBoxFromYear = $("#fromYear").data("kendoComboBox");
    comboBoxToYear = $("#toYear").data("kendoComboBox");
    var dropdownlist = $("#DivisionID").data("kendoDropDownList");
    dropdownlist.bind('change', function () {
        $("#StrDivisionID").val(dropdownlist.value());
    });
    dropdownlist.value($("#EnvironmentDivisionID").val());
    $($(dropdownlist.list.find('li')[dropdownlist.selectedIndex])).trigger("click");
    $("#StrDivisionID").val(dropdownlist.value());
    comboBoxFromQuarter.enable(false);
    comboBoxToQuarter.enable(false);
    comboBoxFromYear.enable(false);
    comboBoxToYear.enable(false);
    var data = comboBoxFromPeriod.dataItem();
    var data1 = comboBoxToPeriod.dataItem();
    if (data) {
        $("#TranMonthFrom1").val(data.TranMonth);
        $("#TranYearFrom1").val(data.TranYear);
    }
    if (data1) {
        $("#TranMonthTo1").val(data1.TranMonth);
        $("#TranYearTo1").val(data1.TranYear);
    }

    comboBoxFromPeriod.bind('change', cbo_change);
    comboBoxToPeriod.bind('change', cbo_change);
    comboBoxFromQuarter.bind('change', cbo_change);
    comboBoxToQuarter.bind('change', cbo_change);
    comboBoxFromYear.bind('change', cbo_change);
    comboBoxToYear.bind('change', cbo_change);

    $("#popupInnerIframe").kendoWindow({
        activate: function () {           
            comboBoxFromQuarter.select(comboBoxToQuarter.dataSource._data.length - 1);
            comboBoxToQuarter.select(0);
            comboBoxFromYear.select(comboBoxToYear.dataSource._data.length - 1);
            comboBoxToYear.select(0);
            comboBoxFromPeriod.select(comboBoxToPeriod.dataSource._data.length - 1);
            comboBoxToPeriod.select(0);
        }
    });


    $("input[type='radio']").click(function (e) {
        if ($(this).prop('name') == 'rdoTimeFilter') {
            var value = $(this).val();
            isPeriod = value;
            $("#fromPeriod").data("kendoComboBox").enable(value == 0);
            $("#toPeriod").data("kendoComboBox").enable(value == 0);            

            $("#fromQuarter").data("kendoComboBox").enable(value == 1);
            $("#toQuarter").data("kendoComboBox").enable(value == 1);

            $("#fromYear").data("kendoComboBox").enable(value == 2);
            $("#toYear").data("kendoComboBox").enable(value == 2);
            cbo_change(null);
        }
    });

});

function cbo_change(e) {    
    if (isPeriod == 0) {
        var data = comboBoxFromPeriod.dataItem();
        var data1 = comboBoxToPeriod.dataItem();
        if (data) {
            $("#TranMonthFrom1").val(data.TranMonth);
            $("#TranYearFrom1").val(data.TranYear);
        }
        if (data1) {
            $("#TranMonthTo1").val(data1.TranMonth);
            $("#TranYearTo1").val(data1.TranYear);
        }
    } else if (isPeriod == 1) {
        var data = comboBoxFromQuarter.dataItem();
        var data1 = comboBoxToQuarter.dataItem();
        if (data) {
            $("#TranMonthFrom1").val(data.QuarterMonthBegin);
            $("#TranYearFrom1").val(data.TranYear);
        }
        if (data1) {
            $("#TranMonthTo1").val(data1.QuarterMonthEnd);
            $("#TranYearTo1").val(data1.TranYear);
        }
    } else if (isPeriod == 2) {
        var data = comboBoxFromYear.dataItem();
        var data1 = comboBoxToYear.dataItem();

        if (data) {
            $("#TranMonthFrom1").val(data.MonthBegin);
            $("#TranYearFrom1").val(data.YearBegin);
        }
        if (data1) {
            $("#TranYearTo1").val(data1.YearEnd);
            $("#TranMonthTo1").val(data1.MonthEnd);
        }
    }
}
