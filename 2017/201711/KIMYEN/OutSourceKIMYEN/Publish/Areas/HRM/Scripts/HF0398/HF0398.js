
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created          Comment
//#     17/12/2016      Văn Tài          Tạo mới
//####################################################################

var ID = 'HF0398';
var urlInsert = $("#URLInsert").val();
var urlUpdate = $("#URLUpdate").val();
var defaultViewModel = {};
var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var Status = null;   // Lưu trạng thái form từ server trả về: Status=0 : Lưu mới, lưu sao chép
var HF0396Grid = null;
var MethodVacationID = null;


$(document).ready(function () {
    refreshModel();
    SF1000Grid = $('#HF0396Grid').data('kendoGrid');
    DepartmentID = ASOFT.asoftComboBox.castName('MethodVactionID');
    
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
        numbericInputs.bind("keydown", function () {
            var jqThis = $(this),
                caret = jqThis.caret().start,
                valueString = jqThis.val().toString()
            ;
            //LOG("keydown keypress: Current position: " + caret);
            jqThis.attr('data-asf-caret', caret);
            jqThis.attr('data-asf-prev-val', valueString);

        });

        numbericInputs.bind("keyup", function (e) {
            return;
            var jqThis = $(this),
                caret = jqThis.attr('data-asf-caret'),
                valueString = jqThis.val().toString(),
                prevValue = jqThis.attr('data-asf-prev-val')

            ;
            LOG(caret);

            if (prevValue !== valueString) {

                // Kiểm tra keycode
                switch (e.keyCode) {
                    case 13: //_log('enter'); 

                        break;
                    case 32: //_log('space'); 

                        break;
                        //case 8: //_log('backspace');
                        //    //break;
                    case 106: //_log('multiply');
                        break;
                    case 106:// _log('delete');
                        break;
                    case 27: //_log('esc');

                        break;

                    case 37: //_log('37 left');
                        //leftKey_Pressed(e);
                        break;

                    case 38: //_log('38 up');
                        upKey_Pressed(e);
                        break;

                    case 39: //_log('39 right');
                        break;

                    case 40: //_log('40 down');
                        downKey_Pressed(e);
                        break;

                    default: //_log('other key');                

                        break;
                }

                setTimeout(function (_caret, _jqThis) {
                    return function () {
                        _jqThis.caretTo(_caret);
                    }
                }(caret, jqThis), 30);
            }

        });
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
});

HF0398 = new function () {
    this.btnClose_Click = function () {
        popupClose_Click();
    }

    this.btnSaveCopy_Click = function () {
        action = 2;
        checkAndSave();
    }
    this.btnSaveNext_Click = function () {
        action = 1;
        checkAndSave();
    }
    this.btnSave_Click = function () {
        action = 3;
        checkAndUpdate();
    }
    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, ID);
    }
    this.IsToMonthPlus_Changed = function () {
        var IsToMonthPlus = $('#IsToMonthPlus').is(":checked");
        if (!IsToMonthPlus) {
            $('#ToMonthPlus').val('');
            $('#ToMonthPlus').removeAttr("required");
        } else {
            $('#ToMonthPlus').attr("required", "required");
        }
    }
    this.IsPrevVacationDay_Changed = function () {
        var data = ASOFT.helper.dataFormToJSON(ID);
        if (data.IsPrevVacationDay != 0) {
            $('#MaxPrevVacationDay').val('');
            $('#MaxPrevVacationDay').removeAttr("required");
        }
        else {
            $('#MaxPrevVacationDay').attr("required", "required");
        }
    }
}

//Hàm: khởi tạo defaultViewModel là một đối tượng kiểu JSon
//Khởi tạo model này cho TH nút đóng lúc thêm mới
function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}

//Hàm: Làm mới lưới
//Chú ý: Lưới này là lưới phân trang
function refreshGrid() {
    parent.HF0396Grid.dataSource.page(1);
}

// Hàm kiểm tra và lưu
function checkDataSave() {
    if (formIsInvalid()) {
        return;
    }
    insert();
}

// Hàm: Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.FormStatus = 1;
    data.Disabled = $('#Disabled').is(":checked");
    data.IsToMonthPlus = $('#IsToMonthPlus').is(":checked");

    if (data.IsPrevVacationDay == 1) {
        data.MaxPrevVacationDay = null;
    }
    if (!data.IsToMonthPlus) {
        data.ToMonthPlus = null;
    }

    ASOFT.helper.postTypeJson(urlInsert, data, onInsertSuccess);
}

