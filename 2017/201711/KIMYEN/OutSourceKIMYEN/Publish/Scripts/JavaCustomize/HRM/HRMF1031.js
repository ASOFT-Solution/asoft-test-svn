// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    29/09/2017  Văn Tài         Create New
// ##################################################################

// #region --- Copied Methods ---

var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo
        .format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>",
            templateClass,
            textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName,
            textFileID,
            textFileName);
};

var templateAsoftButton = function () {
    this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
        return kendo
            .format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
                buttonClass,
                buttonID,
                spanClass,
                buttonCaption,
                onclickFunction);
    };

    this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
        return kendo
            .format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
                buttonID,
                onclickFunction);
    };

    return this;
};

setButtonDeleteDisableWhenObjectChange = function ($Object, $ButtonDelete, buttonEventClick) {

    if (typeof $Object !== "undefined" && typeof $ButtonDelete !== "undefined") {
        if (typeof $Object.val === "function" && typeof $Object.val() !== "undefined") {
            $Object.val() == ""
                ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
                : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false)
                .children()
                .removeClass("disabledButton");
        }
        if (typeof $Object.value === "function" && $Object.value() !== "undefined") {
            $Object.value() == ""
                ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
                : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false)
                .children()
                .removeClass("disabledButton");
        }
    }
    return false;
}

var ListChoose = {
    "AttachID": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {

                var objFileName = obj.AttachName,

                    objFileID = obj.APK;

                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
            }),

            parentAttach = $("#AttachID").parent(),

            templeteAll = templeteAll.join(""),

            $attach = $("#AttachID");

        $templeteParent.remove();

        templeteParent = "<div class='templeteAll'>{0}</div>";

        parentAttach.append(kendo.format(templeteParent, templeteAll));

        // SET STYLE
        $(".templeteAll").attr("style", "overflow: scroll; height: 96px");


        var objFileID = result.map(function (obj) {
            return {
                "APK": obj.APK,
                "DivisionID": obj.DivisionID,
                "AttachID": obj.AttachID
            }
        });

        $attach.val(JSON.stringify(objFileID)).trigger("change");

        $(".x-close")
            .unbind("click")
            .bind("click",
                function () {
                    deleteFile($(this));
                });
    }
};

function getResultAfterDelete(result, apkDelete) {

    var $resultAfterDelete = $.map(result,
    (function (obj) {

        if (obj.APK != apkDelete)
            return obj;
    }));

    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#AttachID"),

        $result = $attach.val().split(','),

        $resultAfterDelete = getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}

function btnUpload_click(e) {

    SCREEN1031.CurrentChoose = SCREEN1031.ACTION_CHOOSE_ATTACH;

    var urlPopup3 = "/AttachFile?Type=2";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    currentChoose = "AttachID";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#AttachID").val("").trigger("change");
}

// #endregion --- Copied Methods ---

$(document)
    .ready(function () {

        // #region --- Catch Data | Không ảnh hưởng tới luồng chạy ---

        SCREEN1031.isUpdate = $('#isUpdate').val() === "True";
        SCREEN1031.isInherit = $('#isInherit').val() === "True";

        //$("#btn-ImageID_HRMT1030").kendoButton({ "click": btnImageIDHRMT1030_Click });

        if (!SCREEN1031.isUpdate) { // Add New
            SCREEN1031.GenCandidateID();
        } else { // Update 
            SCREEN1031.APK = $("#" + SCREEN1031.FIELD_APK).val();
            SCREEN1031.DivisionID = $("#" + SCREEN1031.FIELD_DIVISIONID).val();
        }

        // #endregion --- Catch Data | Không ảnh hưởng tới luồng chạy ---

        // #region --- First Load : Step by Step ---

        // Step 1
        SCREEN1031.DeleteControls();
        // Next Step
        SCREEN1031.SwapTab();

        // Next Step
        SCREEN1031.InsertControlsTab01();
        SCREEN1031.InsertControlsTab02();
        SCREEN1031.InsertControlsTab05();

        // Next Step
        SCREEN1031.MoveControlTab01();
        SCREEN1031.MoveControlTab02();
        SCREEN1031.MoveControlTab03();
        SCREEN1031.MoveControlTab05();

        // Next Step
        SCREEN1031.MoveControlHeader();

        //Next Step
        SCREEN1031.GetLanguage();

        // #endregion --- First Load : Step by Step ---

        // #region --- Xử lý chạy ngoài core ---

        SCREEN1031.UnbindControl();

        // #endregion --- Xử lý chạy ngoài core ----

        // #region --- Xử lý File đính kèm ---

        var templeteButton = new templateAsoftButton();
        $('#AttachID').css('display', 'none');
        if (SCREEN1031.isUpdate != "True") {
            $("#AttachID")
                .change(function () {
                    setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click);
                })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") +
                    templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            $('.FirstName').after($(".AttachID"))
            $($(".AttachID").children()[0]).css("width", "14%");
        }

        $("input[value='HRMT1030Tab01']").remove();
        $("input[value='HRMT1030Tab02']").remove();

        var tbdemo = ASOFT.helper.dataFormToJSON(id);
        tableName = tbdemo["tableNameEdit"];

        // #endregion --- Xử lý File đính kèm ---

        // #region --- After Loading ---

        SCREEN1031.GridHRMT1033Events();
        SCREEN1031.GridHRMT1034Events();
        SCREEN1031.AllEvents();
        SCREEN1031.SettingControls();

        if (SCREEN1031.isUpdate) {
            SCREEN1031.LoadAttaches();
            SCREEN1031.LoadDISC();
        }

        // #endregion --- After Loading ---

        // #region -- AT LAST: Testing Regions ---

        // #endregion --- AT LAST: Testing Regions ---
    });

