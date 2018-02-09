//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/04/2014      Minh Lâm         Tạo mới
//####################################################################
//Grid
var posGrid = null;
//MVVM object
var posViewModel = null;
//Row number of grid
var rowNumber = 0;
//Empty GUID
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
//IFrame fullscreen
var ifFrameID = 'externalIframe';

/**
* After load HTML
*/
$(document).ready(function () {
    posGrid = $("#POSF0039Grid").data("kendoGrid");
    //viewmode
    createViewModel();
    //Insall Period control
    installPeriod();
});

/******************************************************************************
                            ViewModel
*******************************************************************************/

/**
* Tạo viewmodel
*/
function createViewModel() {

    posViewModel = kendo.observable({
        url: getAbsoluteUrl("POSF0039/POSF0040"),
        fromMonth: null,
        fromYear: null,
        toMonth: null,
        toYear: null,
        isDate: true,
        isSearch: false,
        defaultFromDate: $("#FromDateFilter").data("kendoDatePicker").value(),
        defaultToDate: $("#ToDateFilter").data("kendoDatePicker").value(),
        fromPeriodFilter: $("#FromPeriodFilter").data("kendoDropDownList").value(),
        //toPeriodFilter: $("#ToPeriodFilter").data("kendoComboBox").value(),
        /**
        * add/ edit POSF00161
        */
        add: function (e, APK) {
            //enterFullScreen();
            //ASOFTCORE.log(APK);
            if(APK){
                ASOFT.asoftPopup.showIframe('/POS/POSF0039/POSF0040?apk={0}'.format(APK), {});
            }
            else{
                ASOFT.asoftPopup.showIframe('/POS/POSF0039/POSF0040', {});
            }
            //show iframe for full screen
            /*var ifFrameSector = $(kendo.format("#{0}", ifFrameID));
            if ($.browser.msie) {
                window.open(url, "secondWindow",
                    "fullscreen,scrollbars='yes',statusbar='yes',location='no'").focus();

            } else if (screenfull.enabled) {
                document.addEventListener(screenfull.raw.fullscreenchange, function () {
                    if (!screenfull.isFullscreen) {
                        ifFrameSector.hide();
                        ifFrameSector.attr('src', '');
                    }
                });
                if (APK != undefined && $.isPlainObject(APK)) {
                    ifFrameSector.attr('src', this.url);
                } else {
                    ifFrameSector.attr('src', kendo.format("{0}/{1}", this.url, APK));
                }

                ifFrameSector.show();
                screenfull.request(document.getElementById(ifFrameID));
            }*/
            return false;
        },
        /**
        * Search
        */
        search: function (e) {
            $("#FormFilter .asf-message").remove();
            posGrid.dataSource.page(0);
        },
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON("FormFilter");
            dataFilter.fromMonth = this.fromMonth;
            dataFilter.fromYear = this.fromYear;
            dataFilter.toMonth = this.toMonth;
            dataFilter.toYear = this.toYear;

            return dataFilter;
        },
        reset: function (e) {
            ASOFT.form.clearMessageBox('FormFilter');

            this.set('FromDateFilter', this.defaultFromDate);
            this.set('ToDateFilter', this.defaultToDate);
            this.set('FromPeriodFilter', this.fromPeriodFilter);
            //this.set('ToPeriodFilter', this.toPeriodFilter);
            this.set('DivisionIDFilter', '');
            this.set('ShopIDFilter', '');
            this.set('VoucherTypeIDFilter', '');
            this.set('VoucherNoFilter', '');
            this.set('MemberIDFilter', '');
            this.set('MemberNameFilter', '');
            this.set('CurrencyNameFilter', '');
            this.set('PaymentNameFilter', '');
            this.set('IMEI1Filter', '');
            this.set('IMEI2Filter', '');

            var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
            resetDropDown(multiComboBox);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
            //this.isSearch = false;
            //posGrid.dataSource.page(0);
        },
        //Xóa trên dòng
        deleteMany: function (e) {
            var that = this;
            var args = [];
            var data = {};
            var records = ASOFT.asoftGrid.selectedRecords(posGrid);
            if (records.length == 0) {
                return false;
            };
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                if (posGrid) { // Get all row select
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].APK);
                    }
                }
                data['args'] = args;
                var url = getAbsoluteUrl("POSF0016/DeleteMany");
                //Delete Json
                ASOFT.helper.postTypeJson(url, data, function (result) {
                    ASOFT.helper.showErrorSeverOption(1, result, "FormFilter", function () {
                        posGrid.dataSource.page(0);
                    }, null, null, true);
                });
            });
        }
    });
    kendo.bind($("#FormFilter"), posViewModel);
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
    return null;
}

/******************************************************************************
                            EVENTS
*******************************************************************************/

/**
* detail popup
*/
function detail_Click(e, apk) {
    if (posViewModel != null) {
        return posViewModel.add(e, apk);
    }
    return false;
}

/**
* add detail popup
*/
function btnAdd_Click(e) {
    var url = getAbsoluteUrl("POSF0039/CheckClienConnect");
    //Delete Json
    return posViewModel.add(e);
    ASOFT.helper.postTypeJson(url, {}, function (result) {
        if (result.Status == 2) {
            ASOFT.asoftPopup.showIframe("/POS/POSF0039/POSF0041", {});
            return false;
        } else {
            return posViewModel.add(e);
        }
    });
}

/**
* close popup
*/
function detailPopup_Close(event) {
    var iframe = parent.document.getElementById("externalIframe");
    parent.screenfull.exit();
    $(iframe).hide();
    iframe.src = "";
}

/**
* Refresh grid
*/
function refreshGrid(event) {
    posViewModel.search();
}

/**
* delete many apk
*/
function btnDelete_Click(e) {
    posViewModel.deleteMany(e);
    return false;
}

document.addEventListener("keydown", function (e) {
    if (e.keyCode === 123) {
        toggleFullScreen();
    }
}, false);

function toggleFullScreen() {
    if (!document.fullscreenElement &&    // alternative standard method
        !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {  // current working methods
        if (document.documentElement.requestFullscreen) {
            document.documentElement.requestFullscreen();
        } else if (document.documentElement.msRequestFullscreen) {
            document.documentElement.msRequestFullscreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullscreen) {
            document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        }
    }
}

function existFullScreen() {
    if (document.exitFullscreen) {
        document.exitFullscreen();
    } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen();
    }
}

function enterFullScreen() {
    if (!document.fullscreenElement &&    // alternative standard method
            !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {  // current working methods
        if (document.documentElement.requestFullscreen) {
            document.documentElement.requestFullscreen();
        } else if (document.documentElement.msRequestFullscreen) {
            document.documentElement.msRequestFullscreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullscreen) {
            document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    }
}