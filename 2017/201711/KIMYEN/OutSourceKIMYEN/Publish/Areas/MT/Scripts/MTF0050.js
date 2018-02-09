// Global variables
var formStatus = null;
var saveActionType = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
var urlRedirect = null;
var reportId = null;
var MTF0051Popup = null;
var GridMaster = null;
var havesearch = null;
var ComboBoxType = null;
var ComboBoxGroupID = null;
var ComboBoxDivisionID = null;

//=============================================================================
// Init Object
//=============================================================================
$(document).ready(function () {
    MTF0051Popup = ASOFT.asoftPopup.CastName("MTF0051Popup");
    GridMaster = $("#MTF0050_GridMaster").data("kendoGrid");
    MTF0051Popup.bind("activate", function() {
        ComboBoxType = ASOFT.asoftComboBox.CastName("Type");
        ComboBoxGroupID = ASOFT.asoftComboBox.CastName("GroupID");
        ComboBoxDivisionID = ASOFT.asoftComboBox.CastName("DivisionID"); 
    });
});

//=============================================================================
// Grid Events
//=============================================================================

// Filter Grid Master
function FilterData() {
    var grid = $("#MTF0050_GridMaster").data("kendoGrid");
    havesearch = true;
    grid.dataSource.page(1);
}

//Send data grid
function SendFilter() {
    var data = ASOFT.helper.getFormData(null, "FormFilter");
    var datamaster = {};
    var isCommon = $('form#FormFilter input[name="IsCommonFilter"]').prop('checked');
    $.each(data, function () {
        if (datamaster[this.name]) {
            if (!datamaster[this.name].push) {
                datamaster[this.name] = [datamaster[this.name]];
            }
            datamaster[this.name].push(this.value || '');
        } else {
            datamaster[this.name] = this.value || '';
        }
    });
    datamaster['IsCommonFilter'] = isCommon;
    return datamaster;
}

// Reset filter
function btnResetFilterMaster_Click() {
    clearFormData("FormFilter");
    refreshGrid();
}

//=============================================================================
// CRUD
//=============================================================================

// Xóa report
function DoDelete() {
    var grid = $("#MTF0050_GridMaster").data("kendoGrid");
    var urlMtf0050DoDelete = $('#UrlMTF0050DoDelete').val();
    var listdeleterow = [];
    var fromdata = {};
    if (grid) {
        grid.tbody
                .find(".asoftcheckbox:checked")
                .closest("tr")
                .each(function () {
                    listdeleterow.push(grid.dataItem(this));
                });
        
        if (listdeleterow.length == 0) {
            ASOFT.Dialog.MessageDialog("Ban chua chon dong de xoa");
            return;
        }
    }
    
    fromdata["args"] = listdeleterow;
    $.ajax({
        type: "POST",
        url: urlMtf0050DoDelete,
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(fromdata),
        success: function (data) {
            if (data.success != 0) {
                ASOFT.Dialog.MessageDialog("Xóa thành công");
                
                grid.dataSource.read();
            }
            else ASOFT.Dialog.MessageDialog("Xóa không thành công");
        }
    });
}

//Thêm mới
function AddNew() {
    var popup = MTF0051Popup;
    formStatus = 1;
    var data = {
        FormStatus: formStatus
    };
    var urlMtf0051 = $('#UrlMTF0051').val();
    ASOFT.asoftPopup.Show(popup, urlMtf0051, data);
}

// Sửa Master
function Edit() {
    var popup = MTF0051Popup;
    reportId = $('#MTF0052ReportID').val();
    formStatus = 2;
    var data = {
        FormStatus: formStatus,
        ReportID: reportId
    };
    var urlMtf0051 = $('#UrlMTF0051').val();
    ASOFT.asoftPopup.Show(popup, urlMtf0051, data);
}

// Lưu dữ liệu
function SaveData() {
    // check Input
    if (ASOFT.Form.CheckRequired("MTF0051")) {
        return;
    }

    // get formData
    var urlMtf0051Update = (formStatus == 1)
                            ? $('#UrlMTF0051Insert').val()
                            : $('#UrlMTF0051Update').val();

    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.getFormData(null, "MTF0051");
    var isCommon = $('form#MTF0051 input[name="IsCommon"]').prop('checked');
    var isDisabled = $('form#MTF0051 input[name="Disabled"]').prop('checked');
    data.unshift({ name: "IsCommon", value: isCommon });
    data.unshift({ name: "Disabled", value: isDisabled });

    ASOFT.helper.post(urlMtf0051Update, data, SaveSuccess);
}

// Lưu thành công
function SaveSuccess(result) {
    if (result.success) {
        // Hiển thị thông báo lưu thành công
        ASOFT.Dialog.MessageDialog("Lưu thành công");
        switch (saveActionType) {
            case 1:
                formStatus = 1;
                clearFormData("MTF0051");
                $('form#MTF0051 input[name="Disabled"]').removeAttr('checked');
                break;
            case 2:
                formStatus = 1;
                $("#ReportID").val('');
                break;
            case 3:
                ClosePopup();
                break;
            default:
                break;
        }
    } else {
        // Hiển thị thông báo lưu không thành công
        ASOFT.Dialog.MessageDialog("Lưu không thành công");
    }


    if (GridMaster) {
        // Reload grid
        GridMaster.dataSource.page(1);
    } else {
        // Reload panel
        reportId = $('#MTF0052ReportID').val();
        var data = { id: reportId };
        var urlMtf0052MPartial = $('#UrlMTF0052MPartial').val();

        ASOFT.helper.post(urlMtf0052MPartial, data, function (html) {
            $('#viewMTF0052MPartial').html(html); // apply partial view
        });
    }
}

// Clear form data
function clearFormData(formId) {
    $('form#' + formId + ' input').val('');
    $('form#' + formId + ' textarea').val('');
}

// close popup
function ClosePopup() {
    MTF0051Popup.close();
}

//=============================================================================
// Button Events
//=============================================================================

// Xóa report Master
function btnDelete_Click() {
    ASOFT.Dialog.ConfirmDialog(ASOFT.helper.getMessage('ASML000096'), DoDelete);
}

// Filter Master
function btnFilter_Click() {
    // Call filter
    FilterData();
}

// Sự kiện thêm mới report Master
function btnAddNew_Click() {
    // Call add new
    AddNew();
}

// Sự kiện sửa report Master
function btnEdit_Click() {
    // Call edit
    Edit();
}

// Lưu và nhập tiếp
function btnSaveNext_Click() {
    saveActionType = 1;
    SaveData();
}

// Lưu và sao chép
function btnSaveCopy_Click() {
    saveActionType = 2;
    SaveData();
}

// Lưu và đóng
function btnSaveClose_Click() {
    saveActionType = 3;
    SaveData();
}

// Đóng popup
function btnClose_Click() {
    ASOFT.Dialog.ConfirmDialog("Bạn có muốn lưu thay đổi", btnSaveClose_Click, ClosePopup);
}

//=============================================================================
// Combobox Events
//=============================================================================
function GroupID_SelectedIndexChanged() {
    var dataItem = ComboBoxGroupID.value();
    if (dataItem == null) { return; }

    var dataSource = { GroupID : dataItem, SelectedFirst: true };
    ASOFT.asoftComboBox.Callback(ComboBoxType, '/ComboBox/Type', dataSource);
}




