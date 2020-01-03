/**------------------------------------------------------------
 * File Name      : BOQ.js 
 * Description    : BOQ Custom Javascript Library
 * Author         : ymjo, 2016. 07. 11.
 ------------------------------------------------------------*/
"use strict";

 /**------------------------------------------------------------
 * BOQ Global Variable
 ------------------------------------------------------------*/
var developmentType = "";
var arrParameter    = {};
var strCallUrl      = "";
var strCallBack     = "";
var objAGApp;

/**------------------------------------------------------------
 * BOQ Global Constants
 ------------------------------------------------------------*/
var BOQ = {
	CSRFID              : "__RequestVerificationToken",
	BLOCKDIVID          : "divPageBlock",
	COMMONERRORMSG      : "Occured error.",
	AJAXERRORMSG        : "Occured error in ajax process.",
	PAGESIZE            : 10,
	COUNTRYCODE         : "US",
    MULTILANGUAGECOOKIE : "BOQ.Language"
}

/**------------------------------------------------------------
 * Request Type
 ------------------------------------------------------------*/
var REQUESTTYPE = {
    FORM : "form",
    AJAX : "ajax"
}

/**------------------------------------------------------------
 * Development Type
 ------------------------------------------------------------*/
var DEVELOPMENTTYPE = {
    JQUERY    : "jQuery",
    ANGULARJS : "angularJS"
}

/**------------------------------------------------------------
 * DEVICE Type
 ------------------------------------------------------------*/
var DEVICETYPE = {
    BROWSER  : "browser",
    MOBILEAPP: "mobileApp"
}


/**------------------------------------------------------------
 * BOQ.Ajax
 ------------------------------------------------------------*/
