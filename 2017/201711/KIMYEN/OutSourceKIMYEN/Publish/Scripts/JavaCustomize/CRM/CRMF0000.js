
$(document).ready(function () {
    ASOFT.helper.postTypeJson("/CRM/CRMF0000/GetLanguage", {}, function (result) {
        $("#Save span").html(result["A00.btnConfig"]);
    });

    $(".grid_6").removeClass();
    $(".grid_6").addClass("form-content");

    $("#Close").unbind();
    $("#Close").kendoButton({
        "click": CustomClose_Click,
    });

    $("#Save").unbind();
    $("#Save").kendoButton({
        "click": CustomSave_Click,
    });

    $("#DivisionID").change(function () {
        changeDivisionID();
    }); 

});

function changeDivisionID() {
    var cbo = $("#VoucherType01").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#MonthYear").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#VoucherType02").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#VoucherType03").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#VoucherType04").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#VoucherType05").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#WareHouseID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#WareHouseTempID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#WareHouseBorrowID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#ExportAccountID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#ImportAccountID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    cbo = $("#ApportionID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    var data = [];
    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJson("/CRM/CRMF0000/ChangeDivisionID", data, checkSuccess);
}

function checkSuccess(result) {
    $("#MonthYear").data("kendoComboBox").value(result.MonthYear);
    $("#VoucherType01").data("kendoComboBox").value(result.result.VoucherType01);
    $("#VoucherType02").data("kendoComboBox").value(result.result.VoucherType02);
    $("#VoucherType03").data("kendoComboBox").value(result.result.VoucherType03);
    $("#VoucherType04").data("kendoComboBox").value(result.result.VoucherType04);
    $("#VoucherType05").data("kendoComboBox").value(result.result.VoucherType05);
    $("#WareHouseID").data("kendoComboBox").value(result.result.WareHouseID);
    $("#WareHouseTempID").data("kendoComboBox").value(result.result.WareHouseTempID);
    $("#WareHouseBorrowID").data("kendoComboBox").value(result.result.WareHouseBorrowID);
    $("#ExportAccountID").data("kendoComboBox").value(result.result.ExportAccountID);
    $("#ImportAccountID").data("kendoComboBox").value(result.result.ImportAccountID);
    $("#ApportionID").data("kendoComboBox").value(result.result.ApportionID);
}

function CustomSave_Click() {
    var CheckComboInList = ["DivisionID", "MonthYear", "VoucherType01", "VoucherType02", "VoucherType04", "VoucherType05", "VoucherType03", "WareHouseID", "WareHouseTempID", "WareHouseBorrowID", "ExportAccountID", "ImportAccountID", "ApportionID"]
    if (ASOFT.form.checkRequiredAndInList(id, CheckComboInList)) {
        return;
    };
    CRMF0000_Save();
};
function CustomClose_Click() {
        ASOFT.dialog.confirmDialog(
           AsoftMessage['00ML000016'],
           function () {
               CRMF0000_Save();
           },
           function () {
               ASOFT.asoftPopup.closeOnly();
     
           })
};

function CRMF0000_Save() {
    ASOFT.form.clearMessageBox();
    var data = ASOFT.helper.dataFormToJSON(id);
    var args = new Object();
    args.DivisionID = data["DivisionID"];
    args.DivisionName = $("#DivisionID").data("kendoComboBox").text();
    args.MonthYear = data["MonthYear"];
    args.VoucherType01 = data["VoucherType01"];
    args.VoucherType02 = data["VoucherType02"];
    args.VoucherType04 = data["VoucherType04"];
    args.VoucherType03 = data["VoucherType03"];
    args.VoucherType05 = data["VoucherType05"];
    args.WareHouseID = data["WareHouseID"];
    args.WareHouseTempID = data["WareHouseTempID"];
    args.WareHouseBorrowID = data["WareHouseBorrowID"];
    args.ExportAccountID = data["ExportAccountID"];
    args.ImportAccountID = data["ImportAccountID"];
    args.ApportionID = data["ApportionID"];
    ASOFT.helper.postTypeJson("/CRM/CRMF0000/InsertOrUpdate", {data : args}, function (result) {
        if (result.Status == 0)//Khong co loi
        {
            ASOFT.form.displayInfo('#CRMF0000', ASOFT.helper.getMessage(result.Message));
            parent.window.location.reload();
        }
        else
        {
            ASOFT.form.displayWarning('#CRMF0000', AsoftMessage[result.Message]);
        }
    });
};
