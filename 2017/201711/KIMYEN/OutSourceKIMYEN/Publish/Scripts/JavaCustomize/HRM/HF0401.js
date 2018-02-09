var apk = null;
var urlParent = null;
$(document).ready(function () {
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();

    urlParent = parent.GetUrlContentMaster() + "HRM/HF0399";
    $('#FullName').prop("readonly", true);
    if ($('#isUpdate').val() == "True") {
        //$('#DepartmentID').data("kendoComboBox").readonly();
        //$('#TeamID').data("kendoComboBox").readonly();
        $('#DepartmentName').prop("readonly", true);
        $('#TeamName').prop("readonly", true);
        $('#EmployeeID').prop("readonly", true);
        ////$("#btnOpenSearch_EmployeeID").kendoButton({
        ////    enable: false
        ////});

        //$("#btnOpenSearch_EmployeeID").attr('disabled', 'disabled');
    }

    else {
        $('#btnOpenSearch_EmployeeID').unbind('click');
        $('#btnOpenSearch_EmployeeID').removeAttr('onclick');
        //OpenSearchClick('EmployeeID')

        $('.btnOpenSearch').unbind('focusin');

        $("#btnOpenSearch_EmployeeID").attr("onclick", "CustomBtnSearch_Click();");

        var autoComplete = $('#EmployeeID').data("kendoAutoComplete");

        autoComplete.bind('change', function () {
            //var departmentID = $('#DepartmentID').val();
            //if (departmentID) {
            //    if ($('#EmployeeID').val()) {
            //        OpenComboDynamic(autoComplete);
            //        autoComplete.search($('#EmployeeID').val());
            //    }
            //}
            //else {
            //    ASOFT.form.displayMessageBox('#HF0401', [ASOFT.helper.getMessage('OOFML000047')], null);
            //}
        });

        //setup before functions
        var typingTimer;                //timer identifier
        var doneTypingInterval = 750;  //time in ms, 0.75 second for example

        $("#EmployeeID").keyup(function (e) {
            if (!KeyCode_IsValid(e))
                return;
            clearTimeout(typingTimer);
            typingTimer = setTimeout(doneTyping, doneTypingInterval);
        });

        $("#EmployeeID").keydown(function (e) {
            if (!KeyCode_IsValid(e))
                return;
            clearTimeout(typingTimer);
        });

        function KeyCode_IsValid(e) {
            var isValid = false;
            var keyCodeInput = e.keyCode;
            if (keyCodeInput >= 48 && keyCodeInput <= 90)
                isValid = true;
            if (!isValid && keyCodeInput >= 96 && keyCodeInput <= 105)
                isValid = true;
            if (!isValid && (keyCodeInput == 8 || keyCodeInput == 46)) // 8 backspcace, 46 delete
                isValid = true;
            return isValid;
        }

        //user is "finished typing," do something
        function doneTyping() {
            //do something
            var departmentID = $('#DepartmentID').val();
            if (departmentID) {
                if ($('#EmployeeID').val()) {
                    OpenComboDynamic(autoComplete);
                    autoComplete.search($('#EmployeeID').val());
                }
            }
            else {
                ASOFT.form.displayMessageBox('#HF0401', [ASOFT.helper.getMessage('OOFML000047')], null);
            }
        }

        $("#popupInnerIframe").kendoWindow({
            activate: function () {
                var txtEmp_width = 250;
                var txtDepartment_width = $('#DepartmentID').width();
                var btnSearch_width = $('#btnOpenSearch_EmployeeID').width();
                if (txtDepartment_width && btnSearch_width) {
                    txtEmp_width = txtDepartment_width - btnSearch_width - 20;
                }

                /// Xử lý độ dài cho autocomplete EmployeeID
                $('#EmployeeID').parent().attr('style', ' width: ' + txtEmp_width + 'px !important; border-top: none; border-left: none; border-right: none; border-color: #AAA;');
                $('#EmployeeID').parent().hover(function () {
                    $('#EmployeeID').parent().removeClass("k-state-hover");
                });
            }
        });
    }
    if ($('#isInherit').val() == 'True') {
        $('#Save').unbind();
        $("#Save").kendoButton({
            "click": CustomBtnSave_Click,
        });
    }

    function initEventNumericTextBox() {
        var
            // format số thành chuỗi dạng số thập phân
            formatGeneralDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoGeneralDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng số thập phân
            formatConvertedDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng số thập phân
            formatPercentDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng số thập phân
            formatUnitCostDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoUnitCostDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng phần trăm
            formatQuantityDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
                return kendo.toString(value, format);
            }

        // format số thành chuỗi dạng phần trăm
        formatOriginalDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoOriginalDecimalsFormatString;
            return kendo.toString(value, format);
        }

        // format số thành chuỗi dạng phần trăm
        formatHolidayDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoHolidayDecimalsFormatString;
            return kendo.toString(value, format);
        }
        ;

        var numbericInputs = $('input[data-asf-type="decimal"]'),
            generalDecimalInputs = numbericInputs.filter('[data-asf-format="general-decimal"]'),
            convertedDecimalInputs = numbericInputs.filter('[data-asf-format="converted-decimal"]'),
            percentDecimalInputs = numbericInputs.filter('[data-asf-format="percent-decimal"]'),
            quantityDecimalInputs = numbericInputs.filter('[data-asf-format="quantity-decimal"]'),
            unitCostDecimalInputs = numbericInputs.filter('[data-asf-format="unit-cost-decimal"]');
        originalDecimalInputs = numbericInputs.filter('[data-asf-format="original-decimal"]');
        holidayDecimalInputs = numbericInputs.filter('[data-asf-format="holiday-decimal"]');
        //numbericInputs.bind("keydown", function () {
        //    var jqThis = $(this),
        //        caret = jqThis.caret().start,
        //        valueString = jqThis.val().toString()
        //    ;
        //    //LOG("keydown keypress: Current position: " + caret);
        //    jqThis.attr('data-asf-caret', caret);
        //    jqThis.attr('data-asf-prev-val', valueString);

        //});

        //numbericInputs.bind("keyup", function (e) {
        //    return;
        //    var jqThis = $(this),
        //        caret = jqThis.attr('data-asf-caret'),
        //        valueString = jqThis.val().toString(),
        //        prevValue = jqThis.attr('data-asf-prev-val')

        //    ;
        //    LOG(caret);

        //    if (prevValue !== valueString) {

        //        // Kiểm tra keycode
        //        switch (e.keyCode) {
        //            case 13: //_log('enter'); 

        //                break;
        //            case 32: //_log('space'); 

        //                break;
        //                //case 8: //_log('backspace');
        //                //    //break;
        //            case 106: //_log('multiply');
        //                break;
        //            case 106:// _log('delete');
        //                break;
        //            case 27: //_log('esc');

        //                break;

        //            case 37: //_log('37 left');
        //                //leftKey_Pressed(e);
        //                break;

        //            case 38: //_log('38 up');
        //                upKey_Pressed(e);
        //                break;

        //            case 39: //_log('39 right');
        //                break;

        //            case 40: //_log('40 down');
        //                downKey_Pressed(e);
        //                break;

        //            default: //_log('other key');                

        //                break;
        //        }

        //        setTimeout(function (_caret, _jqThis) {
        //            return function () {
        //                _jqThis.caretTo(_caret);
        //            }
        //        }(caret, jqThis), 30);
        //    }

        //});
        //setTimeout(function () {
        //    $('#PercentDecimalProperty').caretTo(10);
        //}, 3000);

        holidayDecimalInputs.focusout(function (e) {
            var
                jqThis = $(this),
                valueString = jqThis.val().toString().replace(/ /g, ''),
                value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatHolidayDecimal(value);
            jqThis.val(value);
        });

        generalDecimalInputs.focusout(function (e) {
            var
                jqThis = $(this),
                valueString = jqThis.val().toString().replace(/ /g, ''),
                value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatGeneralDecimal(value);
            jqThis.val(value);
        });

        convertedDecimalInputs.focusout(function (e) {
            var
                jqThis = $(this),
                valueString = jqThis.val().toString().replace(/ /g, ''),
                value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatConvertedDecimal(value);
            jqThis.val(value);
        });

        percentDecimalInputs.focusout(function (e) {
            var
                   jqThis = $(this),
                   valueString = jqThis.val().toString().replace(/ /g, ''),
                   value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatPercentDecimal(value);
            jqThis.val(value);
        });

        quantityDecimalInputs.focusout(function (e) {
            var
                   jqThis = $(this),
                   valueString = jqThis.val().toString().replace(/ /g, ''),
                   value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatQuantityDecimal(value);
            jqThis.val(value);
        });



        unitCostDecimalInputs.focusout(function (e) {
            var
                   jqThis = $(this),
                   valueString = jqThis.val().toString().replace(/ /g, ''),
                   value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatUnitCostDecimal(value);
            jqThis.val(value);
        });
    }

    initEventNumericTextBox();

    $("#DaysPrevMonth").val(formatDecimal(kendo.parseFloat($("#DaysPrevMonth").val() ? $("#DaysPrevMonth").val() : 0), 1))
    $("#DaysInYear").val(formatDecimal(kendo.parseFloat($("#DaysInYear").val() ? $("#DaysInYear").val() : 0), 1))
    $("#VacSeniorDays").val(formatDecimal(kendo.parseFloat($("#VacSeniorDays").val() ? $("#VacSeniorDays").val() : 0), 1))
    $("#AddDays").val(formatDecimal(kendo.parseFloat($("#AddDays").val() ? $("#AddDays").val() : 0), 1))
    $("#DaysRemained").val(formatDecimal(kendo.parseFloat($("#DaysRemained").val() ? $("#DaysRemained").val() : 0), 1))
    $("#DaysSpentToMonth").val(formatDecimal(kendo.parseFloat($("#DaysSpentToMonth").val() ? $("#DaysSpentToMonth").val() : 0), 1))
    $("#DaysSpent").val(formatDecimal(kendo.parseFloat($("#DaysSpent").val() ? $("#DaysSpent").val() : 0), 1))
})

