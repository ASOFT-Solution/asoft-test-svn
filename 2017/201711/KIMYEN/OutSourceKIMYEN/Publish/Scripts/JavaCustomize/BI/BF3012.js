$(document)
    .ready(function() {
        controlcustom();

        $("#btnFromObjectName")
            .bind('click',
                function() {
                    currentChoose = "FromObjectName";
                    var urlChoose = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + ASOFTEnvironment.DivisionID;
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftPopup.showIframe(urlChoose, {});
                });
        $("#btnToObjectName")
            .bind('click',
                function () {
                    currentChoose = "ToObjectName";
                    var urlChoose = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + ASOFTEnvironment.DivisionID;
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftPopup.showIframe(urlChoose, {});
                });
        $("#btnDeleteFromObjectName").click(function () {
            $("#FromObjectID").val('');
            $("#FromObjectName").val('');
        });
        $("#btnDeleteToObjectName").click(function () {
            $("#ToObjectID").val('');
            $("#ToObjectName").val('');
        });
    });


function controlcustom() {
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

    var tr = '<tr><td class="asf-td-caption"></td><td class="asf-td-field"></td></tr>'
    $("#FormReportFilter").prepend("<table id='tableDivision' style='width:93%;'>" + "</table>");
    $("#tableDivision").append($(".DivisionID"));
    $(".DivisionID").attr("style", "margin:auto");
    $("#tableDivision")
        .after("<fieldset id = 'report' class = 'asf-form-container container_12 pagging_bottom' style = 'width:600px;'><legend>Báo cáo</legend><table id = 'tableHeader' class='asf-table-view' ></table></fieldset>");

    $("#report")
        .after("<fieldset id = 'reportfilter' class = 'asf-form-container container_12 pagging_bottom' style = 'width:600px;'><legend>Tiêu chí chọn lọc</legend></fieldset>");
    $("#tableHeader").append($(".ReportID"), $(".ReportName"), $(".ReportTitle"));
    $("#reportfilter").prepend(tableleft);
    $("#reportfilter").prepend(tableRight);
    $("#Tableleft")
        .append($(".TranYear"),
            $(".CurrencyID"),
            $(".FromObjectName"));
    $("#TableRight").append(
        tr,
        tr,
        $(".ToObjectName"));
    //$("#btnDeleteFromObjectName").css('right', '20px');
    //$("#btnFromObjectName").css('right', '50px');
    //$("#btnDeleteToObjectName").css('right', '20px');
    //$("#btnToObjectName").css('right', '50px');
    $(".FromObjectID").css('display', 'none');
    $(".ToObjectID").css('display', 'none');
    $("#ReportTitle").val($("#ReportName").val().toUpperCase());
}

var currentChoose = null;
function receiveResult(result) {
    switch (currentChoose) {
        case "FromObjectName":
            $("#FromObjectID").val(result.ObjectID);
            $("#FromObjectName").val(result.ObjectName);
            break;
        case "ToObjectName":
            $("#ToObjectID").val(result.ObjectID);
            $("#ToObjectName").val(result.ObjectName);
            break;
    }
}
