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
        if (url)
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
            $('#dashboard-toolbar').remove();
            $('.asf-toolbar').empty();
        
    }
    
    this.btnASM_Click = function (e) {
        var item = e.sender;
        var id = item.element.context.id;
        var urlPost = $('#UrlViewASM').val() + "?type=" + id;
        window.open(urlPost, "_blank");
    }
}

$(document).ready(function () {
    $('#btnSaveLayout').bind('click', BF0000.saveLayout);
    $('#btnResetLayout').bind('click', BF0000.resetLayout);

    BF0000.initChart("Block01", $("#UrlBlock01").val());
    BF0000.initChart("Block03", $("#UrlBlock03").val());
    BF0000.initChart("Block04", $("#UrlBlock04").val());
    BF0000.initChart("Block03_1", $("#UrlBlock03_1").val());
    //BF0000.initChart("Block05", $("#UrlBlock05").val());
    //BF0000.initChart("Block08", $("#UrlBlock08").val());

    // Init Chart dashboard ASM
    BF0000.initChart("BlockASM01", $("#UrlBlockASM01").val());
    BF0000.initChart("BlockASM02", $("#UrlBlockASM02").val());
    BF0000.initChart("BlockASM03", $("#UrlBlockASM03").val());
    BF0000.initChart("BlockASM04", $("#UrlBlockASM04").val());


    //BF0000.initChart("Block09", $("#UrlBlock09").val());
    BF0000.zoomDialogWin();
    BF0000.sortableEvents();
    BF0000.zoomEvents();

    //ASOFT.helper.setAutoHeight($('.drmDashboard'));
    $("#multi-draggable-block").append($("#Block03"));
    $("#multi-draggable-block").append($("#Block04"));
    //$("#multi-draggable-block").append($("#Block05"));
    $("#multi-draggable-block").append($("#Block03_1"));
    $("#multi-draggable-block").append($("#Block08"));

    $("#multi-draggable-block").append($("#BlockASM01"));
    $("#multi-draggable-block").append($("#BlockASM02"));
    $("#multi-draggable-block").append($("#BlockASM03"));
    $("#multi-draggable-block").append($("#BlockASM04"));

    //$("#Block06 #Chart06").kendoChart({
    //    seriesDefaults: {
    //        type: "column"
    //    },
    //    series: [{
    //        name: "Sales",
    //        data: [10, 20, -0.5, 0, 100, 0]
    //    }],
    //    valueAxis: [{
    //        majorGridLines: { visible: false },
    //        title: { text: "Sales" },
    //        axisCrossingValue: [0, -10]
    //    }],
    //    categoryAxis: [{
    //        categories: ["Order", "Invoice", "Credit Memo", "Order", "Invoice", "Credit Memo"],
    //        majorGridLines: { visible: false }
    //    }, {
    //        categories: ["Item", "Resources"],
    //        line: { visible: true },
    //        majorGridLines: { visible: false },
    //        title: { text: "Type & Document Type" }
    //    }]
    //});

    BF0000.hideCustom();


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

function formatLabel(value) {
    return kendo.toString((value * 100), "#.00");
}
//paste this code under the head tag or in a separate js file.
// Wait for window load