function CustomBtnSearch_Click() {
    var departmentID = $('#DepartmentID').val();
    var teamID = $('#TeamID').val();
    if (departmentID) {
        if (departmentID && teamID) {
            var url1 = '/PopupSelectData/Index/HRM/OOF2004?DepartmentID=' + departmentID + '&TeamID=' + teamID + '&ScreenID=HF0401';
            ASOFT.asoftPopup.showIframe(url1, {});
        }
        else {
            ASOFT.form.displayMessageBox('#HF0401', [ASOFT.helper.getMessage('OOFML000047')], null);
        }
    } else {
        ASOFT.form.displayMessageBox('#HF0401', [ASOFT.helper.getMessage('OOFML000047')], null);
    }
}

function receiveResult(result) {
    ASOFT.form.clearMessageBox();
    $('#EmployeeID').val(result["EmployeeID"].toString());
    $('#FullName').val(result["FullName"].toString());
}

//$('#EmployeeID').change(function () {
//    var combo = $(this).val();
//    var data = $(this).data("kendoComboBox").dataSource._data;
//    var text = "";
//    for (var i = 0; i < data.length; i++) {
//        if (data[i]["EmployeeID"] == combo) {
//            text = data[i]["FullName"];
//            $('#FullName').val(text);
//            break;
//        }
//    }    
//})

