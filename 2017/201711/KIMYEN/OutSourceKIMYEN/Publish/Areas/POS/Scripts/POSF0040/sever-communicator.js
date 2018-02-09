//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

// module thực hiện tương tác (get/post) với server

ASOFTCORE.create_module("sever-communicator", function (sb) {
    var dishes, grid, dataSource,
        LOG = ASOFTCORE.log,
        storage = window.sessionStorage,
        areas = [],
        tablesP = [],
        tablesV = [],
        allTables = [],
        // Tag <ul> chứa danh sách bàn Phòng lạnh
        tableUListP,
        // Tag <ul> chứa danh sách bàn sân Vườn
        tableUListV,
        // ENUM: trạng thái của bàn
        TableStatus = {
            Empty: 0,
            Ordered: 1,
            Processed: 2,
            Billed: 3,
            Unknown: 5
        },
        that = this,
        seletedTable,
        selectedArea,
        categories = [],
        dishes = [],

        htmlString = '<li>'
                   + '<img class="dish-img" src="/Areas/POS/Content/Images/{0}" />'
                   + '<span class="dish-name">{1}</span>'
                   + '<span>'
                   + '<input id="{2}" class="dish-choose" type="checkbox" {3} data-id="{2}" />'
                   + '<label for="{2}"></label>'
                   + '</span>'
                   + '</li>';


    function reset() {
        eachDish(function (dish) {
            dataSource.remove(dish);
        });
    }

    return {
        init: function () {

            sb.listen({
                'get-ajax-data': this.getAjaxData,
                'post-ajax-data': this.postAjaxData,
                //'choose-dishes': this.getAjaxData,
                'get-table-data': this.getAjaxData,
                'get-dishes-data': this.getDishData,
                'insert-master-data': this.postAjaxData,
                'get-master-data': this.getAjaxData,
                'get-detail-data': this.getAjaxData,
                'get-master-detail-data': this.getAjaxData,
                // Xử lý yêu câu kiểm tra bàn trống
                'try-choose-table': this.getAjaxData,
                'update-db-table-field': this.postAjaxData,
                'get-init-data': this.getAjaxData
            });
        },
        destroy: function () {
            var that = this;
            eachProduct(function (product) {
                sb.removeEvent(product, 'click', that.addToCart);
            });
            sb.ignore(['change-filter', 'reset-filter', 'perform-search', 'quit-search']);
        },

        getAjaxData: function (data) {
            var url = '/POS/{0}/{1}'.format(data.controller, data.action);
            if (data.queryString) {
                url = url + data.queryString;
            }

            ASOFT.helper.postTypeJson(
                url,
                data.typeGetParameter,
                function (result) {
                    data.callBack(result);
                }
            );
        },
        postAjaxData: function (data) {
            var url = '/POS/{0}/{1}'.format(data.controller, data.action);
            if (data.queryString) {
                url = url + data.queryString;
            }
            ASOFT.helper.postTypeJson(
                url,
                data.typePostParameter,
                function (result) {
                    if (data.callBack) {
                        data.callBack(result);
                    } else {
                        LOG('NO callBack function');
                    }
                }
            );


        },
        getDishData: function (data) {
            data.callBack({
                categories: categories,
                dishes: dishes
            });
        }
    };
}, false);

