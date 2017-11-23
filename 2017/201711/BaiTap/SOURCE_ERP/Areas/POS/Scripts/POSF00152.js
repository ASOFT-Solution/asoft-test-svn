//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################

var posGrid = null;
var posDetailGrid = null;
var posViewModel = null;
var rowNumber = 0;

/**
* sau khi load html
*/
$(document).ready(function () {
    posGrid = $('#POSF00152Grid').data('kendoGrid');
    posDetailGrid = $('#POSF0152DetailGrid').data('kendoGrid');
    createViewModel();
    $('input#chkAll').remove();
});
/******************************************************************************
                            ViewModel
*******************************************************************************/
/**
* Tạo viewmodel
*/
function createViewModel() {

    posViewModel = kendo.observable({
        fromDate: $('#VoucherFrom').data('kendoDatePicker').value(),
        toDate: $('#VoucherTo').data('kendoDatePicker').value(),
        detailDataSource: posDetailGrid.dataSource,
        checkDetail: function (items) {
            //display message
            if (items && items.length == 0) {
                ASOFT.form.displayWarning('#FormInherit', ASOFT.helper.getMessage('POSM000012'));
                return false;
            }
            return true;
        },
        search: function (e) {
            var check = ASOFT.form.checkRequiredAndInList('FormInherit', ['VoucherType']);
            //check required
            if (!check) {
                posGrid.dataSource.page(0);
            }
        },
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON('FormInherit');
            //dataFilter.VoucherFrom = this.fromDate;
            //dataFilter.VoucherTo = this.toDate;
            //dataFilter.VoucherType = this.VoucherType;
            return dataFilter;
        },
        getDetailChecked: function () {
            return ASOFT.asoftGrid.getDataChecked(posDetailGrid);
        },
        checkDataSource: function (data) {
            var gridData = this.detailDataSource.data();
            //Check detail
            var length = data.length;
            if (gridData.length == 0) {
                return $.merge(gridData, data);
            } else {
                for (var i = 0; i < length; i++) {
                    var row = data[i];
                    var arr = $.grep(gridData, function (rowDetail, j) {
                        return (rowDetail.InventoryID === row.InventoryID);
                    });
                    if (arr.length == 0) {
                        gridData.push(row);
                    }
                }
            }
        },
        addAllDetail: function (event, items) {
            var ids = [];
            var that = this;
            var action = getAbsoluteUrl('POSF00152/GetDetailData');

            if (items.length > 0) {
                for (var i = 0; i < items.length; i++) {
                    var item = items[i];
                    ids.push(item.APK);
                }
            }
            ASOFT.helper.postTypeJson(
                action,
                { apk: ids },
                function (resultData) {
                    that.detailDataSource.data(resultData.Data);
                }
            );

        },
        addDetail: function (event, id) {
            var isCheck = $(event).prop('checked');
            var action = getAbsoluteUrl('POSF00152/GetDetailData');
            var that = this;
            if (isCheck) {
                ASOFT.helper.postTypeJson(
                action,
                { apk: [id] },
                function (resultData) {
                    //that.detailDataSource.data(that.checkDataSource(resultData.Data));
                    that.detailDataSource.data(resultData.Data);
                    
                }
            );
            } else {
                var gridData = that.detailDataSource.data();
                var data = $.grep(gridData, function (item) {
                    return item.APKMaster !== id;
                });
                that.detailDataSource.data(data);
            }
        },
        //Xóa trên dòng
        deleteAll: function (event) {
            this.detailDataSource.data([]);
        }
    });
    kendo.bind($('#FormInherit'), posViewModel);
}

/******************************************************************************
                            Function
*******************************************************************************/
/**
* Send data to with grid
*/
function sendDataFilter() {
    if (posViewModel != null) {
        return posViewModel.dataFilter();
    }

    return ASOFT.helper.dataFormToJSON('FormInherit');;
}

/*
* rendernumber
*/
function renderNumber(data) {
    /*if (posGrid.dataSource.data().length == (rowNumber -1)) {
        return '';
    }*/
    return ++rowNumber;
}

/******************************************************************************
                            EVENTS
*******************************************************************************/
/*
* databound grid
*/
function detailGrid_dataBound(e) {
    rowNumber = 0;
    ASOFT.asoftGrid.dataBound(e);
}

/*
* databound grid
*/
function checkAll_Click(e) {
    var checkObj = ASOFT.asoftGrid.checkAll(e);
    if (checkObj.check) {
        if (checkObj.items.length > 0) {
            posViewModel.addAllDetail(e, checkObj.items);
        }
    } else {
        //delete all
        posViewModel.deleteAll();
    }
}

/*
* Add detail
*/
function masterGrid_Change(event, apk) {
    if (posViewModel != null && apk != null) {
        return posViewModel.addDetail(event, apk);
    }
}

/**
* Read data
*/
function btnRead_Click(event) {
    if (posViewModel != null) {
        return posViewModel.search();
    }
}

/**
* close popup
*/
function btnClose_Click(event) {
    //Close form
    if (parent.inherit_Close
        && typeof (parent.inherit_Close) === 'function') {
        parent.inherit_Close(event, posViewModel.getDetailChecked());
    }
}

/**
* Choose inherit
*/
function btnChoose_Click(event) {
    var items = posViewModel.getDetailChecked();
    if (posViewModel.checkDetail(items)) {
        //Close form
        if (parent.InheritPopup_Choose
            && typeof (parent.InheritPopup_Choose) === 'function') {
            parent.InheritPopup_Choose(event, items);
        }
    }
}