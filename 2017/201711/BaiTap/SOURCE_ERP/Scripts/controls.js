//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     31/12/2013      Đức Quý         Tạo mới
//####################################################################
/// <reference path='../_references.js' />

//=============================================================================
// Button
//=============================================================================
// Constructor
var ASOFTButton = function(name, enabled, vsibility) {
    this.name = name;
    this.id = name;
    this.selector = $('#' + this.id);
    this.enabled = enabled;
    this.vsibility = vsibility;
    this.SetEnabled(this.enabled);
    this.SetVisibility(this.vsibility);
};

//Khai báo prototype
ASOFTButton.prototype = {
    id: '',
    name: '',
    enabled: true,
    vsibility: true,
    selector: '',
    setEnabled: function(enabled) { //Disabled/Enabled cho button
        if (enabled) {
            $("#" + this.id).removeClass('asf-disabled-button');
            //$("#" + this.id).addClass('asf-button');
            //$("#" + this.id).bind('click', AsoftButton.Click);
            ASOFTButton.bindEvent('click', this.selector);
        } else {
            //$("#" + this.id).removeClass('asf-button');
            $("#" + this.id).addClass('asf-disabled-button');
            //AsoftButton.UnBindEvent('hover', this.selector);
            ASOFTButton.unBindEvent('click', this.selector);
        }
    },

    setVisibility: function(vsibility) {
        if (vsibility)
            this.selector.removeClass('asf-disabled-visibility');
        else
            this.selector.addClass('asf-disabled-visibility');
    }
};

//Bẫy sự kiện
ASOFTButton.BindEvent = function(typeEvent, selector, handler) {
    //var events = $._data(document.getElementById('btnExecl'), "events");
    //if (events === null) {
    if (typeof handler === 'undefined')
        selector.bind(typeEvent, ASOFTButton.Click);
    else
        selector.bind(typeEvent, handler);
    //}
};

//Tắt sự kiện
ASOFTButton.unBindEvent = function(typeEvent, selector) {
    selector.off(typeEvent);
};

//Kích hoạt sự kiênj
ASOFTButton.click = function() {
    //$('#' + this.id).on("click", AsoftButton.EVENT_CLICK);
    //$('#' + this.id).on('click', AsoftButton.EVENT_CLICK);
    $('#' + this.id).trigger(ASOFTButton.EVENT_CLICK);
};

ASOFTButton.EVENT_CLICK = 'buttonClick';

//=============================================================================
// Textbox
//=============================================================================
// Constructor
var ASOFTTextBox = function(name, enabled, readOnly, required) {
    this.name = name;
    //    var count = 0;
    //    var inputs = $.find('input[type="text"]');
    //    for (var i = 0; i < inputs.length; i++) {
    //        if (inputs[i].id == this.name) {
    //            count++;
    //        }
    //    }
    this.id = name;
    this.selector = $('#' + this.id);

    if (typeof enabled !== 'undefined') { //Set Enabled/Disabled nếu được xét
        this.enabled = enabled;
        this.SetEnabled(this.enabled);
    }

    if (typeof readOnly !== 'undefined') { //Set ReadOnly nếu được xét
        this.readOnly = readOnly;
        this.ReadOnly(this.readOnly);
    }

    if (typeof required !== 'undefined') { //Set required nếu được xét
        this.required = required;
        this.SetRequired(this.required);
    }

    ASOFTTextBox.bindEvent('change', this.selector, ASOFTTextBox.textChanged);
};

//Khai báo prototype
ASOFTTextBox.prototype = {
    id: '',
    name: '',
    value: '',
    required: false,
    enabled: true,
    readOnly: false,
    selector: '',

    setEnabled: function(enabled) { //Disabled/Enabled cho textbox
        if (enabled)
            this.selector.removeAttr('disabled');
        else
            this.selector.attr('disabled', 'disabled');
    },

    setReadOnly: function(readOnly) {
        if (readOnly)
            this.selector.attr('readonly', 'readonly');
        else
            this.selector.removeAttr('readonly');
    },

    setValue: function(value) {
        this.selector.val(value);
    },

    getValue: function() {
        return this.selector.val();
    },

    setRequired: function(required) {
        if (required)
            this.selector.attr('FieldRequired', 'required');
        else
            this.selector.removeAttr('FieldRequired');
    },

    setMaxLength: function(maxLength) {
        this.selector.attr('maxLength', maxLength);
    }
};

