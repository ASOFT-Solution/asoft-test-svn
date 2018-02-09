// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    25/12/2017  Văn Tài         Create New
// #    27/12/2017  Kiều Nga        Update
// ##################################################################

$(document)
    .ready(function () {
        BF2017.LayoutSettings();

        //default value
        var cbbTranMonth = $("#FromPeriodFilter").data("kendoComboBox");
        cbbTranMonth.select(0);
        $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
        $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

        var cbbTranMonth = $("#ToPeriodFilter").data("kendoComboBox");
        cbbTranMonth.select(0);
        $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
        $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);

        $("#CurrencyID").data("kendoComboBox").value(ASOFTEnvironment.BaseCurrencyID);
        // #region ---  Events ---

        $("#btnFromObjectName")
         .bind('click',
             function () {
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

        $("#btnExport").remove();
        $("#btnPrint").unbind();
        $("#btnPrint").kendoButton({
            "click": BF2017.custom_Html,
        });
        // #endregion ---  Events ---
    });

BF2017 = new function () {

    /**
     * Điều chỉnh layout màn hình
     * @returns {} 
     * @since [Văn Tài] Created [25/12/2017]
     */
    this.LayoutSettings = function() {
        $("#FormReportFilter").prepend("<table id='tableDivision' style='width:93%;'>" + "</table>");
        $("#tableDivision").append($(".DivisionID"));
        $(".DivisionID").attr("style", "margin:auto");
        $("#tableDivision")
            .after("<fieldset id = 'report' class = 'asf-form-container container_12 pagging_bottom' style = 'width:600px;'><legend>Báo cáo</legend><table id = 'tableHeader' class='asf-table-view' ></table></fieldset>");

        $("#report")
            .after("<fieldset id = 'report' class = 'asf-form-container container_12 pagging_bottom' style = 'width:600px;'><legend>Tiêu chí chọn lọc</legend><table id = 'tableFooter' class='asf-table-view' ></table></fieldset>");
        $("#tableHeader").append($(".ReportID"), $(".ReportName"), $(".ReportTitle"));
        $("#tableFooter")
            .append(
                $(".CurrencyID"),
                $(".FromObjectName"),
                $(".ToObjectName"),
                $(".FromObjectID"),
                $(".ToObjectID")
                );
        //! cho nằm ngoài table
        $("#tableFooter")
            .parent()
            .append($("#PeriodFilter1").parent().parent());

        $("#btnDeleteFromObjectName").css('right', '72px');
        $("#btnFromObjectName").css('right', '105px');
        $("#btnDeleteToObjectName").css('right', '72px');
        $("#btnToObjectName").css('right', '105px');
        $(".FromObjectID").css('display', 'none');
        $(".ToObjectID").css('display', 'none');

        $("#ReportTitle").val($("#ReportName").val().toUpperCase());
    };

    this.custom_Html = function () {
        var data = ASOFT.helper.dataFormToJSON("FormReportFilter");

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

        var para = "";
        para = para + "DivisionID=" + ASOFTEnvironment.DivisionID;
        para = para + "&CurrencyID=" + data["CurrencyID"];
        para = para + "&FromObjectID=" + data["FromObjectID"];
        para = para + "&ToObjectID=" + data["ToObjectID"];
        para = para + "&IsDate=" + data["rdoFilter"];
        if (data["rdoFilter"] == "1") {
            para = para + "&FromDate=" + data["FromDate"];
            para = para + "&ToDate=" + data["ToDate"];
        }
        else {
            para = para + "&FromMonth=" + data["FromTranMonth"];
            para = para + "&ToMonth=" + data["ToTranMonth"];
            para = para + "&FromYear=" + data["FromTranYear"];
            para = para + "&ToYear=" + data["ToTranYear"];
        }
        window.open("/BI/BF3017?" + para, '_blank');
    };
};


/**
 * Nhận dữ liệu trả về
 * @param {} result 
 * @returns {} 
 * @since [Văn Tài] Created [25/12/2017]
 */
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
