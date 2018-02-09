//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF0120 = new function () {
    this.rowNum = 0;
    this.DRF0120Grid = null;
    this.comboBranchID = null;
    this.branchID = null;
    this.isFirst = true;
    this.gridData = [];

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("DRF0120")) {
            return;
        }

        if (DRF0120.DRF0120Grid.dataSource.data().length <= 0) { //Lưới không có dòng nào ko có cho lưu
            ASOFT.form.displayMessageBox('#DRF0120', [ASOFT.helper.getMessage('00ML000067')]);
            return;
        }

        //if (ASOFT.asoftGrid.editGridValidate(DRF0120.gridData)) {
        //    msg = ASOFT.helper.getMessage('Chỉ tiêu bị bỏ trống');
        //    ASOFT.form.displayError('#DRF0120', msg);
        //    return;
        //}

        DRF0120.DRF0120Grid.dataSource.data(DRF0120.gridData);
        var data = ASOFT.helper.dataFormToJSON('DRF0120', 'List', DRF0120.DRF0120Grid);
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0120.drf0120SaveSuccess);
    };

    this.drf0120SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0120', function () {
            DRF0120.btnClose_Click();
        }, null, null, true);
    }

    this.rowNumber = function () {
        return ++DRF0120.rowNum;
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
        DRF0120.rowNum = 0;
    };

    this.branch_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF0120');

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        //$('#BranchName').val(dataItem.AnaName);

        //DRF0120.DRF0120Grid.dataSource.data(DRF0120.gridData);
        //$filter = new Array();
        //$filter.push({ field: "BranchID", operator: "eq", value: dataItem.AnaID });
        //var query = new kendo.data.Query(DRF0120.DRF0120Grid.dataSource.data());
        //var data = query.filter($filter).data;
        var data = DRF0120.gridView_Filter(DRF0120.gridData, 'BranchID', dataItem.AnaID);
        DRF0120.DRF0120Grid.dataSource.data(data);
    }

    this.branch_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        DRF0120.branchID = this.value();
    }

    //Lọc dữ liệu
    this.gridView_Filter = function (data, field, value) {
        DRF0120.DRF0120Grid.dataSource.data(data);
        $filter = new Array();
        $filter.push({ field: field, operator: "eq", value: value});
        var query = new kendo.data.Query(DRF0120.DRF0120Grid.dataSource.data());
        return query.filter($filter).data;
    }
}

$(document).ready(function () {
    DRF0120.DRF0120Grid = ASOFT.asoftGrid.castName('DRF0120Grid');
    DRF0120.comboBranchID = ASOFT.asoftComboBox.castName('BranchID');
    DRF0120.DRF0120Grid.bind('dataBound', function () {
        DRF0120.rowNum = 0;

        if (DRF0120.gridData.length <= 0) {
            $.each(this.dataSource.data(), function () {
                DRF0120.gridData.push(this);
            });
        }

        if (DRF0120.isFirst) {
            DRF0120.isFirst = false;

            var data = DRF0120.gridView_Filter(DRF0120.gridData, 'BranchID', '%');
            DRF0120.DRF0120Grid.dataSource.data(data);
        }
    });
})