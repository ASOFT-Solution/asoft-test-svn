var currentChoose = "";
$(document).ready(function () {
    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    var tableleft = '<div class="grid_6_1 alpha float_left" style="width:49%"> ' +
        '<div class="asf-form-container container_12">' +
                '<table id="Tableleft" class="asf-table-view">' +
                    '<tbody>' +
                    '</tbody>' +
                '</table>' +
            '</div>' +
        '</div>';
    var tableRight = '<div class="grid_6 omega float_right" style="width:49%"> ' +
                '<div class="asf-form-container container_12">' +
                    '<table id="TableRight" class="asf-table-view">' +
                        '<tbody>' +
                        '</tbody>' +
                    '</table>' +
                '</div>' +
            '</div>';
    var tr = '<tr><td class="asf-td-caption"></td><td class="asf-td-field"></td></tr>';

    var cbbTranMonth = $("#FromPeriodFilter").data("kendoComboBox");
    cbbTranMonth.select(0);
    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    var cbbTranMonth = $("#ToPeriodFilter").data("kendoComboBox");
    cbbTranMonth.select(0);
    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);

    $("#CurrencyID").data("kendoComboBox").value(ASOFTEnvironment.BaseCurrencyID);

    //required
    $(".FromAccountID .asf-td-caption").append('<span class="asf-label-required">*</span>');
    $("#FromAccountID").attr('data-val-required', 'The field is required.');

    $(".ToAccountID .asf-td-caption").append('<span class="asf-label-required">*</span>');
    $("#ToAccountID").attr('data-val-required', 'The field is required.');

    $(".block-left .asf-filter-label").append('<span class="asf-label-required">*</span>');
    $("#FromPeriodFilter").attr('data-val-required', 'The field is required.');
    $("#FromDate").attr('data-val-required', 'The field is required.');

    $(".block-right .asf-filter-label").append('<span class="asf-label-required">*</span>');
    $("#ToPeriodFilter").attr('data-val-required', 'The field is required.');
    $("#ToDate").attr('data-val-required', 'The field is required.');

    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OORfilter").prepend(tableRight);
    $("#OORfilter").prepend(tableleft);
    $("#OOR").prepend(tableOO);

    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $("#Tableleft").append($(".TranYear"));
    $("#Tableleft").append($(".CurrencyID"));
    $("#Tableleft").append($(".FromAccountID"));
    $("#Tableleft").append($(".FromObjectName"));
    $("#TableRight").append(tr);
    $("#TableRight").append($(".ToAccountID"));
    $("#TableRight").append($(".ToObjectName"));
    $("#OORfilter").append($("#PeriodFilter2"));
    $("#OORfilter").append($("#PeriodFilter1"));
    $("#OORfilter").append($(".RdbInvoiceDate"));

    $(".ToObjectID").css('display', 'none');
    $(".FromObjectID").css('display', 'none');
    $(".FromYear").css('display', 'none');
    $(".ToYear").css('display', 'none');
    $(".TypeID").css('display', 'none');
    $(".RdbInvoiceDate").css('display', 'none');
    $("#FromObjectName").css('width', '72%');
    $("#ToObjectName").css('width', '72%');
    $("#btnFromObjectName").css('position', 'static');
    $("#btnDeleteFromObjectName").css('position', 'static');
    $("#btnToObjectName").css('position', 'static');
    $("#btnDeleteToObjectName").css('position', 'static');
    $(".RdbInvoiceDate .asf-td-caption").remove();

    $("#rdoFilterDate").change(function (e) {
        $(".RdbInvoiceDate").css('display', 'block');
    });

    $("#rdoFilterPeriod").change(function (e) {
        $(".RdbInvoiceDate").css('display', 'none');
    });

    $(".RdbInvoiceDate").change(function (e) {
        var selValue = $('input[name=RdbInvoiceDate]:checked').val();
        $("#TypeID").val(selValue);
    });

    $("#btnExport").css('display', 'none');
    $("#btnFromObjectName").kendoButton({ "click": SCREENBF3015.btnFromObjectName_Click });
    $("#btnDeleteFromObjectName").kendoButton({ "click": SCREENBF3015.btnDeleteFromObjectName_Click });

    $("#btnToObjectName").kendoButton({ "click": SCREENBF3015.btnToObjectName_Click });
    $("#btnDeleteToObjectName").kendoButton({ "click": SCREENBF3015.btnDeleteToObjectName_Click });

})

SCREENBF3015 = new function () {
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
};

function receiveResult(result) {
    this[SCREENBF3015.ListChoose[currentChoose](result)];
};
