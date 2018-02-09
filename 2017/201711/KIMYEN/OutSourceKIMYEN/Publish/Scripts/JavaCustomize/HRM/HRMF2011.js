var oldVoucherNo = "";
var DivTag2block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";
var DivTag1block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left' style = 'width: 100%'>" +
            "<div class='asf-filter-label' style = 'width: 20%'></div>" +
            "<div class='asf-filter-input' style = 'width: 80%'></div>" +
        "</div>" +
    "</div>";

var DivTag2blockInput_Lable = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input 1' style ='width: 27%;float:left;'></div>" +
            "<div class='asf-filter-input 2' style ='width: 27%;float:right;'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";

var DivTag2blockLable_Input = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input 1' style ='width: 27%; float:left;'></div>" +
            "<div class='asf-filter-input 2' style ='width: 27%;float:right; '></div>" +
        "</div>" +
    "</div>";
var DivTagmain = "<div class='asf-filter-main' id='{0}'>" +
                    "</div>";
var fieldGroup = "<fieldset id='{0}' style = 'margin-top:20px; margin-bottom:10px;'><legend><label>{1}</label></legend></fieldset>";


$(document).ready(function () {

    // #region --- Layout Processing ---
    
    var value = "";
    // RecruitRequireID
    $("#HRMF2011").prepend(kendo.format(DivTag2block, "divRecruitRequireID"));
    $('#divRecruitRequireID .block-left .asf-filter-label').append($(".RecruitRequireID").children()[0]);
    $('#divRecruitRequireID .block-left .asf-filter-input').append($($(".RecruitRequireID").children()[0]).children());
    $('#divRecruitRequireID .block-right .asf-filter-label').append($(".DutyID").children()[0]);
    $('#divRecruitRequireID .block-right .asf-filter-input').append($($(".DutyID").children()[0]).children());

    // RecruitRequireName
    $("#divRecruitRequireID").after(kendo.format(DivTag1block, "divRecruitRequireName"));
    $('#divRecruitRequireName .block-left .asf-filter-label').append($(".RecruitRequireName").children()[0]);
    $('#divRecruitRequireName .block-left .asf-filter-input').append($($(".RecruitRequireName").children()[0]).children());

    // Group Yêu cầu chung
    value = ASOFT.helper.getLanguageString("HRMF2011.GroupRequireCommon", "HRMF2011", "HRM");
    $("#divRecruitRequireName").after(kendo.format(fieldGroup, "fieldRequireCommon", value));
    $("#fieldRequireCommon").append(kendo.format(DivTag2block, "divGenderAndLevelEdu"));
    $("#fieldRequireCommon").append(kendo.format(DivTag2blockInput_Lable, "divAgeAndExperience"));
    $("#fieldRequireCommon").append(kendo.format(DivTag2blockLable_Input, "divAppearanceAndSalary"));

    $('#divGenderAndLevelEdu .block-left .asf-filter-label').append($(".Gender").children()[0]);
    $('#divGenderAndLevelEdu .block-left .asf-filter-input').append($($(".Gender").children()[0]).children());
    $('#divGenderAndLevelEdu .block-right .asf-filter-label').append($(".EducationLevelID").children()[0]);
    $('#divGenderAndLevelEdu .block-right .asf-filter-input').append($($(".EducationLevelID").children()[0]).children());

    value = ASOFT.helper.getLanguageString("HRMF2011.GroupAge", "HRMF2011", "HRM");
    $('#divAgeAndExperience .block-left .asf-filter-label').append(value);
    $('#divAgeAndExperience .block-left .asf-filter-input.1').append($(".FromAge").children()[0]);
    $('#divAgeAndExperience .block-left .asf-filter-input.1').append($(".FromAge").children()[0]);
    $('#divAgeAndExperience .block-left .asf-filter-input.2').append($(".ToAge").children()[0]);
    $('#divAgeAndExperience .block-left .asf-filter-input.2').append($(".ToAge").children()[0]);
    $('#divAgeAndExperience .block-right .asf-filter-label').append($(".Experience").children()[0]);
    $('#divAgeAndExperience .block-right .asf-filter-input').append($($(".Experience").children()[0]).children());

    $('#divAgeAndExperience .block-left .asf-filter-input.1 .asf-td-caption').css('width', '50%');
    $('#divAgeAndExperience .block-left .asf-filter-input.1 .asf-td-field').css('width', '50%');
    $('#divAgeAndExperience .block-left .asf-filter-input.2 .asf-td-caption').css('width', '50%');
    $('#divAgeAndExperience .block-left .asf-filter-input.2 .asf-td-field').css('width', '50%');


    $('#divAppearanceAndSalary .block-left .asf-filter-label').append($(".Appearance").children()[0]);
    $('#divAppearanceAndSalary .block-left .asf-filter-input').append($($(".Appearance").children()[0]).children());

    value = ASOFT.helper.getLanguageString("HRMF2011.GroupSalary", "HRMF2011", "HRM");
    $('#divAppearanceAndSalary .block-right .asf-filter-label').append(value);
    $('#divAppearanceAndSalary .block-right .asf-filter-input.1').append($(".FromSalary").children()[0]);
    $('#divAppearanceAndSalary .block-right .asf-filter-input.1').append($(".FromSalary").children()[0]);
    $('#divAppearanceAndSalary .block-right .asf-filter-input.2').append($(".ToSalary").children()[0]);
    $('#divAppearanceAndSalary .block-right .asf-filter-input.2').append($(".ToSalary").children()[0]);
    $('#divAppearanceAndSalary .block-right .asf-filter-input.1 .asf-td-caption').css('width', '30%');
    $('#divAppearanceAndSalary .block-right .asf-filter-input.1 .asf-td-field').css('width', '70%');
    $('#divAppearanceAndSalary .block-right .asf-filter-input.2 .asf-td-caption').css('width', '30%');
    $('#divAppearanceAndSalary .block-right .asf-filter-input.2 .asf-td-field').css('width', '70%');

    // Work Description
    // RecruitRequireName
    $("#fieldRequireCommon").after(kendo.format(DivTag1block, "divWorkDescriptionName"));
    $('#divWorkDescriptionName .block-left .asf-filter-label').append($(".WorkDescription").children()[0]);

    // RecruitRequireName
    $("#divWorkDescriptionName").after(kendo.format(DivTag1block, "divWorkDescriptionID"))
    $('#divWorkDescriptionID .block-left .asf-filter-input').append($($(".WorkDescription").children()[0]).children());
    $('#divWorkDescriptionID .block-left .asf-filter-input').css('width', '100%');
    $('#divWorkDescriptionID .block-left .asf-filter-label').css('width', '0%');

    // Group Yêu cầu kỹ năng
    value = ASOFT.helper.getLanguageString("HRMF2011.GroupRequire", "HRMF2011", "HRM");
    $("#divWorkDescriptionID").after(kendo.format(fieldGroup, "fieldRequire", value));

    value = ASOFT.helper.getLanguageString("HRMF2011.GroupRequireLanguage", "HRMF2011", "HRM");
    // Yeu cau ngoai ngu
    $("#fieldRequire").append(kendo.format(fieldGroup, "fieldRequireLanguage", value));
    // Ngoai ngu 1
    $("#fieldRequireLanguage").append(kendo.format(DivTag2block, "divLanguage1ID"));
    $('#divLanguage1ID .block-left .asf-filter-label').append($(".Language1ID").children()[0]);
    $('#divLanguage1ID .block-left .asf-filter-input').append($($(".Language1ID").children()[0]).children());
    $('#divLanguage1ID .block-right .asf-filter-label').append($(".LanguageLevel1ID").children()[0]);
    $('#divLanguage1ID .block-right .asf-filter-input').append($($(".LanguageLevel1ID").children()[0]).children());
    // Ngoai ngu 2
    $("#fieldRequireLanguage").append(kendo.format(DivTag2block, "divLanguage2ID"));
    $('#divLanguage2ID .block-left .asf-filter-label').append($(".Language2ID").children()[0]);
    $('#divLanguage2ID .block-left .asf-filter-input').append($($(".Language2ID").children()[0]).children());
    $('#divLanguage2ID .block-right .asf-filter-label').append($(".LanguageLevel2ID").children()[0]);
    $('#divLanguage2ID .block-right .asf-filter-input').append($($(".LanguageLevel2ID").children()[0]).children());
    // Ngoai ngu 3
    $("#fieldRequireLanguage").append(kendo.format(DivTag2block, "divLanguage3ID"));
    $('#divLanguage3ID .block-left .asf-filter-label').append($(".Language3ID").children()[0]);
    $('#divLanguage3ID .block-left .asf-filter-input').append($($(".Language3ID").children()[0]).children());
    $('#divLanguage3ID .block-right .asf-filter-label').append($(".LanguageLevel3ID").children()[0]);
    $('#divLanguage3ID .block-right .asf-filter-input').append($($(".LanguageLevel3ID").children()[0]).children());

    // InformaticsLevel
    $("#fieldRequire").append(kendo.format(DivTag1block, "divInformaticsLevelName"));
    $('#divInformaticsLevelName .block-left .asf-filter-label').append($(".IsInformatics").children()[1]);
    $('#divInformaticsLevelName .block-left .asf-filter-label').css('padding', '0px');
    $('#divInformaticsLevelName .block-left .asf-filter-label').css('width', '100%');
    $('#divInformaticsLevelName .block-left .asf-filter-input').css('width', '0%');
    $('#divInformaticsLevelName').css('padding', '0px');
    $('#divInformaticsLevelName .block-left .asf-filter-label .asf-td-field').css('padding', '0px');

    // RecruitRequireName
    $("#fieldRequire").append(kendo.format(DivTag1block, "divInformaticsLevelID"))
    $('#divInformaticsLevelID .block-left .asf-filter-input').append($($(".InformaticsLevel").children()[1]).children());
    $('#divInformaticsLevelID .block-left .asf-filter-input').css('width', '100%');
    $('#divInformaticsLevelID .block-left .asf-filter-label').css('width', '0%');

    // Creativeness
    $("#fieldRequire").append(kendo.format(DivTag1block, "divCreativenesslName"));
    $('#divCreativenesslName .block-left .asf-filter-label').append($(".IsCreativeness").children()[1]);
    $('#divCreativenesslName .block-left .asf-filter-label').css('padding', '0px');
    $('#divCreativenesslName').css('padding', '0px');
    $('#divCreativenesslName .block-left .asf-filter-label').css('width', '100%');
    $('#divCreativenesslName .block-left .asf-filter-input').css('width', '0%');
    $('#divCreativenesslName .block-left .asf-filter-label .asf-td-field').css('padding', '0px');
    // Creativeness
    $("#fieldRequire").append(kendo.format(DivTag1block, "divCreativenessID"))
    $('#divCreativenessID .block-left .asf-filter-input').append($($(".Creativeness").children()[1]).children());
    $('#divCreativenessID .block-left .asf-filter-input').css('width', '100%');
    $('#divCreativenessID .block-left .asf-filter-label').css('width', '0%');

    // ProblemSolving
    $("#fieldRequire").append(kendo.format(DivTag1block, "divProblemSolvingName"));
    $('#divProblemSolvingName .block-left .asf-filter-label').append($(".IsProblemSolving").children()[1]);
    $('#divProblemSolvingName .block-left .asf-filter-label').css('padding', '0px');
    $('#divProblemSolvingName').css('padding', '0px');
    $('#divProblemSolvingName .block-left .asf-filter-label').css('width', '100%');
    $('#divProblemSolvingName .block-left .asf-filter-input').css('width', '0%');
    $('#divProblemSolvingName .block-left .asf-filter-label .asf-td-field').css('padding', '0px');
    $("#fieldRequire").append(kendo.format(DivTag1block, "divProblemSolvingID"))
    $('#divProblemSolvingID .block-left .asf-filter-input').append($($(".ProblemSolving").children()[1]).children());
    $('#divProblemSolvingID .block-left .asf-filter-input').css('width', '100%');
    $('#divProblemSolvingID .block-left .asf-filter-label').css('width', '0%');

    // Prsentation
    $("#fieldRequire").append(kendo.format(DivTag1block, "divPrsentationName"));
    $('#divPrsentationName .block-left .asf-filter-label').append($(".IsPrsentation").children()[1]);
    $('#divPrsentationName .block-left .asf-filter-label').css('padding', '0px');
    $('#divPrsentationName').css('padding', '0px');
    $('#divPrsentationName .block-left .asf-filter-label').css('width', '100%');
    $('#divPrsentationName .block-left .asf-filter-input').css('width', '0%');
    $('#divPrsentationName .block-left .asf-filter-label .asf-td-field').css('padding', '0px');
    $("#fieldRequire").append(kendo.format(DivTag1block, "divPrsentationID"))
    $('#divPrsentationID .block-left .asf-filter-input').append($($(".Prsentation").children()[1]).children());
    $('#divPrsentationID .block-left .asf-filter-input').css('width', '100%');
    $('#divPrsentationID .block-left .asf-filter-label').css('width', '0%');

    // Communication
    $("#fieldRequire").append(kendo.format(DivTag1block, "divCommunicationName"));
    $('#divCommunicationName .block-left .asf-filter-label').append($(".IsCommunication").children()[1]);
    $('#divCommunicationName .block-left .asf-filter-label').css('padding', '0px');
    $('#divCommunicationName').css('padding', '0px');
    $('#divCommunicationName .block-left .asf-filter-label').css('width', '100%');
    $('#divCommunicationName .block-left .asf-filter-input').css('width', '0%');
    $('#divCommunicationName .block-left .asf-filter-label .asf-td-field').css('padding', '0px');
    $("#fieldRequire").append(kendo.format(DivTag1block, "divCommunicationID"))
    $('#divCommunicationID .block-left .asf-filter-input').append($($(".Communication").children()[1]).children());
    $('#divCommunicationID .block-left .asf-filter-input').css('width', '100%');
    $('#divCommunicationID .block-left .asf-filter-label').css('width', '0%');

    // Yeu cau Sức khỏe
    value = ASOFT.helper.getLanguageString("HRMF2011.GroupRequireHealth", "HRMF2011", "HRM");
    $("#fieldRequire").append(kendo.format(fieldGroup, "fieldRequireHealth", value));
    // Height and Weight
    $("#fieldRequireHealth").append(kendo.format(DivTag2block, "divHeightAndWeight"));
    $('#divHeightAndWeight .block-left .asf-filter-label').append($(".Height").children()[0]);
    $('#divHeightAndWeight .block-left .asf-filter-input').append($($(".Height").children()[0]).children());
    $('#divHeightAndWeight .block-right .asf-filter-label').append($(".Weight").children()[0]);
    $('#divHeightAndWeight .block-right .asf-filter-input').append($($(".Weight").children()[0]).children());

    // HeightStatus
    $("#fieldRequireHealth").append(kendo.format(DivTag2block, "divHeightStatus"));
    $('#divHeightStatus .block-left .asf-filter-label').append($(".HealthStatus").children()[0]);
    $('#divHeightStatus .block-left .asf-filter-input').append($($(".HealthStatus").children()[0]).children());

    // Notes
    $("#fieldRequireHealth").append(kendo.format(DivTag1block, "divNotes"));
    $('#divNotes .block-left .asf-filter-label').append($(".Notes").children()[0]);
    $('#divNotes .block-left .asf-filter-input').append($($(".Notes").children()[0]).children());

    // Disabled
    $("#fieldRequire").after(kendo.format(DivTag1block, "divDisabled"));
    $('#divDisabled .block-left .asf-filter-input').append($(".Disabled"));

    $("#HRMF2011 .container_12").css('display', 'none');

    $("#DutyName").attr('disabled', 'disabled');

    // #endregion --- Layout Processing ---

    CatchEvents();

    // After Loading
    EventTriggering();

    if ($("#isUpdate").val() == 'False') {
        autoCode();
    }
});

