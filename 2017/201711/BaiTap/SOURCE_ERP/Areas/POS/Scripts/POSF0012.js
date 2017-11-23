//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     31/03/2014      Chánh Thi        Cập Nhật
//####################################################################

var isSearch = false; // biến Lọc dữ liệu
var posGrid;

//ID for jquery sector
var GRID_ID = '#POSF0012Grid';
var GRID_NAME = 'POSF0012Grid';
var FORM_ID = '#FormFilter';
var FORM_NAME = 'FormFilter';
var SCREEN_ID = 'POSF0011';
var hiddenShopID = '';

$(document).ready(function () {
    // Tạo Grid
    posGrid = $(GRID_ID).data('kendoGrid');

    var elementIDs = [
    'btnFilterPOSF0012',
    'btnClearFilterPOSF0012',
    'BtnAddNew',
    'BtnDelete',
    'chkAll',
    'btnFilter'
    ];
    ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);

    hiddenShopID = $('#HiddenShopID').val();

    posGrid.bind('dataBound', function () {
        alignCenter({
            grid: posGrid,
            colNames: ['DivisionID', 'Barcode', 8]
        });        
    });

});

function alignCenter(options) {
    if (!options || !options.grid || !options.colNames) {
        throw 'options not valid';
    }
    options.direction = options.direction || 'left';
    options.all = options.all || false;

    var gridFields,
        colCount,
        indicesByString = options.colNames.filter(function (item) { return typeof item === 'string' }),
        indicesByNumber = options.colNames.filter(function (item) { return typeof item === 'number' })
    ;

    if (typeof options.grid === 'string') {
        options.grid = $('#' + options.grid).data('kendoGrid');
        if (!options.grid) {
            throw 'Cannot cast jquery object to kendo grid';
        }
    }

    gridFields = options.grid.dataSource.options.fields;
    colCount = gridFields.length;

    if (!Array.isArray(options.colNames)) {
        return;
    }

    gridFields.forEach(function (f, i) {
        var selectors = [],
            selector
        ;
        
        if (indicesByString.indexOf(f.field) !== -1) {
            selector = 'td:nth-child({0}n+{1})'.format(colCount, i + 1); 
            selectors.push(selector)
        }

        indicesByNumber.forEach(function (f, i) {
            if (f < colCount) {
                selector = 'td:nth-child({0}n+{1})'.format(colCount, f + 1);
                selectors.push(selector)
            }
        });

        options.grid
            .element
            .find(selectors.join())
            .removeClass('asf-cols-align-right')
            .removeClass('asf-cols-align-left')
            .addClass('asf-cols-align-center');
    });
}

    // Show hàng khuyến mãi
    function giftDetail_Click(InventoryID) {
        var url = "";
        // Nếu đã có InventoryID
        if (InventoryID != null) {
            url = kendo.format("/POS/POSF0012/POSF00121?InventoryID={0}", InventoryID);
        }
        ASOFT.asoftPopup.showIframe(url, {});
        return false;
    }

    /**
    * Đóng popup
    */
    function popupClose(event) {
        ASOFT.asoftPopup.hideIframe();
    }

    // lọc dữ liệu
    function filterData() {
        var from = ASOFT.helper.getFormData(null, "FormFilter");
        var datamaster = {};
        var isCommon = $('form#FormFilter input:checkbox#IsCommonFilter').prop('checked');
        $.each(from, function () {
            if (datamaster[this.name]) {
                if (!datamaster[this.name].push) {
                    datamaster[this.name] = [datamaster[this.name]];
                }
                datamaster[this.name].push(this.value || '');
            } else {
                datamaster[this.name] = this.value || '';
            }
        });
        datamaster["IsSearch"] = isSearch;
        return datamaster;
    }

    function refreshGrid() {
        posGrid.dataSource.page(1);
    }

    // Reset lại Form search.
    function btnClearFilter_Click() {
        $('#FormFilter input').val('');
        $('#DivisionID').val('');
        resetDropDown($('#DivisionID').data('kendoDropDownList'));
        $('#ShopID').data('kendoComboBox').value(hiddenShopID);
    }

    // Lọc dữ liệu của lưới
    function btnFilter_Click() {
        isSearch = true;
        posGrid.dataSource.page(1);
        return false;
    }

    function btnAdd_Click() {
        var url = getAbsoluteUrl('POSF0012/POSF0030');
        ASOFT.asoftPopup.showIframe(url, {});
    }

    function btnInventoryFilter_Click() {
        //var url = getAbsoluteUrl('POSF0012/POSF0030');
        //ASOFT.asoftPopup.showIframe(url, {});
        console.log('btnInventoryFilter_Click');
    }

    function btnDelete_Click() {
        var args = [];
        var data = {};
        var records = ASOFT.asoftGrid.selectedRecords(posGrid);
        if (records.length == 0) {
            return false;
        };

        //confirm
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'),
            function () {
                if (posGrid) { // Get all row select
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].InventoryID);
                    }
                }

                data['args'] = args;
                //Delete Json
                var url = getAbsoluteUrl('POSF0012/DeleteMany');
                ASOFT.helper.postTypeJson(url, data, function (result) {
                    ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME, function () {
                    
                    }, null, null, true);
                
                    posGrid.dataSource.page(0);
                });
            });

        return false;
    }