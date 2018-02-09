//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    // [1] Init objects
    DRF2003.DRF2003Popup = ASOFT.asoftPopup.castName("PopupIframe");
    DRF2003.childPopup = ASOFT.asoftPopup.castName("popupInnerIframe");

    DRF2003.btnSave = $("#BtnSaveClose").data('kendoButton');
    if (DRF2003.btnSave) DRF2003.btnSave.enable(false);

    DRF2003.btnReadData = $("#BtnReadData").data('kendoButton');
    if (DRF2003.btnReadData) DRF2003.btnReadData.enable(false);

    // Change to asoft-button style
    var attachment = $("#attachments");
    if (attachment) {
        attachment.parent().addClass("asf-button");
    }
    
    DRF2003.initProcessBar(0);
    DRF2003.displayBlock("progressBar", false);
});

DRF2003 = new function () {
    this.formStatus = null;
    this.DRF2003Popup = null;
    this.childPopup = null;

    this.fileName = null;
    this.errorValidate = null;
    this.errorCache = null;
    this.max = 0;
    this.pageSize = 25;
    this.headerColumns = null;
    this.type = null;
    this.startRow = null;
    this.btnSave = null;
    this.btnReadData = null;
    this.progressbar = null;
    this.progressInterval = null;
    this.errorCacheFile = null;
    this.transaction = null;
    this.completed = false;
    this.page = null;
    this.totalPage = null;
    this.hasError = null;

    var forceChangeMessage = false;
    var count = 1;
    var isFine = false;
    var fileUploaded = 0;

    this.initProcessBar = function (value) {
        var pb = $("#progressBar").kendoProgressBar({
            type: "value",
            max: 100,
            animation: true,
            change: DRF2003.onProgressChange
        }).data("kendoProgressBar");

        if (pb) {
            pb.value(value);
            pb.progressStatus.text("starting progress...");
            //DRF2003.setIntervalProgress();
        }
    };
    
    this.onProgressChange = function (e) {
        this.progressStatus.text(e.value + "%");
        this.progressWrapper.css({
            "border-color": "#94c0d2",
            "box-shadow": "none",
        });
    }

    /**
    * Hàm xử lý sự ẩn hiện div
    */
    this.displayBlock = function (id, show) {
        var html = document.getElementById(id);
        if (html) {
            if (show) {
                html.setAttribute("style", "display:block");
            } else {
                html.setAttribute("style", "display:none");
            }
        }
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2003.closePopup();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF2003.displayBlock("progressBar", true);
        DRF2003.completed = false;
        DRF2003.page = 1;
        DRF2003.totalPage =
            Math.floor(DRF2003.max / DRF2003.pageSize) + (DRF2003.max % DRF2003.pageSize != 0 ? 1 : 0);
        DRF2003.hasError = false;

        var pb = $("#progressBar").data("kendoProgressBar");
        pb.value(0);

        // New async task
        var asyncFunction = function () {
            // new task
            var deferred = $.Deferred();
            
            DRF2003.savePaginate(
                DRF2003.errorCacheFile,
                DRF2003.transaction,
                DRF2003.completed,
                DRF2003.page,
                DRF2003.totalPage
            );

            if (DRF2003.completed) {
                // break task
                return deferred.promise();
            }
            else {
                // continue task
                return deferred.resolve();
            }
        },
        // define new task start;
        looper = $.Deferred().resolve();
        
        // Set interval looper
        DRF2003.setIntervalProccess(function () {
            looper = looper.then(function () {
                return asyncFunction();
            });
        }, DRF2003.totalPage);
    };

    // Lặp lại thread đang xử lý nếu đã hoàn tất
    this.setIntervalProccess = function (Func, limitInv) {
        var start = new Date().getTime();
        var i = 0, limit = limitInv, busy = false;
        var processor = setInterval(function () {
            if (!busy) {
                busy = true;

                Func.apply();
                console.log('Trace import at = ' + (new Date().getTime() - start) + ' [' + i + '/' + limit + ' ]');

                if (++i == limit) {
                    clearInterval(processor);
                    console.log('Trace import at = ' + (new Date().getTime() - start) + ' [done]');
                }

                busy = false;
            }
        }, 100);
    }

    // Lưu dữ liệu phân trang để tránh timeout webbrowser và store procedure
    this.savePaginate = function (errorCacheFile, transaction, completed, page, totalPage) {
        var postUrl = $("#UrlSaveDataPaginate").val();
        if (postUrl) {
            ASOFT.helper.post(postUrl, {
                filename: DRF2003.fileName,
                type: DRF2003.type,
                page: page,
                pageSize: DRF2003.pageSize,
                transactionKey: transaction,
                errorCache: errorCacheFile,
                screenID : window.parent.$('#ScreenID').val() ? window.parent.$('#ScreenID').val() : null
            }, function (data) {

                var pb = $("#progressBar").data("kendoProgressBar");
                pb.value(DRF2003.page / DRF2003.totalPage * 100);

                DRF2003.page++;
                DRF2003.errorCacheFile = data.errors;
                DRF2003.transaction = data.transactionKey;
                if (!data.result) {
                    DRF2003.hasError = true;
                }

                if (data.completed) {
                    completed = true;
                    if (!DRF2003.hasError) {
                        //Load grid truy vấn
                        var grids = ASOFT.helper.getKendoUI($(window.parent.$('#contentMaster')), 'grid');
                        $.each(grids, function () {
                            this.value.dataSource.page(1);
                        });

                        // Close popup
                        DRF2003.closePopup();
                    } else if (data.errors) {
                        isFine = false;
                        forceChangeMessage = true;
                        DRF2003.errorCache = data.errors;
                        count = 1;

                        DRF2003.getAllRowsPaginate(DRF2003.errorCache, count, DRF2003.pageSize, DRF2003.max);
                    }
                }
            });
        }
    }

    // Lưu dữ liệu không phân trang
    this.saveData = function () {
        var postUrl = $("#UrlSaveData").val();
        if (postUrl) {
            ASOFT.helper.post(postUrl, {
                filename: DRF2003.fileName,
                type: DRF2003.type,
                screenID: window.parent.$('#ScreenID').val() ? window.parent.$('#ScreenID').val() : null
            }, function (data) {
                if (data.result) {
                    //Load grid truy vấn
                    var grids = ASOFT.helper.getKendoUI($(window.parent.$('#contentMaster')), 'grid');
                    $.each(grids, function () {
                        this.value.dataSource.page(1);
                    });

                    // Close popup
                    DRF2003.closePopup();
                }
                else if (data.errors) {
                    isFine = false;
                    forceChangeMessage = true;
                    DRF2003.errorCache = data.errors;
                    DRF2003.max = data.max;
                    count = 1;

                    DRF2003.getAllRowsPaginate(DRF2003.errorCache, count, DRF2003.pageSize, DRF2003.max);
                }
            });
        }
    }
    
    // File uploader
    this.onUpload = function (data) {
        DRF2003.displayBlock("progressBar", false);

        if (!DRF2003.type) {
            ASOFT.form.displayError("div#import-message", 'Bạn phải chọn template');
            return;
        }

        if (fileUploaded > 0) {
            $('.k-upload-files .k-file:first').remove();
        }

        fileUploaded++;
    }

    // File upload success
    this.onUploadSuccess = function (data) {
        if (data && data.response.counter > 0) {
            // Clear message box
            ASOFT.form.clearMessageBox('import-message');
            $("#imported-list").html('' +
                '<div id="imported-destination-table"></div>' +
                '<div id="imported-destination-table-total"></div>' +
            '');

            var pb = $("#progressBar").data("kendoProgressBar");
            pb.value(0);

            // Reset environment params
            forceChangeMessage = false;
            isFine = false;
            count = 1;
            DRF2003.errorCache = null;
            DRF2003.errorValidate = null;

            DRF2003.fileName = data.response.array[0];

            DRF2003.btnReadData.enable(true);
        }
    };

    this.btnReadData_Click = function () {
        var postUrl = $("#UrlGetImportHeader").val();
        if (postUrl) {
            ASOFT.helper.post(postUrl, {
                filename: DRF2003.fileName,
                type: DRF2003.type,
                startRow: DRF2003.startRow
            }, DRF2003.appendImportHeaderGrid);
        }
    };

    // Render header
    this.appendImportHeaderGrid = function (data) {
        if (data) {
            if (!data.isTruthTemplete) {
                // Message errors
                var lstMgs = ['Nội dung tập tin tải lên không đúng với mẫu đã chọn.'];

                var mgsNotFoundCols = "Không tìm thấy các trường {0}";
                if (data.notFoundCols) {
                    var notFounds = "[" + data.notFoundCols.join(", ") + "]";
                    lstMgs.push(kendo.format(mgsNotFoundCols, notFounds));
                }

                ASOFT.form.displayError("div#import-message", lstMgs);
            }
            else if (data.headers) {
                DRF2003.fileName = data.file;
                DRF2003.headerColumns = data.headers;
                DRF2003.max = data.maxrow;
                DRF2003.pageSize = data.pageSize;
                DRF2003.errorValidate = data.errors;

                DRF2003.btnReadData.enable(false);
                DRF2003.btnSave.enable(true);

                if (data.rows) {
                    var rows = JSON.parse(data.rows);
                    
                    if (rows.length == 0) {

                        // Bind paginate grid
                        DRF2003.bindingGridPaginate(rows, DRF2003.headerColumns);

                        // Enable btnSave
                        DRF2003.btnSave.enable(true);

                        isFine = true;
                        DRF2003.getAllRowsPaginate(DRF2003.fileName, count, DRF2003.pageSize, DRF2003.max);
                    }
                    else {
                        // Bind grid
                        DRF2003.bindingGridPaginate(rows, DRF2003.headerColumns);

                        DRF2003.getAllRowsPaginate(DRF2003.errorValidate, count, DRF2003.pageSize, DRF2003.max);
                    }
                }
            }
            ASOFT.asoftPopup.center(DRF2003.childPopup);
        }
    };

    // Bind lưới phân trang
    this.bindingGridPaginate = function (dataRows, columns) {
        $('#imported-destination-table').html('');
        $('#imported-destination-table').kendoGrid({
            dataSource: {
                data: dataRows,
                serverPaging: true,
            },
            columns: columns,
            width: 750,
            height: 250,
            resizable: true,
            autoBind: false,
            pageable: {
                pageSizes: [DRF2003.pageSize],
                pageSize: DRF2003.pageSize,
                change: DRF2003.pagerChanged
            },
            scrollable: true,
            selectable: "row",
            dataBound: DRF2003.dataBound,
            dataBinding: DRF2003.dataBinding,
            change: DRF2003.recordSelect,

        }).addClass("asf-grid");
    };

    // Sự kiện change page
    this.pagerChanged = function () {
        var page = this.dataSource.page();
        if (page) {
            if (isFine) {
                DRF2003.getAllRowsPaginate(DRF2003.fileName, page, DRF2003.pageSize, DRF2003.max);
            }
            else {
                if (DRF2003.errorCache) {
                    DRF2003.getAllRowsPaginate(DRF2003.errorCache, page, DRF2003.pageSize, DRF2003.max);
                } else {
                    DRF2003.getAllRowsPaginate(DRF2003.errorValidate, page, DRF2003.pageSize, DRF2003.max);
                }
            }
        }
    };

    // Bind lưới không phân trang
    this.bindingGrid = function (dataRows, columns) {
        $('#imported-destination-table').html('');
        $('#imported-destination-table').kendoGrid({
            dataSource: { 
                data: dataRows,
            },
            columns: columns,
            width: 750,
            height: 250,
            resizable: true,
            scrollable: true,
            selectable: "row",
            dataBound: DRF2003.dataBound,
            change: DRF2003.recordSelect,

        }).addClass("asf-grid");
    };
    
    // Set total rows
    this.dataBinding = function () {
        this.dataSource.total = function () {
            return DRF2003.max;
        }
    }

    // Selected first item
    this.dataBound = function (e) {

        if (this.dataSource && this.dataSource._total > 0) {

            var grid = this;
            grid.tbody.find('tr').each(function () {
                var dataItem = grid.dataItem(this);
                var headers = DRF2003.headerColumns;
                if (dataItem.ErrorColumns) {
                    var errorCols = DRF2003.splitMessage(dataItem.ErrorColumns);
                    if (errorCols.length > 0) {
                        var array = DRF2003.mapColumnHeaderIndexer(errorCols, headers);
                        $.each($(this).children('td'), function (index, e) {
                            if (array.indexOf(index) > -1) {
                                e.setAttribute("class", "import-error-col");
                            }
                        });
                    }
                }
            })

            // Selected first row
            var row = e.sender.tbody.find('tr:first');
            this.select(row);

            // Click trigger event
            row.trigger('click');
        }

        
    };

    // On record selected
    this.recordSelect = function () {
        if (!isFine) {
            //var item = this.dataItem(this.select());
            //if (item) {
            //    if (item.IsValidStatus && item.IsValidStatus == 1) {
            //        var mgs = DRF2003.splitMessage(item.MessageForStatus);
            //        if (forceChangeMessage) {
            //            mgs = DRF2003.changeMessage(mgs);
            //        }

            //        ASOFT.form.displayError("div#import-message", mgs);
            //    }
            //}
            var data = this.dataSource._data;
            var message = [];
            for (var i = 0; i < data.length; i++) {
                if (data[i].IsValidStatus && data[i].IsValidStatus == 1) {
                    var mgs = DRF2003.splitMessage(data[i].MessageForStatus);
                    if (forceChangeMessage) {
                        mgs = DRF2003.changeMessage(mgs,data[i]);
                    }
                    message.push(mgs);
                }
            }
            ASOFT.form.displayError("div#import-message", message);
        }
    };

    // Map column name with index of header
    this.mapColumnHeaderIndexer = function (array, headers) {
        var indexer = [];
        for (var i = 0; i < headers.length; i++) {
            if (array.indexOf(headers[i].field) > -1) {
                indexer.push(i);
            }
        }

        return indexer;
    }

    // Convert format: C4-DRML0001 => C4-Message content display
    this.changeMessage = function (messages, value) {
        var mgsChanged = [];
        for (var i = 0; i < messages.length; i++) {
            var mgs = messages[i].split('-');
            if (mgs[1] == 'DRFML000046' || mgs[1] == 'DRFML000048') {
                mgsChanged.push(messages[i].replace(mgs[1], ASOFT.helper.getMessage(mgs[1]).f(value.ContractNo)));
            }
            else if (mgs[1] == 'DRFML000047') {
                mgsChanged.push(messages[i].replace(mgs[1], ASOFT.helper.getMessage(mgs[1]).f(value.CustomerID)));
            }
            else {
                mgsChanged.push(messages[i].replace(mgs[1], ASOFT.helper.getMessage(mgs[1])));
            }
        }

        return mgsChanged;
    };

    // Split Message
    this.splitMessage = function (message) {
        if (message) {
            if (message.substr(message.length - 1, message.length) == ';') {
                message = message.substr(0, message.length - 1);
            }

            return message.split(";");
        }

        return [];
    }

    this.bindingGridRow = function (dataSource) {
        var grid = $('#imported-destination-table').data("kendoGrid");
        grid.dataSource.data(dataSource);

    };

    // Load dữ liệu (rows) vào lưới
    this.appendImportRowGrid = function (data) {
        if (data && data.rows) {
            DRF2003.bindingGridRow(JSON.parse(data.rows));
        }
    };

    // Load dữ liệu phân trang
    this.getAllRowsPaginate = function (filename, page, pageSize, max) {
        // Show loading
        ASOFT.asoftLoadingPanel.show();

        var postUrl = $("#UrlGetImportRow").val();

        if (postUrl) {
            ASOFT.helper.post(postUrl, {
                filename: filename,
                page: page,
                pagesize: pageSize,
                max: max
            }, DRF2003.appendImportRowGrid);
        }
    };
    
    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    // on bound: Combo Template
    this.onBoundTemplate = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Set text
        DRF2003.type = dataItem.ImportTransTypeID;
        DRF2003.startRow = dataItem.StartRow;
    };

    // on change: Combo Template
    this.onChangeTemplate = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Set text
        DRF2003.type = dataItem.ImportTransTypeID;
        DRF2003.startRow = dataItem.StartRow;
    };

    //Down template excel
    this.btnDownload_Click = function () {
        var comboTemplate = ASOFT.asoftComboBox.castName('ImportTemplateID');
        var dataItem = comboTemplate.dataItem(comboTemplate.selectedIndex);

        if (dataItem == null) return;

        var url = $('#UrlDownload').val();

        window.location = url + '?defaultFileName=' + dataItem.DefaultFileName;
    }
}