function Auto_ChangeDynamic(item) {
    $('#EmployeeID').val(item.EmployeeID);
    $('#FullName').val(item.FullName);
    //var cboDepartmentID = $('#DepartmentID').data("kendoComboBox");
    //cboDepartmentID.search("item.DepartmentID");
    //var cboTeamID = $('#TeamID').data("kendoComboBox");
    //cboTeamID.search("item.TeamID");
}

function CustomBtnSave_Click() {
    var url = "/GridCommon/InsertBussiness/" + module + "/" + id;
    action = 1;
    saveInherit(url)
}

function saveInherit(url) {

    var data = ASOFT.helper.dataFormToJSON(id);
    var CheckInList = [];
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            CheckInList.push(data["CheckInList"]);
        }
        else {
            CheckInList = data["CheckInList"];
        }
    }
    if (ASOFT.form.checkRequiredAndInList(id, CheckInList)) {
        return;
    }
    var Confirm;

    if (typeof CustomerConfirm === "function") {
        Confirm = CustomerConfirm();
        if (Confirm.Status != 0) {
            ASOFT.dialog.confirmDialog(Confirm.Message,
                function () {
                    saveInherit1(url);
                },
                function () {
                    return false;
                });
        }
        else {
            saveInherit1(url);
        }
    }
    else {
        saveInherit1(url);
    }
}

function saveInherit1(url) {
    var data = ASOFT.helper.dataFormToJSON(id);
    var key1 = Array();
    var value1 = Array();
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            data[id] = "1";
        }
        else {
            data[id] = "0";
        }
    })


    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                key1.push(key);
                var vl = Array();
                if (value == "false")
                    value = "0";
                if (value == "true")
                    value = "1";
                vl.push(data[key + "_Content_DataType"], value);
                value1.push(vl);
            }
        }
    })

    if (checkunique == 1) {
        if (unique == null) {
            url1 = url1 + "?mode=1";
        }
        else {
            var un = 0;
            var unn = 0;
            $.each(unique, function (key, value) {
                if (unique[key] == data[key]) {
                    unn++;
                }
                un++;
            })
            if (un == unn) {
                url1 = url1 + "?mode=1";
            }
            checkunique = 0;
        }
    }

    ASOFT.helper.postTypeJson1(url, key1, value1, saveSuccess);
}

var id = $("#sysScreenID").val();
function saveSuccess(result) {
    if (result.Status == 0) {
        if (isUpdate == true) {
            parent.ReloadPage();
        }

        ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
        window.parent.BtnFilter_Click();

    }
    else {
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data);
            }
            ASOFT.form.displayWarning('#' + id, msg);
        }
        else {
            var msgData = new Array();
            $.each(result.Data, function (index, value) {
                var child = value.split(',');
                var msg = ASOFT.helper.getMessage(child[0]);
                msg = kendo.format(msg, child[1], child[2], child[3], child[4]);
                msgData.push(msg);
            });
            ASOFT.form.displayMultiMessageBox(id, 1, msgData);
        }
    }
}

function formatDecimal(value, num) {
    var format = null;
    switch (num) {
        case 1:
            format = ASOFTEnvironment.NumberFormat.KendoHolidayDecimalsFormatString;
            break;
        case 2:
            format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
            break;
    }
    return kendo.toString(value, format);

}