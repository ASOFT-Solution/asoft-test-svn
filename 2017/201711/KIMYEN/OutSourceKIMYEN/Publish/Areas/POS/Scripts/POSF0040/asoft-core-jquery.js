//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

// references
// http://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
// http://en.wikipedia.org/wiki/Observer_pattern
// https://www.youtube.com/watch?v=vXjVFPosQHw
// http://kickass.to/tutsplus-writing-modular-javascript-t6749579.html
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Closures

var ASOFTCORE = (function (CORE) {
    var
        moduleData = {},
        core,
        debug = true,
        storage = window.localStorage,
        numb = '0123456789',
        lwr = 'abcdefghijklmnopqrstuvwxyz',
        upr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',

        _log = (function () {
            var _log;
            // Nếu không debug, thì hàm LOG đặt thành hàm rỗng
            if (!debug) {
                _log = function () { };
                return _log;
            }

            // Tạo hàm log thay thế cho console.log
            if (Function.prototype.bind) {
                _log = Function.prototype.bind.call(console.log, console);
            }
            else {
                _log = function () {
                    Function.prototype.apply.call(console.log, console, arguments);
                };
            }
            return _log;
        }())

    ;


    // format số thành chuỗi dạng số thập phân
    function formatConvertedDecimal(value) {
        var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
        return kendo.toString(value, format);
    }

    // format số thành chuỗi dạng số thập phân
    function formatPercentDecimal(value) {
        var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
        return kendo.toString(value, format);
    }

    // format số thành chuỗi dạng số thập phân
    function formatUnitCostDecimal(value) {
        var format = ASOFTEnvironment.NumberFormat.KendoUnitCostDecimalsFormatString;
        return kendo.toString(value, format);
    }

    // format số thành chuỗi dạng phần trăm
    function formatQuantityDecimal(value) {
        var format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
        return kendo.toString(value, format);
    }

    // format số thành chuỗi dạng phần trăm
    function formatOriginalDecimal(value) {
        var format = ASOFTEnvironment.NumberFormat.KendoOriginalDecimalsFormatString;
        return kendo.toString(value, format);
    }

    // isValid, isNumber, isLower, isUpper, isAlpha
    // ==> các hàm hỗ trợ kiểm tra tính hợp lệ của chuổi
    function isValid(parm, val) {
        if (parm === "") {
            return true;
        }

        for (i = 0; i < parm.length; i++) {
            if (val.indexOf(parm.charAt(i), 0) == -1) return false;
        }
        return true;
    }

    function isNumber(parm) { return isValid(parm, numb); }

    function isLower(parm) { return isValid(parm, lwr); }

    function isUpper(parm) { return isValid(parm, upr); }

    function isAlpha(parm) { return isValid(parm, lwr + upr); }

    // tạo đối tượng core
    core = {
        number: {
            formatConvertedDecimal: formatConvertedDecimal,
            formatPercentDecimal: formatPercentDecimal,
            formatUnitCostDecimal: formatUnitCostDecimal,
            formatQuantityDecimal: formatQuantityDecimal
        },

        that: this,

        // đối tượng để chứa các biến toàn cục,
        // để tiện truy xuất giữa các module
        globalVariables: {},

        // đối tượng chứa tất cả các module được tạo
        moduleData: moduleData,

        // thay đổi trạng thái debug
        // nếu debug thì gọi hàm debug(true)
        // nếu release thì gọi hàm debug (false)
        debug: function (on) {
            debug = on ? true : false;
        },

        // Khởi tạo một module, với 
        // @moduleID: chuỗi id duy nhất, của mỗi module, 
        //      nếu module liên quan đến html dom 
        //      thì moduleID chính là thuộc tính id của contanner element
        // @creator: hàm tạo module, 
        // @inFrame: nếu phần html của module này nằm trên iframe
        //      thì truyền thêm tham số inFrame = true
        // Cú pháp: ASOFTCORE.create_module("master-data", function (sb) {}, [true, false])
        create_module: function (moduleID, creator, inFrame) {
            // thêm module này vào moduleData
            moduleData[moduleID] = {
                create: creator,
                instance: null
            };
        },

        // khởi động một mudule có moduleID truyền vào
        // @inFrame: nếu phần html của module này nằm trên iframe
        //      thì truyền thêm tham số inFrame = true
        // @inFrame: nếu phần html của module này nằm trên iframe
        //      thì truyền thêm tham số inFrame = true
        // Cú pháp: ASOFTCORE.start('master-data', false);
        start: function (moduleID, inFrame) {
            var
                // tìm module theo tên trong moduleData
                mod = moduleData[moduleID];
            // nếu tìm thấy, thì gọi hàm creator của module để tạo module
            // sau khi tạo xong thì gọi hàm init của module
            if (mod) {
                // tạo module với sandbox riêng cho module đó
                mod.instance = mod.create(ASOFTCORE.Sandbox.create(this, moduleID, inFrame));

                // Kiểm tra xem module có hàm init hay không
                if (mod.instance.init && this.utils.isFunc(mod.instance.init)) {
                    mod.instance.init();
                } else {
                    throw 'Module "' + moduleID + '" does not have "init" function';
                }

                // Kiểm tra xem module có hàm destroy hay không
                if (mod.instance.destroy && this.utils.isFunc(mod.instance.destroy)) {

                } else {
                    throw 'Module "' + moduleID + '" does not have "destroy" function';
                }
            }
        },

        // Khởi động tất cả module đang có trong
        start_all: function () {
            var moduleID;
            for (moduleID in moduleData) {
                if (moduleData.hasOwnProperty(moduleID)) {
                    this.start(moduleID);
                }
            }
        },

        // tắt một module, bằng cách gọi hàm destroy của nó, 
        // sau đó xóa nó khỏi moduleData
        stop: function (moduleID) {
            var data = moduleData[moduleID];
            //this.log(data);
            if (data && data.instance) {
                data.instance.destroy();
                data.instance = null;
            } else {
                //this.log(1, "Stop Module '" + moduleID + "': FAILED : module does not exist or has not been started");
            }
        },

        // Tắt tất cả module đang có trong moduleData
        stop_all: function () {
            var moduleID;
            for (moduleID in moduleData) {
                if (moduleData.hasOwnProperty(moduleID)) {
                    this.stop(moduleID);
                }
            }
        },

        // đăng ký một sự kiện
        // hàm này được sandbox gọi khi một module đăng ký listen sự kiện
        // (listen: giống như khi bind function kiểu jQuery)
        registerEvents: function (evts, mod) {
            if (this.is_obj(evts) && mod) {
                if (moduleData[mod]) {
                    moduleData[mod].events = evts;
                } else {
                    //this.log(1, "");
                }
            } else {
                //this.log(1, "");
            }
        },

        // raise một sự kiện
        // hàm này được sandbox gọi khi một module notify một sự kiện
        // (notify: giống như hàm trigger của jQuery)
        // Để tiện debug: hàm này trả về đối tượng chứa tên của (các) module tham gia xử lý sự kiện
        triggerEvent: function (evt) {
            //this.log(evt);
            var mod,
                hasListenner = false,
                whatModule = []
            ;
            for (mod in moduleData) {
                if (moduleData.hasOwnProperty(mod)) {
                    mod = moduleData[mod];
                    if (mod.events && mod.events[evt.type]) {
                        mod.events[evt.type](evt.data);
                        hasListenner = true;
                        whatModule.push(mod);
                    }
                }
            }
            return {
                'hasListenner': hasListenner,
                'listenners': whatModule.length
            };
        },

        // Hủy đăng ký sự kiện của một module
        removeEvents: function (evts, mod) {
            if (this.is_arr(evts) && mod && (mod = moduleData[mod]) && mod.events) {
                delete mod.events[evts];
            }
        },

        // viết gọn hàm console.log của trình duyệt
        LOG: function (message, severity) {
            if (debug) {
                //console[(!severity) ? 'log' : (severity === 2) ? 'warn' : 'error']('-- Caller --: ', arguments.callee.caller);
                //console[(!severity) ? 'log' : (severity === 2) ? 'warn' : 'error']('-- msg/obj--', message);
                console.log('-- Caller --: ', arguments.callee.caller);
                console.log('-- msg/obj--', message);
            } else {
                // send to the server
            }
        },

        // viết gọn hàm console.log của trình duyệt
        log: (function () {
            var _log;
            // Nếu không debug, thì hàm LOG đặt thành hàm rỗng
            if (!debug) {
                _log = function () { };
                return _log;
            }

            // Tạo hàm log thay thế cho console.log
            if (Function.prototype.bind) {
                _log = Function.prototype.bind.call(console.log, console);
            }
            else {
                _log = function () {
                    Function.prototype.apply.call(console.log, console, arguments);
                };
            }
            return _log;
        }()),

        // một số helper
        helper: {
            // thêm số 0 vào trước một số nguyên cho đủ độ dài
            // trả về dạng string
            prefixInteger: function (num, length) {
                return (Array(length).join('0') + num).slice(-length);
            }
        },

        // đối tượng làm việc với server
        db: {
            getJSON: function (url, successCallBack, failedCallBack) {
                successCallBack(storage[url])
            },

            postJSON: function (url, data, successCallBack, failedCallBack) {
                storage[url] = data;
                successCallBack('success')
            }
        },

        // Các xử lý liên quan đến DOM element
        dom: {
            // Tìm một DOM Element
            // context: là đối tượng (jQuery) chứa DOM cần tìm 
            query: function (selector, context) {

                var ret = {}, that = this, jqEls, i = 0;
                if (context && context.find) {
                    jqEls = context.find(selector);
                } else {
                    jqEls = jQuery(selector);
                }

                ret = jqEls.get();
                ret.length = jqEls.length;
                ret.query = function (sel) {
                    return that.query(sel, jqEls);
                }
                //console.log('dom.query');
                //console.log(context);
                return ret;
            },

            // gán một sự kiện vào một dom element
            bind: function (element, evt, fn) {
                if (element && evt) {
                    // nếu chỉ truyền vào 2 tham số, (element, fn)
                    // thì mặc định gán hàm xử lý sự kiện click
                    if (typeof evt === 'function') {
                        fn = evt;
                        evt = 'click';
                    }
                    // nếu truyền đủ 3 tham số, 
                    // thì thực hiện gán đúng sự kiện truyền vào
                    jQuery(element).bind(evt, fn);
                } else {
                    // log wrong arguments
                }
            },


            unbind: function (element, evt, fn) {
                if (element && evt) {
                    if (typeof evt === 'function') {
                        fn = evt;
                        evt = 'click';
                    }
                    jQuery(element).unbind(evt, fn);
                } else {
                    // log wrong arguments
                }
            },
            create: function (el) {
                return document.createElement(el);
            },
            apply_attrs: function (el, attrs) {
                jQuery(el).attr(attrs);
            }
        },
        // Xử lý các sự kiện
        events: {
            // Forward sự kiện click của các nút cho các hàm xử lý sự kiện
            button_Clicked: function (e) {
                var
                    eventName = '',
                    currentTarget = $(e.event.currentTarget)
                ;
                e.preventDefault();
                if (!currentTarget.attr('data-asf-enable-bubbling')) {
                    e.event.stopPropagation();
                }
                if (e && e.event) {
                    eventName = $(e.event.currentTarget).attr('data-asf-event-handler');
                    if (eventName) {
                        ASOFTCORE.triggerEvent({
                            type: eventName,
                            data: e
                        });
                    }
                }
            }
        },
        utils: {
            keyUpConvertedDecimal: function (e) {
                var jqThis = $(this),
                    valueString = jqThis.val(),
                    value = kendo.parseFloat(valueString),
                    newValue,
                    myRe = /^([0-9]+|[0-9]+,){0,1}[0-9]+[.]$/g,
                    matchResult = myRe.exec(valueString);
                ;

                if (!matchResult) {
                    newValue = formatConvertedDecimal(value);
                    $(this).val(newValue).putCursorAtEnd();
                }


            },

            focusConvertedDecimal: function (e) {
                var jqThis = $(this),
                    valueString = jqThis.val(),
                    value = kendo.parseFloat(valueString),
                    newValue,
                    myRe = /^([0-9]+|[0-9]+,){0,1}[0-9]+[.]$/g,
                    matchResult = myRe.exec(valueString);
                ;

                //if (!matchResult) {
                newValue = core.utils.keyUpConvertedDecimal(value);
                //jqThis.off('focus');
                $(this).val(newValue);//.putCursorAtEnd();
                //jqThis.on('focus', core.utils.focusConvertedDecimal);
                //}


            },

            makeLogFunction: function (debug) {
                if (debug === false) {
                    return function () { };
                }
                // Tạo hàm log
                if (Function.prototype.bind) {
                    return Function.prototype.bind.call(console.log, console);
                }
                else {
                    return function () {
                        Function.prototype.apply.call(console.log, console, arguments);
                    };
                }
            },
            /// Show popup print
            waitDialog: function () {
                var that = this,
                    panelText = "Đang in hóa đơn....";
                //Show popup
                function show() { //Che màn hình khi đang trong quá trình lư dữ liệu
                    if (string) {
                        that.panelText = string;
                    }
                    var dialog = createPanel();

                    var leftPosition = (window.innerWidth / 2) - ($('.asf-save-process').width() / 2);
                    var topPosition = (window.innerHeight / 2) - (($('.asf-save-process').height() / 2) + 10);
                    $('.asf-save-process').css({ top: topPosition, left: leftPosition, display: "block" });
                    dialog.css({ display: "block" });
                };
                //hide popup
                function hide() {
                    $('.asf-overlay').css({ display: "none" });
                    $('.asf-save-process').css({ display: "none" });
                };
                //create panel
                function createPanel() {
                    if ($(".asf-overlay").length > 0) {
                        return $(".asf-overlay");
                    } else {
                        var loadingElement = $('.asf-save-process');
                        var overlay = $('<div  class="asf-overlay"></div>');
                        var loading = $('<div class="asf-save-process"></div>');

                        loading.append($('<div class="asf-save-process-img"></div>')).append($('<div class="asf-save-process-text">' + this.panelText + '</div>'));

                        var result = $('body').append(overlay).append(loading);
                        return overlay;
                    }
                };

                return {
                    show: function (string, ticks) {
                        panelText = string;
                        show();
                        if (ticks) {
                            window.setTimeout(hide, ticks);
                        }
                    },
                    hide: function (afterTicks) {
                        if (afterTicks) {
                            window.setTimeout(hide, afterTicks);
                        }
                    }
                }
            }(),
            isNumber: isNumber,
            isAlphanum: function (parm) {
                return isValid(parm, lwr + upr + numb);
            },
            isEmpty: function (val) {
                return (val === undefined || val == null || val.length <= 0) ? true : false;
            },
            isNullOrEmpty: function (val) {
                return (val === undefined || val == null || val.length <= 0) ? true : false;
            },
            isGuid: function (str) {
                return str && /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(str);

            },
            toggleCheckBox: function (checkBox) {
                if (checkBox instanceof jQuery) {
                    checkBox.attr('checked', !checkBox.attr('checked'));
                } else {
                    $(checkBox).attr('checked', !checkBox.attr('checked'));
                }
            },
            warn: function (screenID, messageID) {
                if (screenID[0] !== '#') {
                    screenID = '#' + screenID;
                }
                ASOFT.form.displayWarning(screenID, ASOFT.helper.getMessage(messageID));
                $(document).off('click').on('click', function (e) {
                    $('.asf-message').remove();
                });
            },
            error: function (screenID, messageID) {
                if (screenID[0] !== '#') {
                    screenID = '#' + screenID;
                }
                ASOFT.form.displayError(screenID, ASOFT.helper.getMessage(messageID));
                $(document).off('click').on('click', function (e) {
                    $('.asf-message').remove();
                });
            },
            info: function (screenID, messageID) {
                if (screenID[0] !== '#') {
                    screenID = '#' + screenID;
                }
                ASOFT.form.displayInfo(screenID, ASOFT.helper.getMessage(messageID));
                $(document).off('click').on('click', function (e) {
                    $('.asf-message').remove();
                });
            },

            toggleFullScreen: function () {
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
            },

            existFullScreen: function () {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                } else if (document.msExitFullscreen) {
                    document.msExitFullscreen();
                } else if (document.mozCancelFullScreen) {
                    document.mozCancelFullScreen();
                } else if (document.webkitExitFullscreen) {
                    document.webkitExitFullscreen();
                }
            },

            enterFullScreen: function () {
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
            },
            isFunc: function (func) {
                var getType = {};
                if (!func) {
                    return false;
                }
                return func && getType.toString.call(func) === '[object Function]';
            },
        },
        is_func: function (func) {
            var getType = {};
            return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
        },
        is_arr: function (arr) {
            return jQuery.isArray(arr);
        },
        is_obj: function (obj) {
            return jQuery.isPlainObject(obj);
        }
    };

    for (var attrname in CORE) { newCore[attrname] = CORE[attrname]; }
    return core;
}(ASOFTCORE || {}));

