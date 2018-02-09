

var
    templateAttachFile = function (textFileName, templeteClass, textFileID) {
        this.getTemplete = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label>{1}</label><label class='x-close'>&#10006</label></div>", templeteClass, textFileName, textFileID);
        return this;
    },

    templateAsoftButton = function () {
        this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
            return kendo.format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
                buttonClass,
                buttonID,
                spanClass,
                buttonCaption,
                onclickFunction);
        };

        this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
            return kendo.format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32'></span></a>",
                buttonID,
                onclickFunction);
        };

        return this;
    },

    ListChoose = {

        "FromEmployeeName": function (result) {

            $("#FromEmployeeID").val(result["EmployeeID"]);

            $("#FromEmployeeName").val(result["EmployeeName"]);
        },

        "ToEmployeeName": function (result) {

            $("#ToEmployeeID").val(result["EmployeeID"]);

            $("#ToEmployeeName").val(result["EmployeeName"]);
        }
    },
    currentChoose = null,

    openEventComboDynamic = OpenComboDynamic,

    newOpenComboDynamic = function () {
        // Lấy dữ liệu combochecklist
        var comboDivision = $("#DivisionID").data("kendoDropDownList"), isReturnValueDefault = false;
        if (typeof comboDivision !== "undefined")
            comboDivision.value() == "" ? (comboDivision.value(ASOFTEnvironment.DivisionID), comboDivision.text(""), isReturnValueDefault = true) : false;
        openEventComboDynamic.apply(this, arguments);
        //Kiểm tra có return lại value hay không?
        isReturnValueDefault == true ? (comboDivision.value(""), comboDivision.text(""), isReturnValueDefault = false) : false;
    };

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

$(document).ready(function () {

    $("#btnExport").parent().remove();
    var templeteButton = new templateAsoftButton(),
        controlKendoComBoBoxID = ["FromEmployeeID", "ToEmployeeID"];

    $("#FromEmployeeName")
        .focus(function (e) {
            $(this).blur();
        })
        .css({
            "width": "75%",
            "background-color": "#d0c9c9",
            "cursor": "not-allowed",
            "padding": "0 5px"
        })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnFromEmployeeName", "", "...", "btnFromEmployeeName_click()") + templeteButton.getDeleteAsoftButton("btnFromEmployeeName", "btnDeleteFromEmployeeName_click()"));

    $("#ToEmployeeName")
        .focus(function (e) {
            $(this).blur();
        })
        .css({
            "width": "75%",
            "background-color": "#d0c9c9",
            "cursor": "not-allowed",
            "padding": "0 5px"
        })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnToEmployeeName", "", "...", "btnToEmployeeName_click()") + templeteButton.getDeleteAsoftButton("btnToEmployeeName", "btnDeleteToEmployeeName_click()"));

    setDefaultValue();

    //
    //controlKendoComBoBoxID.forEach(function (item) {
    //    var combobox = $("#" + item).data("kendoComboBox");
    //    typeof combobox != "undefined" ? combobox._events.open[0] = newOpenComboDynamic : false;
    //});
});

function setDefaultValue() {
    $('#FromEmployeeName').val(ASOFTEnvironment.UserName);
    $('#FromAccountID').val(ASOFTEnvironment.UserID);
    $('#ToEmployeeName').val(ASOFTEnvironment.UserName);
    $('#ToAccountID').val(ASOFTEnvironment.UserID);
}

function btnFromEmployeeName_click() {
    currentChoose = "FromEmployeeName";
    var
        divisionlist = $("#DivisionID").data("kendoDropDownList").value() != "" ? $("#DivisionID").data("kendoDropDownList").value() : ASOFTEnvironment.DivisionID,
        urlPopup = ["/PopupSelectData/Index/00/CMNF9003?DivisionID=", divisionlist].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});
}

function btnToEmployeeName_click() {
    currentChoose = "ToEmployeeName";
    var
        divisionlist = $("#DivisionID").data("kendoDropDownList").value() != "" ? $("#DivisionID").data("kendoDropDownList").value() : ASOFTEnvironment.DivisionID,
        urlPopup = ["/PopupSelectData/Index/00/CMNF9003?DivisionID=", divisionlist].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});
}

function btnDeleteFromEmployeeName_click() {
    $("#FromEmployeeName").val("");
    $("#FromAccountID").val("");
}

function btnDeleteToEmployeeName_click() {
    $("#ToEmployeeName").val("");
    $("#ToAccountID").val("");
}