BOQ.Ajax = {
    jQuery : {
        /**------------------------------------------------------------
         * Function Name  : fnJQRequest
         * Author         : ymjo, 2016. 07. 11.
         * Modify History : Just Created.
         ------------------------------------------------------------*/
        fnRequest: function(requestType, requestData, strCallUrl, strCallBack, isaSync, blockBtnID) {
            var intErrCnt = 0;

            $.ajax({
                cache: false,
                async: (typeof (isaSync) == "undefined" ? true : BOQ.Utils.fnGetBoolean(isaSync)),
                type: "POST",
                data: (requestType == REQUESTTYPE.JSON ? JSON.stringify(requestData) : requestData),
                url: strCallUrl,
                dataType: "JSON",
                contentType: (requestType == REQUESTTYPE.JSON ? "application/json; charset=utf-8" : "application/x-www-form-urlencoded"),
                headers: { "__RequestVerificationToken": BOQ.Security.getVerificationToken() },
                beforeSend: function () {
                    if (arrParameter.ISLOADING == undefined) {
                        BOQ.Ajax.fnAjaxBlock(blockBtnID);
                    }
                },
                complete: function () {
                    if (arrParameter.ISLOADING == undefined) {
                        BOQ.Ajax.fnAjaxUnBlock(blockBtnID);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    intErrCnt++;

                    if (intErrCnt == 3 && XMLHttpRequest.readyState == 4 && textStatus == "parsererror") {
                        alert(BOQ.COMMONERRORMSG);
                    } else if (intErrCnt == 3 && XMLHttpRequest.readyState == 0 && textStatus == "error") {
                        alert(BOQ.COMMONERRORMSG);
                    }
                }
            }).retry({ times: 1, timeout: 1000 }).then(function(objJson) {
                try {
                    if (typeof (objJson) === "object") {
                        eval(strCallBack)(BOQ.Utils.fnNullRepalce(objJson));
                    } else if (typeof (objJson) === "string") {
                        eval(strCallBack)(BOQ.Utils.fnNullRepalce(jQuery.parseJSON(objJson)));
                    } else {
                        if (intErrCnt == 3) {
                            alert(BOQ.COMMONERRORMSG);
                        }
                    }
                } catch (ex) {
                    alert(ex.message);
                }
            });
        },

        /**------------------------------------------------------------
         * Function Name  : fnJQRequest for infinite scroll
         * Author         : ysjee, 2018. 09. 06.
         * Modify History : Just Created.
         ------------------------------------------------------------*/
        fnScrollListRequest: function (requestType, requestData, strCallUrl, strCallBack, isaSync, blockBtnID) {
            var intErrCnt = 0;

            $.ajax({
                cache: false,
                async: (typeof (isaSync) == "undefined" ? true : BOQ.Utils.fnGetBoolean(isaSync)),
                type: "POST",
                data: (requestType == REQUESTTYPE.JSON ? JSON.stringify(requestData) : requestData),
                url: strCallUrl,
                dataType: "JSON",
                contentType: (requestType == REQUESTTYPE.JSON ? "application/json; charset=utf-8" : "application/x-www-form-urlencoded"),
                headers: { "__RequestVerificationToken": BOQ.Security.getVerificationToken() },
                beforeSend: function () {
                    if (arrParameter.ISLOADING == undefined) {
                        BOQ.Ajax.fnAjaxBlock(blockBtnID);
                    }
                },
                complete: function () {
                    if (arrParameter.ISLOADING == undefined) {
                        BOQ.Ajax.fnAjaxUnBlock(blockBtnID);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    intErrCnt++;

                    if (intErrCnt == 3 && XMLHttpRequest.readyState == 4 && textStatus == "parsererror") {
                        BOQ.Utils.fnMinusPageNo();
                        alert(BOQ.COMMONERRORMSG);
                    } else if (intErrCnt == 3 && XMLHttpRequest.readyState == 0 && textStatus == "error") {
                        BOQ.Utils.fnMinusPageNo();
                        alert(BOQ.COMMONERRORMSG);
                    }
                }
            }).retry({ times: 1, timeout: 1000 }).then(function(objJson) {
                try {
                    if (typeof (objJson) === "object") {
                        eval(strCallBack)(BOQ.Utils.fnNullRepalce(objJson));
                        BOQ.Utils.fnSetMaxPageNo(objJson.intRowCnt);
                    } else if (typeof (objJson) === "string") {
                        eval(strCallBack)(BOQ.Utils.fnNullRepalce(jQuery.parseJSON(objJson)));
                        BOQ.Utils.fnSetMaxPageNo(BOQ.Utils.fnNullRepalce(jQuery.parseJSON(objJson)).intRowCnt);
                    } else {
                        if (intErrCnt == 3) {
                            BOQ.Utils.fnMinusPageNo();
                            alert(BOQ.COMMONERRORMSG);
                        }
                    }
                } catch (ex) {
                    BOQ.Utils.fnMinusPageNo();
                    alert(ex.message);
                }
            });
        }

    },

	/**------------------------------------------------------------
	 * Function Name  : fnAjaxBlock
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnAjaxBlock: function (blockBtnID) {
        try {
            if (blockBtnID != undefined) {
                $("#" + blockBtnID).prop("disabled", true);
            }
	        $.blockUI({
	            message: $("#" + BOQ.BLOCKDIVID),
	            css: {
	                top: '50%',
	                left: '50%',
	                padding: 0,
	                margin: 0,
	                width: '24px',
	                height: '24px',
	                border: 'none',
	                backgroundColor: 'transparent',
	                '-webkit-border-radius': '10px',
	                '-moz-border-radius': '10px',
	                opacity: 1,
	                color: '#000',
	                'z-index': 9999
	            }, overlayCSS: {
	                backgroundColor: '#FFFFFF',
	                opacity: 0.6,
	                cursor: 'wait'
	            }
	        });
	    } catch (ex) { }
    },

    /**------------------------------------------------------------
 * Function Name  : fnAjaxUnBlock
 * Author         : ysjee, 2019. 08. 21.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
    fnAjaxUnBlock: function (blockBtnID) {
        if (blockBtnID != undefined) {
            $("#" + blockBtnID).prop("disabled", false);
            $.unblockUI();
        }
    }
}
	
/**------------------------------------------------------------
 * BOQ.Utils
 ------------------------------------------------------------*/
BOQ.Utils = {
    //**********************************************************
    // Author        : tumyeong@payletter.com, 2019-09-18
    // Function name : fnIsNumber
    // Purpose       : 숫자 여부 반환
    // Modified by   : Just Created
    //**********************************************************
    fnIsNumber: function (number) {
        var strRegx = /^\d+$/;
        
        return strRegx.test(number);
    },
    //**********************************************************
    // Author        : ysjee@payletter.com, 2018-08-27
    // Function name : fnNullRepalce
    // Purpose       : Json의 null 값을 빈값으로 변환
    // Modified by   : Just Created
    //**********************************************************
    fnNullRepalce: function (JsonData) {
        for (var key in JsonData) {
            if (JsonData[key] === null || JsonData[key] === undefined) {
                JsonData[key] = "";
                continue;
            }
            if (typeof JsonData[key] === "object") {
                JsonData[key] = BOQ.Utils.fnNullRepalce(JsonData[key]);
            }
        }
        return JsonData;
    },
    //**********************************************************
    // Author        : ejlee@payletter.com, 2018-11-15
    // Function name : fnAddZero
    // Purpose       : 길이 만큼 문자열 앞에 "0"을 붙인다.
    // Modified by   : Just Created
    //**********************************************************
    fnAddZero: function (str, len) {
        if (str.length < len) {
            str = "0" + str;
            str = BOQ.Utils.fnAddZero(str, len);
        }
        return str;
    },
    //**********************************************************
    // Author        : shshin@payletter.com, 2017-06-05
    // Function name : fnAddComma
    // Purpose       : 1000원 단위 구분기호(,) 추가
    // Modified by   : Just Created
    //**********************************************************
    fnAddComma : function(amt)
    {
        //<%-- 정규식 --%> 
            var reg = /(^[+-]?\d+)(\d{3})/;
        //<%-- 숫자를 문자열로 변환 --%> 
        amt += '';                     

        while (reg.test(amt)) {
            amt = amt.replace(reg, '$1' + ',' + '$2');
        }

        return amt;
    },
	/**------------------------------------------------------------
	 * Function Name  : fnGetBoolean
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnGetBoolean : function(val) {
		var strRegx = /^(?:f(?:alse)?|no?|0+)$/i;

		return !strRegx.test(val) && !!val;
	},
	
	/**------------------------------------------------------------
	 * Function Name  : fnFrmCreate
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnFrmCreate: function(frmName, strMethod, strAction, strTarget) {
	    var objFrm = document.createElement("form");

	    objFrm.name   = frmName;
	    objFrm.method = strMethod;
	    objFrm.action = strAction;
	    objFrm.target = strTarget ? strTarget : "";

	    return objFrm;
    },
    
	/**------------------------------------------------------------
	 * Function Name  : fnFrmInputCreate
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnFrmInputCreate: function(objFrm, strName, strValue) {
        var objInput = document.createElement("input");

        objInput.type  = "hidden";
        objInput.name  = strName;
        objInput.value = strValue;
        
        objFrm.insertBefore(objInput, null);
        
        return objFrm;
	},

    /**------------------------------------------------------------
     * Function Name  : fnGetPageNo (호출시 자동증가)
     * Author         : ysjee, 2018. 09. 06.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
	fnGetPageNo: function () {
	    var PageNo;
	    var strName = "pageNo";
	    if (document.getElementsByName(strName)[0] === undefined) {
            // 해당 페이지 번호가 정의되있지 않은 경우 태그생성.
	        BOQ.Utils.fnFrmInputCreate(document.getElementsByTagName("form")[0], strName, 1);
	    }
	    PageNo = document.getElementsByName(strName)[0].value;
	    PageNo = parseInt(PageNo);
	    document.getElementsByName(strName)[0].value = PageNo + 1;

	    return PageNo;
	},

    /**------------------------------------------------------------
     * Function Name  : fnGetPageSizeForScroll
     * Author         : ysjee, 2018. 09. 06.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
	fnGetPageSizeForScroll: function () {
	    return BOQ.Utils.fnGetPageNo() * BOQ.PAGESIZE;
	},

    /**------------------------------------------------------------
     * Function Name  : fnMinusPageNo(Ajax 실패시 pageno 원복)
     * Author         : ysjee, 2018. 09. 06.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
	fnMinusPageNo: function () {
	    var PageNo;
	    var strName = "pageNo";
	    if (document.getElementsByName(strName) === undefined) {
	        // 해당 페이지 번호가 정의되있지 않은 경우 아무동작없음.
	        return;
	    }
	    PageNo = document.getElementsByName(strName)[0].value;
	    PageNo = parseInt(PageNo);
	    document.getElementsByName(strName)[0].value = PageNo - 1;
	},

    /**------------------------------------------------------------
     * Function Name  : fnSetMaxPageNo(마지막 페이지번호 저장)
     * Author         : ysjee, 2018. 09. 06.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
	fnSetMaxPageNo: function (listCnt) {
	    var MaxNo;
	    var TagName = "pageMaxNo";

	    if (listCnt % BOQ.PAGESIZE != 0) {
	        MaxNo = parseInt(listCnt / BOQ.PAGESIZE) + 1;
	    }
	    else {
	        MaxNo = parseInt(listCnt / BOQ.PAGESIZE);
	    }

	    if (document.getElementsByName(TagName)[0] === undefined) {
	        // 해당 페이지 번호의 마지막 번호가 정의되있지 않은 경우 태그생성.
	        BOQ.Utils.fnFrmInputCreate(document.getElementsByTagName("form")[0], TagName, MaxNo);
	    }
	    else {
	        document.getElementsByName(TagName)[0].value = MaxNo;
	    }
	},

    /**------------------------------------------------------------
     * Function Name  : fnIsMaxPageNo(현재 페이지번호가 마지막 번호인지 체크)
     * Author         : ysjee, 2018. 09. 06.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
	fnIsMaxPageNo: function () {
	    var TagName = "pageMaxNo";
	    var strName = "pageNo";

	    if (document.getElementsByName(strName)[0] === undefined || document.getElementsByName(TagName)[0] === undefined) {
	        return false;
	    }

        // 호출시 번호가 증가 하기때문에 -1값과 비교.
	    return parseInt(document.getElementsByName(strName)[0].value) - 1 >= parseInt(document.getElementsByName(TagName)[0].value);
	},

    /**------------------------------------------------------------
     * Function Name  : fnResetPageNo(페이지 번호 리셋)
     * Author         : ysjee, 2018. 09. 06.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
	fnResetPageNo: function () {
	    var strName = "pageNo";
	    if (document.getElementsByName(strName)[0] !== undefined) {
	        // 해당 페이지 번호의 마지막 번호가 정의되있지 않은 경우 태그생성.
	        document.getElementsByName(strName)[0].value = 1;
	    }
	},

    /**------------------------------------------------------------
	 * Function Name  : fnAddDigit
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnAddDigit: function (strValue) {
	    var strRetValue = "";
	    strRetValue += strValue;

	    var pattern = /(-?[0-9]+)([0-9]{3})/;

	    while (pattern.test(strRetValue)) {
	        strRetValue = strRetValue.replace(pattern, "$1,$2");
	    }

	    return strRetValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnCreateMap
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnCreateMap: function() {

	    var Map = function () {
	        this.map = new Object();
	    }

	    Map.prototype = {
	        put: function (key, value) {
	            return this.map[key] = value;
	        },
	        get: function (key) {
	            return this.map[key];
	        },
	        containsKey: function (key) {
	            return key in this.map;
	        },
	        containsValue: function (value) {
	            for (var key in this.map) {
	                if (this.map[key] == value) {
	                    return true;
	                }
	            }
	            return false;
	        },
	        isEmpty: function (key) {
	            return (this.size() == 0);
	        },
	        clear: function () {
	            for (var key in this.map) {
	                delete this.map[key];
	            }
	        },
	        remove: function (key) {
	            delete this.map[key];
	        },
	        keys: function () {
	            return Object.keys(this.map);
	        },
	        values: function () {
	            var array = new Array();
	            for (var key in this.map) {
	                values.push(this.map[key]);
	            }
	            return array;
	        },
	        size: function () {
	            return Object.keys(this.map).length;
	        },
	        sortKeys: function () {
	            var count = 0;
	            var array = new Array();
	            for (var key in this.map) {
	                array[count] = key;
	                count++;
	            }

	            return array.sort();
	        },
	        sortValues: function () {

	            var count = 0;
	            var array = new Array();
	            for (var key in this.map) {
	                array[count] = this.map[key];
	                count++;
	            }

	            return array.sort();
	        },
	        reverse: function () {

	            var array = new Array();
	            for (var key in this.map) {
	                array.push({ key: key, value: this.map[key] });
	                delete this.map[key];
	            }

	            for (var i = array.length; i--;) {
	                this.map[array[i].key] = array[i].value;
	            }
	        },
	        mapToArray: function () {
	            var array = new Array();
	            for (var key in this.map) {
	                array.push({ key: key, value: this.map[key] });
	            }

	            return array;
	        }
	    }

	    return new Map();
	}
}

/**------------------------------------------------------------
 * BOQ.Cookie
 ------------------------------------------------------------*/
BOQ.Cookie = {
    /**------------------------------------------------------------
	 * Function Name  : fnSetCookie
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnSetCookie: function (strCookieName, strValue, exdays) {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + exdays);
        var strCookieValue = escape(strValue) + ((exdays==null) ? "" : "; expires=" + exdate.toUTCString());
        document.cookie = strCookieName + "=" + strCookieValue;
    },

    /**------------------------------------------------------------
	 * Function Name  : fnGetCookie
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : tumyeong, 2019.09.03, 쿠키값에 =붙어나오는 부분 수정
	 ------------------------------------------------------------*/
    fnGetCookie: function (strCookieName) {
        strCookieName = strCookieName + '=';
        var strCa = document.cookie.split(';');
        for (var i = 0; i < strCa.length; i++) {
            var c = strCa[i];
            while (c.charAt(0) == ' ') c = c.substring(1);
            if (c.indexOf(strCookieName) == 0) {
                return c.substring(strCookieName.length, c.length);
            }
        }

        return "";
    },

    /**------------------------------------------------------------
	 * Function Name  : fnDeleteCookie
	 * Description    : -
	 * Author         : tumyeong, 2019. 09. 03.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnDeleteCookie: function (strCookieName) {
        var expireDate = new Date();
        expireDate.setDate(expireDate.getDate() - 1);
        document.cookie = strCookieName + "= " + "; expires=" + expireDate.toUTCString();
    }
}

/**------------------------------------------------------------
 * BOQ.Msg
 ------------------------------------------------------------*/
BOQ.Msg = {
    /**------------------------------------------------------------
	 * Function Name  : fnAlert
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/    
    fnAlert: function(strMsg) {
        alert(strMsg);
    },

    /********************************************************************************************
    * Front MessageDic
    ********************************************************************************************/
    fnMultiLanguage: function (strMsgCode) {
        var strCountryCode   = "";
        var strReturnMessage = "";
        
        try {
            strCountryCode = BOQ.Cookie.fnGetCookie(BOQ.MULTILANGUAGECOOKIE);

            if (strCountryCode == "") {
                strReturnMessage = MessageData[BOQ.COUNTRYCODE][strMsgCode];
            } else {
                strReturnMessage = MessageData[strCountryCode][strMsgCode];
            }
        } catch (ex) {
            strReturnMessage = "";
        }
        
        return strReturnMessage;
    }
}

/**------------------------------------------------------------
 * BOQ.AntiCSRF
 ------------------------------------------------------------*/
BOQ.Security = {
	/**------------------------------------------------------------
	 * Function Name  : getVerificationToken
	 * Author         : ymjo, 2016. 07. 11.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	getVerificationToken: function() {
	    var strCSRFValue = "";

	    strCSRFValue = $("input[name='" + BOQ.CSRFID + "']").val()

	    return strCSRFValue;
	}
}