//Bẫy sự kiện
ASOFTTextBox.bindEvent = function(typeEvent, selector, handler) {
    selector.bind(typeEvent, handler);
};
//Tắt sự kiện
ASOFTTextBox.unBindEvent = function(typeEvent, selector) {
    selector.off(typeEvent);
};

//Sự kiện thay đổi giá trị của textbox
ASOFTTextBox.textChanged = function(e) {
    var valueTextbox = e.target.value;
    var data = { TextboxValue: valueTextbox };
    $('#' + this.id).trigger(ASOFTTextBox.EVENT_TEXT_CHANGE, data);
};

ASOFTTextBox.onFocus = function (e) {
    $(e).bind('keypress', ASOFTTextBox.escapeSpecialCharacter);
}

//Chặng các kí tự đặc biệt
ASOFTTextBox.escapeSpecialCharacter = function (e) {
    var regExp = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|.<>\/?]*$/;
    var keyCodes = /(8)|(13)|(16)|(17)|(18)/; //Các phím chức năng được sử dụng
    var upperCase = new RegExp('[A-Z]');
    var lowerCase = new RegExp('^[a-z]');
    var numbers = new RegExp('^[0-9]');
    var keyValue = String.fromCharCode(e.charCode); //e.charCode != 0 ? String.fromCharCode(e.charCode) : e.keyCode;

    if (!regExp.test(keyValue) && e.keyCode != 13 && e.keyCode != 8) {
        if (e.preventDefault) e.preventDefault();
        return false;

    }

    return true;
};


ASOFTTextBox.EVENT_TEXT_CHANGE = "eventTextChanged";
//=============================================================================
// TextArea
//=============================================================================
// Constructor
var ASOFTTextArea = function(name, maxlength, enabled, readOnly) {
    this.name = name;

    this.id = name;
    this.maxLength = maxlength;
    this.selector = $('#' + this.id);

    if (maxlength !== 0) { //Xét maxLength nếu có
        this.maxLength(this.selector, maxlength);
    }

    this.readOnly(readOnly);
    this.setEnabled(enabled);
};

//Khai báo prototype
ASOFTTextArea.prototype = {
    id: '',
    name: '',
    value: '',
    maxLength: 0,
    enabled: true,
    readOnly: false,
    selector: '',

    setEnabled: function(enabled) { //Disabled/Enabled cho textarea
        if (enabled)
            this.selector.removeAttr('disabled');
        else
            this.selector.attr('disabled', 'disabled');
    },

    setReadOnly: function(readOnly) {
        if (readOnly)
            this.selector.attr('readonly', 'readonly');
        else
            this.selector.removeAttr('readonly');
    },

    setText: function(value) {
        this.selector.text(value);
    },

    getText: function() {
        return this.selector.text();
    },

    setMaxLength: function(selector, maxLength) { //Giới hạn kí tự của textarea

        selector.unbind('keypress').bind('keypress', function(e) {
            ASOFTTextArea.checkKeyCode(selector, maxLength, e);
        });

        selector.unbind('keyup').bind('keyup', function() { //Hiển thị text với max length
            if (selector.val().length > maxLength) {
                ASOFTTextArea.subStringControl(selector, 0, maxLength); //textArea.val().substring(0, maxLength);
            }
        });
    }
};

//Lấy chuỗi kí tự theo maxLength
ASOFTTextArea.subStringControl = function(selector, index, maxLength) {
    var trimmedtext = selector.val().substring(0, maxLength);
    selector.val(trimmedtext);
};

//Chặng ko cho nhập trên bàn phím
ASOFTTextArea.checkKeyCode = function(selector, maxLength, event) {
    var uncheckedkeycodes = /(8)|(13)|(16)|(17)|(18)/; //Các phím chức năng được sử dụng
    var keyunicode = event.charCode || event.keyCode;

    if (!uncheckedkeycodes.test(keyunicode)) {
        if (selector.val().length >= maxLength) { //Không cho nhập nếu vượt quá maxLength
            if (event.preventDefault) event.preventDefault();
            return false;
        }
    }
    return true;
};

