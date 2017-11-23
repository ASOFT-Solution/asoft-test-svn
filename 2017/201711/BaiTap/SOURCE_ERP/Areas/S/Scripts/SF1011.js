//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     09/10/2014      Chánh Thi        Tạo mới
//####################################################################

var urlUpdate = null;
var saveActionType = null;
var isLoadForm = 0;
var isSaved = false;

$(document).ready(function () {

});

function popupSaveCopy(e) {
    saveActionType = 2;
    saveData();
}

function popupSaveNew(e) {
    saveActionType = 1;
    saveData();
}

function popupClose(e) {
    //parent.popupClose(e);
    if (!ASOFT.form.formClosing('SF1011') && !isSaved) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            popupSaveUpdate, function () {
                ASOFT.asoftPopup.hideIframe(true);
            });
    }
    else {
        ASOFT.asoftPopup.hideIframe(true);
    }
}
// Lưu dữ liệu
function saveData() {
    if (ASOFT.form.checkRequired('SF1011')) {
        return;
    }   
    // Lấy dữ liệu trên form
    var data = getFormData();
    urlUpdate = $('#UrlInsert').val();
    // Post data
    ASOFT.helper.postTypeJson(urlUpdate, data, SaveSuccess);
}

function getFormData() {
    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.dataFormToJSON("SF1011");
    data.Disabled = ($("#Disabled").attr("checked") == 'checked');
    return data;
}
function SaveSuccess(result) {

    if (result.Status == 0) {
        // Chuyển hướng xử lý nghiệp vụ
        switch (saveActionType) {
            case 1: // Trường hợp lưu & nhập tiếp
                if (isLoadForm == 2) {
                    formStatus = 1;
                    ASOFT.form.displayInfo('#SF1011', ASOFT.helper.getMessage(result.Message).format(result.Data))
                    window.parent.location.reload();
                }
                formStatus = 1;
                ASOFT.form.displayInfo('#SF1011',ASOFT.helper.getMessage(result.Message).format(result.Data))
                parent.refreshGrid();
                $('#SF1011 input').val('');
                break;
            case 2: // Trường hợp lưu & sao chép
                formStatus = 1;
                //ASOFT.asoftPopup.hideIframe();
                ASOFT.form.displayInfo('#SF1011', ASOFT.helper.getMessage(result.Message).format(result.Data))
                parent.refreshGrid();

                $('#SF1011').find('input[type="text"], textarea').change(function () {
                    isSaved = false;
                });
                isSaved = true;
                break;
            case 3: // Trường hợp lưu và đóng
                formStatus = 1;
                ASOFT.form.displayInfo('#SF1011', ASOFT.helper.getMessage(result.Message).format(result.Data.TypesSelected));
                afterSaveHandler(result);
                parent.refreshGrid();
                posGrid.dataSource.read();
                if (result.Data.flag == 1) {
                    //parent.reloadWindow();
                    if (window != window.parent) {
                        window.parent.location.reload();
                    } else {
                        window.location.reload();
                    }
                }
                break;
            default:
                break;
        }

    } else {
        //ASOFT.helper.showErrorSever(result.Data.TypesSelected, "POSF00101");
        //afterSaveHandler(result);
        ASOFT.form.displayWarning('#SF1011', ASOFT.helper.getMessage(result.Message).format(result.Data).format(result.Data));
    }
}

function popupSaveUpdate(e) {
    if (ASOFT.form.checkRequired('SF1011')) {
        return;
    }
    //if (formIsInvalid()) {
    //    return;
    //}
    isLoadForm = 2;
    saveActionType = 1;
    // Lấy dữ liệu trên form
    var data = getFormData();
    //var data = ASOFT.helper.getFormData(null, "POSF00101")

    urlUpdate = $('#UrlUpdate').val();
    if (window.parent.formStatus === 1) {
        urlUpdate = $('#UrlInsert').val();
    }
    // Post data
    ASOFT.helper.postTypeJson(urlUpdate, data, SaveSuccess);
}