// put Cursor At End of input textbox
(function ($) {
    jQuery.fn.putCursorAtEnd = jQuery.fn.putCursorAtEnd || function () {
        return this.each(function () {
            $(this).focus()

            // If this function exists...
            if (this.setSelectionRange) {
                // ... then use it
                // (Doesn't work in IE)

                // Double the length because Opera is inconsistent about whether a carriage return is one character or two. Sigh.
                var len = $(this).val().length * 2;
                this.setSelectionRange(len, len);
            }
            else {
                // ... otherwise replace the contents with itself
                // (Doesn't work in Google Chrome)
                $(this).val($(this).val());
            }

            // Scroll to the bottom, in case we're in a tall textarea
            // (Necessary for Firefox and Google Chrome)
            this.scrollTop = 999999;
        });
    };
})(jQuery);


(function ($, len, createRange, duplicate) {
    $.fn.caret = function (options, opt2) {
        var start, end, t = this[0], browser = navigator.appName;
        var start, end, t = this[0], browser = navigator.appName;//$.browser.msie;
        if (typeof options === "object" && typeof options.start === "number" && typeof options.end === "number") {
            start = options.start;
            end = options.end;
        } else if (typeof options === "number" && typeof opt2 === "number") {
            start = options;
            end = opt2;
        } else if (typeof options === "string") {
            if ((start = t.value.indexOf(options)) > -1) end = start + options[len];
            else start = null;
        } else if (Object.prototype.toString.call(options) === "[object RegExp]") {
            var re = options.exec(t.value);
            if (re != null) {
                start = re.index;
                end = start + re[0][len];
            }
        }
        if (typeof start != "undefined") {
            if (browser) {
                var selRange = this[0].createTextRange();
                selRange.collapse(true);
                selRange.moveStart('character', start);
                selRange.moveEnd('character', end - start);
                selRange.select();
            } else {
                this[0].selectionStart = start;
                this[0].selectionEnd = end;
            }
            this[0].focus();
            return this
        } else {
            // Modification as suggested by Андрей Юткин
            if (browser) {
                var selection = document.selection;
                if (this[0].tagName.toLowerCase() != "textarea") {
                    var val = this.val(),
                    range = selection[createRange]()[duplicate]();
                    range.moveEnd("character", val[len]);
                    var s = (range.text == "" ? val[len] : val.lastIndexOf(range.text));
                    range = selection[createRange]()[duplicate]();
                    range.moveStart("character", -val[len]);
                    var e = range.text[len];
                } else {
                    var range = selection[createRange](),
                    stored_range = range[duplicate]();
                    stored_range.moveToElementText(this[0]);
                    stored_range.setEndPoint('EndToEnd', range);
                    var s = stored_range.text[len] - range.text[len],
                    e = s + range.text[len]
                }
                // End of Modification
            } else {
                var s = t.selectionStart,
					e = t.selectionEnd;
            }
            var te = t.value.substring(s, e);
            return {
                start: s, end: e, text: te, replace: function (st) {
                    return t.value.substring(0, s) + st + t.value.substring(e, t.value[len])
                }
            }
        }
    }
})(jQuery, "length", "createRange", "duplicate");

