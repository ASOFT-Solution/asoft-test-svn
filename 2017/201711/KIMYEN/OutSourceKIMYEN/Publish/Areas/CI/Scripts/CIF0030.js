
var CIF0030 = new function () {
    this.rowNum = 0;
    this.isFirst = true;
    this.CIF0030Grid_1 = null;
    this.CIF0030Grid_2 = null;
    this.CIF0030Grid_3 = null;
    this.CIF0030Grid_4 = null;
    this.CIF0030Grid_5 = null;

    this.gridData = [];
    //this.gridData_2 = [];
    //this.gridData_3= [];
    //this.gridData_4 = [];
    //this.gridData_5 = [];

    this.invalidGroup = false;
    this.checkboxs = ['IsUsed', 'IsCommon', 'Status'];
    // Cử lý có cho sử hay không thông qua check/unccheck checkbox IsUsed
    this.checkBox_Changed = function (tag) {
        var currentRecord = null;
        var currentgrid = null;
        var row = $(tag).parent().closest('div[role="tabpanel"]');
        if (row.attr("id") == "CIF0030Tab-1") {
            currentRecord = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_1);
            currentgrid = CIF0030.CIF0030Grid_1;
        }
        if (row.attr("id") == "CIF0030Tab-2") {
            currentRecord = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_2);
            currentgrid = CIF0030.CIF0030Grid_2;
        }
        if (row.attr("id") == "CIF0030Tab-3") {
            currentRecord = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_3);
            currentgrid = CIF0030.CIF0030Grid_3;
        }
        if (row.attr("id") == "CIF0030Tab-4") {
            currentRecord = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_4);
            currentgrid = CIF0030.CIF0030Grid_4;
        }
        if (row.attr("id") == "CIF0030Tab-5") {
            currentRecord = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_5);
            currentgrid = CIF0030.CIF0030Grid_5;
        }
        currentRecord[tag.id] = $(tag).prop('checked') ? 1 : 0;

        if (currentRecord["IsUsed"] == 0) { currentgrid.closeCell(); } // bo check IsUsed - ko cho edit

        CIF0030.Updatedatatotal(currentRecord);
    }

    // Hide Iframes
    this.btnClose_Click = function () {
        CIF0030.rowNum = 0;
        ASOFT.asoftPopup.hideIframe(true);
        //ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function ()
        //{
        //    CIF0030.btnConfig_Click();
        //},
        //function ()
        //{
        //    ASOFT.asoftPopup.hideIframe(true);
        //    CIF0030.rowNum = 0;
        //});
    };

    this.tab_Selected = function (e) {
        var group = $(e.item).attr('id');
        if (group === "A")
        {
            var data = CIF0030.gridView_Filter(CIF0030.CIF0030Grid_1, CIF0030.gridData, 'GroupID', group);
            CIF0030.CIF0030Grid_1.dataSource.data(data);
        }
        if (group === "I") {
            var data = CIF0030.gridView_Filter(CIF0030.CIF0030Grid_2, CIF0030.gridData, 'GroupID', group);
            CIF0030.CIF0030Grid_2.dataSource.data(data);
        }
        if (group === "O") {
            var data = CIF0030.gridView_Filter(CIF0030.CIF0030Grid_3, CIF0030.gridData, 'GroupID', group);
            CIF0030.CIF0030Grid_3.dataSource.data(data);
        }
        if (group === "D") {
            var data = CIF0030.gridView_Filter(CIF0030.CIF0030Grid_4, CIF0030.gridData, 'GroupID', group);
            CIF0030.CIF0030Grid_4.dataSource.data(data);
        }
        if (group === "N") {
            var data = CIF0030.gridView_Filter(CIF0030.CIF0030Grid_5, CIF0030.gridData, 'GroupID', group);
            CIF0030.CIF0030Grid_5.dataSource.data(data);
        }

    }

    //Lọc dữ liệu
    this.gridView_Filter = function (gird, data, field, value) {
        gird.dataSource.data(data);
        $filter = new Array();
        $filter.push({ field: field, operator: "eq", value: value });
        var query = new kendo.data.Query(gird.dataSource.data());
        return query.orderBy('TypeID').filter($filter).data;
    }
   
    //Event button config
    this.btnConfig_Click = function () {
        var data = ASOFT.helper.dataFormToJSON('CIF0030');
        data.List = CIF0030.gridData;
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, CIF0030.CIF0030SaveSuccess);
    };

    this.CIF0030SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF0030', function () {
            if (result.Status == 0) {
                ASOFT.asoftPopup.hideIframe(true);
                CIF0030.rowNum = 0;
            }
            
        }, null, null, true);
    }

    // function load data cho griddata và loc data cho gridview 1
    this.Getdata = function () {
        var urlGetdata = $('#UrlGetdata').val();
        var data = {};
        ASOFT.helper.postTypeJson(urlGetdata, data, CIF0030.GetdataSuccess);
    }

    this.GetdataSuccess = function (result) {
        CIF0030.gridData = result;  
    }

    // function cập nhật lại các dòng được sửa vào gridData
    this.Updatedatatotal = function (record) {     
        if (record) { //copy row grid 1 => griddata added row                
            $.each(CIF0030.gridData, function (index, value) {
                if (this.TypeID === record.TypeID) {
                    CIF0030.gridData.splice(index, 1);
                    CIF0030.gridData.push(record);//Add record vào griddata
                    return false;
                }
            });
        }
    }
}
$(document).ready(function () {
    // grid but toan
    CIF0030.CIF0030Grid_1 = ASOFT.asoftGrid.castName('CIF0030Grid1');
    CIF0030.CIF0030Grid_1.bind('dataBound', function () {
        CIF0030.rowNum = 0;

        CIF0030.CIF0030Grid_1.focus(0);
        if (CIF0030.isFirst) {
            CIF0030.isFirst = false;
            var group = "A";
            var data = CIF0030.gridView_Filter(CIF0030.CIF0030Grid_1, CIF0030.gridData, 'GroupID', group);
            CIF0030.CIF0030Grid_1.dataSource.data(data);
        }
    });
    
    //grid mặt hàng
    CIF0030.CIF0030Grid_2 = ASOFT.asoftGrid.castName('CIF0030Grid2');
    CIF0030.CIF0030Grid_2.bind('dataBound', function () {
        CIF0030.rowNum = 0;
    });

    //grid đối tượng
    CIF0030.CIF0030Grid_3 = ASOFT.asoftGrid.castName('CIF0030Grid3');
    CIF0030.CIF0030Grid_3.bind('dataBound', function () {
        CIF0030.rowNum = 0;
    });

    //grid Ngày
    CIF0030.CIF0030Grid_4 = ASOFT.asoftGrid.castName('CIF0030Grid4');
    CIF0030.CIF0030Grid_4.bind('dataBound', function () {
        CIF0030.rowNum = 0;
    });

    //grid ghi chú
    CIF0030.CIF0030Grid_5 = ASOFT.asoftGrid.castName('CIF0030Grid5');
    CIF0030.CIF0030Grid_5.bind('dataBound', function () {
        CIF0030.rowNum = 0;
    });

    // load data cho vào griddata
    CIF0030.Getdata();

    //control việc có được edit thông tin trên grid không
    CIF0030.CIF0030Grid_1.bind('edit', function () {
        var row = $(this.select());
        var cell = row.find('input#IsUsed');
        if (cell.prop('checked')) {
            record = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_1, 'CIF0030');
            CIF0030.Updatedatatotal(record)
            }
        else {
                this.closeCell();
            }
    });
    CIF0030.CIF0030Grid_2.bind('edit', function () {
        var row = $(this.select());
        var cell = row.find('input#IsUsed');
        if (cell.prop('checked')) {
            record = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_2, 'CIF0030');
            CIF0030.Updatedatatotal(record)
        }
        else {
            this.closeCell();
        }
    });
    CIF0030.CIF0030Grid_3.bind('edit', function () {
        var row = $(this.select());
        var cell = row.find('input#IsUsed');
        if (cell.prop('checked')) {
            record = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_3, 'CIF0030');
            CIF0030.Updatedatatotal(record)
        }
        else {
            this.closeCell();
        }
    });
    CIF0030.CIF0030Grid_4.bind('edit', function () {
        var row = $(this.select());
        var cell = row.find('input#IsUsed');
        if (cell.prop('checked')) {
            record = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_4, 'CIF0030');
            CIF0030.Updatedatatotal(record)
        }
        else {
            this.closeCell();
        }
    });
    CIF0030.CIF0030Grid_5.bind('edit', function () {
        var row = $(this.select());
        var cell = row.find('input#IsUsed');
        if (cell.prop('checked')) {
            record = ASOFT.asoftGrid.selectedRecord(CIF0030.CIF0030Grid_5, 'CIF0030');
            CIF0030.Updatedatatotal(record)
        }
        else {
            this.closeCell();
        }
    });
})