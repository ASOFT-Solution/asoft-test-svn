// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    06/11/2017  Văn Tài         Create New
// ##################################################################
$(document)
    .ready(function () {

        var url = new URL(window.location.href);
        SCREEN2022.RecPeriodID = url.searchParams.get("PK");
        SCREEN2022.DivisionID = $("#EnvironmentDivisionID").val();

        // #region --- First Load : Step by Step ---

        SCREEN2022.GetRecruitInfoView(SCREEN2022.RecPeriodID);
        SCREEN2022.GetRecruitRequirementView(SCREEN2022.RecPeriodID);
        SCREEN2022.GetInterviewTurn(SCREEN2022.RecPeriodID);        

        // #endregion --- First Load : Step by Step ---

        // #region --- Xử lý chạy ngoài core ---

        //SCREEN2022.SettingLayout();

        // #endregion --- Xử lý chạy ngoài core ----
    });


// SCREEN2022: HRMF2022
SCREEN2022 = new function () {

    // #region --- Constants ---

    // #region --- Actions ---

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
    this.FIELD_RECRUITPLANNAME = "RecruitPlanName";
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
    this.FIELD_ACTUALCOST = "ActualCost";
    this.FIELD_COSTBOUNDARY = "CostBoundary";
    this.FIELD_ACTUALQUANTITY = "ActualQuantity";
    this.FIELD_QUANTITYBOUNDARY = "QuantityBoundary";

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

    this.FIELD_NUMERINTERVIEWS = "NumerInterviews";

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

    this.RecPeriodID = "";
    this.DivisionID = "";

    // #endregion --- Member Variables ---

    // #region --- Methods ---

    /**
     * Lấy View Thông tin tuyển dụng
     * @param {} id 
     * @returns {} 
     * @since [Văn Tài] Created [06/11/2017]
     */
    this.GetRecruitInfoView = function (id) {
        var data = {
            pRecruitPeriodID: id
        };

        $.ajax({
            url: '/HRM/HRMF2022/GetRecruitInfoView',
            data: data,
            async: false,
            success: function (result) {
                $("#HRMF2022_TabRecruitInfo-1").empty();
                $("#HRMF2022_TabRecruitInfo-1").append(result);
            }
        });
    }

    /**
     * Lấy View Yêu cầu tuyển dụng
     * @param {} id 
     * @returns {} 
     * @since [Văn Tài] Created [07/11/2017]
     */
    this.GetRecruitRequirementView = function (id) {
        var data = {
            pRecruitPeriodID: id
        };

        $.ajax({
            url: '/HRM/HRMF2022/GetRecruitRequirementView',
            data: data,
            async: false,
            success: function (result) {
                $("#HRMF2022_TabRecruitRequirement-1").empty();
                $("#HRMF2022_TabRecruitRequirement-1").append(result);
            }
        });
    }

    /**
     * Lấy View Vòng phỏng vấn
     * @param {} id 
     * @returns {} 
     * @since [Văn Tài] Created [08/11/2017]
     */
    this.GetInterviewTurn = function (id) {
        var RecruitPeriodID = SCREEN2022.GetTextBoxValue(SCREEN2022.FIELD_RECRUITPERIODID);
        var DutyID = SCREEN2022.GetTextBoxValue(SCREEN2022.FIELD_DUTYID);
        var InterviewLevel = SCREEN2022.GetTextBoxValue("TotalLevel");

        if (InterviewLevel == "") InterviewLevel = 1;

        var data = {
            divisionID: SCREEN2022.DivisionID,
            recruitPeriodID: RecruitPeriodID,
            dutyID: DutyID,
            interviewLevel: InterviewLevel,
            mode: 2
        };

        $.ajax({
            url: '/Partial/PartialHRMF2021NumbersInterview',
            async: false,
            data: data,
            success: function (result) {
                $("#HRMF2022_TabInterviewTurn-1").empty();
                $("#HRMF2022_TabInterviewTurn-1").append(result);

                setTimeout(function () {
                    $("#BtnNext").remove();
                    $("#BtnPrev").remove();
                },
                    200);
            }
        });
    };

    /**
     * Điều chỉnh lại layout
     * @returns {} 
     * @since [Văn Tài] Created [13/11/2017]
     */
    this.SettingLayout = function () {

    };

    // #endregion --- Methods ---

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
        var language = ASOFT.helper.getLanguageString(languageID, SCREEN1032.SCREEN_ID, "HRM");
        return (SCREEN1032.IsNotNullOrUndefined(language) ? language : "Undefined");
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

    /**
     * Lấy giá trị Textbox
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetTextBoxValue = function (elementID) {
        var value = $("#" + elementID).val();
        if (SCREEN2022.IsNotNullOrUndefined(value)) return value;
        return "";
    }

    // Kiểm tra không phải null hay undefined
    this.IsNotNullOrUndefined = function (checker) {
        return (typeof (checker) != 'undefined' && checker != null);
    };

    /**
     * Export Success
     * @param {}  
     * @returns {} 
     * @since [Thanh Trong] Created [14/12/2017]
     */
    this.ExportSuccess = function (result) {
        if (result) {
            var urlPost = '/ContentMaster/ReportViewer';
            var options = '&viewer=pdf';
            var RM = '&Module=HRM&ScreenID=HRMF2022';
            // Tạo path full
            var fullPath = urlPost + "?id=" + result.apk + options + RM;
            // Getfile hay in báo cáo
            window.open(fullPath, "_blank");
        }
    }

    // #endregion --- Utilities ---
};

/**
* Sự kiện click button print
* @param {}  
* @returns {} 
* @since [Thanh Trong] Created [14/12/2017]
*/
function CustomerPrint() {
    var urlview = new URL(window.location.href);
    var pk = urlview.searchParams.get("PK");
    var URLDoPrintorExport = '/HRM/Common/DoPrintOrExport?sceenid=HRMF2022&pk=' + pk;
    ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, SCREEN2022.ExportSuccess);
}