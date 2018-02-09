
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    //$("#Disabled_HF0392").data("kendoComboBox").select(1);
    if ($("#isUpdate").val() == "True") {
        $("#TrainingFieldID").attr("readonly", true);
    }
    $(".Description").after($(".IsCommon"));
    $(".Description").after($(".Disabled"));
    $("form#HRMF1041 .asf-filter-main").children().removeClass('grid_6');
    $("form#HRMF1041 .asf-filter-main").children().addClass('grid_12');
    $("#RelatedToTypeID").val('1');
})

function validateCode(TrainingFieldID) {
    var re = /[ !@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
    return re.test(TrainingFieldID.toLowerCase());
}

function CustomerCheck() {
    var TrainingFieldID = $("#TrainingFieldID").val();
    if (validateCode(TrainingFieldID)) {
        ASOFT.form.displayError('#HRMF1041', ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF1041.TrainingFieldID", "HRMF1041", "HRM")));
        return true;
    }
    return false
}