// Set caret position easily in jQuery
// Written by and Copyright of Luke Morton, 2011
// Licensed under MIT
(function ($) {
    // Behind the scenes method deals with browser
    // idiosyncrasies and such
    $.caretTo = function (el, index) {
        if (el.createTextRange) {
            var range = el.createTextRange();
            range.move("character", index);
            range.select();
        } else if (el.selectionStart != null) {
            el.focus();
            el.setSelectionRange(index, index);
        }
    };

    // The following methods are queued under fx for more
    // flexibility when combining with $.fn.delay() and
    // jQuery effects.

    // Set caret to a particular index
    $.fn.caretTo = function (index, offset) {
        return this.queue(function (next) {
            if (isNaN(index)) {
                var i = $(this).val().indexOf(index);
                if (offset === true) {
                    i += index.length;
                } else if (offset) {
                    i += offset;
                }
                $.caretTo(this, i);
            } else {
                $.caretTo(this, index);
            }
            next();
        });
    };

    // Set caret to beginning of an element
    $.fn.caretToStart = function () {
        return this.caretTo(0);
    };

    // Set caret to the end of an element
    $.fn.caretToEnd = function () {
        return this.queue(function (next) {
            $.caretTo(this, $(this).val().length);
            next();
        });
    };
}(jQuery));

