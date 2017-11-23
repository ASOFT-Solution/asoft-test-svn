var duetype = null;

$(document).ready(function () {
    //$(".line_left").remove();
    //$(".grid_6").addClass("form-content");
    //$(".grid_6").removeClass();
    if ($("#isUpdate").val() == "False") {
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
    }
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    $("#DueDays").bind("keyup", function () {
        if ($(this).val() != "") {
            $("#CloseDay").attr("readonly", true);
            $("#TheDay").attr("readonly", true);
            $("#TheMonth").attr("readonly", true);
            $("#CloseDay").val("");
            $("#TheDay").val("");
            $("#TheMonth").val("");
        }
        else {
            $("#CloseDay").attr("readonly", false);
            $("#TheDay").attr("readonly", false);
            $("#TheMonth").attr("readonly", false);
        }
    });

    $("#CloseDay").bind("keyup", function () {
        if ($(this).val() != "") {
            $("#DueDays").attr("readonly", true);
            $("#DueDays").val("");
        }
        else {
            if ($("#TheDay").val() == "" && $("#TheMonth").val() == "")
            {
                $("#DueDays").attr("readonly", false);
            }
        }
    })

    $("#TheDay").bind("keyup", function () {
        if ($(this).val() != "") {
            $("#DueDays").attr("readonly", true);
            $("#DueDays").val("");
        }
        else {
            if ($("#CloseDay").val() == "" && $("#TheMonth").val() == "") {
                $("#DueDays").attr("readonly", false);
            }
        }
    })

    $("#TheMonth").bind("keyup", function () {
        if ($(this).val() != "") {
            $("#DueDays").attr("readonly", true);
            $("#DueDays").val("");
        }
        else {
            if ($("#CloseDay").val() == "" && $("#TheDay").val() == "") {
                $("#DueDays").attr("readonly", false);
            }
        }
    })

    var grDueDate = "<fieldset id='grDueDate'><legend><label>" + "Căn cứ thời gian" + "</label></legend></fieldset>";

    var table = "<div class='container_12'><div class='grid_6' id='left'><table class='asf-table-view'></table></div><div class='grid_6 line_left' id='right'><table class='asf-table-view'></table></div></div>";

    var tablePayment = "<div class='container_12' id='tablePayment'><div class='grid_6' id='left'><table class='asf-table-view'></table></div><div class='grid_6 line_left' id='right'><table class='asf-table-view'></table></div></div>";

    var grDiscount = "<fieldset id='grDiscount'><legend><label>" + "Căn cứ chiết khấu" + "</label></legend></fieldset>";

    $("#CIF1281").prepend(grDiscount);
    $("#CIF1281").prepend(grDueDate);
    $("#CIF1281").prepend(tablePayment);
    $("#grDueDate").append(table);
    $("#grDiscount").append(table);

    $("#grDueDate").before("<table id='check1' class='asf-table-view'></table>");
    $("#check1").prepend($(".IsDueDate"));

    $("#grDiscount").before("<table id='check2' class='asf-table-view'></table>");
    $("#check2").prepend($(".IsDiscount"));


    MoveElement("PaymentTermName", "tablePayment", "left");
    MoveElement("PaymentTermID ", "tablePayment", "left");
    MoveElement("Disabled", "tablePayment", "right");
    MoveElement("IsCommon", "tablePayment", "right");



    MoveElement("CloseDay", "grDueDate", "left");
    MoveElement("DueDays", "grDueDate", "left");
    MoveElement("DueType", "grDueDate", "left");
    MoveElement("TheMonth", "grDueDate", "right");
    MoveElement("TheDay", "grDueDate", "right");

    MoveElement("DiscountDays", "grDiscount", "left");
    MoveElement("DiscountType", "grDiscount", "left");
    MoveElement("DiscountPercentage", "grDiscount", "right");


    if (!$("#IsDueDate").is(':checked')) {
        disableControlIsTime(true);
    }

    if (!$("#IsDiscount").is(':checked')) {
        disableControlIsDiscount(true);
    }


    $("#IsDueDate").bind("click", function () {
        if ($("#IsDueDate").is(':checked')) {
            disableControlIsTime(false);
        }
        else {
            disableControlIsTime(true);
        }
    })

    $("#IsDiscount").bind("click", function () {
        if ($("#IsDiscount").is(':checked')) {
            disableControlIsDiscount(false);
        }
        else {
            disableControlIsDiscount(true);
        }
    })
});


function disableControlIsTime(disable) {
    $("#DueType").data("kendoComboBox").enable(!disable);
    $("#CloseDay").attr("disabled", disable);
    $("#DueDays").attr("disabled", disable);
    $("#DueType").attr("disabled", disable);
    $("#TheDay").attr("disabled", disable);
    $("#TheMonth").attr("disabled", disable);
}

function disableControlIsDiscount(disable) {
    $("#DiscountType").data("kendoComboBox").enable(!disable);
    $("#DiscountDays").attr("disabled", disable);
    $("#DiscountPercentage").attr("disabled", disable);
}

function MoveElement(ClassMove, IDAppend, ClassGrid) {
    $("#" + IDAppend + " #" + ClassGrid + " .asf-table-view").prepend($("." + ClassMove));
}

function CheckUsingCommon() {
    var data = [];
    data.push($("#PaymentTermID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1280/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            if ($("#IsCommon").is(':checked'))
                $(".IsCommon").hide();
        }
        else {
            $("#PaymentTermID").removeAttr("readonly");
        }
    });
}

function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}
