//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//#     27/08/2014      Thai Son        Update
//####################################################################

// references
// http://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
// http://en.wikipedia.org/wiki/Observer_pattern
// https://www.youtube.com/watch?v=vXjVFPosQHw
// http://kickass.to/tutsplus-writing-modular-javascript-t6749579.html
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Closures

// Đối tượng Sandbox: hỗ trợ giao tiếp giữa các module, và với CORE

var ASOFTCORE = ASOFTCORE || {};
ASOFTCORE.Sandbox = {

    // hàm khởi tạo Sandbox cho một module,
    // được gọi khi CORE tạo mới một module
    create: function (core, module_selector, inFrame) {
        var
            // tìm dom element tương ứng với module cần cần tạo
            CONTAINER = null,
            context = window.frames[0] && $(window.frames[0].document),
            log = ASOFTCORE.log;

        // Nếu module liên quan đến dom element trong iframe, 
        // thì tìm dom element trong frame
        // Nếu không thì tìm trong page hiện tại
        if (inFrame) {
            CONTAINER = core.dom.query('#' + module_selector, context);
        } else {
            CONTAINER = core.dom.query('#' + module_selector);
        }

        return {
            //currentTable: {},
            // Tìm một đối tượng DOM theo selector truyền vào
            find: function (selector) {
                return CONTAINER.query(selector);
            },

            // gán xử lý sự kiện cho một dom element
            addEvent: function (element, type, fn) {
                core.dom.bind(element, type, fn);
            },

            // gỡ xử lý sự kiện khỏi một dom element
            removeEvent: function (element, type, fn) {
                core.dom.unbind(element, type, fn);
            },

            // notify (trigger) một sự kiện
            // cho các module khác, có liên quan, xử lý
            notify: function (evt) {
                var hasListenner = false;
                if (core.is_obj(evt) && evt.type) {
                    hasListenner = core.triggerEvent(evt);
                }

                if (!hasListenner) {
                    if (core.is_func(evt.data.seftCallBack)) {
                        evt.data.seflCallBack.call(evt)
                    }
                }
            },

            // đăng ký các sự kiện
            listen: function (evts) {
                if (core.is_obj(evts)) {
                    core.registerEvents(evts, module_selector);
                }
            },

            // Hủy đăng ký một sự kiện
            ignore: function (evts) {
                if (core.is_arr(evts)) {
                    core.removeEvents(evts, module_selector);
                }
            },

            // Hủy đăng ký tất cả sự kiện
            ignoreAll: function (evts) {
                if (core.is_arr(evts)) {
                    core.removeAllEvents(evts, module_selector);
                }
            },

            // utiliy để tạo một dom element
            // truyền vào tên và các thuộc tính
            create_element: function (el, config) {
                var i, child, text;
                el = core.dom.create(el);

                if (config) {
                    if (config.children && core.is_arr(config.children)) {
                        i = 0;
                        while (child = config.children[i]) {
                            el.appendChild(child);
                            i++;
                        }
                        delete config.children;
                    }
                    if (config.text) {
                        el.appendChild(document.createTextNode(config.text));
                        delete config.text;
                    }
                    core.dom.apply_attrs(el, config);
                }
                return el;
            },
            // hàm console.log viết gọn
            log: core.log
        };
    }
}