// SCREEN1031: HRMF1031
SCREEN1031 = new function () {

    // #region --- Constants ---

    // #region --- Actions ---

    this.ACTION_CHOOSE_ATTACH = "CHOOSE_ATTACH";
    this.ACTION_CHOOSE_RECRUITTURN = "CHOOSE_RECRUITURN";

    // #endregion --- Actions ---

    this.TABLE_HRMT1030 = "HRMT1030";
    this.TABLE_HRMT1033 = "HRMT1033";
    this.TABLE_HRMT1034 = "HRMT1034";
    this.SCREEN_ID = "HRMF1031";

    this.GRID_HRMT1033 = "GridEditHRMT1033";
    this.GRID_HRMT1034 = "GridEditHRMT1034";

    // Field Name
    // Master
    this.FIELD_APK = "APK";
    this.FIELD_DIVISIONID = "DivisionID";
    this.FIELD_CANDIDATEID = "CandidateID";
    this.FIELD_FIRSTNAME = "FirstName";
    this.FIELD_MIDDLENAME = "MiddleName";
    this.FIELD_LASTNAME = "LastName";
    this.FIELD_IMAGEID = "ImageID";
    this.FIELD_ATTACHID = "AttachID";
    this.FIELD_CITYID = "CityID";
    // #region --- Tab01 ---
    this.FIELD_BIRTHDAY = "Birthday";
    this.FIELD_BORNPLACE = "BornPlace";
    this.FIELD_NATIONALITYID = "NationalityID";
    this.FIELD_ETHNICNAME = "EthnicName";
    this.FIELD_ETHNICID = "EthnicID";
    this.FIELD_RELIGIONNAME = "ReligionName";
    this.FIELD_RELIGIONID = "ReligionID";
    this.FIELD_NATIVECOUNTRY = "NativeCountry";
    this.FIELD_IDENTIFYCARDNO = "IdentifyCardNo";
    this.FIELD_IDENTIFYPLACE = "IdentifyPlace";
    this.FIELD_IDENTIFYCITY = "IdentifyCity";
    this.FIELD_IDENTIFYCITYID = "IdentifyCityID";
    this.FIELD_IDENTIFYDATE = "IdentifyDate";
    this.FIELD_GENDER = "Gender";
    this.FIELD_ISSINGLE = "IsSingle";
    this.FIELD_HEALTHSTATUS = "HealthStatus";
    this.FIELD_HEIGHT = "Height";
    this.FIELD_WEIGHT = "Weight";
    this.FIELD_PASSPORTNO = "PassportNo";
    this.FIELD_PASSPORTDATE = "PassportDate";
    this.FIELD_PASSPORTEND = "PassportEnd";
    this.FIELD_PERMANENTADDRESS = "PermanentAddress";
    this.FIELD_TEMPORARYADDRESS = "TemporaryAddress";
    this.FIELD_PHONENUMBER = "PhoneNumber";
    this.FIELD_EMAIL = "Email";
    this.FIELD_FAX = "Fax";
    this.FIELD_NOTE = "Note";
    // #endregion --- Tab01 ---

    // #region --- Tab02 ---
    this.FIELD_RECPERIODID = "RecPeriodID";
    this.FIELD_RECPERIODNAME = "RecPeriodName";
    this.FIELD_DEPARTMENTID = "DepartmentID";
    this.FIELD_DEPARTMENTNAME = "DepartmentName";
    this.FIELD_DUTYID = "DutyID";
    this.FIELD_DUTYNAME = "DutyName";
    this.FIELD_RECEIVEFILEDATE = "ReceiveFileDate";
    this.FIELD_RECEIVEFILEPLACE = "ReceiveFilePlace";
    this.FIELD_RECRUITSTATUS = "RecruitStatus";
    this.FIELD_RESOURCEID = "ResourceID";
    this.FIELD_RESOURCENAME = "ResourceName";
    this.FIELD_WORKTYPE = "WorkType";
    this.FIELD_STARTDATE = "Startdate";
    this.FIELD_REQUIRESALARY = "RequireSalary";
    this.FIELD_RECREASON = "RecReason";
    this.FIELD_STRENGTH = "Strength";
    this.FIELD_WEAKNESS = "Weakness";
    this.FIELD_CAREERAIM = "CareerAim";
    this.FIELD_PERSONALAIM = "PersonalAim";
    this.FIELD_APTITUDE = "Aptitude";
    this.FIELD_HOBBY = "Hobby";

    // #endregion --- Tab02 ---

    // #region --- Tab03 ---

    this.FIELD_EDUCATIONLEVELID = "EducationLevelID";
    this.FIELD_INFORMATICSLEVEL = "InformaticsLevel";
    this.FIELD_INFORMATICSLEVELID = "InformaticsLevelID";
    this.FIELD_POLITICSID = "PoliticsID";
    this.FIELD_LANGUAGEID = "LanguageID";
    this.FIELD_LANGUAGELEVELID = "LanguageLevelID";

    this.FIELD_LANGUAGE1ID = "Language1ID";
    this.FIELD_LANGUAGELEVEL1ID = "LanguageLevel1ID";
    this.FIELD_LANGUAGE2ID = "Language2ID";
    this.FIELD_LANGUAGELEVEL2ID = "LanguageLevel2ID";
    this.FIELD_LANGUAGE3ID = "Language3ID";
    this.FIELD_LANGUAGELEVEL3ID = "LanguageLevel3ID";

    // Grid HRMT1033
    this.FIELD_COMPANYNAME = "CompanyName";
    this.FIELD_COMPANYADDRESS = "CompanyAddress";
    this.FIELD_COUNTRYID = "CountryID";
    this.FIELD_COUNTRYNAME = "CountryName";
    this.FIELD_FROMDATE = "FromDate";
    this.FIELD_TODATE = "ToDate";
    this.FIELD_DUTY = "Duty";
    this.FIELD_NOTES = "Notes";

    // Grid HRMT1034
    this.FIELD_EDUCATIONCENTER = "EducationCenter";
    this.FIELD_EDUCATIONMAJOR = "EducationMajor";
    this.FIELD_EDUCATIONFROMDATE = "EducationFromDate";
    this.FIELD_EDUCATIONTODATE = "EducationToDate";
    this.FIELD_EDUCATIONTYPEID = "EducationTypeID";
    this.FIELD_EDUCATIONTYPENAME = "EducationTypeName";
    this.FIELD_DESCRIPTION = "Description";

    // #endregion --- Tab03 ---

    // #region --- Tab04 ---

    // #endregion --- Tab04 ---

    // #region --- Tab05 ---

    this.FIELD_EVALUATIONDATE = "EvaluationDate";
    this.FIELD_NATURE_D = "Nature_D";
    this.FIELD_NATURE_I = "Nature_I";
    this.FIELD_NATURE_S = "Nature_S";
    this.FIELD_NATURE_C = "Nature_C";
    this.FIELD_NATURE = "Nature";
    this.FIELD_ADAPTIVE_D = "Adaptive_D";
    this.FIELD_ADAPTIVE_I = "Adaptive_I";
    this.FIELD_ADAPTIVE_S = "Adaptive_S";
    this.FIELD_ADAPTIVE_C = "Adaptive_C";
    this.FIELD_ADAPTIVE = "Adaptive";
    this.FIELD_DESCRIPTION = "Description";


    // #endregion --- Tab05 ---


    // IDs
    // khung table chứa các trường
    this.ID_TABLE_TAB01 = "TABLE_TAB01";
    this.ID_TABLE_TAB02 = "TABLE_TAB02";

    // id của tab
    this.ID_TAB01 = "Tabs-1";
    this.ID_TAB02 = "Tabs-2";
    this.ID_TAB03 = "Tabs-3";
    this.ID_TAB04 = "Tabs-4";
    this.ID_TAB05 = "Tabs-5";

    // #endregion --- Constants ---

    // #region --- Variables & Controls ---

    // Variables 
    this.CurrentChoose = null;
    this.isUpdate = null;
    this.isInherit = null;
    this.SaveSuccess = false;

    this.DivisionID = "";
    this.APK = "";

    this.EmployeeID = $("#CandidateID").val();
    this.DepartmentID = $("#DepartmentID").val();
    this.DutyID = $("#DutyID").val();

    this.oldID = "";

    // Controls
    // Grids
    this.GridHRMT1033 = null;
    this.GridHRMT1034 = null;

    // #endregion --- Variables & Controls ---

    // #region --- Methods ---

    // Xóa một số controls
    this.DeleteControls = function () {
        var tab1 = "GridEditHRMT1030Tab01";
        var tab2 = "GridEditHRMT1030Tab02";

        var gridTab01 = $("#" + tab1).kendoGrid().data("kendoGrid");
        var gridTab02 = $("#" + tab2).kendoGrid().data("kendoGrid");

        if (SCREEN1031.IsNotNullOrUndefined(gridTab01)) {
            gridTab01.destroy();
            $("#" + tab1).empty();
            document.getElementById("GridEditHRMT1030Tab01").remove();
        }
        if (SCREEN1031.IsNotNullOrUndefined(gridTab02)) {
            gridTab02.destroy();
            $("#" + tab2).empty();
            document.getElementById("GridEditHRMT1030Tab02").remove();
        }

        if (!SCREEN1031.isUpdate) {
            $("#Tabs-5").remove();
            $("#HRMT10341").remove();
        }
    };

    // Di chuyển tab 4 lên trước tab 3
    this.SwapTab = function () {
        // Chuyển tab header và nội dung 
        $("#HRMT1033").before($("#HRMT1034"));
        $("#Tabs-3").before($("#Tabs-4"));
    };

    // Insert Controsl 
    this.InsertControlsTab01 = function () {
        $.ajax({
            url: '/Partial/PartialHRMF1030_Tab01',
            async: false,
            success: function (result) {
                $("#" + SCREEN1031.ID_TAB01).append(result);
            }
        });
    };

    this.InsertControlsTab02 = function () {
        $.ajax({
            url: '/Partial/PartialHRMF1030_Tab02',
            async: false,
            success: function (result) {
                $("#" + SCREEN1031.ID_TAB02).append(result);
            }
        });
    };

    /**
        * Insert cấu trúc tab DISC
        * @returns {} 
        * @since [Văn Tài] Created [12/12/2017]
        */
    this.InsertControlsTab05 = function () {
        $.ajax({
            url: '/Partial/PartialHRMF1030_Tab05',
            async: false,
            success: function (result) {

                $("#" + SCREEN1031.ID_TAB05).append(result);
            }
        });
    };
    /**
        * Viết lại một số sự kiện
        * @returns {} 
        * @since [Văn Tài] Created [04/10/2017]
        */
    this.UnbindControl = function () {
        $("#SaveNew").unbind("click");
        $("#SaveClose").unbind("click");
        $("#BtnSave").unbind("click");
        $("#Close").unbind("click");
    };

    /**
     * Thiết lập một số controls
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SettingControls = function () {
        if (SCREEN1031.isUpdate) {
            $("#" + SCREEN1031.FIELD_CANDIDATEID).prop("readonly", true);
        } else {
            SCREEN1031.SetRadioButtonValue(SCREEN1031.FIELD_ISSINGLE, 0);
        }
    }

    /**
         * Gen mã hồ sơ ứng viên
         * @returns {} 
         * @since [Văn Tài] Created [18/12/2017]
         */
    this.GenCandidateID = function () {

        var url = "/HRM/Common/GetVoucherNoText";
        ASOFT.helper.postTypeJson(url,
            { tableID: "HRMF1031" },
            function (result) {
                if (result) {
                    $("#" + SCREEN1031.FIELD_CANDIDATEID).val(result);
                    SCREEN1031.oldID = result;
                }
            });
    };

    /**
     * Thực hiện Gen mã mới 
     * @returns {} 
     * @since [Văn Tài] Created [25/12/2017]
     */
    this.ReGenCandidateID = function () {
        //var oldID = $("#" + SCREEN1031.FIELD_RECRUITPERIODID).val();
        var url = "/HRM/Common/UpdateVoucherNo";
        ASOFT.helper.postTypeJson(url, { VoucherNo: SCREEN1031.oldID, tableID: "HRMF1031" }, null);

        SCREEN1031.GenCandidateID();
    };

    /**
     * Hoạt động sau khi Lưu
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.AfterSaveProcessing = function (saveState) {
        SCREEN1031.SetTextBoxValue(SCREEN1031.FIELD_CANDIDATEID);

        ASOFT.form.displayInfo('#' + SCREEN1031.SCREEN_ID, ASOFT.helper.getMessage("00ML000015"));

        if (saveState == 0) {

            // #region --- TextBox: ResetText ---
            var resetTextBoxList = [
                SCREEN1031.FIELD_CANDIDATEID,
                SCREEN1031.FIELD_FIRSTNAME,
                SCREEN1031.FIELD_MIDDLENAME,
                SCREEN1031.FIELD_LASTNAME,
                SCREEN1031.FIELD_ATTACHID,
                SCREEN1031.FIELD_BORNPLACE,
                SCREEN1031.FIELD_NATIVECOUNTRY,
                SCREEN1031.FIELD_IDENTIFYPLACE,
                SCREEN1031.FIELD_IDENTIFYCARDNO,
                SCREEN1031.FIELD_HEALTHSTATUS,
                SCREEN1031.FIELD_HEIGHT,
                SCREEN1031.FIELD_WEIGHT,
                SCREEN1031.FIELD_PASSPORTNO,
                SCREEN1031.FIELD_PASSPORTEND,
                SCREEN1031.FIELD_PERMANENTADDRESS,
                SCREEN1031.FIELD_TEMPORARYADDRESS,
                SCREEN1031.FIELD_PHONENUMBER,
                SCREEN1031.FIELD_EMAIL,
                SCREEN1031.FIELD_FAX,
                SCREEN1031.FIELD_NOTE,
                SCREEN1031.FIELD_RECPERIODID,
                SCREEN1031.FIELD_RECPERIODNAME,
                SCREEN1031.FIELD_RECEIVEFILEDATE,
                SCREEN1031.FIELD_REQUIRESALARY,
                SCREEN1031.FIELD_RECREASON,
                SCREEN1031.FIELD_STRENGTH,
                SCREEN1031.FIELD_WEAKNESS,
                SCREEN1031.FIELD_CAREERAIM,
                SCREEN1031.FIELD_PERSONALAIM,
                SCREEN1031.FIELD_APTITUDE,
                SCREEN1031.FIELD_HOBBY
            ];
            var i;
            for (i = 0; i < resetTextBoxList.length; i++) {
                SCREEN1031.SetTextBoxValue(resetTextBoxList[i], "");
            }
            // #endregion --- TextBox: ResetText ---

            // #region --- DateTimePicker: ResetText ---

            var resetDateValueList = [
            SCREEN1031.FIELD_BIRTHDAY,
            SCREEN1031.FIELD_PASSPORTDATE,
            SCREEN1031.FIELD_PASSPORTEND,
            SCREEN1031.FIELD_RECEIVEFILEDATE,
            SCREEN1031.FIELD_STARTDATE
            ];

            for (i = 0; i < resetDateValueList.length; i++) {
                SCREEN1031.SetDateTimePickerValue(resetDateValueList[i], "");
            }

            // #endregion --- DateTimePicker: ResetText ---

            // #region --- ComboBox: ResetText ---

            var resetComboValueList = [
                SCREEN1031.FIELD_NATIONALITYID,
                SCREEN1031.FIELD_ETHNICID,
                SCREEN1031.FIELD_RELIGIONID,
                SCREEN1031.FIELD_GENDER,
                SCREEN1031.FIELD_IDENTIFYCITYID,
                SCREEN1031.FIELD_DEPARTMENTID,
                SCREEN1031.FIELD_DUTYID,
                SCREEN1031.FIELD_RECRUITSTATUS,
                SCREEN1031.FIELD_RESOURCEID,
                SCREEN1031.FIELD_WORKTYPE,
                SCREEN1031.FIELD_EDUCATIONLEVELID,
                SCREEN1031.FIELD_INFORMATICSLEVEL,
                SCREEN1031.FIELD_POLITICSID,
                SCREEN1031.FIELD_LANGUAGE1ID,
                SCREEN1031.FIELD_LANGUAGE2ID,
                SCREEN1031.FIELD_LANGUAGE3ID,
                SCREEN1031.FIELD_LANGUAGELEVEL1ID,
                SCREEN1031.FIELD_LANGUAGELEVEL2ID,
                SCREEN1031.FIELD_LANGUAGELEVEL3ID
            ];

            for (i = 0; i < resetComboValueList.length; i++) {
                SCREEN1031.SetComboBoxValue(resetComboValueList[i], "");
            }

            // #endregion --- ComboBox: ResetText ---

            // #region --- RadioButton: Default Value ---

            SCREEN1031.SetRadioButtonValue(SCREEN1031.FIELD_ISSINGLE, 0);

            // #endregion --- RadioButton: Default Value ---

            // #region --- KendoGrid: Reset Value ---

            SCREEN1031.GridHRMT1033.dataSource.data([]);
            SCREEN1031.GridHRMT1033.dataSource.add({});

            SCREEN1031.GridHRMT1034.dataSource.data([]);
            SCREEN1031.GridHRMT1034.dataSource.add({});

            // #endregion --- KendoGrid: Reset Value ---
        }

        // Gen mã mới
        if (!(SCREEN1031.isUpdate)) {
            SCREEN1031.ReGenCandidateID();
        }
    }

    /**
     * Lấy danh sách đính kèm
     * @returns {} 
     * @since [Văn Tài] Created [12/10/2017]
     */
    this.LoadAttaches = function () {
        var url = "/HRM/HRMF1031/LoadAttaches";
        var sendData = {
            pAPKMaster: SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_CANDIDATEID),
            pRelatedToTypeID_REL: 4
        };
        ASOFT.helper.postTypeJson(url, sendData, function (result) {
            if (result && result.length > 0) {
                SCREEN1031.CurrentChoose = SCREEN1031.ACTION_CHOOSE_ATTACH;
                receiveResult(result);
            }
        });
    }

    /**
 * Lấy D.I.S.C
 * @since [Kiều Nga] Created [18/12/2017]
 */
    this.LoadDISC = function () {
        var CandidateID = $("#CandidateID").val();
        ASOFT.helper.postTypeJson('/HRM/HRMF1031/LoadDISC', { EmployeeID: CandidateID }, function (result) {
            $("#EvaluationDate").data("kendoDatePicker").value(result.EvaluationDate);
            $("#Nature_D").val(result.Nature_D);
            $("#Nature_I").val(result.Nature_I);
            $("#Nature_S").val(result.Nature_S);
            $("#Nature_C").val(result.Nature_C);
            $("#Nature").val(result.Nature);
            $("#Adaptive_D").val(result.Adaptive_D);
            $("#Adaptive_I").val(result.Adaptive_I);
            $("#Adaptive_S").val(result.Adaptive_S);
            $("#Adaptive_C").val(result.Adaptive_C);
            $("#Adaptive").val(result.Adaptive);
            $("#Description").val(result.Description);
        });
    }

    /**
     * Lấy toàn bộ dữ liệu
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetAllData = function () {
        var data = {};
        data.dataMaster = {};
        data.GridHRMT1033 = {};
        data.GridHRMT1034 = {};

        // #region --- Main Value ---

        if (SCREEN1031.isUpdate) {
            data.dataMaster[SCREEN1031.FIELD_DIVISIONID] = SCREEN1031.DivisionID;
            data.dataMaster[SCREEN1031.FIELD_APK] = SCREEN1031.APK;
        }

        // #endregion --- Main Value ---

        // #region --- TextBoxes Value ---
        var textValueList = [
            SCREEN1031.FIELD_CANDIDATEID,
            SCREEN1031.FIELD_FIRSTNAME,
            SCREEN1031.FIELD_MIDDLENAME,
            SCREEN1031.FIELD_LASTNAME,
            SCREEN1031.FIELD_ATTACHID,
            SCREEN1031.FIELD_BORNPLACE,
            SCREEN1031.FIELD_NATIVECOUNTRY,
            SCREEN1031.FIELD_IDENTIFYPLACE,
            SCREEN1031.FIELD_IDENTIFYCARDNO,
            SCREEN1031.FIELD_HEALTHSTATUS,
            SCREEN1031.FIELD_HEIGHT,
            SCREEN1031.FIELD_WEIGHT,
            SCREEN1031.FIELD_PASSPORTNO,
            SCREEN1031.FIELD_PASSPORTEND,
            SCREEN1031.FIELD_PERMANENTADDRESS,
            SCREEN1031.FIELD_TEMPORARYADDRESS,
            SCREEN1031.FIELD_PHONENUMBER,
            SCREEN1031.FIELD_EMAIL,
            SCREEN1031.FIELD_FAX,
            SCREEN1031.FIELD_NOTE,
            SCREEN1031.FIELD_RECPERIODID,
            SCREEN1031.FIELD_RECEIVEFILEPLACE,
            SCREEN1031.FIELD_REQUIRESALARY,
            SCREEN1031.FIELD_RECREASON,
            SCREEN1031.FIELD_STRENGTH,
            SCREEN1031.FIELD_WEAKNESS,
            SCREEN1031.FIELD_CAREERAIM,
            SCREEN1031.FIELD_PERSONALAIM,
            SCREEN1031.FIELD_APTITUDE,
            SCREEN1031.FIELD_HOBBY,
            SCREEN1031.FIELD_EVALUATIONDATE,
            SCREEN1031.FIELD_NATURE_D,
            SCREEN1031.FIELD_NATURE_I,
            SCREEN1031.FIELD_NATURE_S,
            SCREEN1031.FIELD_NATURE_C,
            SCREEN1031.FIELD_NATURE,
            SCREEN1031.FIELD_ADAPTIVE_D,
            SCREEN1031.FIELD_ADAPTIVE_I,
            SCREEN1031.FIELD_ADAPTIVE_S,
            SCREEN1031.FIELD_ADAPTIVE_C,
            SCREEN1031.FIELD_ADAPTIVE,
            SCREEN1031.FIELD_DESCRIPTION
        ];
        // #endregion --- TextBoxes Values ---

        // Đổ dữ liệu textbox
        var i;
        for (i = 0; i < textValueList.length; i++) {
            var textValue = $("#" + textValueList[i]).val();
            data.dataMaster[textValueList[i]] = SCREEN1031.IsNotNullOrUndefined(textValue) ? textValue : null;
        }

        // #region --- DateTimePickers Value ---
        var dateValueList = [
            SCREEN1031.FIELD_BIRTHDAY,
            SCREEN1031.FIELD_IDENTIFYDATE,
            SCREEN1031.FIELD_PASSPORTDATE,
            SCREEN1031.FIELD_PASSPORTEND,
            SCREEN1031.FIELD_RECEIVEFILEDATE,
            SCREEN1031.FIELD_STARTDATE
        ];
        // #endregion --- DateTimePickers Value ---

        // Đổ dữ liệu DateTimePicker
        for (i = 0; i < dateValueList.length; i++) {
            var dateValue = $("#" + dateValueList[i]).data("kendoDatePicker").value();
            data.dataMaster[dateValueList[i]] = SCREEN1031.IsNotNullOrUndefined(dateValue) ? dateValue : null;
        }

        // #region --- ComboBoxes Value ---

        // Quốc tịch
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_NATIONALITYID))) {
            data.dataMaster[SCREEN1031.FIELD_NATIONALITYID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_NATIONALITYID)[SCREEN1031.FIELD_COUNTRYID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_NATIONALITYID] = null;
        }

        // Dân tộc
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_ETHNICID))) {
            data.dataMaster[SCREEN1031.FIELD_ETHNICID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_ETHNICID)[SCREEN1031.FIELD_ETHNICID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_ETHNICID] = null;
        }

        // Tôn giáo
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RELIGIONID))) {
            data.dataMaster[SCREEN1031.FIELD_RELIGIONID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RELIGIONID)[SCREEN1031.FIELD_RELIGIONID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_RELIGIONID] = null;
        }

        // Giới tính
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_GENDER))) {
            data.dataMaster[SCREEN1031.FIELD_GENDER] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_GENDER)["ID"];
        } else {
            data.dataMaster[SCREEN1031.FIELD_GENDER] = null;
        }

        // Tỉnh cấp CMND
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_IDENTIFYCITYID))) {
            data.dataMaster[SCREEN1031.FIELD_IDENTIFYCITYID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_IDENTIFYCITYID)[SCREEN1031.FIELD_CITYID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_IDENTIFYCITYID] = null;
        }

        // Phòng ban ứng tuyển
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_DEPARTMENTID))) {
            data.dataMaster[SCREEN1031.FIELD_DEPARTMENTID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_DEPARTMENTID)[SCREEN1031.FIELD_DEPARTMENTID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_DEPARTMENTID] = null;
        }

        // Vị trí ứng tuyển
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_DUTYID))) {
            data.dataMaster[SCREEN1031.FIELD_DUTYID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_DUTYID)[SCREEN1031.FIELD_DUTYID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_DUTYID] = null;
        }

        // Trạng thái
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RECRUITSTATUS))) {
            data.dataMaster[SCREEN1031.FIELD_RECRUITSTATUS] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RECRUITSTATUS)["ID"];
        } else {
            data.dataMaster[SCREEN1031.FIELD_RECRUITSTATUS] = null;
        }

        // Nguồn tuyển dụng
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RESOURCEID))) {
            data.dataMaster[SCREEN1031.FIELD_RESOURCEID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RESOURCEID)[SCREEN1031.FIELD_RESOURCEID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_RESOURCEID] = null;
        }

        // Hình thức làm việc
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_WORKTYPE))) {
            data.dataMaster[SCREEN1031.FIELD_WORKTYPE] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_WORKTYPE)["ID"];
        } else {
            data.dataMaster[SCREEN1031.FIELD_WORKTYPE] = null;
        }

        // Trình độ học vấn
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_EDUCATIONLEVELID))) {
            data.dataMaster[SCREEN1031.FIELD_EDUCATIONLEVELID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_EDUCATIONLEVELID)[SCREEN1031.FIELD_EDUCATIONLEVELID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_EDUCATIONLEVELID] = null;
        }

        // Trình độ tin học 
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_INFORMATICSLEVEL))) {
            data.dataMaster[SCREEN1031.FIELD_INFORMATICSLEVEL] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_INFORMATICSLEVEL)[SCREEN1031.FIELD_INFORMATICSLEVELID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_INFORMATICSLEVEL] = null;
        }

        // Trình độ chính trị
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_POLITICSID))) {
            data.dataMaster[SCREEN1031.FIELD_POLITICSID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_POLITICSID)[SCREEN1031.FIELD_POLITICSID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_POLITICSID] = null;
        }

        // Ngoại ngữ 1
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGE1ID))) {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGE1ID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGE1ID)[SCREEN1031.FIELD_LANGUAGEID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGE1ID] = null;
        }

        // Ngoại ngữ 2
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGE2ID))) {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGE2ID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGE2ID)[SCREEN1031.FIELD_LANGUAGEID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGE2ID] = null;
        }

        // Ngoại ngữ 3
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGE3ID))) {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGE3ID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGE3ID)[SCREEN1031.FIELD_LANGUAGEID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGE3ID] = null;
        }

        // Cấp độ ngoại ngữ 1
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGELEVEL1ID))) {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGELEVEL1ID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGELEVEL1ID)[SCREEN1031.FIELD_LANGUAGELEVELID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGELEVEL1ID] = null;
        }

        // Cấp độ ngoại ngữ 2
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGELEVEL2ID))) {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGELEVEL2ID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGELEVEL2ID)[SCREEN1031.FIELD_LANGUAGELEVELID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGELEVEL2ID] = null;
        }

        // Cấp độ ngoại ngữ 3
        if (SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGELEVEL3ID))) {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGELEVEL3ID] = SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_LANGUAGELEVEL3ID)[SCREEN1031.FIELD_LANGUAGELEVELID];
        } else {
            data.dataMaster[SCREEN1031.FIELD_LANGUAGELEVEL3ID] = null;
        }

        // #endregion --- ComboBoxes Value ---

        // #region --- RadioButton Values ---
        var radioValueList = [
            SCREEN1031.FIELD_ISSINGLE
        ];
        // #endregion --- RadioButton Values ---

        // Đổ dữ liệu RadioButton
        for (i = 0; i < radioValueList.length ; i++) {
            var radioValue = $('input[id="{0}"]:checked'.format(radioValueList[i])).val();
            data.dataMaster[radioValueList[i]] = SCREEN1031.IsNotNullOrUndefined(radioValue) ? radioValue : null;
        }

        // #region --- Grid Data ---

        data.GridHRMT1033 = SCREEN1031.GridHRMT1033.dataSource._data;
        data.GridHRMT1034 = SCREEN1031.GridHRMT1034.dataSource._data;

        // #endregion --- Grid Data ---

        // #region --- Final Data Format ---

        data.dataMaster[SCREEN1031.FIELD_CANDIDATEID] = data.dataMaster[SCREEN1031.FIELD_CANDIDATEID].toUpperCase();

        // #endregion --- Final Data Format ---

        return data;
    };

    /**
     * Kiểm tra tồn tại mã ứng viên
     * @param {} candidateID 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.IsExistCandidateID = function (candidateID) {
        var isExist;
        candidateID = candidateID.toUpperCase();
        var url = "/HRM/HRMF1031/CheckExist";
        var sendData = {
            pCandidateID: candidateID
        };
        ASOFT.helper.postTypeJson(url, sendData, function (result) {
            isExist = result.Message.Status == 1;
        });

        return isExist;
    }

    this.validateEmail = function (email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email.toLowerCase());
    }

    this.CheckCompareDate = function (fromdatestr,todatestr)
    {
        var date1 = fromdatestr.split("/");
        var date2 = todatestr.split("/");

        var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
        var todate = new Date(date2[2], date2[1] - 1, date2[0]);
        if (fromdate > todate) {
            return true;
        }
        return false;
    }
    this.CheckCompareDateNow = function (datestr)
    {
        var date1 = datestr.split("/");
        var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
        var datenow = new Date();
        if (fromdate > datenow) {
            return true;
        }
        return false;
    }
    /**
     * Kiểm tra không hợp lệ dữ liệu
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.IsInValid = function () {
        SCREEN1031.ClearMessageBox();

        // #region --- Flag Checkers ---

        // Invalid Input
        var invalidTextBox = [];
        var invalidComboBox = [];

        // Master flag
        var InvalidData = false;

        // Null flag
        var NullValue = false;
        var IsExistCandidateID_ADDNEW = false;
        var Invalid = false;

        // #endregion --- Flag Checkers ---

        // #region --- Messages ---

        var message_array = [];

        // Yêu cầu nhập
        var MSG_REQUIREDINPUT = "00ML000039";
        var MSG_ISEXIST = "00ML000053";

        // #endregion --- Messages ---

        // #region --- CHECK: Required Input ---

        // Mã ứng viên
        if (SCREEN1031.IsEmptyString(
                SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_CANDIDATEID))
        ) {
            NullValue = true;
            invalidTextBox.push(SCREEN1031.FIELD_CANDIDATEID);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_CANDIDATEID, MSG_REQUIREDINPUT));
        }
        // Họ tên
        if (SCREEN1031.IsEmptyString(SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_FIRSTNAME)) ||
                SCREEN1031.IsEmptyString(SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_LASTNAME))
        ) {

            NullValue = true;
            if (SCREEN1031.IsEmptyString(SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_FIRSTNAME))) invalidTextBox.push(SCREEN1031.FIELD_FIRSTNAME);
            if (SCREEN1031.IsEmptyString(SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_LASTNAME))) invalidTextBox.push(SCREEN1031.FIELD_LASTNAME);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_FIRSTNAME, MSG_REQUIREDINPUT));
        }
        // Quốc tịch
        if (!SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_NATIONALITYID))) {
            NullValue = true;
            invalidComboBox.push(SCREEN1031.FIELD_NATIONALITYID);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_NATIONALITYID, MSG_REQUIREDINPUT));
        }
        // Phòng ban ứng tuyển
        if (!SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_DEPARTMENTID))) {
            NullValue = true;
            invalidComboBox.push(SCREEN1031.FIELD_DEPARTMENTID);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_DEPARTMENTID, MSG_REQUIREDINPUT));
        }
        // Vị trí ứng tuyển
        if (!SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_DUTYID))) {
            NullValue = true;
            invalidComboBox.push(SCREEN1031.FIELD_DUTYID);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_DUTYID, MSG_REQUIREDINPUT));
        }
        // Trạng thái
        if (!SCREEN1031.IsNotNullOrUndefined(SCREEN1031.GetComboBoxValueItem(SCREEN1031.FIELD_RECRUITSTATUS))) {
            NullValue = true;
            invalidComboBox.push(SCREEN1031.FIELD_RECRUITSTATUS);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_RECRUITSTATUS, MSG_REQUIREDINPUT));
        }
        // Đợt tuyển dụng
        if (SCREEN1031.IsEmptyString(SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_RECPERIODNAME))) {
            NullValue = true;
            invalidComboBox.push(SCREEN1031.FIELD_RECPERIODNAME);
            message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_RECPERIODNAME, MSG_REQUIREDINPUT));
        }

        // #endregion --- CHECK: Required Input ---

        //  #region --- Check invalid
            var Email = $("#Email").val();
            var Birthday = $("#Birthday").val(), date1 = Birthday.split("/");
            var Fax = $("#Fax").val();
            var PassportNo = $("#PassportNo").val();
            var IdentifyCardNo = $("#IdentifyCardNo").val();
            var PhoneNumber = $("#PhoneNumber").val();
            var ReceiveFileDate = $("#ReceiveFileDate").val();
            var Startdate = $("#Startdate").val();
            var msgg = "{0} không được là số âm";

            if (!SCREEN1031.validateEmail(Email) && Email != "" && Email != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f('Email'));
            };
            var d = new Date(date1[2], date1[1] - 1, date1[0]);
            if ((isNaN(d.valueOf()) || SCREEN1031.CheckCompareDateNow(Birthday)) && Birthday != "" && Birthday != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF1031.Birthday", "HRMF1031", "HRM")));
            }

            if (isNaN(Fax.valueOf()) && Fax != "" && Fax != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF1031.Fax", "HRMF1031", "HRM")));
            }
            else if (Fax.valueOf() < 0) {
                Invalid = true;
                message_array.push(msgg.f(ASOFT.helper.getLanguageString("HRMF1031.Fax", "HRMF1031", "HRM")));
            }
            
            if (isNaN(PassportNo.valueOf()) && PassportNo != "" && PassportNo != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF1031.PassportNo", "HRMF1031", "HRM")));
            }
            else if (PassportNo.valueOf() < 0) {
                Invalid = true;
                message_array.push(msgg.f(ASOFT.helper.getLanguageString("HRMF1031.PassportNo", "HRMF1031", "HRM")));
            }

            if (isNaN(IdentifyCardNo.valueOf()) && IdentifyCardNo != "" && IdentifyCardNo != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF1031.IdentifyCardNo", "HRMF1031", "HRM")));
            }
            else if (IdentifyCardNo.valueOf() < 0) {
                Invalid = true;
                message_array.push(msgg.f(ASOFT.helper.getLanguageString("HRMF1031.IdentifyCardNo", "HRMF1031", "HRM")));
            }

            if (isNaN(PhoneNumber.valueOf()) && PhoneNumber != "" && PhoneNumber != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF1031.PhoneNumber", "HRMF1031", "HRM")));
            }
            else if (PhoneNumber.valueOf() < 0) {
                Invalid = true;
                message_array.push(msgg.f(ASOFT.helper.getLanguageString("HRMF1031.PhoneNumber", "HRMF1031", "HRM")));
            }

            if (SCREEN1031.CheckCompareDate(ReceiveFileDate, Startdate))
            {
                Invalid = true;
                var msgdate = "{0} không thể lớn hơn {1}";
                message_array.push(msgdate.f(ASOFT.helper.getLanguageString("HRMF1031.ReceiveFileDate", "HRMF1031", "HRM"),ASOFT.helper.getLanguageString("HRMF1031.Startdate", "HRMF1031", "HRM")));
            }

        // #endregion


        if (!NullValue) {
            // #region --- CHECK: Exist Data ---

            if (!SCREEN1031.isUpdate) {
                IsExistCandidateID_ADDNEW = SCREEN1031.IsExistCandidateID(SCREEN1031.GetTextBoxValue(SCREEN1031.FIELD_CANDIDATEID));
                if (IsExistCandidateID_ADDNEW) {
                    invalidTextBox.push(SCREEN1031.FIELD_CANDIDATEID);
                    message_array.push(ASOFT.helper.getLabelText(SCREEN1031.FIELD_CANDIDATEID, MSG_ISEXIST));
                    IsExistCandidateID_ADDNEW = true;

                    SCREEN1031.ReGenCandidateID();
                }
            }

            // #endregion --- CHECK: Exist Data ---
        }

        // #region --- Show Errors ---

        InvalidData = (NullValue
            || IsExistCandidateID_ADDNEW
            || Invalid);
        if (InvalidData) {
            // Danh sách textbox lỗi
            for (var i = 0; i < invalidTextBox.length; i++) {
                SCREEN1031.ShowElementError(invalidTextBox[i]);
            }
            // Danh sách combo lỗi
            for (var i = 0; i < invalidComboBox.length; i++) {
                SCREEN1031.ShowComboError(invalidComboBox[i]);
            }

            // Nội dung lỗi
            SCREEN1031.ShowMessageErrors(message_array);
        }

        // #endregion --- Show Errors ---

        return InvalidData;
    };

    /**
     * Lưu dữ liệu
     * @param {} data 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SaveData = function (data) {
        var saveSuccess = false;
        var addNew = (SCREEN1031.isUpdate == false);
        var url = "/HRM/HRMF1031/UpdateData";
        var sendData = {
            pAddNew: addNew,
            pMaster: data.dataMaster,
            pHRMT1033List: data.GridHRMT1033,
            pHRMT1034List: data.GridHRMT1034
        };
        ASOFT.helper.postTypeJson(url, sendData, function (result) {
            if (result.Message.Status == 1) { // Lỗi
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), result.Message.MessageID, result.Message.Params);
            } else {
                saveSuccess = true;
            }
        });
        return saveSuccess;
    }

    // #region --- Move Controls ---

    /**
     * Xử lý cho Tab thông tin cá nhân
     * @returns {} 
     * @since [Văn Tài] Created [03/10/2017]
     */
    this.MoveControlTab01 = function () {
        var PersonalLeftTable = $("#PersonalLeftTable");
        var PersonalRightTable = $("#PersonalRightTable");
        var ContactTable = $("#ContactTable");

        var label_width = "14.1%";

        var fieldLeftList = [
            SCREEN1031.FIELD_BIRTHDAY,
            SCREEN1031.FIELD_BORNPLACE,
            SCREEN1031.FIELD_NATIONALITYID,
            SCREEN1031.FIELD_ETHNICNAME,
            SCREEN1031.FIELD_ETHNICID,
            SCREEN1031.FIELD_RELIGIONID,
            SCREEN1031.FIELD_RELIGIONNAME,
            SCREEN1031.FIELD_NATIVECOUNTRY,
            SCREEN1031.FIELD_IDENTIFYCARDNO,
            SCREEN1031.FIELD_IDENTIFYPLACE,
            SCREEN1031.FIELD_IDENTIFYCITY,
            SCREEN1031.FIELD_IDENTIFYCITYID,
            SCREEN1031.FIELD_IDENTIFYDATE
        ];

        var fieldRightList = [
            SCREEN1031.FIELD_GENDER,
            SCREEN1031.FIELD_ISSINGLE,
            SCREEN1031.FIELD_HEALTHSTATUS,
            SCREEN1031.FIELD_HEIGHT,
            SCREEN1031.FIELD_WEIGHT,
            SCREEN1031.FIELD_PASSPORTNO,
            SCREEN1031.FIELD_PASSPORTDATE,
            SCREEN1031.FIELD_PASSPORTEND,
        ];

        var fieldContactList = [
            SCREEN1031.FIELD_PERMANENTADDRESS,
            SCREEN1031.FIELD_TEMPORARYADDRESS,
            SCREEN1031.FIELD_PHONENUMBER,
            SCREEN1031.FIELD_EMAIL,
            SCREEN1031.FIELD_FAX,
            SCREEN1031.FIELD_NOTE
        ];

        for (var i = 0; i < fieldLeftList.length; i++) {
            var item = $("." + fieldLeftList[i]);
            item.appendTo(PersonalLeftTable);
        }
        for (var i = 0; i < fieldRightList.length; i++) {
            var item = $("." + fieldRightList[i]);
            item.appendTo(PersonalRightTable);
        }
        for (var i = 0; i < fieldContactList.length; i++) {
            var item = $("." + fieldContactList[i]);
            item.appendTo(ContactTable);
        }

        var item = $("input[name='IsSingle']").parent().parent();
        item.appendTo(PersonalRightTable);

        $("." + SCREEN1031.FIELD_PERMANENTADDRESS + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_TEMPORARYADDRESS + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_PHONENUMBER + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_EMAIL + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_FAX + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_NOTE + " .asf-td-caption").css("width", label_width);

        var IsSingle = $("input[id='" + SCREEN1031.FIELD_ISSINGLE + "']").parent().parent();

        $("." + SCREEN1031.FIELD_HEALTHSTATUS).before(IsSingle[0]);
        $("." + SCREEN1031.FIELD_HEALTHSTATUS).before(IsSingle[1]);
    };

    /**
     * Xử lý cho tab thông tin tuyển dụng
     * @returns {} 
     * @since [Văn Tài] Created [03/10/2017]
     */
    this.MoveControlTab02 = function () {

        var RecruitInfo01LeftTable = $("#RecruitInfo01LeftTable");
        var RecruitInfo01RightTable = $("#RecruitInfo01RightTable");
        var RecruitInfo02Table = $("#RecruitInfo02Table");
        var RecruitInfo03LeftTable = $("#RecruitInfo03LeftTable");
        var RecruitInfo03RightTable = $("#RecruitInfo03RightTable");
        var RecruitInfo04Table = $("#RecruitInfo04Table");


        var RecruitInfo01LeftList = [
            SCREEN1031.FIELD_RECPERIODID,
            SCREEN1031.FIELD_RECPERIODNAME,
            SCREEN1031.FIELD_DEPARTMENTID,
            SCREEN1031.FIELD_DEPARTMENTNAME,
            SCREEN1031.FIELD_RECEIVEFILEDATE,
        ];

        var RecruitInfo01RightList = [
            SCREEN1031.FIELD_DUTYID,
            SCREEN1031.FIELD_DUTYNAME,
            SCREEN1031.FIELD_RECRUITSTATUS,
        ];

        var RecruitInfo02List = [
            SCREEN1031.FIELD_RECEIVEFILEPLACE
        ];

        var RecruitInfo03LeftList = [
            SCREEN1031.FIELD_RESOURCEID,
            SCREEN1031.FIELD_RESOURCENAME,
            SCREEN1031.FIELD_STARTDATE
        ];

        var RecruitInfo03RightList = [
            SCREEN1031.FIELD_WORKTYPE,
            SCREEN1031.FIELD_REQUIRESALARY
        ];

        var RecruitInfo04List = [
            SCREEN1031.FIELD_RECREASON,
            SCREEN1031.FIELD_STRENGTH,
            SCREEN1031.FIELD_WEAKNESS,
            SCREEN1031.FIELD_CAREERAIM,
            SCREEN1031.FIELD_PERSONALAIM,
            SCREEN1031.FIELD_APTITUDE,
            SCREEN1031.FIELD_HOBBY
        ];

        var label_width = "14.1%";

        for (var i = 0; i < RecruitInfo01LeftList.length; i++) {
            var item = $("." + RecruitInfo01LeftList[i]);
            item.appendTo(RecruitInfo01LeftTable);
        }

        for (var i = 0; i < RecruitInfo01RightList.length; i++) {
            var item = $("." + RecruitInfo01RightList[i]);
            item.appendTo(RecruitInfo01RightTable);
        }

        for (var i = 0; i < RecruitInfo02List.length; i++) {
            var item = $("." + RecruitInfo02List[i]);
            item.appendTo(RecruitInfo02Table);
        }
        $("." + SCREEN1031.FIELD_RECEIVEFILEPLACE + " .asf-td-caption").css("width", label_width);

        for (var i = 0; i < RecruitInfo03LeftList.length; i++) {
            var item = $("." + RecruitInfo03LeftList[i]);
            item.appendTo(RecruitInfo03LeftTable);
        }

        for (var i = 0; i < RecruitInfo03RightList.length; i++) {
            var item = $("." + RecruitInfo03RightList[i]);
            item.appendTo(RecruitInfo03RightTable);
        }

        for (var i = 0; i < RecruitInfo04List.length; i++) {
            var item = $("." + RecruitInfo04List[i]);
            item.appendTo(RecruitInfo04Table);
        }
        $("." + SCREEN1031.FIELD_RECEIVEFILEPLACE + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_RECREASON + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_STRENGTH + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_WEAKNESS + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_CAREERAIM + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_PERSONALAIM + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_APTITUDE + " .asf-td-caption").css("width", label_width);
        $("." + SCREEN1031.FIELD_HOBBY + " .asf-td-caption").css("width", label_width);

        $("." + SCREEN1031.FIELD_RECPERIODID).css("display", "none");
    }

    /**
     * Xử lý cho tab Thông tin học vấn
     * @returns {} 
     * @since [Văn Tài] Created [03/10/2017]
     */
    this.MoveControlTab03 = function () {

        // Lấy title trình độ ngoại ngữ
        var EnglishSkill = SCREEN1031.GetLanguageFromServer("HRMF1031.EnglishSkill");

        // SETTING GRID
        $("#GridEditHRMT1034").css("height", "370px");
        var AcademicInfo =
            '<div class="asf-form-container container_12 pagging_bottom ">' +
                '<div class="grid_6_1 alpha float_left">' +
                '<div>' +
                '<table id="AcademicTopLeftTable" class="asf-table-view"><tbody></tbody></table>' +
                '</div>' +
                '</div>' +
                '<div class="grid_6 omega float_right line_left_with_grid">' +
                '<div>' +
                '<table id="AcademicTopRightTable" class="asf-table-view"><tbody></tbody></table>' +
                '</div>' +
                '</div>' +
                '</div>' +
                '<fieldset id="EnglishLevelGroup" style="margin-bottom: 10px;">' +
                '<legend>' +
                '<label>' +
                EnglishSkill +
                '</label>' +
                '</legend>' +
                '<div class="asf-form-container container_12 pagging_bottom ">' +
                '<div class="grid_6_1 alpha float_left">' +
                '<table id="EnglishLevelLeftTable" class="asf-table-view">' +
                '<tbody>' +
                '</tbody>' +
                '</table>' +
                '</div>' +
                '<div class="grid_6 omega float_right line_left_with_grid">' +
                '<table id="EnglishLevelRightTable" class="asf-table-view">' +
                '<tbody>' +
                '</tbody>' +
                '</table>' +
                '</div>' +
                '</div>'
        '</fieldset>';
        $(AcademicInfo).insertBefore("#GridEditHRMT1034");

        var AcademicTopLeftTable = $("#AcademicTopLeftTable");
        var AcademicTopRightTable = $("#AcademicTopRightTable");
        var EnglishLevelLeftTable = $("#EnglishLevelLeftTable");
        var EnglishLevelRightTable = $("#EnglishLevelRightTable");

        var TopLeftFieldList = [
            SCREEN1031.FIELD_EDUCATIONLEVELID,
            SCREEN1031.FIELD_INFORMATICSLEVEL,
        ];

        var TopRightFieldList = [
            SCREEN1031.FIELD_POLITICSID
        ];

        var EnglistLevelLeftFieldList = [
            SCREEN1031.FIELD_LANGUAGE1ID,
            SCREEN1031.FIELD_LANGUAGE2ID,
            SCREEN1031.FIELD_LANGUAGE3ID
        ];

        var EnglistLevelRightFieldList = [
            SCREEN1031.FIELD_LANGUAGELEVEL1ID,
            SCREEN1031.FIELD_LANGUAGELEVEL2ID,
            SCREEN1031.FIELD_LANGUAGELEVEL3ID
        ];

        for (var i = 0; i < TopLeftFieldList.length; i++) {
            var item = $("." + TopLeftFieldList[i]);
            item.appendTo(AcademicTopLeftTable);
        }

        for (var i = 0; i < TopRightFieldList.length; i++) {
            var item = $("." + TopRightFieldList[i]);
            item.appendTo(AcademicTopRightTable);
        }

        for (var i = 0; i < EnglistLevelLeftFieldList.length; i++) {
            var item = $("." + EnglistLevelLeftFieldList[i]);
            item.appendTo(EnglishLevelLeftTable);
        }

        for (var i = 0; i < EnglistLevelRightFieldList.length; i++) {
            var item = $("." + EnglistLevelRightFieldList[i]);
            item.appendTo(EnglishLevelRightTable);
        }

    };

    /**
     * Xử lý cho tab DISC
     * @returns {} 
     * @since [Văn Tài] Created [12/12/2017]
     */
    this.MoveControlTab05 = function () {

        // Xóa grid tạm
        $("#GridEditHRMT10341").remove();

        var DISCInfo =
           '<div>' +
                '<div style="margin-bottom: 10px;">' +
                        '<a class="k-button k-button-icontext asf-button" id="BtnAddDISC" style="margin-top:5px;" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">Cập nhật thông tin D.I.S.C</span></a>' +
                '</div>' +
                '<div  class="grid_6_1 alpha float_left">' +
                    '<div class="asf-form-container container_12 pagging_bottom">' +
                        '<table id="EvaluationDateGroup" class="asf-table-view">' +
                            '<tbody>' +
                            '</tbody>' +
                        '</table>' +
                    '</div>' +
                    '<fieldset id="NaturalcharacterGroup" style="margin-bottom: 10px;">' +
                        '<legend>' +
                            '<label>' +
                                 'Tính cách tự nhiên' +
                           '</label/>' +
                        '</legend>' +
                       '<div class="asf-form-container container_12 pagging_bottom ">' +
                            '<table id="Naturalcharacter" class="asf-table-view">' +
                                '<tbody>' +
                                '</tbody>' +
                            '</table>' +
                       '</div>' +
                    '</fieldset>' +
                    '<fieldset id="AdaptabilityGroup" style="margin-bottom: 10px;">' +
                        '<legend>' +
                            '<label>' +
                                 'Tính cách thích ứng' +
                           '</label/>' +
                        '</legend>' +
                       '<div class="asf-form-container container_12 pagging_bottom ">' +
                            '<table id="Adaptability" class="asf-table-view">' +
                                '<tbody>' +
                                '</tbody>' +
                            '</table>' +
                       '</div>' +
                    '</fieldset>' +
                '</div>' +
                '<div class="grid_6 omega float_right">' +
                     '<fieldset id="DescriptionGroup">' +
                        '<legend>' +
                            '<label>' +
                                 'Mô tả tính cách' +
                           '</label/>' +
                        '</legend>' +
                       '<div class="asf-form-container">' +
                            '<table id="DescriptionDISC" class="asf-table-view">' +
                                '<tbody>' +
                                '</tbody>' +
                            '</table>' +
                       '</div>' +
                    '</fieldset>' +
                '</div>' +
            '</div>';
        $(DISCInfo).insertBefore("#parentDISC");
        var Naturalcharacter = $("#Naturalcharacter");
        var Adaptability = $("#Adaptability");
        var EvaluationDateGroup = $("#EvaluationDateGroup");
        var DescriptionDISC = $("#DescriptionDISC");

        var NaturalcharacterFieldsList = [
            SCREEN1031.FIELD_NATURE_D,
            SCREEN1031.FIELD_NATURE_I,
            SCREEN1031.FIELD_NATURE_S,
            SCREEN1031.FIELD_NATURE_C,
            SCREEN1031.FIELD_NATURE
        ];

        var AdaptabilityFieldsList = [
            SCREEN1031.FIELD_ADAPTIVE_D,
            SCREEN1031.FIELD_ADAPTIVE_I,
            SCREEN1031.FIELD_ADAPTIVE_S,
            SCREEN1031.FIELD_ADAPTIVE_C,
            SCREEN1031.FIELD_ADAPTIVE
        ];

        var EvaluationDateFieldsList = [
            SCREEN1031.FIELD_EVALUATIONDATE
        ];


        for (var i = 0; i < EvaluationDateFieldsList.length; i++) {
            var item = $("." + EvaluationDateFieldsList[i]);
            item.appendTo(EvaluationDateGroup);
        }

        for (var i = 0; i < NaturalcharacterFieldsList.length; i++) {
            var item = $("." + NaturalcharacterFieldsList[i]);
            item.appendTo(Naturalcharacter);
        }

        for (var i = 0; i < AdaptabilityFieldsList.length; i++) {
            var item = $("." + AdaptabilityFieldsList[i]);
            item.appendTo(Adaptability);
        }

        var item = $("." + SCREEN1031.FIELD_DESCRIPTION);
        item.appendTo(DescriptionDISC);
        $("." + SCREEN1031.FIELD_DESCRIPTION + " .asf-td-caption").remove();
        $("#Description").css("height", "99%");
        $("#Description").css("overflow", "scroll");
        $("#Description").css("overflow-y", "scroll");
        $("#Description").attr("rows", "27");

        //var parentDISC = $("#parentDISC");
        //var FieldsList = [
        //    SCREEN1031.FIELD_EVALUATIONDATE,
        //    SCREEN1031.FIELD_NATURE_D,
        //    SCREEN1031.FIELD_NATURE_I,
        //    SCREEN1031.FIELD_NATURE_S,
        //    SCREEN1031.FIELD_NATURE_C,
        //    SCREEN1031.FIELD_NATURE,
        //    SCREEN1031.FIELD_ADAPTIVE_D,
        //    SCREEN1031.FIELD_ADAPTIVE_I,
        //    SCREEN1031.FIELD_ADAPTIVE_S,
        //    SCREEN1031.FIELD_ADAPTIVE_C,
        //    SCREEN1031.FIELD_ADAPTIVE,
        //    SCREEN1031.FIELD_DESCRIPTION
        //];


        //for (var i = 0; i < FieldsList.length; i++) {
        //    var item = $("." + FieldsList[i]);
        //    item.appendTo(parentDISC);
        //}

    }

    // Xử lý di chuyển các control master ngoài tabstrip
    this.MoveControlHeader = function () {
        var headerParent = $("#" + SCREEN1031.FIELD_CANDIDATEID).parent().parent().parent().parent().parent().parent();

        // Bỏ các tr ra ngoài div 
        headerParent.before($("." + SCREEN1031.FIELD_CANDIDATEID));
        headerParent.before($("." + SCREEN1031.FIELD_FIRSTNAME));
        headerParent.before($("." + SCREEN1031.FIELD_MIDDLENAME));
        headerParent.before($("." + SCREEN1031.FIELD_LASTNAME));
        headerParent.before($("." + SCREEN1031.FIELD_IMAGEID));
        headerParent.before($("." + SCREEN1031.FIELD_ATTACHID));

        var newParentDiv =
            '<div class="asf-form-container container_12" id="ParentHeader">' +
                '<div id="pnLeftHeader" style="width:35%; float:left;">' +
                '</div>' +
                '<div id="pnRightHeader" style="width:65%; float:left;">' +
                '</div>' +
                '</div>';

        // Insert div cha mới
        $(headerParent).before(newParentDiv);

        // Insert 1 table layout thuộc phần bên phải div mới
        // Nhằm xử lý hiển thị các trường
        $("<table style='width:100%;'" +
                "><tbody id='tableBodyRightHeader'>" +
                "</tbody>" +
                "</table>")
            .appendTo("#pnRightHeader");

        $("tr[class='" + SCREEN1031.FIELD_IMAGEID + "']").appendTo("#pnLeftHeader");

        $("." + SCREEN1031.FIELD_CANDIDATEID).appendTo($("#tableBodyRightHeader"));
        $("#" + SCREEN1031.FIELD_CANDIDATEID).css("text-transform", "uppercase");

        $("." + SCREEN1031.FIELD_FIRSTNAME).appendTo($("#tableBodyRightHeader"));
        $("." + SCREEN1031.FIELD_MIDDLENAME).appendTo($("#tableBodyRightHeader"));
        $("." + SCREEN1031.FIELD_LASTNAME).appendTo($("#tableBodyRightHeader"));
        $("tr[class='" + SCREEN1031.FIELD_ATTACHID + "']").appendTo("#tableBodyRightHeader");

        // Xóa label không cần thiết của hình ảnh
        $("label[for='" + SCREEN1031.FIELD_IMAGEID + "']").parent().remove();

        // #region --- Xử lý layout hình ảnh ---

        $("tr[class='" + SCREEN1031.FIELD_IMAGEID + "']").attr("style", "float:left; width:100%;");
        $("tr[class='" + SCREEN1031.FIELD_IMAGEID + "']").children().attr("style", "float:left; width:100%;");
        $("tr[class='" + SCREEN1031.FIELD_IMAGEID + "']")
            .children()
            .children()
            .attr("style", "float:left; margin-left:10px");

        $("#" + SCREEN1031.FIELD_IMAGEID + "_Image").parent().parent().parent().css("width", "50%");
        $("#btn-" + SCREEN1031.FIELD_IMAGEID + "_" + SCREEN1031.TABLE_HRMT1030).parent().attr("style", "width:100%;");
        $("#btn-" + SCREEN1031.FIELD_IMAGEID + "_" + SCREEN1031.TABLE_HRMT1030)
            .attr("style", "margin-left:20px; margin-top:5px;");
        $("." + SCREEN1031.FIELD_IMAGEID + " img").css("height", "100px");

        $("#" + SCREEN1031.FIELD_IMAGEID + "_" + SCREEN1031.TABLE_HRMT1030).parent().parent().css("height", "20px")

        // #endregion --- Xử lý layout hình ảnh ---

        // Xử lý file đính kèm
        $("#" + SCREEN1031.FIELD_ATTACHID).css("width", "79%");
        $("#btn" + SCREEN1031.FIELD_ATTACHID).css("position", "inherit");
        $("#btn" + SCREEN1031.FIELD_ATTACHID).css("margin-bottom", "2px");
        $("#btnDelete" + SCREEN1031.FIELD_ATTACHID).css("right", "20px");

        // Xử lý layout
        $("#" + SCREEN1031.FIELD_FIRSTNAME).attr("style", "width:30%; margin-right:5%");
        $("#" + SCREEN1031.FIELD_MIDDLENAME).attr("style", "width:30%; margin-right:5%");
        $("#" + SCREEN1031.FIELD_LASTNAME).attr("style", "width:30%;");

        // Để các trường tên ứng viên nằm cùng 1 dòng
        var nameParent = $("#" + SCREEN1031.FIELD_FIRSTNAME).parent();
        $("#" + SCREEN1031.FIELD_MIDDLENAME).appendTo(nameParent);
        $("#" + SCREEN1031.FIELD_LASTNAME).appendTo(nameParent);

        // Xóa tr không sử dụng
        $("tr[class='" + SCREEN1031.FIELD_MIDDLENAME + "']").remove();
        $("tr[class='" + SCREEN1031.FIELD_LASTNAME + "']").remove();

        // #region --- Xóa các Control Attach cũ ---

        // Xóa nút chọn và nút xóa cũ
        $("#btn" + SCREEN1031.FIELD_ATTACHID).remove();
        $("#btnDelete" + SCREEN1031.FIELD_ATTACHID).remove();

        // #endregion --- Xóa các Control Attach cũ ---

        headerParent.remove();
    };

    /**
     * Lấy dữ liệu ngôn ngữ cho 1 số control
     * @returns {} 
     * @since [Văn Tài] Created [03/10/2017]
     */
    this.GetLanguage = function () {
        var maritalStatus = SCREEN1031.GetLanguageFromServer("HRMF1031.MaritalStatus");
        var maritalStatusChild = $("#" + SCREEN1031.FIELD_ISSINGLE).parent().parent().children();
        if (SCREEN1031.IsNotNullOrUndefined(maritalStatusChild)) maritalStatusChild[0].append(maritalStatus);
    }

    // #endregion --- Move Controls ---

    // #region --- Utilities ---

    // Kiểm tra không phải null hay undefined
    this.IsNotNullOrUndefined = function (checker) {
        return (typeof (checker) != 'undefined' && checker != null);
    };

    /**
     * Kiểm tra chuỗi rỗng
     * @param {} str 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.IsEmptyString = function (str) {
        return (!str || 0 === str.length);
    }

    /**
     * Lấy ngôn ngữ từ Server
     * @param {} languageID 
     * @returns {} 
     * @since [Văn Tài] Created [03/10/2017]
     */
    this.GetLanguageFromServer = function (languageID) {
        var language = ASOFT.helper.getLanguageString(languageID, SCREEN1031.SCREEN_ID, "HRM");
        return (SCREEN1031.IsNotNullOrUndefined(language) ? language : "Undefined");
    }

    /**
     * Lấy giá trị Textbox
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetTextBoxValue = function (elementID) {
        var value = $("#" + elementID).val();
        if (SCREEN1031.IsNotNullOrUndefined(value)) return value;
        return "";
    }

    /**
     * Lấy giá trị của DateTimePicker
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetDateTimePickerValue = function (elementID) {
        return $("#" + elementID).data("kendoDatePicker").value();
    }

    /**
     * Lấy toàn bộ dữ liệu ComboBox được chọn
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetComboBoxValueItem = function (elementID) {
        var combo = $("#" + elementID).data("kendoComboBox");
        return combo.dataItem(combo.select());
    }

    /**
     * Set giá trị textbox
     * @param {} elementID 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetTextBoxValue = function (elementID, value) {
        $("#" + elementID).val(value);
    }

    /**
     * Set giá trị control dateTimePicker
     * @param {} elementID 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetDateTimePickerValue = function (elementID, value) {
        $("#" + elementID).data("kendoDatePicker").value(value);
    }

    /**
     * Set giá trị control ComboBox
     * @param {} elementID 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetComboBoxValue = function (elementID, value) {
        $("#" + elementID).data("kendoComboBox").value(value);
    }

    /**
     * Check giá trị cho RadioButton
     * @param {} element 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetRadioButtonValue = function (elementID, value) {
        $('input:radio[id="' + elementID + '"][value="' + value + '"]').prop('checked', true);
    }

    /**
     * Hiển thị lỗi
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.ShowElementError = function (elementID) {
        $("#" + elementID).addClass('asf-focus-input-error');
    }

    /**
     * Hiển thị lỗi combo 
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.ShowComboError = function (comboID) {
        $("#" + comboID).parent().addClass("asf-focus-input-error");
    }

    /**
     * Xóa các báo lỗi
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.RemoveElementError = function () {
        $(".asf-focus-input-error").removeClass("asf-focus-input-error");
    }

    /**
     * Ẩn lỗi
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.HideElementError = function (elementID) {
        $("#" + elementID).removeClass('asf-focus-input-error');
    }

    /**
     * Lấy vị trí Column
     * @param {} grid 
     * @param {} columnName 
     * @returns {}
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetColumnIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName) return i;
        }
        return -1;
    }

    /**
     * Thực hiện xóa Message thông báo
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.ClearMessageBox = function () {
        ASOFT.form.clearMessageBox();
        $(".asf-focus-input-error").removeClass("asf-focus-input-error");
    }

    /**
     * Hiển thị nội dung lỗi
     * @param {} message_array 
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.ShowMessageErrors = function (message_array) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array, null);
    }

    // #endregion --- Utilities ---

    // #endregion --- Methods ---

    // #region --- Events ---

    /**
     * Bắt sự kiện cho Grid HRMT1033
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.GridHRMT1033Events = function () {
        SCREEN1031.GridHRMT1033 = $('#GridEditHRMT1033').data('kendoGrid');

        $(SCREEN1031.GridHRMT1033.tbody)
            .on("change",
                "td",
                function (e) {
                    var selectedItem = SCREEN1031.GridHRMT1033.dataItem(
                        SCREEN1031.GridHRMT1033.select());
                    var columnId = e.target.id;
                    var targetValue = e.target.value;

                    if (!SCREEN1031.IsNotNullOrUndefined(targetValue)) return;

                    // #region --- Check ColumnName ---

                    if (columnId == ("cbb" + SCREEN1031.FIELD_COUNTRYNAME)) {
                        var comboValue = $("#cbb" +
                                SCREEN1031
                                .FIELD_COUNTRYNAME)
                            .data("kendoComboBox")
                            .dataItem();
                        if (SCREEN1031.IsNotNullOrUndefined(comboValue.CountryID) &&
                            SCREEN1031.IsNotNullOrUndefined(comboValue.CountryName)) {
                            selectedItem.CountryID = comboValue.CountryID;
                            selectedItem.CountryName = comboValue.CountryName;
                        }
                    }

                    // #endregion --- Check ColumnName ---
                });
    };

    /**
     * Bắt sự kiện cho Grid HRMT1034 
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.GridHRMT1034Events = function () {
        SCREEN1031.GridHRMT1034 = $('#GridEditHRMT1034').data('kendoGrid');

        $(SCREEN1031.GridHRMT1034.tbody)
            .on("change",
                "td",
                function (e) {
                    var selectedItem = SCREEN1031.GridHRMT1034.dataItem(
                        SCREEN1031.GridHRMT1034.select());
                    var columnId = e.target.id;
                    var targetValue = e.target.value;

                    if (!SCREEN1031.IsNotNullOrUndefined(targetValue)) return;

                    // #region --- Check ColumnName ---

                    if (columnId == ("cbb" + SCREEN1031.FIELD_EDUCATIONTYPENAME)) {
                        var comboValue = $("#cbb" +
                                SCREEN1031
                                .FIELD_EDUCATIONTYPENAME)
                            .data("kendoComboBox")
                            .dataItem();
                        if (SCREEN1031.IsNotNullOrUndefined(comboValue.ID) &&
                            SCREEN1031.IsNotNullOrUndefined(comboValue.Value)) {
                            selectedItem.EducationTypeID = comboValue.ID;
                            selectedItem.EducationTypeName = comboValue.Value;
                        }
                    }

                    // #endregion --- Check ColumnName ---

                    SCREEN1031.GridHRMT1034.refresh();
                });
    };

    /**
     * Bắt các sự kiện nằm trên SCREEN
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.AllEvents = function () {

        // Chọn đợt tuyển dụng
        $("#btn" + SCREEN1031.FIELD_RECPERIODNAME)
            .click(function () {
                SCREEN1031.CurrentChoose = SCREEN1031.ACTION_CHOOSE_RECRUITTURN;

                url = '/PopupSelectData/Index/HRM/HRMF2034?ScreenID=' + $('#sysScreenID').val();

                ASOFT.asoftPopup.showIframe(url, {});
            });

        // Xóa đợt tuyển dụng
        $("#btnDelete" + SCREEN1031.FIELD_RECPERIODNAME)
            .click(function () {
                $("#" + SCREEN1031.FIELD_RECPERIODID).val("");
                $("#" + SCREEN1031.FIELD_RECPERIODNAME).val("");
            });

        // Xử lý đóng popup
        $("#Close")
            .click(function () {
                ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                function () {

                    if (SCREEN1031.IsInValid()) return;

                    var data = SCREEN1031.GetAllData();
                    var saveSuccess = SCREEN1031.SaveData(data);
                    if (saveSuccess) {
                        window.parent.location.reload();
                    } else {
                        ASOFT.asoftPopup.hideIframe();
                        parent.popupClose();
                    }
                },
                function () {
                    if (SCREEN1031.SaveSuccess) {
                        window.parent.location.reload();
                    } else {
                        ASOFT.asoftPopup.hideIframe();
                        parent.popupClose();
                    }
                });
            });


        //Mở popup HRMF2111
        $(document).on("click", "#BtnAddDISC", function (e) {
            var CandidateID = $("#CandidateID").val();
            //var APK = "";
            //var DivisionID = "";
            //ASOFT.helper.postTypeJson('/HRM/HRMF1031/GetAPK', { EmployeeID: CandidateID }, function (result) {
            //    APK = result.APK;
            //    DivisionID = result.DivisionID;
            //});
            var postUrl = "/PopupLayout/Index/HRM/HRMF2111?PK=#=APKMaster#&Table=HRMT21101&key=APK&DivisionID=" + ASOFTEnvironment.DivisionID;
            ASOFT.asoftPopup.showIframe(postUrl, {});
        });

        // #region --- Lưu & Nhập tiếp ---
        $("#SaveNew")
            .click(function () {

                if (SCREEN1031.IsInValid()) return;

                var data = SCREEN1031.GetAllData();
                var saveSuccess = SCREEN1031.SaveData(data);
                if (saveSuccess) {
                    SCREEN1031.AfterSaveProcessing(0);
                    SCREEN1031.SaveSuccess = true;
                }
            });

        // #endregion --- Lưu & Nhập tiếp ---

        // #region --- Lưu & Sao chép ---
        $("#SaveClose")
            .click(function () {
                if (SCREEN1031.IsInValid()) return;

                var data = SCREEN1031.GetAllData();
                var saveSuccess = SCREEN1031.SaveData(data);
                if (saveSuccess) {
                    SCREEN1031.AfterSaveProcessing(1);

                    SCREEN1031.SaveSuccess = true;
                }
            });

        // #endregion --- Lưu & Sao chép

        // #region --- Lưu cập nhật ---

        $("#BtnSave")
            .click(function () {
                if (SCREEN1031.IsInValid()) return;

                var data = SCREEN1031.GetAllData();
                var saveSuccess = SCREEN1031.SaveData(data);
                if (saveSuccess) {
                    SCREEN1031.AfterSaveProcessing(1);
                    window.parent.location.reload();
                }
            });

        // #endregion --- Lưu cập nhật ---
    };

    this.CallBackFromHRMF2111 = function () {
        var CandidateID = $("#CandidateID").val();
        //// ajax ve server get model
        ASOFT.helper.postTypeJson('/HRM/HRMF1031/LoadDISC', { EmployeeID: CandidateID }, function (result) {
            $("#EvaluationDate").data("kendoDatePicker").value(result.EvaluationDate);
            $("#Nature_D").val(result.Nature_D);
            $("#Nature_I").val(result.Nature_I);
            $("#Nature_S").val(result.Nature_S);
            $("#Nature_C").val(result.Nature_C);
            $("#Nature").val(result.Nature);
            $("#Adaptive_D").val(result.Adaptive_D);
            $("#Adaptive_I").val(result.Adaptive_I);
            $("#Adaptive_S").val(result.Adaptive_S);
            $("#Adaptive_C").val(result.Adaptive_C);
            $("#Adaptive").val(result.Adaptive);
            $("#Description").val(result.Description);
        });
        popupClose();
    }

    // #endregion --- Events ---
};

// #region --- Global Callback ---

function receiveResult(result) {
    // Dữ liệu file đính kèm
    if (SCREEN1031.CurrentChoose == SCREEN1031.ACTION_CHOOSE_ATTACH) {
        this[ListChoose['AttachID'](result)];
    }

    // Chọn đợt tuyển dụng
    if (SCREEN1031.CurrentChoose == SCREEN1031.ACTION_CHOOSE_RECRUITTURN) {
        $("#" + SCREEN1031.FIELD_RECPERIODID).val(result.RecruitPeriodID);
        $("#" + SCREEN1031.FIELD_RECPERIODNAME).val(result.RecruitPeriodName);
    }
};

function btnImageIDHRMT1030_Click ()
{
    $(".ImageID .k-widget").removeClass("k-widget");
    $(".k-upload-status-total").remove();
    $('.k-upload-files').remove();
}

// #endregion --- Global Callback ---