// Hàm: Update
function update() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.FormStatus = 2;
    data.Disabled = $('#Disabled').is(":checked");
    data.IsToMonthPlus = $('#IsToMonthPlus').is(":checked");

    if (data.IsPrevVacationDay == 1) {
        data.MaxPrevVacationDay = null;
    }
    if (!data.IsToMonthPlus) {
        data.ToMonthPlus = null;
    }

    ASOFT.helper.postTypeJson(urlUpdate, data, onUpdateSuccess);
}

// Hàm: Lưu thành công
function onInsertSuccess(result) {
    if (result.Status) {
        switch (action) {
            case 1://save new
                {
                    ASOFT.form.displayInfo('#' + ID, [ASOFT.helper.getMessage(result.Message)]);
                    window.parent.refreshGrid();
                    clearFormHF0398();
                    refreshModel();
                }
                break;
            case 2://save copy
                {
                    ASOFT.form.displayInfo('#' + ID, [ASOFT.helper.getMessage(result.Message)]);
                    window.parent.refreshGrid();
                    refreshModel();
                }
                break;
            case 0://save close, Lưu xong và đóng lại  
                {
                    window.parent.refreshGrid();
                    parent.popupClose();
                }
        }
    }
    else {
        ASOFT.form.displayMessageBox('#' + ID, [ASOFT.helper.getMessage(result.Message)]);
    }
}

// Hàm: Update thành công
function onUpdateSuccess(result) {
    if (result.Status) //Update khi bấm Save
    {
        window.parent.location.reload();
    }
    else {
        ASOFT.form.displayMessageBox('#' + ID, [ASOFT.helper.getMessage(result.Message)]);
    }
}

//Hàm: Kiểm tra lưu
function checkAndSave() {
    checkDataSave();
}

//Hàm: Kiểm tra update
function checkAndUpdate() {
    checkDataUpdate();
}

//Hàm: Kiểm tra dữ liệu update
function checkDataUpdate() {
    if (formIsInvalid()) {
        return;
    }
    update();
}

//Sự kiện: Đóng popup lúc thêm,thêm mới
function popupClose_Click(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                checkDataSave();
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

//Sự kiện : Đóng lúc Update
function popupClose_ClickA(event) {
    if (!ASOFT.form.formClosing('HF0398')) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                checkDataUpdate();
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

// Kiểm tra dữ liệu trên form có bị thay đổi hay không
var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};

var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(ID);
    return dataPost;
};

var KENDO_INPUT_SUFFIX = '_input';
// Kiểm tra bằng nhau giữa hai trạng thái của form
var isRelativeEqual = function (data1, data2) {
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                return false;
            }
            else {
                if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1) {
                    continue;
                }
                // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                if (data1[prop].valueOf() != data2[prop].valueOf()) {
                    return false;
                }
            }
        }
        return true;
    }
    return undefined;
};

// Hàm kiểm tra mã phép thâm niên có trong ComboBox hiện tại không?
function formIsInvalid() {
    var isValid = true;
    isInValid = ASOFT.form.checkRequiredAndInList(ID, []);
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.Disabled = $('#Disabled').is(":checked");
    data.IsToMonthPlus = $('#IsToMonthPlus').is(":checked");

    if (data.IsToMonthPlus && !isInValid) {
        if (data.ToMonthPlus.length <= 0) {
            isInValid = true;
            ASOFT.form.displayMessageBox('#' + ID, [ASOFT.helper.getMessage("HFML000546")]);
        }
    }
    if (data.IsPrevVacationDay == 0 && !isInValid) {
        if (data.MaxPrevVacationDay.length <= 0) {
            isInValid = true;
            ASOFT.form.displayMessageBox('#' + ID, [ASOFT.helper.getMessage("HFML000547")]);
        }
    }
    return isInValid;
}

// Hàm: Dọn trắng các textbox khi lưu và thêm mới
function clearFormHF0398() {
    $("#MethodVacationID").val('');
    $("#MethodVacationName").val('');
    $("#VacationDay").val('');
    $("#Disabled").removeAttr("checked");
    var comboboxSeniorityID = $("#SeniorityID").data("kendoComboBox");
    comboboxSeniorityID.select(0);
    $("#IsToMonthPlus").removeAttr("checked");
    $("#ToMonthPlus").val('');
    $("#MaxPrevVacationDay").val('');

    $("input[name=IsPrevVacationDay][value='1']").prop('checked', true);
    $("input[name=IsWorkDate][value='1']").prop('checked', true);
    $("input[name=IsManagaVacation][value='1']").prop('checked', true);
}
