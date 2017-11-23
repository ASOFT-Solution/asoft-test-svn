

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

        "FromObjectName": function (result) {

            $("#FromObjectID").val(result["ObjectID"]);

            $("#FromObjectName").val(result["ObjectName"]);
        },

        "ToObjectName": function (result) {

            $("#ToObjectID").val(result["ObjectID"]); 

            $("#ToObjectName").val(result["ObjectName"]);
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

    var templeteButton = new templateAsoftButton();
        //controlKendoComBoBoxID = ["FromEmployeeID", "ToEmployeeID"];

    $("#FromObjectName")
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
        .append(templeteButton.getAsoftButton("", "btnFromObjectName", "", "...", "btnFromObjectName_click()") + templeteButton.getDeleteAsoftButton("btnFromObjectName", "btnDeleteFromObjectName_click()"));

    $("#ToObjectName")
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
        .append(templeteButton.getAsoftButton("", "btnToObjectName", "", "...", "btnToObjectName_click()") + templeteButton.getDeleteAsoftButton("btnToObjectName", "btnDeleteToObjectName_click()"));

    setDefaultValue();

    ////
    //controlKendoComBoBoxID.forEach(function (item) {
    //    var combobox = $("#" + item).data("kendoComboBox");
    //    typeof combobox != "undefined" ? combobox._events.open[0] = newOpenComboDynamic : false;
    //});
});

function setDefaultValue() {
    //$('#FromObjectName').val(ASOFTEnvironment.UserName);
    //$('#FromObjectID').val(ASOFTEnvironment.UserID);
    //$('#ToObjectName').val(ASOFTEnvironment.UserName);
    //$('#ToObjectID').val(ASOFTEnvironment.UserID);
}

function btnFromObjectName_click() {
    currentChoose = "FromObjectName";
    var
        divisionlist = $("#DivisionID").data("kendoDropDownList").value() != "" ? $("#DivisionID").data("kendoDropDownList").value() : ASOFTEnvironment.DivisionID,
        urlPopup = ["/PopupSelectData/Index/00/CMNF9004?DivisionID=", divisionlist].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});
}

function btnToObjectName_click() {
    currentChoose = "ToObjectName";
    var
        divisionlist = $("#DivisionID").data("kendoDropDownList").value() != "" ? $("#DivisionID").data("kendoDropDownList").value() : ASOFTEnvironment.DivisionID,
        urlPopup = ["/PopupSelectData/Index/00/CMNF9004?DivisionID=", divisionlist].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});
}

function btnDeleteFromObjectName_click() {
    $("#FromObjectName").val("");
    $("#FromObjectID").val("");
}

function btnDeleteToObjectName_click() {
    $("#ToObjectName").val("");
    $("#ToObjectID").val("");
}


