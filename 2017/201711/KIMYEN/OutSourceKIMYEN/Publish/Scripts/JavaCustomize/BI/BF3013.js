var currentChoose = "";
$(document).ready(function () {
    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    var tableleft = '<div class="grid_6_1 alpha float_left" style="width:49%"> ' +
            '<div class="asf-form-container container_12 pagging_bottom">' +
                    '<table id="Tableleft" class="asf-table-view">' +
                        '<tbody>' +
                        '</tbody>' +
                    '</table>' +
                '</div>' +
            '</div>';
    var tableRight = '<div class="grid_6 omega float_right" style="width:49%"> ' +
                '<div class="asf-form-container container_12 pagging_bottom">' +
                    '<table id="TableRight" class="asf-table-view">' +
                        '<tbody>' +
                        '</tbody>' +
                    '</table>' +
                '</div>' +
            '</div>';
    var tr = '<tr><td class="asf-td-caption"></td><td class="asf-td-field"></td></tr>';

    //default value
    var cbbFromYear = $("#FromYear").data("kendoComboBox");
    cbbFromYear.select(0);

    var cbbToYear = $("#ToYear").data("kendoComboBox");
    cbbToYear.select(0);

    var cbbFromTranMonth = $("#FromPeriodFilter").data("kendoComboBox");
    cbbFromTranMonth.select(0);
    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    var cbbTranMonth = $("#ToPeriodFilter").data("kendoComboBox");
    cbbTranMonth.select(0);
    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);

    $("#CurrencyID").data("kendoComboBox").value(ASOFTEnvironment.BaseCurrencyID);

    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").prepend(tableRight);
    $("#OORfilter").prepend(tableleft);
    $("#OORfilter").prepend($("#PeriodFilter2"));
    $("#OORfilter").prepend($("#PeriodFilter1"));

    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#ReportTitle").val($("#ReportName").val().toUpperCase());

    $("#Tableleft").append($(".MonthYear"));
    $("#Tableleft").append($(".CurrencyID"));
    $("#Tableleft").append($(".FromObjectName"));
    $("#Tableleft").append($(".GroupID1"));
    $("#Tableleft").append($(".GroupID2"));
    $("#Tableleft").append($(".GroupID3"));
    $("#TableRight").append(tr);
    $("#TableRight").append($(".ToObjectName"));
    $("#TableRight").append($(".GroupID4"));
    $("#TableRight").append($(".GroupID5"));

    $(".ToObjectID").css('display', 'none');
    $(".FromObjectID").css('display', 'none');
    $(".TranYear").css('display', 'none');
    $(".TranMonth").css('display', 'none');
    $(".MonthYear").css('display', 'none');
    $("#FromObjectName").css('width', '72%');
    $("#ToObjectName").css('width', '72%');
    $("#btnFromObjectName").css('position', 'static');
    $("#btnDeleteFromObjectName").css('position', 'static');
    $("#btnToObjectName").css('position', 'static');
    $("#btnDeleteToObjectName").css('position', 'static');

    $("#btnExport").css('display', 'none');

    $("#MonthYear").change(function(e)
    {
        var MonthYear = $("#MonthYear").val();
        var IndexOf = MonthYear.lastIndexOf("/");
        var TranYear = MonthYear.substr(0, IndexOf);
        var TranMonth = MonthYear.substr(IndexOf + 1, MonthYear.length);
        $("#TranYear").val(TranYear);
        $("#TranMonth").val(TranMonth);
    });

    $("#btnFromObjectName").kendoButton({ "click": SCREENBF3013.btnFromObjectName_Click });
    $("#btnDeleteFromObjectName").kendoButton({ "click": SCREENBF3013.btnDeleteFromObjectName_Click });

    $("#btnToObjectName").kendoButton({ "click": SCREENBF3013.btnToObjectName_Click });
    $("#btnDeleteToObjectName").kendoButton({ "click": SCREENBF3013.btnDeleteToObjectName_Click });

    $("#MonthYear").change(function (e) {
        var MonthYear = $("#MonthYear").val();
        var IndexOf = MonthYear.lastIndexOf("/");
        var TranYear = MonthYear.substr(0, IndexOf);
        var TranMonth = MonthYear.substr(IndexOf + 1, MonthYear.length);
        $("#TranYear").val(TranYear);
        $("#TranMonth").val(TranMonth);
    });

})

SCREENBF3013 = new function () {
    this.ListChoose = {
        "btnFromObjectIDName": function (result) {
            $("#FromObjectID").val(result.ObjectID);
            $("#FromObjectName").val(result.ObjectName);
        },
        "btnToObjectName": function (result) {
            $("#ToObjectID").val(result.ObjectID);
            $("#ToObjectName").val(result.ObjectName);
        },
    };

    this.btnFromObjectName_Click = function (e) {
        currentChoose = "btnFromObjectIDName";
        var url = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + $("#EnvironmentDivisionID").val();
        ASOFT.asoftPopup.showIframe(url, {});
    };

    this.btnToObjectName_Click = function (e) {
        currentChoose = "btnToObjectName";
        var url = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + $("#EnvironmentDivisionID").val();
        ASOFT.asoftPopup.showIframe(url, {});
    };

    this.btnDeleteFromObjectName_Click = function () {
        $("#FromObjectID").val('');
        $("#FromObjectName").val('');
    };

    this.btnDeleteToObjectName_Click = function () {
        $("#ToObjectID").val('');
        $("#ToObjectName").val('');
    };

    this.print_Click = function () {
        isPrint = false;
        var data = getData();
        var url = URLDoPrintorExport;

        //CheckInList
        var CheckInList = [];
        if (data["CheckInList"] != undefined) {
            if (jQuery.type(data["CheckInList"]) === "string") {
                CheckInList.push(data["CheckInList"]);
            }
            else {
                CheckInList = data["CheckInList"];
            }
        }
        if (ASOFT.form.checkRequiredAndInList("FormReportFilter", CheckInList)) {
            return;
        }

        //for (var i = 0; i < 4; i++) {
        //    var error = "";
        //    if ((data["GroupID" + i] == "undefined" || data["GroupID" + i] == "") && (data["GroupID" + i++] != "" && data["GroupID" + i++] != "undefined"))
        //    {
        //        error
        //    }
        //}
        ASOFT.helper.postTypeJson(url, data, ExportSuccess);
    }
};

function receiveResult(result) {
    this[SCREENBF3013.ListChoose[currentChoose](result)];
};
