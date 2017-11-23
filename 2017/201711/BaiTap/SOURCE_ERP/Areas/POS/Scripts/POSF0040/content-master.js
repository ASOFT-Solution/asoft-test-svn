//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################


ASOFTCORE.create_module("contentMaster", function (sb) {
    var dishes,
        grid,
        dataSource,
        selectedTable,
        selectedArea,
        LOG = ASOFTCORE.log,
        CSS_HIDDEN = 'asf-disabled-visibility'
    ;

    /**
    * In chế biến
    */
    function btnPrintProcessDish_Click(e) {
        // Gở bỏ sự kiện click trên nút in chế biến
        // Khi in xong thì gán lại
        //sb.ignore(['btnPrintProcessDish_Click']);

        if (posViewModel) {
            posViewModel.printProcess();
        }
    }

    /**
    * In hóa đơn
    */
    function btnPrintBill_Click(e) {
        // Gở bỏ sự kiện click trên nút in hóa đơn
        // Khi in xong thì gán lại
        //LOG('btnPrintBill_Click');
        //sb.ignore(['btnPrintBill_Click']);
        if (posViewModel) {
            posViewModel.printBill();
        }
    }

    // Xử lý khi chọn một bàn ăn
    function chooseTable_Handler(data) {
        var i = 0,
            dish = null,
            item = null,
            table = data.table,
            postData = {},
            cboCurrency = $('#CurrencyID').data('kendoComboBox'),
            dpVoucherDate = $('#VoucherDate').data('kendoDatePicker')
        ;

        if (!table) {
            // TO DO:
            ASOFT.dialog.messageDialog('Bạn chưa chọn bàn nào');
            return;
        }
        selectedTable = table;

        // Đổi tiêu đề của khu vực - bàn
        $('#table-name').text(table.TableID);
        $('#area-name').text(table.Area.AreaName);

        // Nếu trạng thái của bàn là 0 (tức là bàn trống)
        // ... thì thêm một phiếu bán hàng
        // Nếu bàn không trống, thì lấy dữ liệu master và detail hiển thị
        // .. . lên màn hình bán hàng
        if (table.StatusTableID === 0) {
            postData['TableID'] = table.TableID;
            postData['AreaID'] = table.Area.AreaID;
            //postData['CurrencyID'] = cboCurrency.value();
            //postData['CurrencyName'] = cboCurrency.text();
            postData['VoucherDate'] = dpVoucherDate.value();

            // notify db
            sb.notify({
                type: 'insert-master-data',
                data: {
                    action: 'TryInsertMaster',
                    controller: 'POSF0036',
                    queryString: '',
                    parameters: postData,
                    typeGetParameter: {},
                    typePostParameter: postData,
                    callBack: tryInsertSuccessHandler
                }
            });
        } else {
            sb.notify({
                type: 'get-master-detail-data',
                data: {
                    action: 'GetMasterAndDetail',
                    controller: 'POSF0036',
                    queryString: '?areaID={0}&tableID={1}'.format(selectedTable.Area.AreaID, selectedTable.TableID),
                    parameters: {},
                    typeGetParameter: {},
                    typePostParameter: {},
                    callBack: fillMasterDetail
                }
            });
        }

        // Notify search-id-barcode
        sb.notify({
            type: 'enable-multy-select'
        });

        //startMarquee();
        $('#Header').removeClass(CSS_HIDDEN);
        $('#contentMaster').removeClass(CSS_HIDDEN);
        startMarquee();
        resizeGrid();
    };

    // Hiển thị master
    function fillMasterDetail(result) {
        sb.notify({
            type: 'fill-all-fields',
            data: {
                MasterData: result.Data.MasterData,
                DetailData: result.Data.DetailData
                //onSelectTable: true
            }
        });

        ASOFT.asoftPopup.hideIframe();
    }

    // Hiển thị master
    function fillMaster(result) {
        var master = result.MasterData;
    }

    // Hiển thị detail
    function fillDetail(result) {
        LOG('fillDetail');
    }

    // Xử lý sau khi thêm thành công master
    function tryInsertSuccessHandler(result) {

        // notify master-data
        sb.notify({
            type: 'fill-all-fields',
            data: {
                MasterData: result.Data.MasterData
                //onSelectTable: true
            }
        });

        ASOFT.asoftPopup.hideIframe();
    }

    // Trả về bàn hiện tại trên màn hình bán hàng
    function getCurrentTable(data) {
        // Lấy bàn hiện tại, trả về cho module đang yêu cầu
        data.callBack(selectedTable);
    }

    // Xử lý sự kiện ấn nút chọn bàn  trên mà hình bán hàng
    function btnChooseTable_Click(e) {
        // Mở popup chọn bàn
        ASOFT.asoftPopup.showIframe('/POS/POSF0036/Default', {});
        ASOFTCORE.globalVariables.fromButtonChoose = true;
        LOG('btnChooseTable_Click');
    }

    // Xử lý sự kiện ấn nút chọn món trên mà hình bán hàng
    function btnChooseDish_Click(e) {
        // Mở popup chọn món
        ASOFT.asoftPopup.showIframe('/POS/POSF0038/Default', {});
    }

    function btnMergeSplitTable_Click(e) {
        if (!posViewModel.TempAPKMaster) {
            LOG("KHONG CO BAN");
            return;
        }

        // notify master-data
        sb.notify({
            type: 'try-open-merge-split-table',
            data: {
                callBack: function () {
                    ASOFT.asoftPopup.showIframe('/POS/POSF0031/Index?apk={0}'.format(posViewModel.TempAPKMaster), {});
                }
            }
        });

    }

    function btnMergeSplitBill_Click(e) {
        if (!posViewModel.TempAPKMaster) {
            LOG("KHONG CO BAN");
            return;
        }

        // notify master-data
        sb.notify({
            type: 'try-open-merge-split-bill',
            data: {
                callBack: function () {
                    ASOFT.asoftPopup.showIframe('/POS/POSF0032/Index?apk={0}'.format(posViewModel.TempAPKMaster), {});
                },
                selfCallBack: function (e) {
                    LOG(e);
                }
            }
        });

    }

    function btnReturnedInventory_Click() {
        var data = {};
        if (!posViewModel.TempAPKMaster) {
            LOG('NO TABLE CHOOSEN');
            return false;
        }
        data.args = {
            APK: posViewModel.TempAPKMaster
        };
        ASOFT.asoftPopup.showIframe('/POS/POSF0042?apk={0}'.format(posViewModel.TempAPKMaster), {});
    }

    function btnExtension_Click() {
        var element = $('div:has(> #pos_info)')
        element.toggleClass('floating-element')
       .offset({
           top: ($(window).height() - element.height()) / 2,
           left: ($(window).width() - element.width()) / 2
       })

        $(window).off('resize', window_Resize).on('resize', window_Resize);

        function window_Resize(e) {
            element.offset({
                top: ($(window).height() - element.height()) / 2,
                left: ($(window).width() - element.width()) / 2
            });
        }
        $('#btnCloseExtension').off('click').on('click', function () {
            element.removeClass('floating-element')
        });
    }

    function btnFinishShift_Click() {
        ASOFT.asoftPopup.showIframe('/POS/POSF0033', {});
    }

    function closeWindow_Handler() {

        $('#Header').addClass(CSS_HIDDEN);
        $('#contentMaster').addClass(CSS_HIDDEN);
        ASOFT.asoftPopup.showIframe('/POS/POSF0036/Default', {});

    }

    function closeWindowOnEdit_Handler() {
        LOG('reload page');
        $('#Header').addClass(CSS_HIDDEN);
        $('#contentMaster').addClass(CSS_HIDDEN);
        window.location.assign("/POS/POSF0039/POSF0040")

    }


    var onclickElementSelectors = [
            '#btnChooseTable',
            '#btnChooseDish',
            '#btnMergeSplitBill',
            '#btnMergeSplitTable',
            '#btnReturnedInventory',
            '#btnPrintBill',
            '#btnPrintProcessDish',
            '#btnFinishShift',
            '#BtnCancel',
            '#btnPromotion',
            '#btnSave',
            '#btnAddObject',
            '#posFilter a',
    ],
    toggle = false,
    elementHasMessageBox = [
            '#btnChooseTable',
            '#btnChooseDish',
            '#btnMergeSplitBill',
            '#btnMergeSplitTable',
            '#btnReturnedInventory',
            '#btnPrintBill',
            '#btnPrintProcessDish',
            '#btnFinishShift',
            '#BtnCancel',
            '#btnPromotion',
            '#btnSave'
    ];

    function addAutoHideMessageBoxEvent() {
        $(onclickElementSelectors.join()).on('click', function (e) {
            clearMessageBox();
        });
    }

    function removeAutoHideMessageBoxEvent() {
        $(onclickElementSelectors.join()).unbind();
    }

    function clearMessageBox() {
        ASOFT.form.clearMessageBox();
    }

    function stopMarquee() {
        if (ASOFTCORE.globalVariables.mq) {
            ASOFTCORE.globalVariables.mq.marquee('destroy');
            ASOFTCORE.globalVariables.mq = undefined;
        }
    }

    function startMarquee() {
        ASOFTCORE.globalVariables.mq = $('.asf-marquee').marquee({
            //speed in milliseconds of the marquee
            duration: 7000,
            //gap in pixels between the tickers
            gap: 50,
            //time in milliseconds before the marquee will start animating
            delayBeforeStart: 0,
            //'left' or 'right'
            direction: 'left',
            //true or false - should the marquee be duplicated to show an effect of continues flow
            duplicated: false
        });
    }

    function btnPrintBill_OnEdit_Click(e) {
        if (posViewModel) {
            posViewModel.reprintBill(ASOFTCORE.globalVariables.apkMaster);
        }
        LOG('btnPrintProcessDish_OnEdit_Click');
    }



    return {
        init: function () {
            var that = this;
            //getData();
            grid = $(sb.find("#mainGrid")[0]).data('kendoGrid');
            dataSource = grid.dataSource;

            sb.addEvent(btnReturnedInventory, "click", btnReturnedInventory_Click);

            sb.listen({
                // chờ sự kiện chọn một bàn (ấn nút chọn) trên màn hình chọn bàn
                'choose-table': chooseTable_Handler,
                'get-current-table': getCurrentTable,
                // Chờ sự kiện ấn nút chọn bàn trên mà hình bán hàng
                'btnChooseTable_Click': closeWindow_Handler,
                'btnChooseTableOnEdit_Click': closeWindowOnEdit_Handler,
                // Chờ sự kiên ấn nút chọn món trên mà hình bán hàng
                'btnChooseDish_Click': btnChooseDish_Click,
                //'btnMergeSplitTable_Click': btnMergeSplitTable_Click,
                'btnMergeSplitBill_Click': btnMergeSplitBill_Click,
                'btnMergeSplitTable_Click': btnMergeSplitTable_Click,
                'btnFinishShift_Click': btnFinishShift_Click,
                'btnReturnedInventory_Click': btnReturnedInventory_Click,
                'btnPrintBill_Click': btnPrintBill_Click,
                'btnPrintProcessDish_Click': btnPrintProcessDish_Click,
                'btnPrintBill_OnEdit_Click': btnPrintBill_OnEdit_Click,
                'btnExtension_Click': btnExtension_Click,
                'close-sale-screen': closeWindow_Handler,
                'start-marquee': startMarquee,
                'stop-marquee': stopMarquee,
            });
        },

        destroy: function () {
            var that = this;
            eachProduct(function (product) {
                sb.removeEvent(product, 'click', that.addToCart);
            });
            sb.ignore(['choose-table', 'choose-dish', 'choose-dishes']);
        },

    };
}, false);

