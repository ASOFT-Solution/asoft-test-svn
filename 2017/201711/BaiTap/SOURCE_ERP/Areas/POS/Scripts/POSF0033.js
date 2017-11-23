//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/06/2014      Chanh Thi      Tạo mới
//####################################################################

//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     22/04/2014      Chánh Thi        Tạo mới
//####################################################################

var posGrid = null;// Grid POSF00191
var posViewModel = null; // ViewModel of POSF00191
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000'; // Định dạng mã tăng tự động
var rowNumber = 0; // số dòng ban đầu
var voucherDate = null; // Ngày chứng từ
var sale = 0;
$(document).ready(function () {
    createViewModel();
});

/**
* create viewmodel
*/
function createViewModel() {
    posViewModel = kendo.observable({
        defaultViewModel: ASOFT.helper.dataFormToJSON('POSF0033'),
        Description: $('#DescriptionMaster').val(),
        isDataChanged: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF0033');
            var check = (dataPost.VoucherDate == this.defaultViewModel.VoucherDate)
                && (dataPost.VoucherNo == this.defaultViewModel.VoucherNo)
                && (dataPost.EmployeeID == this.defaultViewModel.EmployeeID)
                && (dataPost.EmployeeName == this.defaultViewModel.EmployeeName)
                && (dataPost.Description == this.defaultViewModel.Description);

            check = (check && !this.gridDataSource.hasChanges());

            return !check;
        },
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF0033');
            return dataPost;
        },
        close: function () {
            //Close form
            if (parent.popupClose
                && typeof (parent.popupClose) === 'function') {// Kiểm tra trước khi đóng popup
                parent.popupClose();
            }
        },
        /**
        * save 
        * action = 1 : saveAndContinue
        * action = 2 : saveAndCopy
        * action = 3 : update
        */
        save: function (e, actionFlg) {
            var that = this;
            var dataPost = this.getInfo();
            if (dataPost.NextShift == '' || dataPost.NextShift == null) {
                ASOFT.form.displayInfo('#POSF0033', ASOFT.helper.getMessage('POSM000058'));
                return false;
            }
            var action = '/POS/POSF0033/Save';
            var url = '/Login?UserID={0}'.format(dataPost.NextShift);
            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    switch (actionFlg) {
                        case 1:
                            ASOFT.form.displayInfo('#POSF0033', ASOFT.helper.getMessage(data.Message));
                            if (window === window.parent) {
                                window.parent.location.href = url;
                            }
                            else {
                                window.parent.parent.location.href = url;
                            }
                            break;
                        case 2:
                            ASOFT.form.displayInfo('#POSF0033', ASOFT.helper.getMessage(data.Message));
                            //set default VoucherNo
                            that.defaultViewModel.VoucherNo = data.Data;
                            $('#VoucherNo').val(that.defaultViewModel.VoucherNo);
                            break;
                        case 3:
                            ASOFT.form.displayInfo('#POSF0033', ASOFT.helper.getMessage(data.Message));
                            that.defaultViewModel = ASOFT.helper.dataFormToJSON('POSF0033');
                            that.gridDataSource.saveChanges();
                            if (data.Data != null) {
                                $('#LastModifyDateValue').val(data.Data.LastModifyDateValue);
                            }
                            break;
                    }
                }
            );
        }//end save (function)
    });
    kendo.bind($('#POSF00191'), posViewModel);
}

/**
* Close popup
*/
function btnClose_Click(event) {
    if (posViewModel.isDataChanged()) {// Check data is change or not.
        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000016'),
            //yes
            function () {
                posViewModel.save(null, 0);
            },
            //no
            function () {
                posViewModel.close();
            });
    } else {
        //Close popup
        posViewModel.close();
    }
}

/**
* Close popup without confirm
*/
function btnCloseOnly_Click(event) {
    //Close popup
    posViewModel.close();
}

/**
* Save
*/
function btnSave_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('POSM000059'),
        //yes
        function () {
            posViewModel.save(e, 1);
        },
        null
    );
}



