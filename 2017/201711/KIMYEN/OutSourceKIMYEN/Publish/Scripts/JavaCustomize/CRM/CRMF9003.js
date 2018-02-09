var RelatedToID_OLD = null;
var RelatedToTypeID_REL_OLD = null;

$(document).ready(function () {
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();

    //var btnFrom = '<a id="btSearchFrom" style="z-index:10001; position: absolute; right: 48px; height: 25px !important; min-width: 27px;" data-role="button" class="k-button {0} asf-button" role="button" aria-disabled="false" tabindex="0" {1}>...</a>';

    //var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 20px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button {0}  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" {1}></a>';

    //var onclick = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnSearchFrom_Click()'";
    //var classE = $("#RelatedToTypeID_REL").val() == "" ? "k-state-disabled" : "k-button-icontext";
    //var onclick1 = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnDeleteFrom_Click()'";

    //var btnDelete1 = kendo.format(btnDelete, classE, onclick1);

    //var btnFrom1 = kendo.format(btnFrom, classE, onclick);
    //$("#RelatedToID").after(btnFrom1);
    //$("#RelatedToID").after(btnDelete1);
    $("#Description").css("width", "98%");
    //$("#RelatedToID").attr('readonly', 'readonly');

    //$("#RelatedToTypeID_REL").change(function () {
    //    $("#btSearchFrom").remove();
    //    $("#btDeleteFrom").remove();
    //    $(".RelatedToID .asf-td-caption").text($("#RelatedToTypeID_REL").data("kendoComboBox").text());
    //    onclick = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnSearchFrom_Click()'";
    //    classE = $("#RelatedToTypeID_REL").val() == "" ? "k-state-disabled" : "k-button-icontext";
    //    onclick1 = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnDeleteFrom_Click()'";
    //    btnDelete1 = kendo.format(btnDelete, classE, onclick1);
    //    btnFrom1 = kendo.format(btnFrom, classE, onclick);
    //    if ($("#RelatedToTypeID_REL").val() == "")
    //    {
    //       $("#RelatedToID").val('');
    //    }

    //    $("#RelatedToID").after(btnFrom1);
    //    $("#RelatedToID").after(btnDelete1);
    //});

    RelatedToID_OLD = $("#RelatedToID").val();
    RelatedToTypeID_REL_OLD = $("#RelatedToTypeID_REL").val();
})

function btnSearchFrom_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9004";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    $("#RelatedToID").val(result["ObjectID"]);
}

function btnDeleteFrom_Click() {
     $("#RelatedToID").val('');
}


function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#RelatedToID").val(RelatedToID_OLD);
        $("#RelatedToTypeID_REL").val(RelatedToTypeID_REL_OLD);
    }
}