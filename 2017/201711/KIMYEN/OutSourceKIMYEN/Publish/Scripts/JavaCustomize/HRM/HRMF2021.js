// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    25/10/2017  Văn Tài         Create New
// ##################################################################

// #region --- Attach file
var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};

var templateAsoftButton = function () {
    this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
        return kendo.format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
            buttonClass,
            buttonID,
            spanClass,
            buttonCaption,
            onclickFunction);
    };

    this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
        return kendo.format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
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
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
        if (typeof $Object.value === "function" && $Object.value() !== "undefined") {
            $Object.value() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
    }
    return false;
}

function getResultAfterDelete(result, apkDelete) {

    var $resultAfterDelete = $.map(result, (function (obj) {

        if (obj.APK != apkDelete)
            return obj;
    }));

    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

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

    var urlPopup3 = "/AttachFile?Type=5";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    SCREEN2021.CurrentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

// #endregion ---

$(document)
    .ready(function () {
        $("#ActualCost").attr("readonly", true);
        $("#CostBoundary").attr("readonly", true);
        $("#QuantityBoundary").attr("readonly", true);
        $("#ActualQuantity").attr("readonly", true);

        // #region --- Catch Data | Không ảnh hưởng tới luồng chạy ---

        var url = new URL(window.location.href);

        SCREEN2021.isUpdate = $('#isUpdate').val() === "True";

        var isInherit = url.searchParams.get("IsInherit");
        if (isInherit != undefined && isInherit != null)
            SCREEN2021.isInherit = isInherit == 1;

        SCREEN2021.DivisionID = $("#" + SCREEN2021.FIELD_DIVISIONID).val();
        if (!SCREEN2021.isUpdate) { // Add New
            SCREEN2021.SetNumericTextBoxValue(SCREEN2021.FIELD_NUMBERINTERVIEWS + "_" + SCREEN2021.TABLE_HRMT2021, 1);
            SCREEN2021.GenRecruitPeriodID();

            var templeteButton = new templateAsoftButton(),
            form = $("#sysScreenID"),
            parentSysScreenID = parent.$("#sysScreenID").val();

            $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
            $($(".Attach").children()[0]).css("width", "14%");
            $("#Attach").css('display', 'none');

        } else { // Update 
            SCREEN2021.APK = $("#" + SCREEN2021.FIELD_APK).val();
            $("#RecruitPeriodID").attr("readonly", true);
            $('.Attach').css('display', 'none');
        }

        // Inherit
        if (SCREEN2021.isInherit) {

            $("#SaveClose").removeClass("control-hide");
            $("#SaveClose").attr("aria-disabled", false);
            $("#SaveNew").removeClass("control-hide");
            $("#SaveNew").attr("aria-disabled", false);

            $("#BtnSave").addClass("control-hide");
            $("#BtnSave").attr("aria-disabled", true);
        }

        // #endregion --- Catch Data | Không ảnh hưởng tới luồng chạy ---

        // #region --- First Load : Step by Step ---

        // Step 01
        SCREEN2021.MoveControlTab01();
        SCREEN2021.MoveControlTab02();
        // Step 02
        SCREEN2021.InsertControlsTab03();
        // Step 03
        SCREEN2021.RemoveTop();

        // #endregion --- First Load : Step by Step ---

        // #region --- Xử lý chạy ngoài core ---

        SCREEN2021.UnbindControl();

        // SETTINGS: READONLY, DISABLED
        SCREEN2021.SettingControls();

        // #endregion --- Xử lý chạy ngoài core ----

        // #region --- After Loading ---

        // Bắt các sự kiện cho các controls

        SCREEN2021.AllEvents();
        SCREEN2021.SettingControls();

        SCREEN2021.TriggeringEvents();

        // #region --- Inherit Processing ---

        // Inherit
        if (SCREEN2021.isInherit) {
            //! Điều chỉnh thêm mới theo trường hợp kế thừa
            SCREEN2021.isUpdate = !SCREEN2021.isInherit;
            $("#" + SCREEN2021.FIELD_RECRUITPERIODID).val("");
            SCREEN2021.GenRecruitPeriodID();
        }

        $("#btnDeleteRecruitRequirement_HRMT2024").kendoButton({ "click": SCREEN2021.btnDeleteRecruitRequirement_HRMT2024_Click });
        // #endregion --- Inherit Processing ---

        // #endregion --- After Loading ---

    });

// HRMF2021 : Đợt tuyển dụng
SCREEN2021 = new function () {

    // #region --- Constants ---

    // #region --- Actions ---


    this.ACTION_CHOOSE_RECRUITREQUIRE = "CHOOSE_RECRUITREQUIRE";
    this.ACTION_CHOOSE_RECRUITPLAN = "CHOOSE_RECRUITRPLAN";

    // #endregion --- Actions ---

    this.SCREEN_ID = "HRMF2021";
    this.TABLE_HRMT2020 = "HRMT2020";
    this.TABLE_HRMT2021 = "HRMT2021";
    this.TABLE_HRMT2022 = "HRMT2022";
    this.TABLE_HRMT2023 = "HRMT2023";
    this.TABLE_HRMT2024 = "HRMT2024";

    this.FIELD_APK = "APK";
    this.FIELD_DIVISIONID = "DivisionID";

    // #region --- Tab 01 ---

    this.FIELD_RECRUITPERIODID = "RecruitPeriodID";
    this.FIELD_RECRUITPERIODNAME = "RecruitPeriodName";
    this.FIELD_RECRUITPLANID = "RecruitPlanID";
    this.FIELD_RECRUITPLANNAME = "RecruitPlanName"; RecruitPlanName
    this.FIELD_DEPARTMENTID = "DepartmentID";
    this.FIELD_DUTYID = "DutyID";
    this.FIELD_PERIODFROMDATE = "PeriodFromDate";
    this.FIELD_PERIODTODATE = "PeriodToDate";
    this.FIELD_RECEIVEFROMDATE = "ReceiveFromDate";
    this.FIELD_RECEIVETODATE = "ReceiveToDate";
    this.FIELD_RECRUITQUANTITY = "RecruitQuantity";
    this.FIELD_WORKPLACE = "WorkPlace";
    this.FIELD_WORKTYPE = "WorkType";
    this.FIELD_REQUIREDATE = "RequireDate";
    this.FIELD_COST = "Cost";
    this.FIELD_COSTS = "Costs";
    this.FIELD_NOTE = "Note";
    this.FIELD_TOTALLEVEL = "TotalLevel";
    this.FIELD_ATTACH = "Attach";

    // Trường bổ sung
    this.FIELD_INHERITRECRUITPERIODID = "InheritRecruitPeriodID";

    // #endregion --- Tab 01 ---

    // #region --- Tab 02 ---

    this.FIELD_DISABLED = "Disabled";
    this.FIELD_GENDER = "Gender";
    this.FIELD_FROMAGE = "FromAge";
    this.FIELD_TOAGE = "ToAge";
    this.FIELD_EDUCATIONLEVELID = "EducationLevelID";
    this.FIELD_APPEARANCE = "Appearance";
    this.FIELD_FROMSALARY = "FromSalary";
    this.FIELD_TOSALARY = "ToSalary";
    this.FIELD_WORKDESCRIPTION = "WorkDescription";
    this.FIELD_LANGUAGE1ID = "Language1ID";
    this.FIELD_LANGUAGE2ID = "Language2ID";
    this.FIELD_LANGUAGE3ID = "Language3ID";
    this.FIELD_LANGUAGELEVEL1ID = "LanguageLevel1ID";
    this.FIELD_LANGUAGELEVEL2ID = "LanguageLevel2ID";
    this.FIELD_LANGUAGELEVEL3ID = "LanguageLevel3ID";
    this.FIELD_ISINFORMATICS = "IsInformatics";
    this.FIELD_INFORMATICSLEVEL = "InformaticsLevel";
    this.FIELD_ISCREATIVENESS = "IsCreativeness";
    this.FIELD_CREATIVENESS = "Creativeness";
    this.FIELD_ISPROBLEMSOLVING = "IsProblemSolving";
    this.FIELD_PROBLEMSOLVING = "ProblemSolving";
    this.FIELD_ISPRSENTATION = "IsPrsentation";
    this.FIELD_PRSENTATION = "Prsentation";
    this.FIELD_ISCOMMUNICATION = "IsCommunication";
    this.FIELD_COMMUNICATION = "Communication";
    this.FIELD_HEIGHT = "Height";
    this.FIELD_WEIGHT = "Weight";
    this.FIELD_HEALTHSTATUS = "HealthStatus";
    this.FIELD_NOTES = "Notes";
    this.FIELD_EXPERIENCE = "Experience";

    this.FIELD_LANGUAGEID = "LanguageID";
    this.FIELD_LANGUAGELEVELID = "LanguageLevelID";

    // Field bổ sung
    this.FIELD_RECRUITREQUIREMENT = "RecruitRequirement";
    this.FIELD_RECRUITREQUIREID = "RecruitRequireID";
    this.FIELD_RECRUITREQUIRENAME = "RecruitRequireName";

    // #endregion --- Tab 02 ---

    // #region --- Tab 03 ---

    this.FIELD_TOTALLEVEL = "TotalLevel";
    this.FIELD_INTERVIEWLEVEL = "InterviewLevel";
    this.FIELD_INTERVIEWADDRESS = "InterviewAddress";
    this.FIELD_INTERVIEWTYPEID = "InterviewTypeID";
    this.FIELD_DETAILTYPEID = "DetailTypeID";
    this.FIELD_TOTALINTERVIEWER = "TotalInterviewer";
    this.FIELD_INTERVIEWERID = "InterviewerID";

    this.FIELD_NUMBERINTERVIEWS = "NumberInterviews";

    // #endregion --- Tab 03 ---

    // #region --- Tab 04 ---

    this.FIELD_CONTENT = "Content";
    this.FIELD_COST = "Cost";
    this.FIELD_NOTES = "Notes";

    // #endregion --- Tab 04 ---

    // id của tab
    this.ID_TAB01 = "Tabs-1";
    this.ID_TAB02 = "Tabs-2";
    this.ID_TAB03 = "Tabs-3";
    this.ID_TAB04 = "Tabs-4";

    // #endregion --- Constants ---

    // #region --- Member Variables ---

    this.APK = "";
    this.Division = "";
    this.InheritRecruitPeriodID = "";
    this.DefaultInterviewers = 1;
    this.oldID = "";

    // FLAGS

    /**
     * FLAG: Load giao diện Vòng phỏng vấn
     */
    this.Action01Loading = false;
    this.RecruitTurnLoadNew = false;

    this.SaveSuccess = false;

    // #endregion --- Member Variables ---

    // #region --- Methods ---

    /**
     * Insert dữ liệu tab Vòng phỏng vấn
     * @returns {} 
     * @since [Văn Tài] Created [26/10/2017]
     */
    this.InsertControlsTab03 = function () {
        $("#" + SCREEN2021.ID_TAB03)
            .append(
                "<div id='RecruitContent' style='height:500px; width:100%;'>" +
                "</div>");
        SCREEN2021.GetNumbersInterviewPartial();
    };

    /**
     * Xử lý hiển thị tab Vòng theo Số vòng phỏng vấn
     * @returns {} 
     * @since [Văn Tài] Created [26/10/2017]
     */
    this.NumbersInterviewProcessing = function () {
        var numbersInterview = SCREEN2021.GetNumericTextBoxValue(SCREEN2021.FIELD_NUMBERINTERVIEWS + "_" + SCREEN2021.TABLE_HRMT2021);

        var TabMaster = "TabMaster";
        if (!SCREEN2021.IsNotNullOrUndefined(numbersInterview)) numbersInterview = 0;

        $("#RecruitContent").css("display", numbersInterview == 0 ? "none" : "");

        if ($('#' + TabMaster + "01").length) {
            for (var i = 1; i <= 5; i++) {
                $("#" + TabMaster + "0{0}".format(i)).css("display", i <= numbersInterview ? "" : "none");
            }
        }
    };

    /**
     * Viết lại một số sự kiện
     * @returns {} 
     * @since [Văn Tài] Created [31/10/2017]
     */
    this.UnbindControl = function () {
        $("#SaveNew").unbind("click");
        $("#SaveClose").unbind("click");
        $("#BtnSave").unbind("click");
        $("#Close").unbind("click");
    };

    this.CompareDateStr = function (fromdatestr, todatestr) {
        var date1 = fromdatestr.split("/");
        var date2 = todatestr.split("/");
        var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
        var todate = new Date(date2[2], date2[1] - 1, date2[0]);
        if (fromdate > todate) {
            return true;
        }
        return false;
    }

    /**
    * Kiểm tra không hợp lệ dữ liệu
    * @returns {} 
    * @since [Văn Tài] Created [31/10/2017]
    */
    this.IsInValid = function () {
        SCREEN2021.ClearMessageBox();

        // #region --- Flag Checkers ---

        // Invalid Input
        var invalidTextBox = [];
        var invalidComboBox = [];

        // Master flag
        var InvalidData = false;

        // Null flag
        var NullValue = false;
        var IsExistRecruitPeriodID_ADDNEW = false;
        var IsBoundFixingProblem = false;
        var Invalid = false;

        // #endregion --- Flag Checkers ---

        // #region --- Messages ---

        var message_array = [];

        // Yêu cầu nhập
        var MSG_REQUIREDINPUT = "00ML000039";
        var MSG_ISEXIST = "00ML000053";

        // Kiểm tra định biên
        var MSG_BoundFixing_001 = "HRMFML000018";
        var MSG_BoundFixing_002 = "HRMFML000019";

        // #endregion --- Messages ---

        // #region --- CHECK: Required Input ---

        // Mã đợt tuyển dụng
        if (SCREEN2021.IsEmptyString(
                SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_RECRUITPERIODID))
        ) {
            NullValue = true;
            invalidTextBox.push(SCREEN2021.FIELD_RECRUITPERIODID);
            message_array.push(ASOFT.helper.getLabelText(SCREEN2021.FIELD_RECRUITPERIODID, MSG_REQUIREDINPUT));
        }

        // Vị trí tuyển dụng
        if (!SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
            NullValue = true;
            invalidComboBox.push(SCREEN2021.FIELD_DUTYID);
            message_array.push(ASOFT.helper.getLabelText(SCREEN2021.FIELD_DUTYID, MSG_REQUIREDINPUT));
        }

        // #region  --- Tab vòng phỏng vấn ---

        var TabMaster = "TabMaster";
        for (var index = 1; index <= 5; index++) {
            var tab = TabMaster + "0{0}".format(index);
            if ($('#' + tab).length > 0 && $('#' + tab).css('display') != 'none') {
                var idCombo = "InterviewTypeID0{0}_{1}".format(index, SCREEN2021.TABLE_HRMT2021);
                var value = SCREEN2021.GetComboBoxValueItem(idCombo);
                if (!SCREEN2021.IsNotNullOrUndefined(value)) {
                    NullValue = true;

                    invalidComboBox.push(idCombo);
                    var message = ASOFT.helper.getMessage(MSG_REQUIREDINPUT);
                    var labelText = $($("#" + idCombo).parent().parent().parent().parent().children()[1]).find('td label')[0].innerText;
                    message_array.push(message.format(labelText));
                }
            }
        }

        // #endregion --- Tab vòng phỏng vấn ---

        // #endregion --- CHECK: Required Input ---

        //  #region --- CHECK invalid
            var PeriodFromDate = $("#PeriodFromDate").val(), date1 = PeriodFromDate.split("/");
            var PeriodToDate = $("#PeriodToDate").val(), date2 = PeriodToDate.split("/");
            var ReceiveFromDate = $("#ReceiveFromDate").val(), date3 = ReceiveFromDate.split("/");
            var ReceiveToDate = $("#ReceiveToDate").val(), date4 = ReceiveToDate.split("/");

            var d = new Date(date1[2], date1[1] - 1, date1[0]);
            if (isNaN(d.valueOf()) && PeriodFromDate != "" && PeriodFromDate != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF2021.PeriodFromDate", "HRMF2021", "HRM")));
            }

            var d2 = new Date(date2[2], date2[1] - 1, date2[0]);
            if (isNaN(d2.valueOf()) && PeriodToDate != "" && PeriodToDate != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF2021.PeriodToDate", "HRMF2021", "HRM")));
            }

            var d3 = new Date(date3[2], date3[1] - 1, date3[0]);
            if (isNaN(d3.valueOf()) && ReceiveFromDate != "" && ReceiveFromDate != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF2021.ReceiveFromDate", "HRMF2021", "HRM")));
            }

            var d4 = new Date(date4[2], date4[1] - 1, date4[0]);
            if (isNaN(d4.valueOf()) && ReceiveToDate != "" && ReceiveToDate != "undefined") {
                Invalid = true;
                message_array.push(ASOFT.helper.getMessage('AFML000387').f(ASOFT.helper.getLanguageString("HRMF2021.ReceiveToDate", "HRMF2021", "HRM")));
            }
            
            var msg = "{0} không là được là số âm"
            if ($("#RecruitQuantity").val() < 0) {
                Invalid = true;
                message_array.push(msg.f(ASOFT.helper.getLanguageString("HRMF2021.RecruitQuantity", "HRMF2021", "HRM")));
            }

            if (SCREEN2021.CompareDateStr(PeriodFromDate, PeriodToDate) == true || SCREEN2021.CompareDateStr(ReceiveFromDate, ReceiveToDate) == true) {
                message_array.push(ASOFT.helper.getMessage('OOFML000022'));
                Invalid = true;
            }
        // #endregion

        if (!NullValue) {

            // #region --- CHECK: Exist Data ---

            if (!SCREEN2021.isUpdate) {
                IsExistRecruitPeriodID_ADDNEW = SCREEN2021.IsExistRecruitPeriodID(SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_RECRUITPERIODID));
                if (IsExistRecruitPeriodID_ADDNEW) {
                    invalidTextBox.push(SCREEN2021.FIELD_RECRUITPERIODID);
                    message_array.push(ASOFT.helper.getLabelText(SCREEN2021.FIELD_RECRUITPERIODID, MSG_ISEXIST));
                    IsExistRecruitPeriodID_ADDNEW = true;

                    SCREEN2021.GenRecruitPeriodID();
                }
            }

            // #endregion --- CHECK: Exist Data ---

            var BoundFixingChecker = SCREEN2021.CheckBoundFixing();
            if (BoundFixingChecker && BoundFixingChecker.length > 0) {
                if (BoundFixingChecker[0]["Status_Quantity"] == 1) { // Vượt số lượng định biên
                    IsBoundFixingProblem = true;
                    invalidComboBox.push(SCREEN2021.FIELD_DUTYID);
                    var message01 = ASOFT.helper.getMessage(MSG_BoundFixing_001);
                    message_array.push(message01);
                }
                if (BoundFixingChecker[0]["Status_Cost"] == 1) { // Vượt chi phí định biên
                    IsBoundFixingProblem = true;
                    invalidComboBox.push(SCREEN2021.FIELD_DUTYID);
                    var message02 = ASOFT.helper.getMessage(MSG_BoundFixing_002);
                    message_array.push(message02);
                }
            }
        }

        // #region --- Show Errors ---

        InvalidData = (NullValue
            || IsExistRecruitPeriodID_ADDNEW
            || IsBoundFixingProblem
            || Invalid
            );
        if (InvalidData) {
            // Danh sách textbox lỗi
            for (var i = 0; i < invalidTextBox.length; i++) {
                SCREEN2021.ShowElementError(invalidTextBox[i]);
            }
            // Danh sách combo lỗi
            for (var i = 0; i < invalidComboBox.length; i++) {
                SCREEN2021.ShowComboError(invalidComboBox[i]);
            }

            // Nội dung lỗi
            SCREEN2021.ShowMessageErrors(message_array);
        }

        // #endregion --- Show Errors ---

        return InvalidData;
    };

    /**
     * Gen mã đợt tuyển dụng
     * @returns {} 
     * @since [Văn Tài] Created [04/11/2017]
     * @since [Văn Tài] Updated [14/12/2017]
     */
    this.GenRecruitPeriodID = function () {
        var url = "/HRM/Common/GetVoucherNoText";
        ASOFT.helper.postTypeJson(url,
            { tableID: "HRMF2021" },
            function (result) {
                if (result) {
                    $("#" + SCREEN2021.FIELD_RECRUITPERIODID).val(result);
                    SCREEN2021.oldID = result;
                }
            });
    }

    this.ReGenRecruitPeriodID = function () {
        //var oldID = $("#" + SCREEN1031.FIELD_RECRUITPERIODID).val();
        var url = "/HRM/Common/UpdateVoucherNo";
        ASOFT.helper.postTypeJson(url, { VoucherNo: SCREEN2021.oldID, tableID: "HRMF2021" }, null);
        SCREEN2021.GenRecruitPeriodID();
    };



    /**
    * Kiểm tra tồn tại mã đợt tuyển dụng
    * @returns {} 
    * @since [Văn Tài] Created [04/11/2017]
    */
    this.IsExistRecruitPeriodID = function (recruitPeriodID) {
        var isExist;
        var url = "/HRM/HRMF2021/CheckExist";
        var sendData = {
            pRecruitPeriodID: recruitPeriodID
        };
        ASOFT.helper.postTypeJson(url, sendData, function (result) {
            isExist = result.Message.Status == 1;
        });

        return isExist;
    }

    /**
     * Thiết lập controls
     * @returns {} 
     * @since [Văn Tài] Created [04/11/2017]
     */
    this.SettingControls = function () {
        //        $("#" + SCREEN2021.FIELD_RECRUITPERIODID).attr("readonly", true);
    };

    /**
     * Kiểm tra định biên
     * @returns {} DataTable
     * @since [Văn Tài] Created [04/11/2017]
     */
    this.CheckBoundFixing = function () {

        var departmentID = "";
        // Phòng ban
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID))) {
            departmentID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID)[SCREEN2021.FIELD_DEPARTMENTID];
        } else {
            departmentID = "";
        }

        var dutyID = "";
        // Phòng ban
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
            dutyID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
        } else {
            dutyID = "";
        }

        var dateValue = SCREEN2021.GetDateTimePickerValue(SCREEN2021.FIELD_PERIODFROMDATE);
        var fromDate = SCREEN2021.IsNotNullOrUndefined(dateValue) ? dateValue : null;
        dateValue = SCREEN2021.GetDateTimePickerValue(SCREEN2021.FIELD_PERIODTODATE);
        var toDate = SCREEN2021.IsNotNullOrUndefined(dateValue) ? dateValue : null;

        var textValue = SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_RECRUITQUANTITY);
        var quantity = SCREEN2021.IsNotNullOrUndefined(textValue) ? textValue : null;

        textValue = SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_COST);
        var cost = SCREEN2021.IsNotNullOrUndefined(textValue) ? textValue : null;

        if (cost != undefined && cost != "")
            //cost = kendo.parseFloat(cost);

        if (quantity != undefined && quantity != "")
            quantity = kendo.parseFloat(quantity);

        var url = "/HRM/HRMF2021/CheckBoundFixing";
        var sendData = {
            pScreenID: SCREEN2021.SCREEN_ID,
            pTableID: SCREEN2021.TABLE_HRMT2020,
            pRecruitPlanID: SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_RECRUITPLANID),
            pDepartmentID: departmentID,
            pDutyID: dutyID,
            pQuantity: quantity,
            pCost: cost,
            pFromdate: fromDate,
            pToDate: toDate
        };

        var resultCallback = null;

        ASOFT.helper.postTypeJson(url, sendData, function (result) {
            resultCallback = result;
        });

        return resultCallback;
    }

    /**
     * Lấy dữ liệu yêu cầu tuyển dụng
     * @param {} RecruitRequireID 
     * @returns {} 
     * @since [Văn Tài] Created [03/11/2017]
     */
    this.RecruitRequirementProcessing = function (RecruitRequireID) {
        var data = {
            pRecruitRequireID: RecruitRequireID
        };
        $.ajax({
            url: '/HRM/HRMF2021/GetRecruitRequirementDetails',
            async: false,
            data: data,
            success: function (result) {
                if (result) {
                    SCREEN2021.DisplayRecruitRequirement(result);
                }
            }
        });
    }

    /**
     * Hiển thị yêu cầu tuyển dụng
     * @param {} data 
     * @returns {} 
     * @since [Văn Tài] Created [04/11/2017]
     */
    this.DisplayRecruitRequirement = function (data) {
        var currentTable = SCREEN2021.TABLE_HRMT2024;

        var textBoxList = [
            SCREEN2021.FIELD_GENDER,
            SCREEN2021.FIELD_GENDER,
            SCREEN2021.FIELD_FROMAGE,
            SCREEN2021.FIELD_TOAGE,
            SCREEN2021.FIELD_APPEARANCE,
            SCREEN2021.FIELD_EXPERIENCE,
            SCREEN2021.FIELD_FROMSALARY,
            SCREEN2021.FIELD_TOSALARY,
            SCREEN2021.FIELD_WORKDESCRIPTION,
            SCREEN2021.FIELD_INFORMATICSLEVEL,
            SCREEN2021.FIELD_CREATIVENESS,
            SCREEN2021.FIELD_PROBLEMSOLVING,
            SCREEN2021.FIELD_PRSENTATION,
            SCREEN2021.FIELD_COMMUNICATION,
            SCREEN2021.FIELD_HEIGHT,
            SCREEN2021.FIELD_WEIGHT,
            SCREEN2021.FIELD_HEALTHSTATUS,
            SCREEN2021.FIELD_NOTES
        ];

        var comboBoxList = [
            SCREEN2021.FIELD_GENDER,
            SCREEN2021.FIELD_EDUCATIONLEVELID,
            SCREEN2021.FIELD_LANGUAGE1ID,
            SCREEN2021.FIELD_LANGUAGE2ID,
            SCREEN2021.FIELD_LANGUAGE3ID,
            SCREEN2021.FIELD_LANGUAGELEVEL1ID,
            SCREEN2021.FIELD_LANGUAGELEVEL2ID,
            SCREEN2021.FIELD_LANGUAGELEVEL3ID,
        ];

        var checkBoxList = [
            SCREEN2021.FIELD_ISINFORMATICS,
            SCREEN2021.FIELD_ISCREATIVENESS,
            SCREEN2021.FIELD_ISPROBLEMSOLVING,
            SCREEN2021.FIELD_ISPRSENTATION,
            SCREEN2021.FIELD_ISCOMMUNICATION
        ];

        var i;
        for (i = 0; i < textBoxList.length; i++) {
            SCREEN2021.SetTextBoxValue(textBoxList[i] + "_" + currentTable, data.Data[textBoxList[i]]);
        }

        for (i = 0; i < comboBoxList.length; i++) {
            SCREEN2021.SetComboBoxValue(comboBoxList[i] + "_" + currentTable, data.Data[comboBoxList[i]]);
        }
        for (i = 0; i < checkBoxList.length; i++) {
            SCREEN2021.SetCheckBoxValue(checkBoxList[i] + "_" + currentTable, data.Data[comboBoxList[i]] === 1 || currentTable, data.Data[comboBoxList[i]]);
        }

        // Xử lý event Checkbox
        SCREEN2021.RequirementCheckBoxTriggering();
    }

    /**
     * Lấy dữ liệu kế hoạch tuyển dụng
     * @param {} RecruitPlanID 
     * @returns {} 
     * @since [Văn Tài] Created [04/11/2017]
     */
    this.RecruitPlanProcessing = function (RecruitPlanID) {
        var departmentID = "";
        // Phòng ban
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID))) {
            departmentID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID)[SCREEN2021.FIELD_DEPARTMENTID];
        } else {
            departmentID = "";
        }

        var dutyID = "";
        // Phòng ban
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
            dutyID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
        } else {
            dutyID = "";
        }

        var data = {
            pDepartmentID: departmentID,
            pDutyID: dutyID,
            pRecruitPlanID: RecruitPlanID
        };

        $.ajax({
            url: '/HRM/HRMF2021/GetRecruitPlanDetails',
            async: false,
            data: data,
            success: function (result) {
                if (result) {
                    SCREEN2021.DisplayRecruitPlan(result);
                }
            }
        });
    };

    this.ListChoose = {
        "Attach": function (result) {

            var $templeteParent = $(".templeteAll"),

                templeteAll = result.map(function (obj) {

                    var objFileName = obj.AttachName,

                        objFileID = obj.APK;

                    return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
                }),

                parentAttach = $("#Attach").parent(),

                templeteAll = templeteAll.join(""),

                $attach = $("#Attach");

            $templeteParent.remove();

            templeteParent = "<div class='templeteAll'>{0}</div>";

            parentAttach.append(kendo.format(templeteParent, templeteAll));

            var objFileID = result.map(function (obj) {
                return obj.AttachID;
            });

            $attach.val(objFileID.join(',')).trigger("change");

            $(".x-close").unbind("click").bind("click", function () {
                deleteFile($(this));
            });
        }
    }
    /**
     * Hiển thị Kế hoạch tuyển dụng
     * @param {} data 
     * @returns {} 
     * @since [Văn Tài] Created [04/11/2017]
     */
    this.DisplayRecruitPlan = function (data) {

        if (data == null || data.Data == null) return;

        var textBoxList = [
            SCREEN2021.FIELD_RECRUITPLANID,
            //SCREEN2021.FIELD_RECRUITPLANNAME,
            SCREEN2021.FIELD_RECRUITQUANTITY,
            SCREEN2021.FIELD_WORKPLACE,
            SCREEN2021.FIELD_COST,
            SCREEN2021.FIELD_COSTS,
            SCREEN2021.FIELD_NOTE
        ];

        var comboBoxList = [
            SCREEN2021.FIELD_DEPARTMENTID,
            SCREEN2021.FIELD_DUTYID,
            SCREEN2021.FIELD_WORKTYPE
        ];

        var dateTimePickerList = [
            SCREEN2021.FIELD_PERIODFROMDATE,
            SCREEN2021.FIELD_PERIODTODATE,
            SCREEN2021.FIELD_RECEIVEFROMDATE,
            SCREEN2021.FIELD_RECEIVETODATE,
            SCREEN2021.FIELD_REQUIREDATE
        ];

        var i;
        for (i = 0; i < textBoxList.length; i++) {

            SCREEN2021.SetTextBoxValue(textBoxList[i], data.Data[textBoxList[i]]);
        }

        for (i = 0; i < comboBoxList.length; i++) {
            SCREEN2021.SetComboBoxValue(comboBoxList[i], data.Data[comboBoxList[i]]);
        }

        for (i = 0; i < dateTimePickerList.length; i++) {
            SCREEN2021.SetDateTimePickerValue(dateTimePickerList[i], data.Data[dateTimePickerList[i]]);
        }
    };

    /**
  * Lấy toàn bộ dữ liệu
  * @returns {} 
  * @since [Văn Tài] Created [31/10/2017]
  */
    this.GetAllData = function () {
        var data = {};
        data.dataMaster = {};   // Thông tin tuyển dụng
        data.dataHRMT2021 = []; // List - Hình thức phỏng vấn
        data.dataHRMT2022 = []; // List - Hội đồng tuyển dụng

        data.GridHRMT2023 = {}; // Grid chi phí
        data.dataHRMT2024 = {}; // Yêu cầu tuyển dụng

        var i;

        // #region --- Main Value ---

        if (SCREEN2021.isUpdate) {
            data.dataMaster[SCREEN2021.FIELD_DIVISIONID] = SCREEN2021.DivisionID;
            data.dataMaster[SCREEN2021.FIELD_APK] = SCREEN2021.APK;
        }

        // #endregion --- Main Value ---

        // #region --- Catch Master : HRMT2020 ---

        var masterTextBoxValue = [
                SCREEN2021.FIELD_RECRUITPERIODID,
                SCREEN2021.FIELD_RECRUITPERIODNAME,
                SCREEN2021.FIELD_RECRUITPLANID,
                SCREEN2021.FIELD_RECRUITQUANTITY,
                SCREEN2021.FIELD_WORKPLACE,
                SCREEN2021.FIELD_WORKTYPE,
                SCREEN2021.FIELD_NOTE
        ];

        var masterDateTimeValue = [
                SCREEN2021.FIELD_PERIODFROMDATE,
                SCREEN2021.FIELD_PERIODTODATE,
                SCREEN2021.FIELD_RECEIVEFROMDATE,
                SCREEN2021.FIELD_RECEIVETODATE,
                SCREEN2021.FIELD_REQUIREDATE
        ];

        // Đổ dữ liệu textbox
        var textValue;
        for (i = 0; i < masterTextBoxValue.length; i++) {
            textValue = SCREEN2021.GetTextBoxValue(masterTextBoxValue[i]);
            data.dataMaster[masterTextBoxValue[i]] = SCREEN2021.IsNotNullOrUndefined(textValue) ? textValue : null;
        }

        // TODO: trường Cost gặp vấn đề
        // Biến đổi trường Cost => Costs // trùng trường Grid
        textValue = SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_COST);
        data.dataMaster[SCREEN2021.FIELD_COST] = SCREEN2021.IsNotNullOrUndefined(textValue) ? textValue : null;

        // Đổ dữ liệu DateTimePicker
        for (i = 0; i < masterDateTimeValue.length; i++) {
            var dateValue = SCREEN2021.GetDateTimePickerValue(masterDateTimeValue[i]);
            data.dataMaster[masterDateTimeValue[i]] = SCREEN2021.IsNotNullOrUndefined(dateValue) ? dateValue : null;
        }

        // #region --- Master ComboBox ---

        // Phòng ban
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID))) {
            data.dataMaster[SCREEN2021.FIELD_DEPARTMENTID] = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID)[SCREEN2021.FIELD_DEPARTMENTID];
        } else {
            data.dataMaster[SCREEN2021.FIELD_DEPARTMENTID] = null;
        }

        // Vị trí tuyển dụng
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
            data.dataMaster[SCREEN2021.FIELD_DUTYID] = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
        } else {
            data.dataMaster[SCREEN2021.FIELD_DUTYID] = null;
        }

        // Hình thức làm việc
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_WORKTYPE))) {
            data.dataMaster[SCREEN2021.FIELD_WORKTYPE] = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_WORKTYPE)["ID"];
        } else {
            data.dataMaster[SCREEN2021.FIELD_WORKTYPE] = null;
        }

        // #endregion --- Master ComboBox ---

        //? Vấn đề InheritRecruitPeriodID
        data.dataMaster[SCREEN2021.FIELD_INHERITRECRUITPERIODID] = $("#" + SCREEN2021.FIELD_RECRUITPLANID).val();

        // Tổng số vòng phỏng vấn
        data.dataMaster[SCREEN2021.FIELD_TOTALLEVEL] = SCREEN2021.GetNumericTextBoxValue("NumberInterviews_{0}".format(SCREEN2021.TABLE_HRMT2021));

        // #endregion --- Catch Master : HRMT2020 ---

        // #region --- TAB: Yêu cầu tuyển dụng: HRMT2024 ---

        var hrmt2024TextBoxValue = [
            SCREEN2021.FIELD_DISABLED,
            SCREEN2021.FIELD_FROMAGE,
            SCREEN2021.FIELD_TOAGE,
            SCREEN2021.FIELD_APPEARANCE,
            SCREEN2021.FIELD_FROMSALARY,
            SCREEN2021.FIELD_TOSALARY,
            SCREEN2021.FIELD_EXPERIENCE,
            SCREEN2021.FIELD_WORKDESCRIPTION,
            SCREEN2021.FIELD_INFORMATICSLEVEL,
            SCREEN2021.FIELD_CREATIVENESS,
            SCREEN2021.FIELD_PROBLEMSOLVING,
            SCREEN2021.FIELD_PRSENTATION,
            SCREEN2021.FIELD_COMMUNICATION,
            SCREEN2021.FIELD_HEIGHT,
            SCREEN2021.FIELD_WEIGHT,
            SCREEN2021.FIELD_HEALTHSTATUS,
            SCREEN2021.FIELD_NOTES
        ];

        var hrmt2024CheckBoxValue = [
            SCREEN2021.FIELD_ISINFORMATICS,
            SCREEN2021.FIELD_ISCREATIVENESS,
            SCREEN2021.FIELD_ISPRSENTATION,
            SCREEN2021.FIELD_ISPROBLEMSOLVING,
            SCREEN2021.FIELD_ISCOMMUNICATION
        ];

        // Đổ dữ liệu textbox
        var key = "";
        for (i = 0; i < hrmt2024TextBoxValue.length; i++) {
            key = hrmt2024TextBoxValue[i] + "_" + SCREEN2021.TABLE_HRMT2024;
            textValue = SCREEN2021.GetTextBoxValue(key);
            data.dataHRMT2024[hrmt2024TextBoxValue[i]] = SCREEN2021.IsNotNullOrUndefined(textValue) ? textValue : null;
        }

        // Đổ dữ liệu checkbox
        for (i = 0; i < hrmt2024CheckBoxValue.length; i++) {
            key = hrmt2024CheckBoxValue[i] + "_" + SCREEN2021.TABLE_HRMT2024;
            data.dataHRMT2024[hrmt2024CheckBoxValue[i]] = SCREEN2021.GetCheckBoxValue(key);
        }

        // #region --- HRMT2024: ComboBox ---

        key = SCREEN2021.FIELD_GENDER + "_" + SCREEN2021.TABLE_HRMT2024;
        // Giới tính
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_GENDER] = SCREEN2021.GetComboBoxValueItem(key)["ID"];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_GENDER] = null;
        }

        key = SCREEN2021.FIELD_EDUCATIONLEVELID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Trình độ học vấn
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_EDUCATIONLEVELID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_EDUCATIONLEVELID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_EDUCATIONLEVELID] = null;
        }

        key = SCREEN2021.FIELD_LANGUAGE1ID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Ngoại ngữ 1
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGE1ID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_LANGUAGEID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGE1ID] = null;
        }

        key = SCREEN2021.FIELD_LANGUAGE2ID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Ngoại ngữ 2
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGE2ID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_LANGUAGEID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGE2ID] = null;
        }

        key = SCREEN2021.FIELD_LANGUAGE3ID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Ngoại ngữ 3
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGE3ID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_LANGUAGEID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGE3ID] = null;
        }

        key = SCREEN2021.FIELD_LANGUAGELEVEL1ID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Cấp độ ngoại ngữ 1
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGELEVEL1ID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_LANGUAGELEVELID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGELEVEL1ID] = null;
        }

        key = SCREEN2021.FIELD_LANGUAGELEVEL2ID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Cấp độ ngoại ngữ 2
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGELEVEL2ID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_LANGUAGELEVELID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGELEVEL2ID] = null;
        }

        key = SCREEN2021.FIELD_LANGUAGELEVEL3ID + "_" + SCREEN2021.TABLE_HRMT2024;
        // Cấp độ ngoại ngữ 3
        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(key))) {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGELEVEL3ID] = SCREEN2021.GetComboBoxValueItem(key)[SCREEN2021.FIELD_LANGUAGELEVELID];
        } else {
            data.dataHRMT2024[SCREEN2021.FIELD_LANGUAGELEVEL3ID] = null;
        }

        // #endregion --- HRMT2024: ComboBox ---

        // #endregion --- TAB: Yêu cầu tuyển dụng: HRMT2024 ---

        // #region --- TAB: Vòng phỏng vấn: HRMT2021, HRMT2022 ---

        // Tồn tại vị trí tuyển dụng => Thực hiện lấy dữ liệu các vòng
        if (SCREEN2021.IsNotNullOrUndefined(data.dataMaster[SCREEN2021.FIELD_DUTYID])) {
            var TabMaster = "TabMaster";
            for (var index = 1; index <= 5; index++) {
                var tab = TabMaster + "0{0}".format(index);
                if ($('#' + tab).css('display') != 'none') {

                    var turnElement = {}; // Đối tượng vòng tuyển dụng

                    // #region --- Hình thức phỏng vấn ---

                    turnElement[SCREEN2021.FIELD_DIVISIONID] = ""; // Controller xử lý bổ xung
                    turnElement[SCREEN2021.FIELD_RECRUITPERIODID] = "";
                    turnElement[SCREEN2021.FIELD_INTERVIEWLEVEL] = index;

                    turnElement[SCREEN2021.FIELD_INTERVIEWADDRESS] = SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_INTERVIEWADDRESS + "0{0}".format(index) + "_" + SCREEN2021.TABLE_HRMT2021);

                    // Lấy hình thức phỏng vấn
                    turnElement[SCREEN2021.FIELD_INTERVIEWERID] = "";
                    var value = SCREEN2021.GetComboBoxValueItem("InterviewTypeID0{0}_{1}".format(index, SCREEN2021.TABLE_HRMT2021));
                    if (SCREEN2021.IsNotNullOrUndefined(value)) turnElement[SCREEN2021.FIELD_INTERVIEWTYPEID] = value[SCREEN2021.FIELD_INTERVIEWTYPEID];

                    // Xử lý lấy các checkbox "checked"
                    var listCheck = $("[id*='chk']");
                    // Lấy danh sách checkbox thuộc tab hiện tại - "checked"
                    listCheck = $.grep(listCheck,
                        function (v) { return v.id.indexOf("_0{0}_{1}".format(index, SCREEN2021.TABLE_HRMT2021)) > 0 && v.checked; });

                    // Lấy id checkbox =>  format: chk + InterviewTypeID + _TableName
                    turnElement[SCREEN2021.FIELD_DETAILTYPEID] = "";
                    if (listCheck.length > 0) {
                        for (var j = 0; j < listCheck.length; j++) {
                            turnElement[SCREEN2021.FIELD_DETAILTYPEID] += listCheck[j].id;
                            if (j < listCheck.length - 1) turnElement[SCREEN2021.FIELD_DETAILTYPEID] += ",";
                        }
                    }

                    // #endregion --- Hình thức phỏng vấn ---

                    // #region --- Hội đồng tuyển dụng ---

                    var interviewerList = {};
                    interviewerList[SCREEN2021.FIELD_DIVISIONID] = "";
                    interviewerList[SCREEN2021.FIELD_RECRUITPERIODID] = "";
                    interviewerList[SCREEN2021.FIELD_INTERVIEWLEVEL] = index;
                    interviewerList[SCREEN2021.FIELD_TOTALINTERVIEWER] = SCREEN2021.GetNumericTextBoxValue("spnTotal0{0}_{1}".format(index, SCREEN2021.TABLE_HRMT2021));
                    interviewerList[SCREEN2021.FIELD_INTERVIEWERID] = $("#multiInterviewers0{0}_{1}".format(index, SCREEN2021.TABLE_HRMT2021)).data("kendoMultiSelect").value().join(',');

                    // Lấy danh sách hội đồng tuyển dụng
                    data.dataHRMT2022.push(interviewerList);

                    // #endregion --- Hội đồng tuyển dụng ---

                    data.dataHRMT2021.push(turnElement);
                }
            }

        } // END - Check If

        // #endregion --- TAB: Vòng phỏng vấn: HRMT2021, HRMT2022 ---

        // #region --- TAB: Chi phí: HRMT2023 ---

        data.GridHRMT2023 = $('#GridEditHRMT2023').data('kendoGrid').dataSource._data;

        // #endregion --- TAB: Chi phí: HRMT2023 ---

        return data;
    }

    /**
     * Lưu dữ liệu
     * @param {} data 
     * @returns {} 
     * @since [Văn Tài] Created [01/10/2017]
     * @since [Văn Tài] Updated [14/12/2017]
     * @exception Các chữ số hàng nghìn 10,000 gặp lỗi không không parse được số, kendo.parseFloat bổ sung
     */
    this.SaveData = function (data) {
        var saveSuccess = false;
        var addNew = (SCREEN2021.isUpdate == false);
        var url = "/HRM/HRMF2021/UpdateData";

        if (data.dataMaster.Costs != undefined && data.dataMaster.Costs != "")
            data.dataMaster.Costs = kendo.parseFloat(data.dataMaster.Costs);
        if (data.dataMaster.Cost != undefined && data.dataMaster.Cost != "")
            data.dataMaster.Cost = kendo.parseFloat(data.dataMaster.Cost);
        if (data.dataMaster.RecruitQuantity != undefined && data.dataMaster.RecruitQuantity != "")
            data.dataMaster.RecruitQuantity = kendo.parseFloat(data.dataMaster.RecruitQuantity);

        if (data.dataMaster.FromSalary != undefined && data.dataMaster.FromSalary != "")
            data.dataHRMT2024.FromSalary = kendo.parseFloat(data.dataHRMT2024.FromSalary);
        if (data.dataMaster.ToSalary != undefined && data.dataMaster.ToSalary != "")
            data.dataHRMT2024.ToSalary = kendo.parseFloat(data.dataHRMT2024.ToSalary);

        //Get Data Attach
        var Attach = [];
            $(".file-templete").each(function () {
                Attach.push($(this).attr('id'));
            });

        var sendData = {
            pAddNew: addNew,
            pMaster: data.dataMaster,
            pDataHRMT2021: data.dataHRMT2021,
            pDataHRMT2022: data.dataHRMT2022,
            pDataHRMT2023: data.GridHRMT2023,
            pDataHRMT2024: data.dataHRMT2024,
            Attach: Attach,
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

    /**
    * Hoạt động sau khi Lưu
    * @returns {} 
    * @since [Văn Tài] Created [02/10/2017]
    */
    this.AfterSaveProcessing = function (saveState) {
        SCREEN2021.SetTextBoxValue(SCREEN2021.FIELD_CANDIDATEID);

        ASOFT.form.displayInfo('#' + SCREEN2021.SCREEN_ID, ASOFT.helper.getMessage("00ML000015"));

        if (saveState == 0) {

            // #region --- TextBox: ResetText ---

            var resetMasterTextBoxList = [
                SCREEN2021.FIELD_RECRUITPERIODID,
                SCREEN2021.FIELD_RECRUITPERIODNAME,
                SCREEN2021.FIELD_RECRUITPLANID,
                SCREEN2021.FIELD_RECRUITPLANNAME,
                SCREEN2021.FIELD_RECRUITQUANTITY,
                SCREEN2021.FIELD_COSTS,
                SCREEN2021.FIELD_WORKPLACE,
                SCREEN2021.FIELD_NOTE
            ];
            var i;
            for (i = 0; i < resetMasterTextBoxList.length; i++) {
                SCREEN2021.SetTextBoxValue(resetMasterTextBoxList[i], "");
            }

            var resetDetailTextBoxList = [
                SCREEN2021.FIELD_RECRUITREQUIREMENT,
                SCREEN2021.FIELD_FROMAGE,
                SCREEN2021.FIELD_TOAGE,
                SCREEN2021.FIELD_APPEARANCE,
                SCREEN2021.FIELD_EXPERIENCE,
                SCREEN2021.FIELD_FROMSALARY,
                SCREEN2021.FIELD_TOSALARY,
                SCREEN2021.FIELD_WORKDESCRIPTION,
                SCREEN2021.FIELD_INFORMATICSLEVEL,
                SCREEN2021.FIELD_CREATIVENESS,
                SCREEN2021.FIELD_PROBLEMSOLVING,
                SCREEN2021.FIELD_PRSENTATION,
                SCREEN2021.FIELD_COMMUNICATION,
                SCREEN2021.FIELD_WEIGHT,
                SCREEN2021.FIELD_HEIGHT,
                SCREEN2021.FIELD_HEALTHSTATUS,
                SCREEN2021.FIELD_NOTES
            ];
            for (i = 0; i < resetMasterTextBoxList.length; i++) {
                SCREEN2021.SetTextBoxValue(resetMasterTextBoxList[i], "");
            }

            for (i = 0; i < resetDetailTextBoxList.length; i++) {
                var key = resetDetailTextBoxList[i] + "_" + SCREEN2021.TABLE_HRMT2024;
                SCREEN2021.SetTextBoxValue(key, "");
            }

            // #endregion --- TextBox: ResetText ---

            // Gen mã mới
            if (!SCREEN2021.isUpdate) {
                SCREEN2021.ReGenRecruitPeriodID();
            }

            // #region --- DateTimePicker: ResetText ---

            var resetMasterDateValueList = [
                  SCREEN2021.FIELD_PERIODFROMDATE,
                  SCREEN2021.FIELD_RECEIVEFROMDATE,
                  SCREEN2021.FIELD_PERIODTODATE,
                  SCREEN2021.FIELD_RECEIVETODATE,
                  SCREEN2021.FIELD_REQUIREDATE
            ];

            for (i = 0; i < resetMasterDateValueList.length; i++) {
                SCREEN2021.SetDateTimePickerValue(resetMasterDateValueList[i], "");
            }

            // #endregion --- DateTimePicker: ResetText ---

            // #region --- ComboBox: ResetText ---

            var resetMasterComboValueList = [
               SCREEN2021.FIELD_DEPARTMENTID,
               SCREEN2021.FIELD_DUTYID,
               SCREEN2021.FIELD_WORKTYPE
            ];

            for (i = 0; i < resetMasterComboValueList.length; i++) {
                SCREEN2021.SetComboBoxValue(resetMasterComboValueList[i], "");
            }

            var resetDetailComboValueList = [
              SCREEN2021.FIELD_GENDER,
              SCREEN2021.FIELD_EDUCATIONLEVELID,
              SCREEN2021.FIELD_LANGUAGE1ID,
              SCREEN2021.FIELD_LANGUAGE2ID,
              SCREEN2021.FIELD_LANGUAGE3ID,
              SCREEN2021.FIELD_LANGUAGELEVEL1ID,
              SCREEN2021.FIELD_LANGUAGELEVEL2ID,
              SCREEN2021.FIELD_LANGUAGELEVEL3ID
            ];

            for (i = 0; i < resetDetailComboValueList.length; i++) {
                var key = resetDetailComboValueList[i] + "_" + SCREEN2021.TABLE_HRMT2024;
                SCREEN2021.SetComboBoxValue(key, "");
            }

            // #endregion --- ComboBox: ResetText ---

            // #region --- CheckBox: Unchecked ---

            var resetDetailCheckBoxValueList = [
               SCREEN2021.FIELD_ISINFORMATICS,
               SCREEN2021.FIELD_ISCREATIVENESS,
               SCREEN2021.FIELD_ISPROBLEMSOLVING,
               SCREEN2021.FIELD_ISPRSENTATION,
               SCREEN2021.FIELD_ISCOMMUNICATION
            ];

            for (i = 0; i < resetDetailCheckBoxValueList.length; i++) {
                var key = resetDetailCheckBoxValueList[i] + "_" + SCREEN2021.TABLE_HRMT2024;
                SCREEN2021.SetCheckBoxValue(key, false);
            }

            // #endregion --- CheckBox: Unchecked ---

            // #region --- Spinner: Default Value ---

            var resetDetailSpinnerValueList = [
              SCREEN2021.FIELD_NUMBERINTERVIEWS
            ];

            for (i = 0; i < resetDetailSpinnerValueList.length; i++) {
                var key = resetDetailSpinnerValueList[i] + "_" + SCREEN2021.TABLE_HRMT2021;
                SCREEN2021.SetNumericTextBoxValue(key, 1);
            }

            // #endregion --- Spinner: Default Value ---

            // #region --- KendoGrid: Reset Value ---

            $('#GridEditHRMT2023').data('kendoGrid').dataSource.data([]);
            $('#GridEditHRMT2023').data('kendoGrid').dataSource.add({});

            // #endregion --- KendoGrid: Reset Value ---

            // #region --- Trigger Events ---

            $("#" + SCREEN2021.FIELD_DUTYID).trigger("change");

            // #endregion --- Trigger Events ---

        }

    };

    /**  
    * get data số lượng, chi phí chọn phòng ban
    * [Thanh Trong] Create New [29/12/2017]
    **/
    this.LoadData = function () {
        var data = {
            Mode: 0,
            DutyID: $("#DutyID").val(),
            DepartmentID: $("#DepartmentID").val(),
            FromDate: $("#PeriodFromDate").val(),
            ToDate: $("#PeriodToDate").val(),
            RecruitPlanID: $("#RecruitPlanID").val()
        };
        $.ajax({
            url: "/HRM/HRMF2021/LoadData",
            async: false,
            data: data,
            success: function (result) {
                var record = JSON.parse(result);
                if (record == undefined || record.length == 0) return;

                if (SCREEN2021.IsNotNullOrUndefined(record[0]["QuantityBoundary"]))
                    $("#QuantityBoundary").val(record[0]["QuantityBoundary"]);

                if (SCREEN2021.IsNotNullOrUndefined(record[0]["ActualQuantity"]))
                    $("#ActualQuantity").val(record[0]["ActualQuantity"]);
            }
        });
    }

    /**
     * Get data số lương, chi phí khi chọn vị trí
     * [Thanh Trong] Created [29/12/2017]
     * @returns {} 
     */
    this.LoadDataCostMaster = function () {
        var data = {
            Mode: 0,
            DutyID: "",
            DepartmentID: $("#DepartmentID").val(),
            FromDate: $("#PeriodFromDate").val(),
            ToDate: $("#PeriodToDate").val(),
            RecruitPlanID: $("#RecruitPlanID").val()
        };
        $.ajax({
            url: "/HRM/HRMF2021/LoadData",
            async: false,
            data: data,
            success: function (result) {
                var record = JSON.parse(result);

                if (record == undefined || record.length == 0) return;
                
                $("#CostBoundary").val(record[0]["CostBoundary"]);
                $("#ActualCost").val(record[0]["ActualCost"]);
            }
        });
    }

    // #region --- Move Controls ---

    /**
     * Xử lý cho Tab thông tin tuyển dụng
     * @returns {} 
     * @since [Văn Tài] Created [25/10/2017]
     */
    this.MoveControlTab01 = function () {
        var DTD = "<div class='container_12'><table class='asf-table-view' id='DTD'></table>";
        var PB = "<div class='container_12'><table class='asf-table-view' id='PB'></table>";
        var KHTD = "<div class='container_12'><table class='asf-table-view' id='KHTD'></table>";
        var GroupTG = "<fieldset id='GroupTG'><legend><label>" +
             SCREEN2021.GetLanguageFromServer("HRMF2021.Time") +
            "</label></legend><table class='asf-table-view'></table></fieldset>";

        $("#Tabs-1").prepend(GroupTG);
        $("#Tabs-1").prepend(KHTD);
        $("#Tabs-1").prepend(PB);
        $("#Tabs-1").prepend(DTD);

        $("#DTD").append($(".RecruitPeriodID"));
        $("#DTD").append($(".RecruitPeriodName"));
        $("#PB").append($(".DepartmentID"));

        $("#KHTD").append($(".RecruitPlanName"));
        $($(".RecruitPlanName .asf-td-caption")[0]).css("width", "17.5%");

        $($(".DepartmentID td")[1]).css("width", "31%");
        $(".DepartmentID").append($(".DutyID td"));
        $(".DepartmentID td").removeClass("asf-td-caption");

        $("#GroupTG .asf-table-view").append($(".PeriodFromDate"));
        $("#GroupTG .asf-table-view").append($(".ReceiveFromDate"));
        $(".PeriodFromDate").append($(".PeriodToDate td"));
        $(".PeriodFromDate td").removeClass("asf-td-caption");
        $(".ReceiveFromDate").append($(".ReceiveToDate td"));
        $(".ReceiveFromDate td").removeClass("asf-td-caption");


        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".ActualCost"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".CostBoundary"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".ActualQuantity"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".QuantityBoundary"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".RecruitQuantity"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".WorkType"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".Cost"));
        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".Attach"));

        $(".WorkPlace").before($(".ActualCost"));
        $(".WorkPlace").before($(".CostBoundary"));


        $("#Tabs-1 .grid_6_1 .asf-table-view").append($(".RecruitPlanID"));
        $(".RecruitPlanID").css("display", "none");

        $("#DTD .asf-td-caption").css("width", "17.4%");

        $("#RecruitPlanName").css("width", "91% !important");
        $("#btnRecruitPlanName").css("right", "51px");
        $("#btnDeleteRecruitPlanName").css("right", "20px");

    };

    /**
     * Xử lý cho Tab yêu cầu tuyển dụng
     * @returns {} 
     * @since [Văn Tài] Created [25/10/2017]
     */
    this.MoveControlTab02 = function () {
        var GrouYCC = "<fieldset id='GrouYCC'>" +
            "<legend>" +
            "<label>" +
                 SCREEN2021.GetLanguageFromServer("HRMF2021.CommonRequirement") +
          "</label>" +
            "</legend><table class='asf-table-view' id='top'></table></fieldset>";

        var GrouYCKN = "<fieldset id='GrouYCKN'>" +
            "<legend>" +
                "<label>" +
                 SCREEN2021.GetLanguageFromServer("HRMF2021.SkillRequirement") +
                "</label>" +
            "</legend>" +
            "<table class='asf-table-view' id='topGrouYCKN'></table><table class='asf-table-view' id='botGrouYCKN'></table></fieldset>";
        var GrouYCSK = "<fieldset id='GrouYCSK'>" +
            "<legend>" +
                "<label> " +
                SCREEN2021.GetLanguageFromServer("HRMF2021.HealthRequirement") +
                "</label>" +
            "</legend>" +
            "<table class='asf-table-view'></fieldset>";

        var WD = "<div class='container_12'><table class='asf-table-view' id='WD'></table>";
        $("#Tabs-2").prepend(GrouYCSK);
        $("#Tabs-2").prepend(GrouYCKN);
        $("#Tabs-2").prepend(WD);
        $("#Tabs-2").prepend(GrouYCC);

        $("#top").append($(".Gender_HRMT2024"));
        $("#top").append($(".FromAge_HRMT2024"));
        $("#top").append($(".FromSalary_HRMT2024"));

        $(".Gender_HRMT2024").append($(".EducationLevelID_HRMT2024 td"));

        $(".FromAge_HRMT2024 .asf-td-field").prepend($(".FromAge_HRMT2024 label"));
        $(".FromAge_HRMT2024 .asf-td-caption").append("<label for='FromAge_HRMT2024'>" +
            SCREEN2021.GetLanguageFromServer("HRMF2021.Age") +
            "</label>");
        $("#FromAge_HRMT2024").after($("#ToAge_HRMT2024"));
        $("#FromAge_HRMT2024").after($(".ToAge_HRMT2024 label"));

        $(".FromAge_HRMT2024").append($(".Experience_HRMT2024 td"));
        $("#FromAge_HRMT2024").css("width", "30%");
        $("#ToAge_HRMT2024").css("width", "30%");
        $("#FromAge_HRMT2024").css("margin-left", "10px");
        $("#ToAge_HRMT2024").css("margin-left", "10px");
        $(".FromAge_HRMT2024 .asf-td-field").css("width", "40%");

        $(".FromSalary_HRMT2024 .asf-td-field").prepend($(".FromSalary_HRMT2024 label"));
        $(".FromSalary_HRMT2024 .asf-td-caption").append("<label for='FromSalary_HRMT2024'>" +
            SCREEN2021.GetLanguageFromServer("HRMF2021.Salary") +
            "</label>");
        $("#FromSalary_HRMT2024").after($("#ToSalary_HRMT2024"));
        $("#FromSalary_HRMT2024").after($(".ToSalary_HRMT2024 label"));

        $(".FromSalary_HRMT2024").prepend($(".Appearance_HRMT2024 td"));
        $("#FromSalary_HRMT2024").css("width", "30%");
        $("#ToSalary_HRMT2024").css("width", "30%");
        $("#FromSalary_HRMT2024").css("margin-left", "10px");
        $("#ToSalary_HRMT2024").css("margin-left", "10px");
        $(".FromSalary_HRMT2024 .asf-td-field").css("width", "40%");

        $(".Gender_HRMT2024 td").removeClass("asf-td-caption");
        $(".FromAge_HRMT2024 td").removeAttr("colspan");
        $(".FromAge_HRMT2024 td").removeClass("asf-td-caption");
        $(".FromSalary_HRMT2024 td").removeAttr("colspan");
        $(".FromSalary_HRMT2024 td").removeClass("asf-td-caption");

        $("#WD").append($(".WorkDescription_HRMT2024"));
        $(".WorkDescription_HRMT2024 .asf-td-field").css("width", "100%");
        $(".WorkDescription_HRMT2024 td").removeClass("asf-td-caption");

        $("#topGrouYCKN").append($(".Language1ID_HRMT2024"));
        $(".Language1ID_HRMT2024").append($(".LanguageLevel1ID_HRMT2024 td"));
        $("#topGrouYCKN").append($(".Language2ID_HRMT2024"));
        $(".Language2ID_HRMT2024").append($(".LanguageLevel2ID_HRMT2024 td"));
        $("#topGrouYCKN").append($(".Language3ID_HRMT2024"));
        $(".Language3ID_HRMT2024").append($(".LanguageLevel3ID_HRMT2024 td"));

        $(".Language1ID_HRMT2024 td").removeClass("asf-td-caption");
        $(".Language1ID_HRMT2024 td").removeAttr("colspan");
        $(".Language2ID_HRMT2024 td").removeClass("asf-td-caption");
        $(".Language2ID_HRMT2024 td").removeAttr("colspan");
        $(".Language3ID_HRMT2024 td").removeClass("asf-td-caption");
        $(".Language3ID_HRMT2024 td").removeAttr("colspan");

        $("#botGrouYCKN").append($(".IsInformatics_HRMT2024"));
        $("#botGrouYCKN").append($(".InformaticsLevel_HRMT2024"));
        $("#botGrouYCKN").append($(".IsCreativeness_HRMT2024"));
        $("#botGrouYCKN").append($(".Creativeness_HRMT2024"));
        $("#botGrouYCKN").append($(".IsProblemSolving_HRMT2024"));
        $("#botGrouYCKN").append($(".ProblemSolving_HRMT2024"));
        $("#botGrouYCKN").append($(".IsPrsentation_HRMT2024"));
        $("#botGrouYCKN").append($(".Prsentation_HRMT2024"));
        $("#botGrouYCKN").append($(".IsCommunication_HRMT2024"));
        $("#botGrouYCKN").append($(".Communication_HRMT2024"));
        $("#botGrouYCKN .asf-td-caption").remove();

        $("#GrouYCSK .asf-table-view").append($(".Height_HRMT2024"));
        $("#GrouYCSK .asf-table-view").append($(".HealthStatus_HRMT2024"));
        $("#GrouYCSK .asf-table-view").append($(".Notes_HRMT2024"));

        $(".Height_HRMT2024").prepend($(".Weight_HRMT2024 td"));
        $(".Height_HRMT2024 td").removeClass("asf-td-caption");
        $(".Height_HRMT2024 td").removeAttr("colspan");

        $(".HealthStatus_HRMT2024 .asf-td-field").attr("colspan", "3");
        $(".HealthStatus_HRMT2024 td").removeClass("asf-td-caption");
        $(".Notes_HRMT2024 .asf-td-field").attr("colspan", "3");
        $(".Notes_HRMT2024 td").removeClass("asf-td-caption");

        $(".ToAge_HRMT2024").remove();
        $(".ToSalary_HRMT2024").remove();

        var top_select =
            "<div class='grid_6_1 alpha float_left' style='margin-right: 50%;'>" +
                "<table class='asf-table-view' id='RecRequiredSelect'>" +
                "<tbody></tbody>" +
                "</table>" +
            "</div>";
        $(top_select).insertBefore("#GrouYCC");
        $("." + SCREEN2021.FIELD_RECRUITREQUIREMENT + "_" + SCREEN2021.TABLE_HRMT2024).appendTo("#RecRequiredSelect");

        $("label[for='WorkDescription_HRMT2024']").parent().css("width", "10%");
    };
    /**
     * Xử lý header nằm trên Tab
     * @returns {} 
     * @since [Văn Tài] Created [08/11/2017]
     */
    this.RemoveTop = function () {
        $("#" + SCREEN2021.SCREEN_ID).children()[0].remove();
    }

    /**
     * Lấy PartialView cho tab Vòng phỏng vấn
     * @returns {} 
     * @since [Văn Tài] Created [26/10/2017]
     */
    this.GetNumbersInterviewPartial = function () {
        $("#RecruitContent").empty();

        var RecruitPeriodID = SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_RECRUITPERIODID);
        var DutyID = "";
        var InterviewLevel = SCREEN2021.GetTextBoxValue(SCREEN2021.FIELD_NUMBERINTERVIEWS + "_" + SCREEN2021.TABLE_HRMT2021);

        if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
            DutyID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
        }

        var data = {
            divisionID: SCREEN2021.DivisionID,
            recruitPeriodID: RecruitPeriodID,
            dutyID: DutyID,
            interviewLevel: InterviewLevel,
            mode: SCREEN2021.isUpdate ? 1 : 0
        };

        $.ajax({
            url: '/Partial/PartialHRMF2021NumbersInterview',
            async: false,
            data: data,
            success: function (result) {
                $("#RecruitContent").append(result);

                if (SCREEN2021.RecruitTurnLoadNew) {
                    for (var index = 1; index <= 5; index++) {
                        SCREEN2021.SetNumericTextBoxValue("spnTotal0{0}_{1}".format(index, SCREEN2021.TABLE_HRMT2021), SCREEN2021.DefaultInterviewers);
                    }
                }
            }

        });
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
        var language = ASOFT.helper.getLanguageString(languageID, SCREEN2021.SCREEN_ID, "HRM");
        return (SCREEN2021.IsNotNullOrUndefined(language) ? language : "Undefined");
    }

    /**
     * Lấy giá trị Textbox
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetTextBoxValue = function (elementID) {
        var value = $("#" + elementID).val();
        if (SCREEN2021.IsNotNullOrUndefined(value)) return value;
        return "";
    }

    /**
     * Lấy giá trị control Numeric
     * @param {} elementID 
     * @returns {} 
     * @since  [Văn Tài] Created [26/10/2017]
     */
    this.GetNumericTextBoxValue = function (elementID) {
        return $("#" + elementID).data("kendoNumericTextBox").value();
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
        try {
            var combo = $("#" + elementID).data("kendoComboBox");
            return combo.dataItem(combo.select());
        } catch (ex) {
            console.error(e, e.stack);
        }
    }

    /**
     * Lấy giá trị CheckBox
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [01/11/2017]
     */
    this.GetCheckBoxValue = function (elementID) {
        return $("#" + elementID)[0].checked;
    };

    /**
     * Set giá trị CheckBox
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [01/11/2017]
     */
    this.SetCheckBoxValue = function (elementID, value) {
        $("#" + elementID)[0].checked = value;
    };

    /**
     * Set giá trị textbox
     * @param {} elementID : Id textbox
     * @param {} value : giá trị thay đổi
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetTextBoxValue = function (elementID, value) {
        $("#" + elementID).val(value);
    }

    /**
     * Set giá trị control Numeric
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [26/10/2017]
     */
    this.SetNumericTextBoxValue = function (elementID, value) {
        $("#" + elementID).data("kendoNumericTextBox").value(value);
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
     * @param {} value: true | false
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
     * Sự kiện chọn cho Các combo Hình thức phỏng vấn
     * @returns {} 
     * @since [Văn Tài] Created [26/10/2017]
     */
    this.OnInterviewTypeComboChange = function (render) {
        if (SCREEN2021.Action01Loading) return;

        if (render && render.sender && render.sender.element[0]) {
            var id = render.sender.element[0].id;

            if (id) {
                var dutyID = "";
                var interviewTypeID = "";

                if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
                    dutyID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
                }
                if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(id))) {
                    interviewTypeID = SCREEN2021.GetComboBoxValueItem(id)[SCREEN2021.FIELD_INTERVIEWTYPEID];
                }

                index = id.slice(-SCREEN2021.TABLE_HRMT2021.length - 3, -SCREEN2021.TABLE_HRMT2021.length - 1);
                id = id.split('_')[0];

                var data = {
                    dutyID: dutyID,
                    interviewTypeID: interviewTypeID,
                    index: index
                };

                $.ajax({
                    url: '/HRM/HRMF2021/GetInterviewTypeDetailView',
                    async: false,
                    data: data,
                    success: function (result) {
                        $(".trCheck" + index).remove(); // Xóa các tr cũ. Load tr Checkbox mới
                        $("#tr" + id).parent().append(result);
                    }
                });
            }
        }
    };

    /**
     * Bắt sự kiện thay đối giá trị Số lượng Hội đồng tuyển dụng
     * @param {} render 
     * @returns {} 
     * @since [Văn Tài] Created [30/10/2017]
     */
    this.OnTotalInterviewersChange = function (render) {
        if (SCREEN2021.Action01Loading) return;

        if (render && render.sender && render.sender.element[0]) {
            var id = render.sender.element[0].id;

            if (id == "spnTotal01_HRMT2021") {
                var multi = $("#multiInterviewers01_HRMT2021").data("kendoMultiSelect");
                multi.value("");
                multi.input.blur();
            }
            if (id == "spnTotal02_HRMT2021") {
                var multi = $("#multiInterviewers02_HRMT2021").data("kendoMultiSelect");
                multi.value("");
                multi.input.blur();
            }
            if (id == "spnTotal03_HRMT2021") {
                var multi = $("#multiInterviewers03_HRMT2021").data("kendoMultiSelect");
                multi.value("");
                multi.input.blur();
            }
            if (id == "spnTotal04_HRMT2021") {
                var multi = $("#multiInterviewers04_HRMT2021").data("kendoMultiSelect");
                multi.value("");
                multi.input.blur();
            }
            if (id == "spnTotal05_HRMT2021") {
                var multi = $("#multiInterviewers05_HRMT2021").data("kendoMultiSelect");
                multi.value("");
                multi.input.blur();
            }
        }
    }

    /**
     * Sự kiện thay đổi Chọn danh sách Hội đồng tuyển dụng
     * @param {} render 
     * @returns {} 
     * @since [Văn Tài] Created [30/10/2017]
     */
    this.OnSelectInterviewsChange = function (render) {
        if (SCREEN2021.Action01Loading) return;

        if (render && render.sender && render.sender.element[0]) {
            var id = render.sender.element[0].id;

            SCREEN2021.ClearMessageBox();

            var message = "HRMFML000028"; // Vượt quá số lượng
            var count = 0;
            var QuantityExceeded = false;

            var multiControl = "multiInterviewers0{0}_HRMT2021";
            var spnControl = "spnTotal0{0}_HRMT2021";

            for (var i = 1; i <= 5; i++) {
                var idMulti = multiControl.format(i);
                var idSpinner = spnControl.format(i);

                if (id == idMulti) {
                    if ($("#" + idMulti).val() == "") return;
                    count = parseInt($("#" + idSpinner).val());

                    var itemCount = $("#" + idMulti).data("kendoMultiSelect").value().length;
                    if (itemCount > count) {
                        SCREEN2021.ShowComboError(idSpinner);
                        SCREEN2021.ShowComboError(idMulti);
                        QuantityExceeded = true;

                        var newValue = $("#" + idMulti).data("kendoMultiSelect").value().slice(0, itemCount - 1);
                        $("#" + idMulti).data("kendoMultiSelect").value(newValue);
                    }
                    break;
                }
            }

            var message_array = [];
            if (QuantityExceeded == true) {
                message_array.push(ASOFT.helper.getMessage("HRMFML000028"));
                SCREEN2021.ShowMessageErrors(message_array);
            }
        }
    }

    /**
     * Xử lý sự kiện cho các Controls
     * @returns {} 
     * @since [Văn Tài] Created [26/10/2017]
     */
    this.AllEvents = function () {

        //Load chi phí khi chọn phòng ban
        $("#DepartmentID").data("kendoComboBox").bind("change", function (e) {
            SCREEN2021.LoadDataCostMaster();
        });

        // Sự kiện thay đổi Vị trí tuyển dụng
        $("#" + SCREEN2021.FIELD_DUTYID)
            .on("change",
                function (e) {
                    // Load chi phí, số lượng
                    SCREEN2021.LoadData();

                    // FLAGS
                    SCREEN2021.Action01Loading = true;

                    SCREEN2021.RecruitTurnLoadNew = true;
                    SCREEN2021.GetNumbersInterviewPartial();

                    // FLAGS
                    SCREEN2021.Action01Loading = false;
                });

        // Sự kiện thay đổi số Vòng tuyển dụng
        $("#" + SCREEN2021.FIELD_NUMBERINTERVIEWS + "_" + SCREEN2021.TABLE_HRMT2021)
            .on("change",
                function (e) {
                    SCREEN2021.NumbersInterviewProcessing();
                });

        // Nhấn nút Chọn yêu cầu tuyền dụng
        $("#btn" + SCREEN2021.FIELD_RECRUITREQUIREMENT + "_" + SCREEN2021.TABLE_HRMT2024)
            .on("click",
                function (e) {

                    SCREEN2021.CurrentChoose = SCREEN2021.ACTION_CHOOSE_RECRUITREQUIRE;

                    var dutyID = "";
                    // Phòng ban
                    if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
                        dutyID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
                    } else {
                        dutyID = "";
                    }

                    url = '/PopupSelectData/Index/HRM/HRMF2024?ScreenID=' + $('#sysScreenID').val() + '&DutyID=' + dutyID;

                    ASOFT.asoftPopup.showIframe(url, {});
                });

        // Xử lý đóng popup
        $("#Close")
            .click(function () {
                ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                function () {

                    if (SCREEN2021.IsInValid()) return;

                    var data = SCREEN2021.GetAllData();
                    var saveSuccess = SCREEN2021.SaveData(data);
                    if (saveSuccess) {
                        window.parent.location.reload();
                    } else {
                        ASOFT.asoftPopup.hideIframe();
                        parent.popupClose();
                    }

                    if (HRMF2020)
                        HRMF2020.isInherit = false;
                },
                function () {
                    if (SCREEN2021.SaveSuccess) {
                        window.parent.location.reload();
                    } else {
                        ASOFT.asoftPopup.hideIframe();
                        parent.popupClose();
                    }

                    if (HRMF2020)
                        HRMF2020.isInherit = false;
                });
            });

        // Xử lý nhấn nút xóa Yêu cầu tuyển dụng
        $("#btnDeleteRecruitRequirement" + "_" + SCREEN2021.TABLE_HRMT2024)
            .on("click",
                function (e) {
                    $("#" + SCREEN2021.FIELD_RECRUITREQUIREMENT + "_" + SCREEN2021.TABLE_HRMT2024).val("");
                });

        // Xử lý nhấn nút chọn Kế hoạch tuyển dụng
        $("#btnRecruitPlanName")
            .on("click",
                function (e) {
                    SCREEN2021.CurrentChoose = SCREEN2021.ACTION_CHOOSE_RECRUITPLAN;

                    var departmentID = "";
                    // Phòng ban
                    if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID))) {
                        departmentID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DEPARTMENTID)[SCREEN2021.FIELD_DEPARTMENTID];
                    } else {
                        departmentID = "";
                    }

                    var dutyID = "";
                    // Phòng ban
                    if (SCREEN2021.IsNotNullOrUndefined(SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID))) {
                        dutyID = SCREEN2021.GetComboBoxValueItem(SCREEN2021.FIELD_DUTYID)[SCREEN2021.FIELD_DUTYID];
                    } else {
                        dutyID = "";
                    }

                    url = '/PopupSelectData/Index/HRM/HRMF2023?ScreenID=' + $('#sysScreenID').val() + '&DepartmentID=' + departmentID + '&DutyID=' + dutyID;

                    ASOFT.asoftPopup.showIframe(url, {});
                });

        // Xử lý nhấn nút xóa Kế hoạch tuyển dụng
        $("#btnDeleteRecruitPlanName")
            .on("click",
                function (e) {
                    $("#" + SCREEN2021.FIELD_RECRUITPLANID).val("");
                    $("#" + SCREEN2021.FIELD_RECRUITPLANNAME).val("");
                    SCREEN2021.InheritRecruitPeriodID = "";
                }
            );

        // #region --- Lưu & Nhập tiếp ---

        $("#SaveNew")
            .click(function () {

                if (SCREEN2021.IsInValid()) return;

                var data = SCREEN2021.GetAllData();
                var saveSuccess = SCREEN2021.SaveData(data);
                if (saveSuccess) {
                    SCREEN2021.AfterSaveProcessing(0);

                    SCREEN2021.SaveSuccess = true;
                }
            });

        // #endregion --- Lưu & Nhập tiếp ---

        // #region --- Lưu & Sao chép ---
        $("#SaveClose")
            .click(function () {
                if (SCREEN2021.IsInValid()) return;

                var data = SCREEN2021.GetAllData();
                var saveSuccess = SCREEN2021.SaveData(data);
                if (saveSuccess) {
                    SCREEN2021.SaveSuccess = true;
                    SCREEN2021.AfterSaveProcessing(1);
                }
            });

        // #endregion --- Lưu & Sao chép

        // #region --- Lưu cập nhật ---

        $("#BtnSave")
            .click(function () {
                if (SCREEN2021.IsInValid()) return;

                var data = SCREEN2021.GetAllData();
                var saveSuccess = SCREEN2021.SaveData(data);
                if (saveSuccess) {
                    SCREEN2021.AfterSaveProcessing(1);
                    window.parent.location.reload();
                }
            });

        // #endregion --- Lưu cập nhật ---

        // #region --- Sự kiện Check Box yêu cầu tuyển dụng ---

        // CheckBox Trình độ tin học
        $("#" + SCREEN2021.FIELD_ISINFORMATICS + "_" + SCREEN2021.TABLE_HRMT2024).change(function () {
            var key = SCREEN2021.FIELD_INFORMATICSLEVEL + "_" + SCREEN2021.TABLE_HRMT2024;
            if (this.checked) {
                $("#" + key).attr("readonly", false);
            } else {
                $("#" + key).attr("readonly", true);
                $("#" + key).val("");
            }
        });

        // CheckBox Khả năng sáng tạo
        $("#" + SCREEN2021.FIELD_ISCREATIVENESS + "_" + SCREEN2021.TABLE_HRMT2024).change(function () {
            var key = SCREEN2021.FIELD_CREATIVENESS + "_" + SCREEN2021.TABLE_HRMT2024;
            if (this.checked) {
                $("#" + key).attr("readonly", false);
            } else {
                $("#" + key).attr("readonly", true);
                $("#" + key).val("");
            }
        });

        // CheckBox Khả năng giải quyết vấn đề
        $("#" + SCREEN2021.FIELD_ISPROBLEMSOLVING + "_" + SCREEN2021.TABLE_HRMT2024).change(function () {
            var key = SCREEN2021.FIELD_PROBLEMSOLVING + "_" + SCREEN2021.TABLE_HRMT2024;
            if (this.checked) {
                $("#" + key).attr("readonly", false);
            } else {
                $("#" + key).attr("readonly", true);
                $("#" + key).val("");
            }
        });

        // CheckBox Khả năng trình bày, thuyết phục
        $("#" + SCREEN2021.FIELD_ISPRSENTATION + "_" + SCREEN2021.TABLE_HRMT2024).change(function () {
            var key = SCREEN2021.FIELD_PRSENTATION + "_" + SCREEN2021.TABLE_HRMT2024;
            if (this.checked) {
                $("#" + key).attr("readonly", false);
            } else {
                $("#" + key).attr("readonly", true);
                $("#" + key).val("");
            }
        });

        // CheckBox Khả năng giao tiếp
        $("#" + SCREEN2021.FIELD_ISCOMMUNICATION + "_" + SCREEN2021.TABLE_HRMT2024).change(function () {
            var key = SCREEN2021.FIELD_COMMUNICATION + "_" + SCREEN2021.TABLE_HRMT2024;
            if (this.checked) {
                $("#" + key).attr("readonly", false);
            } else {
                $("#" + key).attr("readonly", true);
                $("#" + key).val("");
            }
        });

        // #endregion --- Sự kiện Check Box yêu cầu tuyển dụng ---
    };

    /**
     * Thực thi kích hoạt một số control ban đầu
     * @returns {} 
     * @since [Văn Tài] Created [15/11/2017]
     */
    this.TriggeringEvents = function () {
        // Yêu cầu tuyển dụng
        SCREEN2021.RequirementCheckBoxTriggering();
    };

    /**
     * Thực thi kích hoạch các CheckBox yêu cầu tuyển dụng
     * @returns {} 
     * @since [Văn Tài] Created [15/11/2017]
     */
    this.RequirementCheckBoxTriggering = function () {
        $("#" + SCREEN2021.FIELD_ISINFORMATICS + "_" + SCREEN2021.TABLE_HRMT2024).trigger("change");
        $("#" + SCREEN2021.FIELD_ISCREATIVENESS + "_" + SCREEN2021.TABLE_HRMT2024).trigger("change");
        $("#" + SCREEN2021.FIELD_ISPROBLEMSOLVING + "_" + SCREEN2021.TABLE_HRMT2024).trigger("change");
        $("#" + SCREEN2021.FIELD_ISPRSENTATION + "_" + SCREEN2021.TABLE_HRMT2024).trigger("change");
        $("#" + SCREEN2021.FIELD_ISCOMMUNICATION + "_" + SCREEN2021.TABLE_HRMT2024).trigger("change");
    };

    this.btnDeleteRecruitRequirement_HRMT2024_Click = function () {

        // #region --- TextBox: ResetText ---

        var resetDetailTextBoxList = [
            SCREEN2021.FIELD_GENDER,
            SCREEN2021.FIELD_FROMAGE,
            SCREEN2021.FIELD_TOAGE,
            SCREEN2021.FIELD_APPEARANCE,
            SCREEN2021.FIELD_EXPERIENCE,
            SCREEN2021.FIELD_FROMSALARY,
            SCREEN2021.FIELD_TOSALARY,
            SCREEN2021.FIELD_WORKDESCRIPTION,
            SCREEN2021.FIELD_INFORMATICSLEVEL,
            SCREEN2021.FIELD_CREATIVENESS,
            SCREEN2021.FIELD_PROBLEMSOLVING,
            SCREEN2021.FIELD_PRSENTATION,
            SCREEN2021.FIELD_COMMUNICATION,
            SCREEN2021.FIELD_HEIGHT,
            SCREEN2021.FIELD_WEIGHT,
            SCREEN2021.FIELD_HEALTHSTATUS,
            SCREEN2021.FIELD_NOTES
        ];

        for (i = 0; i < resetDetailTextBoxList.length; i++) {
            var key = resetDetailTextBoxList[i] + "_" + SCREEN2021.TABLE_HRMT2024;
            SCREEN2021.SetTextBoxValue(key, "");
        }

        // #endregion --- TextBox: ResetText ---

        // #region --- ComboBox: ResetText ---
        var resetDetailComboValueList = [
          SCREEN2021.FIELD_GENDER,
          SCREEN2021.FIELD_EDUCATIONLEVELID,
          SCREEN2021.FIELD_LANGUAGELEVEL1ID,
          SCREEN2021.FIELD_LANGUAGELEVEL2ID,
          SCREEN2021.FIELD_LANGUAGELEVEL3ID,
          SCREEN2021.FIELD_LANGUAGE1ID,
          SCREEN2021.FIELD_LANGUAGE2ID,
          SCREEN2021.FIELD_LANGUAGE3ID,
        ];

        for (i = 0; i < resetDetailComboValueList.length; i++) {
            var key = resetDetailComboValueList[i] + "_" + SCREEN2021.TABLE_HRMT2024;
            SCREEN2021.SetComboBoxValue(key, "");
        }

        // #endregion --- ComboBox: ResetText ---

        // #region --- CheckBox: Unchecked ---

        var resetDetailCheckBoxValueList = [
           SCREEN2021.FIELD_ISINFORMATICS,
           SCREEN2021.FIELD_ISCREATIVENESS,
           SCREEN2021.FIELD_ISPROBLEMSOLVING,
           SCREEN2021.FIELD_ISPRSENTATION,
           SCREEN2021.FIELD_ISCOMMUNICATION
        ];

        for (i = 0; i < resetDetailCheckBoxValueList.length; i++) {
            var key = resetDetailCheckBoxValueList[i] + "_" + SCREEN2021.TABLE_HRMT2024;
            SCREEN2021.SetCheckBoxValue(key, false);
        }

        // #endregion --- CheckBox: Unchecked ---

    }
    // #endregion --- Events ---
};

