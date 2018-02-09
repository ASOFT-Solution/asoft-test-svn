// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    11/10/2017  Văn Tài         Create New
// ##################################################################
$(document)
    .ready(function () {

        $("#A00_SystemInfo-1").parent().remove();

        // #region --- Kiểm tra quyền ---

        SCREEN1032.CheckCanEdit();

        // #endregion --- Kiểm tra quyền ---

        SCREEN1032.NameProcessing();
        SCREEN1032.MoveControls();
        SCREEN1032.MoveControlTab05();
        SCREEN1032.GetImage();
        SCREEN1032.LoadDISC();
        SCREEN1032.SwapTab();

        if (ASOFTEnvironment.CustomerIndex.MinhTri == 'True') {
            $("#BtnPrint").unbind();
            $("#BtnPrint").kendoButton({
                "click": SCREEN1032.PrintClick_MinhTri,
            });
        }
        else {
            $("#BtnPrint").removeClass('asfbtn-item-32').css('display', 'none');
        }

    });


// SCREEN1032: HRMF1032
SCREEN1032 = new function () {

    // #region --- Constants ---

    this.TABLE_HRMT1030 = "HRMT1030";
    this.TABLE_HRMT1033 = "HRMT1033";
    this.TABLE_HRMT1034 = "HRMT1034";
    this.SCREEN_ID = "HRMF1032";

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

    // #endregion --- Constants ---

    // #region --- Methods ---

    /**
     * Kiểm tra phân quyền
     * @returns {} 
     * @since [Văn Tài] Created [12/10/2017]
     */
    this.CheckCanEdit = function () {
        var url = new URL(window.location.href);
        var pk = url.searchParams.get("PK");
        $.ajax({
            url: '/HRM/HRMF1032/CheckUpdateData?pCandidateID=' + pk + "&Mode=0",
            success: function (result) {
                if (result.CanEdit == 0) {
                    $("#BtnEdit").parent().addClass('asf-disabled-li');
                }
            }
        });
    }

    /**
     * Xử lý hiển thị tên
     * @returns {} 
     * @since [Văn Tài] Created [12/10/2017]
     */
    this.NameProcessing = function () {
        $("." + SCREEN1032.FIELD_FIRSTNAME)[0].innerHTML = "{0} {1} {2}".format(
            $("." + SCREEN1032.FIELD_FIRSTNAME)[0].innerHTML,
            $("." + SCREEN1032.FIELD_MIDDLENAME)[0].innerHTML,
            $("." + SCREEN1032.FIELD_LASTNAME)[0].innerHTML
        );

        $("." + SCREEN1032.FIELD_MIDDLENAME).parent().remove();
        $("." + SCREEN1032.FIELD_LASTNAME).parent().remove();
    }

    /**
     * Dời một số controls
     * @returns {} 
     * @since [Văn Tài] Created [12/10/2017]
     */
    this.MoveControls = function () {
        $("." + SCREEN1032.FIELD_IDENTIFYPLACE).parent().before(
                $("." + SCREEN1032.FIELD_IDENTIFYCARDNO).parent()
           );
        $("." + SCREEN1032.FIELD_PASSPORTDATE).parent().before(
               $("." + SCREEN1032.FIELD_PASSPORTNO).parent()
          );

        $("." + SCREEN1032.FIELD_IDENTIFYCARDNO).parent().before(
              $("." + SCREEN1032.FIELD_ETHNICID).parent()
         );

        // Lấy title trình độ ngoại ngữ
        var EnglishSkill = SCREEN1032.GetLanguageFromServer("HRMF1032.EnglishSkill");
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
               '</div>' +
        '</fieldset>';
        $(AcademicInfo).appendTo($("#tb_HRMT1034-1").children()[1]);

        var AcademicTopLeftTable = $("#AcademicTopLeftTable");
        var AcademicTopRightTable = $("#AcademicTopRightTable");
        var EnglishLevelLeftTable = $("#EnglishLevelLeftTable");
        var EnglishLevelRightTable = $("#EnglishLevelRightTable");

        var TopLeftFieldList = [
            SCREEN1032.FIELD_EDUCATIONLEVELID,
            SCREEN1032.FIELD_INFORMATICSLEVEL,
        ];

        var TopRightFieldList = [
            SCREEN1032.FIELD_POLITICSID
        ];

        var EnglistLevelLeftFieldList = [
            SCREEN1032.FIELD_LANGUAGE1ID,
            SCREEN1032.FIELD_LANGUAGE2ID,
            SCREEN1032.FIELD_LANGUAGE3ID
        ];

        var EnglistLevelRightFieldList = [
            SCREEN1032.FIELD_LANGUAGELEVEL1ID,
            SCREEN1032.FIELD_LANGUAGELEVEL2ID,
            SCREEN1032.FIELD_LANGUAGELEVEL3ID
        ];

        for (var i = 0; i < TopLeftFieldList.length; i++) {
            var item = $("." + TopLeftFieldList[i]).parent();
            item.appendTo(AcademicTopLeftTable);
        }

        for (var i = 0; i < TopRightFieldList.length; i++) {
            var item = $("." + TopRightFieldList[i]).parent();
            item.appendTo(AcademicTopRightTable);
        }

        for (var i = 0; i < EnglistLevelLeftFieldList.length; i++) {
            var item = $("." + EnglistLevelLeftFieldList[i]).parent();
            item.appendTo(EnglishLevelLeftTable);
        }

        for (var i = 0; i < EnglistLevelRightFieldList.length; i++) {
            var item = $("." + EnglistLevelRightFieldList[i]).parent();
            item.appendTo(EnglishLevelRightTable);
        }

        $("#HRMF1032_SubTitle07").remove();
    }

    this.MoveControlTab05 = function () {
        var DISCInfo =
           '<div>' +
                '<div class="asf-form-container container_12 pagging_bottom">' +
                    '<div class="grid_6_1 alpha float_left">' +
                        '<table id="EvaluationDateGroup" class="asf-table-view">' +
                            '<tbody>' +
                            '</tbody>' +
                        '</table>' +
                    '</div>' +
                '</div>' +
                '<div class="asf-form-container container_12 pagging_bottom">' +
                        '<div class="grid_6_1 alpha float_left">' +
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
                        '</div>' +
                        '<div class="grid_6 omega float_right">' +
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
                '</div>' +
                 '<div class="asf-form-container container_12 pagging_bottom">' +
                    '<div class="grid_6_1 alpha float_left">' +
                        '<table id="DescriptionDISC" class="asf-table-view">' +
                            '<tbody>' +
                            '</tbody>' +
                        '</table>' +
                    '</div>' +
                '</div>' +
            '</div>';
        $(DISCInfo).appendTo($("#HRMF1032_SubTitle08-1"));
        var Naturalcharacter = $("#Naturalcharacter");
        var Adaptability = $("#Adaptability");
        var EvaluationDateGroup = $("#EvaluationDateGroup");
        var DescriptionDISC = $("#DescriptionDISC");

        var NaturalcharacterFieldsList = [
            SCREEN1032.FIELD_NATURE_D,
            SCREEN1032.FIELD_NATURE_I,
            SCREEN1032.FIELD_NATURE_S,
            SCREEN1032.FIELD_NATURE_C,
            SCREEN1032.FIELD_NATURE
        ];

        var AdaptabilityFieldsList = [
            SCREEN1032.FIELD_ADAPTIVE_D,
            SCREEN1032.FIELD_ADAPTIVE_I,
            SCREEN1032.FIELD_ADAPTIVE_S,
            SCREEN1032.FIELD_ADAPTIVE_C,
            SCREEN1032.FIELD_ADAPTIVE
        ];

        var EvaluationDateFieldsList = [
            SCREEN1032.FIELD_EVALUATIONDATE
        ];


        for (var i = 0; i < EvaluationDateFieldsList.length; i++) {
            var item = $("." + EvaluationDateFieldsList[i]).parent();
            item.appendTo(EvaluationDateGroup);
        }

        for (var i = 0; i < NaturalcharacterFieldsList.length; i++) {
            var item = $("." + NaturalcharacterFieldsList[i]).parent();
            item.appendTo(Naturalcharacter);
        }

        for (var i = 0; i < AdaptabilityFieldsList.length; i++) {
            var item = $("." + AdaptabilityFieldsList[i]).parent();
            item.appendTo(Adaptability);
        }

        var item = $(".Description").parent();
            item.appendTo(DescriptionDISC);
        $("#HRMF1032_SubTitle08-1 .asf-master-content").remove();;
    }

    /**
     * Lấy control hình ảnh
     * @returns {} 
     * @since [Văn Tài] Created [13/10/2017]
     */
    this.GetImage = function () {
        var GridPartialAvatar = "/Partial/GetAvatarHRMT1030/HRM/HRMF1032?CandidateID=" + $(".CandidateID").text();
        ASOFT.partialView.Load(GridPartialAvatar, "#HRMF1032_SubTitle01-1 .first .asf-table-view", 2);

        $("." + SCREEN1032.FIELD_IMAGEID).parent().remove();
    }

    /**
     * Di chuyển tab
     * @returns {} 
     * @since [Văn Tài] Created [18/12/2017]
     */
    this.SwapTab = function() {
        $("#HRMF1032_SubTitle08").before($("#tb_HRMT1034"));
    };

    this.ExportSuccess_MinhTri = function (result) {
        if (result) {
            var urlPrint = '/HRM/HRMF2010/ReportViewer';
            var urlExcel = '/HRM/HRMF2010/ExportReport';
            //var urlPost = isPrint ? urlPrint : urlExcel;
            //var options = isPrint ? '&viewer=pdf' : '';
            var urlPost;
            var options = '';

            if (isPrint) {
                urlPost = !isMobile ? urlPrint : urlExcel;
                options = !isMobile ? '&viewer=pdf' : '&viewer=pdf&mobile=mobile';
            }
            else
                urlPost = urlExcel;

            var RM = '&Module=HRM&ScreenID=HRMF1032&project=MinhTri';
            // Tạo path full
            var fullPath = urlPost + "?id=" + result.apk + options + RM;

            // Getfile hay in báo cáo
            if (isPrint)
                if (!isMobile)
                    window.open(fullPath, "_blank");
                else
                    window.location = fullPath;
            else {
                window.location = fullPath;
            }
        }
    }

    this.PrintClick_MinhTri = function () {
        var dataFilter = {};

        var url_string = window.location.href;
        var url = new URL(url_string);
        var CandidateID = url.searchParams.get("PK");
        dataFilter.CandidateID = CandidateID;

        var url = '/HRM/HRMF2010/DoPrintOrExport_Candidate';
        isPrint = true;
        ASOFT.helper.postTypeJson(url, dataFilter, SCREEN1032.ExportSuccess_MinhTri);
    }

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

    /**
     * Load thông tin D.I.S.C
     * @returns {} 
     * @since [Kiều Nga] Created [18/12/2017]
     */
    this.LoadDISC = function () {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var CandidateID = url.searchParams.get("PK");
        ASOFT.helper.postTypeJson('/HRM/HRMF1031/LoadDISC', { EmployeeID: CandidateID }, function (result) {
            $(".EvaluationDate").html(result.EvaluationDate);
            $(".Nature_D").html(result.Nature_D);
            $(".Nature_I").html(result.Nature_I);
            $(".Nature_S").html(result.Nature_S);
            $(".Nature_C").html(result.Nature_C);
            $(".Nature").html(result.Nature);
            $(".Adaptive_D").html(result.Adaptive_D);
            $(".Adaptive_I").html(result.Adaptive_I);
            $(".Adaptive_S").html(result.Adaptive_S);
            $(".Adaptive_C").html(result.Adaptive_C);
            $(".Adaptive").html(result.Adaptive);
            $(".Description").html(result.Description);
        });
    }


    // #endregion --- Utilities ---
}