//Bẫy sự kiện
ASOFTTextArea.bindEvent = function (typeEvent, selector, handler) {
    selector.bind(typeEvent, handler);
};

//Tắt sự kiện
ASOFTTextArea.unBindEvent = function (typeEvent, selector) {
    selector.off(typeEvent);
};

//Sự kiện thay đổi giá trị của textbox
ASOFTTextArea.textChanged = function(e) {
    var valueTextbox = e.target.value;
    var data = { TextboxValue: valueTextbox };
    $('#' + this.id).trigger(ASOFTTextArea.EVENT_TEXT_CHANGE, data);
};

ASOFTTextArea.EVENT_TEXT_CHANGE = "eventTextChanged";

/********************************MultiSelectDropdownList********************************/


/**
* Init Multi select box
*/
function initMultiSelectDropDownList(event) {
    var dropdown = event.sender;
    if (dropdown != null) {
        dropdown.ul.addClass('asf-multiselectbox');
        
        dropdown.list.find(".k-item, .check-input").bind("click", function (e) {
            var $item = $(this);
            var $input;

            if ($item.hasClass("k-item")) {
                // Text was clicked
                $input = $item.find(".check-input");
                $input.prop("checked", !$input.is(':checked'));
            }
            else
                // Checkbox was clicked
                $input = $item;

            // Check all clicked?
            if ($input.val() == "" || $input.val() == "ALL")
                dropdown.list.find(".check-input").prop("checked", $input.is(':checked'));

            updateDropDown(dropdown, false);

            e.stopImmediatePropagation();
        });
        //update Checkbox
        updateDropDown(dropdown, true);
    }
}

/**
* reset info
*/
function resetDropDown(dropdown) {
    if (dropdown != undefined) {
        dropdown.list.find(".check-input").prop("checked", false);
        updateDropDown(dropdown, true);
    }
}

/**
* Update info
*/
function updateDropDown(dropdown, first) {
    var items = [];
    var values = [];
    var id = "#" + dropdown.wrapper.context.id;
    $(id).val("");
    //var dropdown = $("#DivisionID2").data("kendoDropDownList");
    dropdown.list.find(".check-input").each(function (index) {
        var $input = $(this);
        var parent = $input.closest('li');
        var item = dropdown.dataItem(index);
        if (first) {
            if (item.Checked) {
                $input.prop("checked", true);
                if (!parent.hasClass('k-state-selected')) {
                    parent.addClass('k-state-selected');
                }
                items.push($input.next().text());
                values.push($input.val());
            } else {
                if (parent.hasClass('k-state-selected')) {
                    parent.removeClass('k-state-selected');
                }
            }
            
        } else {
            if (($input.val() != "" && $input.val() != "ALL") && $input.is(':checked')) {
                items.push($input.next().text());
                values.push($input.val());
                if (!parent.hasClass('k-state-selected')) {
                    parent.addClass('k-state-selected');
                }
            } else {
                if (parent.hasClass('k-state-selected')) {
                    parent.removeClass('k-state-selected');
                }
            }
        }
    });

    // Check the Check All if all the items are checked
    var isAllCheck = (items.length == dropdown.list.find(".check-input").length - 1);
    if (isAllCheck) {
        $(dropdown.list.find(".check-input")[0]).prop("checked", true);
        var parent = $(dropdown.list.find(".check-input")[0]).closest('li');
        if (!parent.hasClass('k-state-selected')) {
            parent.addClass('k-state-selected');
        }
    } else {
        $(dropdown.list.find(".check-input")[0]).prop("checked", false);
    }
    
    if (items.length > 0) {
        
        var label = $(id).attr('label-option');
        dropdown.text(label.format(items.length));
        $(id).val(values.toString());
    } else {
        dropdown.value(null);
        dropdown.text("");
        $(id).val("");
    }
};

function preventDefault(e) {
    e.preventDefault();
    return false;
}