// #region --- Global Callback ---

function receiveResult(result) {

    // Chọn kế hoạch tuyển dụng
    if (SCREEN2021.CurrentChoose == SCREEN2021.ACTION_CHOOSE_RECRUITPLAN) {
        $("#" + SCREEN2021.FIELD_RECRUITPLANID).val(result.RecruitPlanID);
        $("#" + SCREEN2021.FIELD_RECRUITPLANNAME).val(result.RecruitPlanID + "_" + result.Description);
        SCREEN2021.InheritRecruitPeriodID = result.RecruitPlanID;
        SCREEN2021.RecruitPlanProcessing(result.RecruitPlanID);
    }

    // Chọn yêu cầu tuyển dụng
    if (SCREEN2021.CurrentChoose == SCREEN2021.ACTION_CHOOSE_RECRUITREQUIRE) {
        $("#" + SCREEN2021.FIELD_RECRUITREQUIREMENT + "_" + SCREEN2021.TABLE_HRMT2024).val(result.RecruitRequireName);
        var RecruitRequireID = result.RecruitRequireID;
        SCREEN2021.RecruitRequirementProcessing(RecruitRequireID);
    }

    // Chọn file đính kèm
    if (SCREEN2021.CurrentChoose == "Attach") {
        SCREEN2021.ListChoose[SCREEN2021.CurrentChoose](result);
    }

};

// #endregion --- Global Callback ---