/**
 * Bắt các Events
 * @returns {} 
 * @since [Văn Tài] Created [15/11/2017]
 */
function CatchEvents() {
    // CheckBox Trình độ tin học
    $("#IsInformatics").change(function () {
        var key = "InformaticsLevel";
        if (this.checked) {
            $("#" + key).attr("readonly", false);
        } else {
            $("#" + key).attr("readonly", true);
            $("#" + key).val("");
        }
    });

    // CheckBox Khả năng sáng tạo
    $("#IsCreativeness").change(function () {
        var key = "Creativeness";
        if (this.checked) {
            $("#" + key).attr("readonly", false);
        } else {
            $("#" + key).attr("readonly", true);
            $("#" + key).val("");
        }
    });

    // CheckBox Khả năng giải quyết vấn đề
    $("#IsProblemSolving").change(function () {
        var key = "ProblemSolving";
        if (this.checked) {
            $("#" + key).attr("readonly", false);
        } else {
            $("#" + key).attr("readonly", true);
            $("#" + key).val("");
        }
    });

    // CheckBox Khả năng trình bày, thuyết phục
    $("#IsPrsentation").change(function () {
        var key = "Prsentation";
        if (this.checked) {
            $("#" + key).attr("readonly", false);
        } else {
            $("#" + key).attr("readonly", true);
            $("#" + key).val("");
        }
    });

    // CheckBox Khả năng giao tiếp
    $("#IsCommunication").change(function () {
        var key = "Communication";
        if (this.checked) {
            $("#" + key).attr("readonly", false);
        } else {
            $("#" + key).attr("readonly", true);
            $("#" + key).val("");
        }
    });
}

/**
 * Chạy kích hoạt sự kiện
 * @returns {} 
 * @since [Văn Tài] Created [15/11/2017]
 */
function EventTriggering() {
    $("#IsInformatics").trigger("change");
    $("#IsCreativeness").trigger("change");
    $("#IsProblemSolving").trigger("change");
    $("#IsPrsentation").trigger("change");
    $("#IsCommunication").trigger("change");
}

/**  
* [Kieu Nga] Create New [13/12/2017]
**/

function autoCode() {
    var url = "/HRM/Common/GetVoucherNoText"
    ASOFT.helper.postTypeJson(url, { tableID: "HRMT2010" }, function (result) {
        if (result) {
            $("#RecruitRequireID").val(result);
            oldVoucherNo = result;
        }
    })
}

/**  
* Process after insert data
*
* [Kieu Nga] Create New [13/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate") != "True")) {
        var url = "/HRM/Common/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo, tableID: "HRMT2010" }, null);
        autoCode();
    }
}