$(document).ready(function () {
    function initEventNumericTextBox() {
        var
            // format số thành chuỗi dạng số thập phân
            formatGeneralDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoGeneralDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng số thập phân
            formatConvertedDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng số thập phân
            formatPercentDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng số thập phân
            formatUnitCostDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoUnitCostDecimalsFormatString;
                return kendo.toString(value, format);
            },

            // format số thành chuỗi dạng phần trăm
            formatQuantityDecimal = function (value) {
                //return value;
                var format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
                return kendo.toString(value, format);
            }

            // format số thành chuỗi dạng phần trăm
        formatOriginalDecimal = function (value) {
                //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoOriginalDecimalsFormatString;
                return kendo.toString(value, format);
            }
        ;

        var numbericInputs = $('input[data-asf-type="decimal"]'),
            generalDecimalInputs = numbericInputs.filter('[data-asf-format="general-decimal"]'),
            convertedDecimalInputs = numbericInputs.filter('[data-asf-format="converted-decimal"]'),
            percentDecimalInputs = numbericInputs.filter('[data-asf-format="percent-decimal"]'),
            quantityDecimalInputs = numbericInputs.filter('[data-asf-format="quantity-decimal"]'),
            unitCostDecimalInputs = numbericInputs.filter('[data-asf-format="unit-cost-decimal"]');
            originalDecimalInputs = numbericInputs.filter('[data-asf-format="original-decimal"]');
        numbericInputs.bind("keydown", function () {
            var jqThis = $(this),
                caret = jqThis.caret().start,
                valueString = jqThis.val().toString()
            ;
            //LOG("keydown keypress: Current position: " + caret);
            jqThis.attr('data-asf-caret', caret);
            jqThis.attr('data-asf-prev-val', valueString);

        });

        numbericInputs.bind("keyup", function (e) {
            return;
            var jqThis = $(this),
                caret = jqThis.attr('data-asf-caret'),
                valueString = jqThis.val().toString(),
                prevValue = jqThis.attr('data-asf-prev-val')

            ;
            LOG(caret);

            if (prevValue !== valueString) {

                // Kiểm tra keycode
                switch (e.keyCode) {
                    case 13: //_log('enter'); 

                        break;
                    case 32: //_log('space'); 

                        break;
                        //case 8: //_log('backspace');
                        //    //break;
                    case 106: //_log('multiply');
                        break;
                    case 106:// _log('delete');
                        break;
                    case 27: //_log('esc');

                        break;

                    case 37: //_log('37 left');
                        //leftKey_Pressed(e);
                        break;

                    case 38: //_log('38 up');
                        upKey_Pressed(e);
                        break;

                    case 39: //_log('39 right');
                        break;

                    case 40: //_log('40 down');
                        downKey_Pressed(e);
                        break;

                    default: //_log('other key');                

                        break;
                }

                setTimeout(function (_caret, _jqThis) {
                    return function () {
                        _jqThis.caretTo(_caret);
                    }
                }(caret, jqThis), 30);
            }

        });
        //setTimeout(function () {
        //    $('#PercentDecimalProperty').caretTo(10);
        //}, 3000);


        generalDecimalInputs.keyup(function (e) {
            var
                jqThis = $(this),
                valueString = jqThis.val().toString().replace(/ /g, ''),
                value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatGeneralDecimal(value);
            jqThis.val(value);
        });

        convertedDecimalInputs.keyup(function (e) {
            var
                jqThis = $(this),
                valueString = jqThis.val().toString().replace(/ /g, ''),
                value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatConvertedDecimal(value);
            jqThis.val(value);
        });

        percentDecimalInputs.keyup(function (e) {
            var
                   jqThis = $(this),
                   valueString = jqThis.val().toString().replace(/ /g, ''),
                   value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatPercentDecimal(value);
            jqThis.val(value);
        });

        quantityDecimalInputs.keyup(function (e) {
            var
                   jqThis = $(this),
                   valueString = jqThis.val().toString().replace(/ /g, ''),
                   value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatQuantityDecimal(value);
            jqThis.val(value);
        });



        unitCostDecimalInputs.keyup(function (e) {
            var
                   jqThis = $(this),
                   valueString = jqThis.val().toString().replace(/ /g, ''),
                   value = kendo.parseFloat(jqThis.val());

            if (e.which === 110) {
                if ((valueString.split(".").length - 1) === 1) {
                    return;
                }
            }

            value = formatUnitCostDecimal(value);
            jqThis.val(value);
        });
    }

    initEventNumericTextBox();
});