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
    posGrid = $('#POSF00191Grid').data('kendoGrid');
    createViewModel();

    //Lưu sau khi nhập cột 
    posGrid.bind('dataBound', function (e) {
        rowNumber = 0;
    });

    // Lấy ngày mã chứng từ
    $('#VoucherDate').focusout(function () {
        var result = $(this).val();
        voucherDate = result;
    });

});

/**
* Send data to with grid
*/
function SendDataMaster() {
    if ($('#APK').val() != '' && voucherDate != '') {
        return {
            APK: $('#APK').val(),
            VoucherDate : voucherDate
        };
    }
    return null;
}

/*
* rendernumber
*/
function renderNumber(data) {
    return ++rowNumber;
}

/**
* Đóng popup
*/
function popupClose(event) {
    parent.popupClose(event);
}

/**
* create viewmodel
*/
function createViewModel() {
    posViewModel = kendo.observable({
        defaultViewModel: ASOFT.helper.dataFormToJSON('POSF00191'),
        gridDataSource: posGrid.dataSource,
        Description: $('#DescriptionMaster').val(),
        isDataChanged: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF00191');
            var check = (dataPost.VoucherDate == this.defaultViewModel.VoucherDate)
                && (dataPost.VoucherNo == this.defaultViewModel.VoucherNo)
                && (dataPost.EmployeeID == this.defaultViewModel.EmployeeID)
                && (dataPost.EmployeeName == this.defaultViewModel.EmployeeName)
                && (dataPost.Description == this.defaultViewModel.Description);

            check = (check && !this.gridDataSource.hasChanges());

            return !check;
        },
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF00191');
            dataPost.EmployeeID = $('#EmployeeID').data('kendoComboBox').value();
            dataPost.DetailList = this.gridDataSource.data();
            dataPost.IsDataChanged = this.gridDataSource.hasChanges();
            return dataPost;
        },
        isInvalid: function () {
            //checkgrid
            $('#POSF00191Grid').removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);

            var check = ASOFT.form.checkRequiredAndInList('POSF00191', ['EmployeeID']);
            if (!check) { // Check in list dữ liệu
                if (this.gridDataSource.data().length <= 0) {
                    $('#POSF00191Grid').addClass('asf-focus-input-error');
                    //display message
                    var msg = ASOFT.helper.getMessage('00ML000061');
                    ASOFT.form.displayError('#POSF00191', msg);
                } else {
                    //show quantity
                    var cols = [
                        '',
                        'Note02',
                        'Note01',
                        'Note03',
                        'Note04',
                        'Note05',
                        'ShowCaseQuantity',
                        'ErrorQuantity'];

                    if (ASOFT.asoftGrid.editGridValidate(posGrid,cols)) {// kiểm tra khi edit lưới
                        var msg = ASOFT.helper.getMessage('00ML000060');
                        ASOFT.form.displayError('#POSF00191', msg);
                        check = true;
                    }
                }
            }

            return (check || this.gridDataSource.data().length <= 0);
        },
        reset: function () {
            $('#APK').val('');
            $('#VoucherNo').val(this.defaultViewModel.VoucherNo);
            this.set('VoucherDate', this.defaultViewModel.VoucherDate);
            this.set('PreparedBy', '');
            this.set('PreparedBy', '');
            this.set('Description', '');
            posGrid.dataSource.read();
        },
        close: function () {
            //Close form
            if (parent.popupClose
                && typeof (parent.popupClose) === 'function') {// Kiểm tra trước khi đóng popup
                parent.popupClose();
            }
        },
        deleteItems: function (tagA) {
            //remove gridEdit
            ASOFT.asoftGrid.removeEditRow(tagA, posGrid);
            return false;
        },
        /**
        * save 
        * action = 1 : saveAndContinue
        * action = 2 : saveAndCopy
        * action = 3 : update
        */
        save: function (e, actionFlg) {
            if (this.isInvalid()) {// kiểm tra điều kiện hợp lệ 
                return false;
            }
            var that = this;
            var dataPost = this.getInfo();
            var isUpdate = ($('#APK').val() != null
                && $('#APK').val() != ''
                && $('#APK').val() != EMPTY_GUID);
            var action = '/POS/POSF0019/Insert';
            if (isUpdate) {
                action = '/POS/POSF0019/Update';
                dataPost.APK = $('#APK').val();
            }

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    if (data.Status == 0) { // Kiểm tra tình trang status
                        var msg = ASOFT.helper.getMessage(data.Message);
                        if (data.Data != null) { // kiểm tra dữ liệu 
                            msg = kendo.format(msg, data.Data);
                        }
                        //display message
                        ASOFT.form.displayWarning('#POSF00191', msg);

                    } else {
                        //refresh grid master
                        if (parent.refreshGrid
                            && typeof (parent.refreshGrid) === 'function') {
                            parent.refreshGrid();
                        }

                        switch (actionFlg) {
                            case 0:
                                //close form
                                that.close();
                                break;
                            case 1:
                                ASOFT.form.displayInfo('#POSF00191', ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel.VoucherNo = data.Data;
                                that.reset();
                                break;
                            case 2:
                                ASOFT.form.displayInfo('#POSF00191', ASOFT.helper.getMessage(data.Message));
                                //set default VoucherNo
                                that.defaultViewModel.VoucherNo = data.Data;
                                $('#VoucherNo').val(that.defaultViewModel.VoucherNo);
                                break;
                            case 3:
                                ASOFT.form.displayInfo('#POSF00191', ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel = ASOFT.helper.dataFormToJSON('POSF00191');
                                that.gridDataSource.saveChanges();
                                if (data.Data != null) {
                                    $('#LastModifyDateValue').val(data.Data.LastModifyDateValue);
                                }
                                break;
                        }

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
* Change combox
*/
function cboEmployeeID_Cascade(e) {
    // Item đã được chọn
    var dataItem = this.dataItem(this.selectedIndex);

    if (dataItem == null) { // If not choose anyone , set it with null value.
        return null;
    };

    // get tranmonth, tranyear value
    posViewModel.set('EmployeeName', dataItem.Name);
    posViewModel.set('EmployeeID', dataItem.ID);
}

/**
* Save
*/
function btnSaveNew_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            posViewModel.save(e, 1);
        },
        null
    );
}

/**
* Save and copy
*/
function btnSaveCopy_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            if (posViewModel.isDataChanged()) {
                posViewModel.save(e, 2);
            }
        }, null);
}

/**
* Update
*/
function btnUpdate_Click(e) {
    if (posViewModel.isDataChanged()) {
        ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            posViewModel.save(e, 3);
        });
    }
}

/**
* Grid Save
*/
function Grid_Save(e) {

    if(e.values.ShowCaseQuantity || e.values.ErrorQuantity 
        || e.values.Note01 || e.values.Note02 
        || e.values.Note03 || e.values.Note03 || 
        e.values.Note04 || e.values.Note05) { // Nếu giá trị có thay đổi tính toán cộng trừ trên grid

        var showCaseQuantity = e.values.ShowCaseQuantity || e.model.ShowCaseQuantity;
        var errorQuantity = e.values.ErrorQuantity || e.model.ErrorQuantity;
        var note01 = e.values.Note01 || e.model.Note01;
        var note02 = e.values.Note02 || e.model.Note02;
        var note03 = e.values.Note03 || e.model.Note03;
        var note04 = e.values.Note04 || e.model.Note04;
        var note05 = e.values.Note05 || e.model.Note05;
        var stockQuantity = e.model.StockQuantity;
        var sub = stockQuantity - showCaseQuantity - errorQuantity - note01 - note02 - note03 - note04 - note05;
        e.model.set("SalesQuantity", sub);

    }
}
