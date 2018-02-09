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

    var combobox = $("#TranYear").data("kendoComboBox");
    combobox.select(0);

    $("#CurrencyID").data("kendoComboBox").value(ASOFTEnvironment.BaseCurrencyID);

    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").prepend(tableRight);
    $("#OORfilter").prepend(tableleft);

    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#ReportTitle").val($("#ReportName").val().toUpperCase());

    $("#Tableleft").append($(".TranYear"));
    $("#Tableleft").append($(".CurrencyID"));
    $("#Tableleft").append($(".FromObjectName"));
    $("#TableRight").append(tr);
    $("#TableRight").append(tr);
    $("#TableRight").append($(".ToObjectName"));
    $("#Tableleft").append($(".FactoryID1"));
    $("#Tableleft").append($(".FactoryID2"));
    $("#Tableleft").append($(".FactoryID3"));
    $("#TableRight").append($(".FactoryID4"));
    $("#TableRight").append($(".FactoryID5"));

    $(".ToObjectID").css('display', 'none');
    $(".FromObjectID").css('display', 'none');
    $("#FromObjectName").css('width', '72%');
    $("#ToObjectName").css('width', '72%');
    $("#btnFromObjectName").css('position', 'static');
    $("#btnDeleteFromObjectName").css('position', 'static');
    $("#btnToObjectName").css('position', 'static');
    $("#btnDeleteToObjectName").css('position', 'static');

    $("#btnExport").css('display', 'none');

    $("#btnFromObjectName").kendoButton({ "click": SCREENBF3016.btnFromObjectName_Click });
    $("#btnDeleteFromObjectName").kendoButton({ "click": SCREENBF3016.btnDeleteFromObjectName_Click });

    $("#btnToObjectName").kendoButton({ "click": SCREENBF3016.btnToObjectName_Click });
    $("#btnDeleteToObjectName").kendoButton({ "click": SCREENBF3016.btnDeleteToObjectName_Click });

})

SCREENBF3016 = new function () {
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
    this[SCREENBF3016.ListChoose[currentChoose](result)];
};
