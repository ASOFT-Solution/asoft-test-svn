
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     15/10/2014      Chánh Thi        Tạo mới
//####################################################################
var saveActionType = null;
var urlUpdate = null;
$(document).ready(function () {

});

function popupSaveUpdate() {
    saveActionType = 3;
    saveData();
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe(true);
}

function getFormData() {
    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.dataFormToJSON("SF1014");
    return data;
}

function saveData() {
    if (ASOFT.form.checkRequired('SF1014')) {
        return;
    }
    //if (formIsInvalid()) {
    //    return;
    //}
    // Lấy dữ liệu trên form
    var data = getFormData();
    urlUpdate = $('#UrlUpdatePassword').val();
    // Post data
    ASOFT.helper.postTypeJson(urlUpdate, data, SaveSuccess);
}

function SaveSuccess(result) {

    if (result.Status == 0) {
        // Chuyển hướng xử lý nghiệp vụ
        switch (saveActionType) {
            case 1: // Trường hợp lưu & nhập tiếp
                formStatus = 1;
                ASOFT.form.displayInfo('#SF1014', ASOFT.helper.getMessage(result.Message).format(result.Data))
                parent.refreshGrid();
                //posGrid.dataSource.read();
                //posGrid.refreshGrid();
                //posGrid.dataSource.fetch();
                break;
            case 2: // Trường hợp lưu & sao chép
                formStatus = 1;
                //ASOFT.asoftPopup.hideIframe();
                ASOFT.form.displayInfo('#SF1014', ASOFT.helper.getMessage(result.Message).format(result.Params));
                parent.refreshGrid();
                posGrid.dataSource.read();

                //ASOFT.asoftPopup.showIframe('/POS/POSF0010/POSF00101?FormStatus={0}&ShopID={1}'.format(formStatus, result.Data), data);
                break;
            case 3: // Trường hợp lưu và đóng
                formStatus = 1;
                ASOFT.form.displayInfo('#SF1014', ASOFT.helper.getMessage(result.Message).format(result.Data.TypesSelected));
                ASOFT.helper.showErrorSeverOption(0, result, 'SF1013', function () {
                    ASOFT.asoftPopup.hideIframe(true);
                }, null, null, true);
                break;
            default:
                break;
        }

    } else {
        //ASOFT.helper.showErrorSever(result.Data.TypesSelected, "POSF00101");
        //afterSaveHandler(result);
        ASOFT.form.displayWarning('#SF1014', ASOFT.helper.getMessage(result.Message).format(result.Data).format(result.Data));
    }
}
