$(document).ready(function () {
    //$(".line_left").remove();
    if ($("#isUpdate").val() == "False") {
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
    }
    if ($("#isUpdate").val() == "True") {
        $("#GroupID").data("kendoComboBox").readonly(true);
        if ($("#IsCommon").is(':checked')) {
            $("#DivisionID").val("@@@");
        }
        CheckUsingCommon();
    }

    var grBussiness = "<fieldset id='grBussiness'><legend><label>" + "Thiết lập nghiệp vụ" + "</label></legend></fieldset>";
    var table = "<div class='container_12'><div class='grid_6' id='left'><table class='asf-table-view'></table></div><div class='grid_6 line_left' id='right'><table class='asf-table-view'></table></div></div>";


    var tableAna = "<fieldset><legend></legend><div class='container_12' id='tableAna'><div class='grid_6' id='left'><table class='asf-table-view'></table></div><div class='grid_6 line_left' id='right'><table class='asf-table-view'></table></div></div></fieldset>";


    $("#CIF1311").prepend(grBussiness);
    $("#CIF1311").prepend(tableAna);
    $("#grBussiness").append(table);


    MoveElement("AnaName", "tableAna", "left");
    MoveElement("AnaID", "tableAna", "left");
    MoveElement("AnaTypeID ", "tableAna", "left");
    MoveElement("GroupID ", "tableAna", "left");
    MoveElement("Disabled", "tableAna", "right");
    MoveElement("IsCommon", "tableAna", "right");
    MoveElement("RefDate", "tableAna", "right");
    MoveElement("Notes", "tableAna", "right");

    MoveElement("Amount05", "grBussiness", "left");
    MoveElement("Note05", "grBussiness", "left");
    MoveElement("Amount04", "grBussiness", "left");
    MoveElement("Note04", "grBussiness", "left");
    MoveElement("Amount03", "grBussiness", "left");
    MoveElement("Note03", "grBussiness", "left");
    MoveElement("Amount02", "grBussiness", "left");
    MoveElement("Note02", "grBussiness", "left");
    MoveElement("Amount01", "grBussiness", "left");
    MoveElement("Note01", "grBussiness", "left");


    MoveElement("Amount10", "grBussiness", "right");
    MoveElement("Note10", "grBussiness", "right");
    MoveElement("Amount09", "grBussiness", "right");
    MoveElement("Note09", "grBussiness", "right");
    MoveElement("Amount08", "grBussiness", "right");
    MoveElement("Note08", "grBussiness", "right");
    MoveElement("Amount07", "grBussiness", "right");
    MoveElement("Note07", "grBussiness", "right");
    MoveElement("Amount06", "grBussiness", "right");
    MoveElement("Note06", "grBussiness", "right");

    if ($("#GroupID").val() == 1) {
        TextBoxEnable(false);
    }
    else {
        TextBoxEnable(true);
    }

    $("#GroupID").bind("change", function () {
        if ($(this).val() == 1) {
            TextBoxEnable(false);
        }
        else {
            TextBoxEnable(true);
        }
    })
});

function TextBoxEnable(enable) {
    $("#Amount01").attr("disabled", enable);
    $("#Note01").attr("disabled", enable);
    $("#Amount02").attr("disabled", enable);
    $("#Note02").attr("disabled", enable);
    $("#Amount03").attr("disabled", enable);
    $("#Note03").attr("disabled", enable);
    $("#Amount04").attr("disabled", enable);
    $("#Note04").attr("disabled", enable);
    $("#Amount05").attr("disabled", enable);
    $("#Note05").attr("disabled", enable);
    $("#Amount06").attr("disabled", enable);
    $("#Note06").attr("disabled", enable);
    $("#Amount07").attr("disabled", enable);
    $("#Note07").attr("disabled", enable);
    $("#Amount08").attr("disabled", enable);
    $("#Note08").attr("disabled", enable);
    $("#Amount09").attr("disabled", enable);
    $("#Note09").attr("disabled", enable);
    $("#Amount10").attr("disabled", enable);
    $("#Note10").attr("disabled", enable);
}

function MoveElement(ClassMove, IDAppend, ClassGrid) {
    $("#" + IDAppend + " #" + ClassGrid + " .asf-table-view").prepend($("." + ClassMove));
}


function CheckUsingCommon() {
    var data = [];
    data.push($("#AnaID").val());
    data.push($("#GroupID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1310/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            if ($("#IsCommon").is(':checked'))
                $(".IsCommon").hide();
            $("#AnaTypeID").data("kendoComboBox").readonly(true);
        }
        else {
            $("#AnaID").removeAttr("readonly");
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