//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     04/09/2014      Đức Quý         Tạo mới
//####################################################################

BF0000 = new function () {
    this.sortable = null;
    this.currentZoomer = null;
    this.zoomDialog = null;

    this.initChart = function (name, url) {
        ASOFT.helper.post(url,
                          {},
                          function (data) {
                              $('#' + name).html(data);
                          });
    }

    this.zoomDialogWin = function () {
        BF0000.zoomDialog = $("#ZoomConfig").data("kendoWindow");
    };

    this.openMenuWin = function (e) {
        var posE = $(e).offset();

        //if (CheckItemMenu(id)) return;
        if (typeof (BF0000.zoomDialog) === 'undefined'
            || BF0000.zoomDialog == null) return;
        BF0000.zoomDialog.wrapper.css({ top: posE.top + 34, left: posE.left });
        BF0000.zoomDialog.open();

        // save current zoomer
        BF0000.currentZoomer = e;
    }

    this.closeBlock = function (e) {
        var xCloset = $(e).closest('.asf-block-wrapper');
        if (xCloset) {
            xCloset.remove();
        }
    };
    this.OpenSetting = function (e) {
        // Url load dữ liệu lên form
        var postUrl = $("#UrlBF0001").val();
        var data = {};
        // [4] Hiển thị popup
        BF0000.showPopup(postUrl, data);
    };
    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(url, {});
    };

    this.closeMenuWin = function () {
        if (typeof (BF0000.zoomDialog) === 'undefined'
             || BF0000.zoomDialog == null) return;
        BF0000.zoomDialog.close();

        // Destroy current zoomer
        BF0000.currentZoomer = null;
    };

    this.raiseZoomer = function (id) {
        if (BF0000.currentZoomer == null) return;
        var xFormat = $('#' + id);
        if (xFormat) {
            var xCssFormat = xFormat.attr('data-force');
            var xCloset = $(BF0000.currentZoomer).closest('.asf-block-wrapper');
            xCloset.attr('class', 'asf-block-wrapper ' + xCssFormat);

            var chart = xCloset.find('.k-chart');
            if (chart) {
                chart.each(function () {
                    var chartId = $(this).attr('id');
                    $('#' + chartId).data('kendoChart').refresh();
                });
            }
        }
    };

    this.sortableEvents = function () {
        var container = document.getElementById("multi-draggable-block");
        new Sortable(container, {
            draggable: '.asf-block-wrapper',
            handle: '.asf-block-toolbar'
        });

        [].forEach.call(container.getElementsByClassName('asf-block-content'), function (el) {
            new Sortable(el, { group: 'sortable-block' });
        });

    };

    this.zoomEvents = function () {
        $('.asf-i-magnify-add').bind('click', function (e) {
            BF0000.openMenuWin(this);
        });

        $('.asf-i-delete').bind('click', function (e) {
            BF0000.closeBlock(this);
        });

        $('.asf-i-cogs-32').bind('click', function (e) {
            BF0000.OpenSetting(this);
        });

        $('.asf-i-refresh').bind('click', function (e) {
            BF0000.OpenSetting(this);
        });

        $('.zoom-tooltip').bind('mouseleave', function (e) {
            BF0000.closeMenuWin();
        });

        $('.zoom-tooltip a').bind('click', function (e) {
            var id = $(this).attr('id');
            BF0000.raiseZoomer(id);
        });
    };

    this.getSortedInfo = function () {
        var savedRange = [];
        $('.asf-block-wrapper').each(function () {
            var element = $(this);
            savedRange.push({
                Key: BF0000.dataIndex(element),
                Value: BF0000.dataForce(element)
            });
            //savedRange.push({ name: 'value', value: BF0000.dataForce(element)});
        });

        return savedRange;
    };

    this.dataIndex = function (e) {
        if (e && e.attr('data-index')) {
            return parseInt(e.attr('data-index'));
        }
        return 0;
    };
    // get data-force
    this.dataForce = function (e) {
        var cClass = e.attr('class');
        if (cClass.indexOf('asf-block-wrapper') != -1) {
            cClass = cClass.replace('asf-block-wrapper', '');
            return cClass.trim();
        }

        // Default block
        return "s-block";
    };

    this.resetLayout = function () {
        var url = $('#UrlReset').val();
        if (url) {
            window.open(url, "_self");
        }
    };

    this.saveLayout = function () {
        // Post index and data-force range for saving action
        var data = BF0000.getSortedInfo();
        var url = $('#UrlSaveData').val();
        if (data && url) {
            ASOFT.helper.postTypeJson(url, {
                indexer: JSON.stringify(data)
            }, function (data) { // Success message
                if (data) {
                    ASOFT.form.displayInfo('div#message', 'Đã lưu thiết lập thàng công!');
                } else {
                    ASOFT.form.displayError('div#message', 'Lỗi, không thể lưu thiết lập!');
                }

                // Auto clear message
                window.setTimeout(function () {
                    $('div#message').empty();
                }, 3000);
            });
        }
    };

    this.hideCustom = function () {
        var isXR = $('#IsXR').val();
        if (isXR === '1') {
            $('#dashboard-toolbar').remove();
            $('.asf-toolbar').empty();
        }
    }

    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    }

  

}

$(document).ready(function () {
    $('#btnSaveLayout').bind('click', BF0000.saveLayout);
    $('#btnResetLayout').bind('click', BF0000.resetLayout);

    //BF0000.initChart("Block01", $("#UrlBlock01").val());
    //BF0000.initChart("Block04", $("#UrlBlock04").val());

    BF0000.zoomDialogWin();
    BF0000.sortableEvents();
    BF0000.zoomEvents();

    ASOFT.helper.setAutoHeight($('.drmDashboard'));

    //BF0000.hideCustom();


    //var userHub = $.connection.userHub;
    //$.connection.hub.qs = { 'userID': $('#UserID').val() };
    //// Create a function that the hub can call back to display messages.
    //userHub.client.sendMessageExists = function (result) {
    //    // Add the message to the page. 
    //    alert('Đã có một người khác đăng nhập tài khoản ' + result);
    //};

    //$.connection.hub.start().done(function () {
    //    //userHub.server.addUser($('#UserID').val());
    //    userHub.server.getUser($('#UserID').val());
    //}).fail(function (error) {
    //    console.error(error);
    //});
});