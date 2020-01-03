/**------------------------------------------------------------
 * File Name      : Calendar.js 
 * Description    : Calendar Javascript Library
 ------------------------------------------------------------*/
(function ($) {
	/* "YYYY-MM[-DD]" => Date */
	function strToDate(str) {
		try {
			var array = str.split('-');
			var year = parseInt(array[0]);
			var month = parseInt(array[1]);
			var day = array.length > 2? parseInt(array[2]): 1 ;
			if (year > 0 && month >= 0) {
				return new Date(year, month - 1, day);
			} else {
				return null;
			}
		} catch (err) {}; // just throw any illegal format
	};

	/* "MM월 YYYY" => Date */
	function strToDate2(str) {
		try {
			var array = str.split(' ');
			var year = parseInt(array[1]);
			var month = parseInt(array[0].replace(/[^0-9]/g,""));
			var day = array.length > 2? parseInt(array[2]): 1 ;
			if (year > 0 && month >= 0) {
				return new Date(year, month - 1, day);
			} else {
				return null;
			}
		} catch (err) {}; // just throw any illegal format
	};

	/* Date => "YYYY-MM-DD" */
	function dateToStr(d) {
		/* fix month zero base */
		var year = d.getFullYear();
		var month = d.getMonth();
		return year + "-" + (month + 1) + "-" + d.getDate();
	};

	/* YYYY-MM-DD => "YY.MM.DD" */
	function strToStr(d) {
        var arr     = d.split('-');
		var year    = arr[0].toString().substr(2,2);
		var month   = (arr[1].length == 1 ? "0" : "") + arr[1];
        var day     = (arr[2].length == 1 ? "0" : "") + arr[2];
		return year + "." + month + "." + day;
	};

	$.fn.calendar = function (options, calendarID, calendarType, callBackFunc, selectedType) {
		var _this = this;
		var opts = $.extend({}, $.fn.calendar.defaults, options);
        var calendarID = calendarID;
        var calendarType = calendarType;        // 1 : 상품 유효기간 선택 시

		_this.init = function () {
			var tpl = 
            "    <div class='layer_cont layer_calendar'>" + 
            "      <div class='tit_calendar'>" + 
            "        <strong class='month'></strong>" + 
            "        <a href='javascript:;' class='btn_prev_y' title='이전 연도'>이전 연도</a>" + 
            "        <a href='javascript:;' class='btn_prev_m' title='이전 달'>이전 달</a>" + 
            "        <a href='javascript:;' class='btn_next_y' title='다음 연도'>다음 연도</a>" + 
            "        <a href='javascript:;' class='btn_next_m' title='다음 달'>다음 달</a>" + 
            "      </div>" + 
            "      <table>" + 
            "        <colgroup>" + 
            "          <col class='col01'>" + 
            "          <col class='col02'>" + 
            "          <col class='col03'>" + 
            "          <col class='col04'>" + 
            "          <col class='col05'>" + 
            "          <col class='col06'>" + 
            "          <col class='col07'>" + 
            "        </colgroup>" + 
            "        <thead>" + 
            "        <tr>" + 
            "          <th>일</th>" + 
            "          <th>월</th>" + 
            "          <th>화</th>" + 
            "          <th>수</th>" + 
            "          <th>목</th>" + 
            "          <th>금</th>" + 
            "          <th>토</th>" + 
            "        </tr>" + 
            "        </thead>" + 
            "        <tbody>" + 
            "        </tbody>" + 
            "      </table>" + 
            "    </div>";
			_this.html(tpl);
		};

		function daysInMonth(d) {
			var newDate = new Date(d);
			newDate.setMonth(newDate.getMonth() + 1);
			newDate.setDate(0);
			return newDate.getDate();
		}

		_this.update = function (date) {
			var mDate = new Date(date);
			mDate.setDate(1); /* start of the month */

			/* set month head */
			var monthStr = (mDate.getMonth()+1) + "월 " + mDate.getFullYear();
			_this.find('.month').text(monthStr)

			var day = mDate.getDay(); /* value 0~6: 0 -- Sunday, 6 -- Saturday */
			mDate.setDate(mDate.getDate() - day) /* now mDate is the start day of the table */

			function dateToTag(d) {
				var tag = $('<td></td>');
				tag.text(d.getDate());
				tag.data('date', dateToStr(d));
				if (date.getMonth() != d.getMonth()) { // the bounday month
					tag.addClass('gray');
				} else if (_this.data('date') == tag.data('date')) { // the select day
					_this.data('date', dateToStr(d));
				}
				return tag;
			};

			var tBody = _this.find('tbody');
			tBody.empty(); /* clear previous first */
			var cols = Math.ceil((day + daysInMonth(date))/7);
			for (var i = 0; i < cols; i++) {
				var tr = $('<tr></tr>');
				for (var j = 0; j < 7; j++, mDate.setDate(mDate.getDate() + 1)) {
					tr.append(dateToTag(mDate));
				}
				tBody.append(tr);
			}
            
		    /* event binding */
            setclickEvent();
		};

		_this.getCurrentDate = function () {
			return _this.data('date');
		}

		_this.init();
		/* in date picker mode, and input date is empty,
		 * should not update 'data-date' field (no selected).
		 */
		var initDate = opts.date? opts.date: new Date();
		if (opts.date || !opts.picker) {
			_this.data('date', dateToStr(initDate));
		}
		_this.update(initDate);

		/* event binding */

		function updateTable(monthOffset) {
			var date = strToDate2(_this.find('.month').text());
			date.setMonth(date.getMonth() + monthOffset);
			_this.update(date);
		};

		_this.find('.btn_next_m').click(function () {
			updateTable(1);
		});

		_this.find('.btn_prev_m').click(function () {
			updateTable(-1);
		});

		_this.find('.btn_next_y').click(function () {
			updateTable(12);

		});

		_this.find('.btn_prev_y').click(function () {
			updateTable(-12);
		});

        function setclickEvent() {
		    _this.off().find('tbody td').click(function () {
			    var $this = $(this);
			    _this.data('date', $this.data('date'));
			    /* if the 'gray' tag become selected, switch to that month */
			    if ($this.hasClass('gray')) {
				    _this.update(strToDate(_this.data('date')));
			    }
                else {
                    if(calendarType && calendarType == 1) {
                        var now     = new Date();
                        var year    = now.getFullYear();
                        var month   = now.getMonth();    //1월이 0으로 되기때문에 +1을 함.
                        var date    = now.getDate();
                        now = new Date(year, month, date);

                        if(strToDate(_this.data('date')).getTime() < now.getTime()) {
                            alert("오늘 이후의 날짜만 선택 하실 수 있습니다.");
                            return this;
                        }
                    }
                    if (selectedType == undefined || !$.isFunction(selectedType)) {
                        selectedType = strToStr;
                    }

                    // 클릭 값 세팅
                    $("#" + calendarID).data('date', _this.data('date'));
                    // 해당 태그가 INPUT 이면 value에 할당
                    if ($("#" + calendarID).prop("tagName") == "INPUT") {
                        $("#" + calendarID).val(selectedType(_this.data('date')));
                    }
                    // 아닌 경우 text에 할당.
                    else {
                        $("#" + calendarID).text(selectedType(_this.data('date')));
                    }
                    $(".layer_wrap").removeClass("layer_on");

			        if (callBackFunc != undefined && $.isFunction(callBackFunc)) {
			            callBackFunc();
			        }
			    }
		    });
        }

		return this;
	};

	$.fn.calendar.defaults = {
		date: new Date(),
		picker: false,
	};
    
	$(window).load(function () {
	});
}($));