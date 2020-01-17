<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POQ.aspx.cs" Inherits="POQ" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style>
        @charset 'utf-8';

/* SK Planet - Base 1.0 */
html,body,form,div,p,h1,h2,h3,h4,h5,h6,dl,dt,dd,ul,ol,li,fieldset,th,td,button,blockquote{margin:0;padding:0;border:0;font-size:100%;font:inherit;}
body{-webkit-text-size-adjust:none;}
input,textarea,select,button{font:inherit;vertical-align:middle;padding:0;}
input[type='button'],input[type='text'],input[type='image'],input[type='submit'],input[type='password'],textarea{-webkit-appearance:none;border-radius:0;}
input[type='checkbox']{-webkit-appearance:checkbox;}
input[type='radio']{-webkit-appearance:radio;}
textarea{resize:none;}
table{border-collapse:collapse;border-spacing:0;}
ol,ul{list-style:none;}
img,fieldset,iframe{border:none;}
address,cite,code,dfn,em,var,th{font-style:normal;font-weight:normal;}
a{text-decoration:none;}
article,aside,dialog,figure,footer,header,hgroup,nav,section{display:block;}

/* ----- Common ----- */
* {-webkit-tap-highlight-color:rgba(0,0,0,0);}
html, body, .wrap {height:100%; overflow:auto}
body {font-size:13px;line-height:18px;color:#3e3c3f;font-family:'Dotum', 'Arial', 'Verdana', sans-serif;word-break:break-all;background-color:#f5f5f5;}
a {color:#3e3c3f;}
i {font-style:normal;}
legend, hr {display:none;}
textarea {border:0;margin:0;}
button {cursor:pointer;margin:0;padding:0;}
img {vertical-align:top;}
select, .inp-st {
	box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
	-moz-appearance:none;-webkit-appearance:none;appearance:none;margin:0;padding:0;border:0 none;font-family:'Dotum', 'Arial', 'Verdana', sans-serif;color:#3e3c3f;
}
::-webkit-input-placeholder { /* 크롬 4–56 */color: #9e9e9e;}
:-moz-placeholder { /* 파이어폭스 4–18 */color: #9e9e9e;opacity:  1;}
::-moz-placeholder { /* 파이어폭스 19–50 */color: #9e9e9e;opacity:  1;}
:-ms-input-placeholder { /* 인터넷 익스플로러 10+ */color:  #9e9e9e;}
::placeholder { /* 파이어폭스 51+, 크롬 57+ */color: #9e9e9e;opacity:  1;}

@media screen and (-ms-high-contrast:active), (-ms-high-contrast:none) {select::-ms-expand {display:none;} input::-ms-clear {display:none;}}
.skip-nav {position:absolute;left:-9999px;overflow:hidden;}
.sec-code {width:6px;height:6px;}
.above-all-layer {position:absolute;left:0;top:0;z-index:1000;width:100%;height:100%;background-color:#fff;opacity:0.3;}
.loading-box {position:absolute;left:50%;top:50%;z-index:1001;width:90px;margin:-59px 0 0 -45px;text-align:center;}
.ani-box {overflow:hidden;width:90px;height:90px;white-space:nowrap;text-indent:100%;background-repeat:no-repeat;background-position:50% 0;background-size:auto 90px;-webkit-animation:splash 600ms steps(4) infinite;animation:splash 600ms steps(4) infinite;}
.ani-box.gif {-webkit-animation:none;animation:none;}
.loading-box strong {display:block;padding-top:10px;color:#5b5a5b;font-size:13px;}
input[type='password'] {font-family:'Arial', 'Verdana', sans-serif;}
.guide-txt {color:#cecdc9;}
/* keyframes animation */
@-webkit-keyframes splash {
	from { background-position:0 0; }
	to { background-position:-360px 0; }
}
@keyframes splash {
	from { background-position:0 0; }
	to { background-position:-360px 0; }
}

.lguplus-btn-icon {
	background-image:url('../img/bi_uplus_agree.png');
	background-size: auto 25px;
	background-repeat: no-repeat;
	padding-left: 100px;
	padding-top: 5px;
	padding-bottom: 5px;
}

/* theme */
	/* default - navy */
	.default .ani-box {background-image:url('../img/set_loading_navy.png');}
	.default .ani-box.gif {background-image:url('../img/loading_navy.gif');}
	.default .header-grp {background-color:#0c3851;}
	.default .header-grp .date, .default .simple-pay-history em {color:#fff;opacity: 0.5}
	.default .st01:checked + label:before {border-color:#0c3851;background-color:#0c3851;}
	.default .st01[type='radio']:checked + label:after {background-color:#0c3851;}
	.default .frm-box .caution-txt {color:#f44040;}
	.default .frm-box .fz14{font-size: 14px;}
	.default .btn-grp .btn-cell .point {background-color:#0c3851;}
	.default .btn-grp .btn-cell .point:active {background-color:#0b3249;}
	.default .btn-grp .btn-cell .point.dimmed:active {color:#fff;background-color:#0c3851;}
	.default .choose-btn-list.col-type .active a, .default .active #eco, .default .choose-btn-list.col-type .active .row {color:#fff;border-color:#0c3851;background-color:#0c3851;}

select#eco {}
	.default .choose-btn-list.col-type .active select {color:#0c3851;}
	.default .choose-one-box .active a {border-color:#0c3851;color:#fff;background-color: #0c3851;}
	.default .key-txt-box dd strong {font-size:28px;color: #0c3851;letter-spacing: -0.04em;}
	.default .row-wrap .btn-row .ins-btn {
		display:block;overflow:hidden;width:100%;height:26px;line-height:20px;letter-spacing:-0.1em;font-size:14px;color:#0c3851;background-color:transparent;text-decoration: underline;
    padding-top: 5px;text-align: right;}
    .default .row-wrap .btn-row .ins-btnbox {
		display:block;overflow:hidden;width:100%;height:38px;line-height:38px;letter-spacing:-0.1em;font-size:14px;color:#fff;background-color:#0c3851;text-align: center;}
    .default .caution .box-cell h1 {padding-top:72px;margin:0 0 7px 0;font-size:20px;line-height:24px;background:url('../img/ico_caution_navy.png') 50% 0 no-repeat;background-size:57px 50px;color: #153f57;font-weight: bold;}
    .default .caution_cd .box-cell.u-plus h1, .default .caution .box-cell.kt h1, .default .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#0c3851;font-weight: bold;}
    .default .caution .box-cell.u-plus h1, .default .caution .box-cell.kt h1, .default .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#0c3851;font-weight: bold;}

	/* theme01 - blue */
	.theme01 .ani-box {background-image:url('../img/set_loading_blue.png');}
	.theme01 .ani-box.gif {background-image:url('../img/loading_blue.gif');}
	.theme01 .header-grp {background-color:#00a9da;}
	.theme01 .header-grp .date, .theme01 .simple-pay-history em {color:#046885;}
	.theme01 .st01:checked + label:before {border-color:#00a9da;background-color:#00a9da;}
	.theme01 .st01[type='radio']:checked + label:after {background-color:#00a9da;}
	.theme01 .frm-box .caution-txt {color:#00a9da;}
	.theme01 .btn-grp .btn-cell .point {background-color:#00a9da;}
	.theme01 .btn-grp .btn-cell .point:active {background-color:#0098c4;}
	.theme01 .btn-grp .btn-cell .point.dimmed:active {color:#fff;background-color:#00a9da;}
	.theme01 .choose-btn-list.col-type .active a, .theme01 .choose-btn-list.col-type .active .row {color:#00a9da;border-color:#00a9da;}
	.theme01 .choose-btn-list.col-type .active select {color:#00a9da;}
	.theme01 .choose-one-box .active a {border-color:#00a9da;color:#00a9da;}
	.theme01 .key-txt-box dd strong {font-size:28px;color: #00a9da;letter-spacing: -0.04em;}
	.theme01 .row-wrap .btn-row .ins-btn {
		display:block;overflow:hidden;width:100%;height:26px;line-height:20px;letter-spacing:-0.1em;font-size:14px;color:#025871;background-color:transparent;text-decoration: underline;
    padding-top: 5px;text-align: right;}
    .theme01 .caution .box-cell h1 {padding-top:72px;margin:0 0 7px 0;font-size:20px;line-height:24px;background:url('../img/ico_caution_blue.png') 50% 0 no-repeat;background-size:57px 50px;color: #00a9da;font-weight: bold;}
    .theme01 .caution_cd .box-cell.u-plus h1, .theme01 .caution .box-cell.kt h1, .theme01 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#00a9da;font-weight: bold;}
    .theme01 .caution .box-cell.u-plus h1, .theme01 .caution .box-cell.kt h1, .theme01 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#00a9da;font-weight: bold;}

	/* theme02 - orange */
	.theme02 .ani-box {background-image:url('../img/set_loading_orange.png');}
	.theme02 .ani-box.gif {background-image:url('../img/loading_orange.gif');}
	.theme02 .header-grp {background-color:#f35d22;}
	.theme02 .header-grp .date, .theme02 .simple-pay-history em {color:#cb3500;}
	.theme02 .st01:checked + label:before {border-color:#f35d22;background-color:#f35d22;}
	.theme02 .st01[type='radio']:checked + label:after {background-color:#f35d22;}
	.theme02 .frm-box .caution-txt {color:#f35d22;}
	.theme02 .btn-grp .btn-cell .point {background-color:#f35d22;}
	.theme02 .btn-grp .btn-cell .point:active {background-color:#da541f;}
	.theme02 .btn-grp .btn-cell .point.dimmed:active {color:#fff;background-color:#f35d22;}
	.theme02 .choose-btn-list.col-type .active a, .theme02 .choose-btn-list.col-type .active .row {color:#f35d22;border-color:#f35d22;}
	.theme02 .choose-btn-list.col-type .active select {color:#f35d22;}
	.theme02 .choose-one-box .active a {border-color:#f35d22;color:#f35d22;}
	.theme02 .key-txt-box dd strong {font-size:28px;color: #f35d22;letter-spacing: -0.04em;}
	.theme02 .row-wrap .btn-row .ins-btn {
		display:block;overflow:hidden;width:100%;height:26px;line-height:20px;letter-spacing:-0.1em;font-size:14px;color:#9e340b;background-color:transparent;text-decoration: underline;
    padding-top: 5px;text-align: right;}
    .theme02 .caution .box-cell h1 {padding-top:72px;margin:0 0 7px 0;font-size:20px;line-height:24px;background:url('../img/ico_caution_orange.png') 50% 0 no-repeat;background-size:57px 50px;color: #f35d22;font-weight: bold;}
    .theme02 .caution_cd .box-cell.u-plus h1, .theme02 .caution .box-cell.kt h1, .theme02 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#f35d22;font-weight: bold;}

    /* theme03 - green */
	.theme03 .ani-box {background-image:url('../img/set_loading_green.png');}
	.theme03 .ani-box.gif {background-image:url('../img/loading_green.gif');}
	.theme03 .header-grp {background-color:#00b04e;}
	.theme03 .header-grp .date, .theme03 .simple-pay-history em {color:#008039;}
	.theme03 .st01:checked + label:before {border-color:#00b04e;background-color:#00b04e;}
	.theme03 .st01[type='radio']:checked + label:after {background-color:#00b04e;}
	.theme03 .frm-box .caution-txt {color:#00b04e;}
	.theme03 .btn-grp .btn-cell .point {background-color:#00b04e;}
	.theme03 .btn-grp .btn-cell .point:active {background-color:#009e46;}
	.theme03 .btn-grp .btn-cell .point.dimmed:active {color:#fff;background-color:#00b04e;}
	.theme03 .choose-btn-list.col-type .active a, .theme03 .choose-btn-list.col-type .active .row {color:#00b04e;border-color:#00b04e;}
	.theme03 .choose-btn-list.col-type .active select {color:#00b04e;}
	.theme03 .choose-one-box .active a {border-color:#00b04e;color:#00b04e;}
	.theme03 .key-txt-box dd strong {font-size:28px;color: #00b04e;letter-spacing: -0.04em;}
	.theme03 .row-wrap .btn-row .ins-btn {
		display:block;overflow:hidden;width:100%;height:26px;line-height:20px;letter-spacing:-0.1em;font-size:14px;color:#025928;background-color:transparent;text-decoration: underline;
    padding-top: 5px;text-align: right;}
    .theme03 .caution .box-cell h1 {padding-top:72px;margin:0 0 7px 0;font-size:20px;line-height:24px;background:url('../img/ico_caution_green.png') 50% 0 no-repeat;background-size:57px 50px;color: #00b04e;font-weight: bold;}
    .theme03 .caution_cd .box-cell.u-plus h1, .theme03 .caution .box-cell.kt h1, .theme03 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#00b04e;font-weight: bold;}
    .theme03 .caution_cd .box-cell.u-plus h1, .theme03 .caution .box-cell.kt h1, .theme03 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#00b04e;font-weight: bold;}

	/* theme04 - pink */
	.theme04 .ani-box {background-image:url('../img/set_loading_pink.png');}
	.theme04 .ani-box.gif {background-image:url('../img/loading_pink.gif');}
	.theme04 .header-grp {background-color:#f45475;}
	.theme04 .header-grp .date, .theme04 .simple-pay-history em {color:#ce2749;}
	.theme04 .st01:checked + label:before {border-color:#f45475;background-color:#f45475;}
	.theme04 .st01[type='radio']:checked + label:after {background-color:#f45475;}
	.theme04 .frm-box .caution-txt {color:#f45475;}
	.theme04 .btn-grp .btn-cell .point {background-color:#f45475;}
	.theme04 .btn-grp .btn-cell .point:active {background-color:#db4b69;}
	.theme04 .btn-grp .btn-cell .point.dimmed:active {color:#fff;background-color:#f45475;}
	.theme04 .choose-btn-list.col-type .active a, .theme04 .choose-btn-list.col-type .active .row {color:#f45475;border-color:#f45475;}
	.theme04 .choose-btn-list.col-type .active select {color:#f45475;}
	.theme04 .choose-one-box .active a {border-color:#f45475;color:#f45475;}
	.theme04 .key-txt-box dd strong {font-size:28px;color: #f45475;letter-spacing: -0.04em;}
	.theme04 .row-wrap .btn-row .ins-btn {
		display:block;overflow:hidden;width:100%;height:26px;line-height:20px;letter-spacing:-0.1em;font-size:14px;color:#973449;background-color:transparent;text-decoration: underline;
    padding-top: 5px;text-align: right;}
    .theme04 .caution .box-cell h1 {padding-top:72px;margin:0 0 7px 0;font-size:20px;line-height:24px;background:url('../img/ico_caution_pink.png') 50% 0 no-repeat;background-size:57px 50px;color: #f45475;font-weight: bold;}
    .theme04 .caution_cd .box-cell.u-plus h1, .theme04 .caution .box-cell.kt h1, .theme04 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#f45475;font-weight: bold;}
    .theme04 .caution_cd .box-cell.u-plus h1, .theme04 .caution .box-cell.kt h1, .theme04 .caution .box-cell.skt h1 {margin-bottom:10px;padding-top:75px;color:#f45475;font-weight: bold;}

/* layout */
	.header-grp {position:relative;padding:27px 20px 15px 20px;}
	.header-grp h1 {height:30px;margin-bottom:12px;width: 70%;display: inline-block;}
	.header-grp .status img{height:30px;}
	.header-grp .payletter_k {background-image:url('/DesignTemplate/ci_payletter.png');}
	.header-grp .date, .header-grp h2 {position:absolute;right:20px;top:27px;background-repeat:no-repeat;background-position:0 0;background-size:113px 25px;width:113px;height:25px;margin-bottom:12px;text-indent: -9999px;}
	.header-grp .payletter{background-image:url('../img/bi_payletter.png');}
	.header-grp .def-txt {margin:-5px 0 2px 0;font-size:14px;color:#fff;opacity:0.8;}
	.simple-pay-history dl {position:relative;padding-bottom:7px;padding-left:68px;font-size:14px;line-height:21px;}
	.simple-pay-history dt {position:absolute;left:0;top:0;color:#fff;opacity:0.7;}
	.simple-pay-history dd {color:#fff;text-align:right;letter-spacing:-0.04em;}
	.simple-pay-history dd span {color:#fff;}
	.simple-pay-history strong {display:inline-block;vertical-align:top;margin-top:-2px;font-size:19px;}
	.content-grp {padding-bottom:100px;}
	.footer-grp {position:fixed;left:0;bottom:0;width:100%;}
	.main-footer {position:relative;z-index:12;padding:20px;}
	.main-footer .sub-txt {position:relative;z-index:12;margin-bottom:19px;font-size:13px;color:#7b7a7c;}
	.main-footer:before, .main-footer .ie-before {content:'';position:absolute;left:0;top:0;z-index:11;width:100%;height:100%;background-color:#f5f5f5;opacity:0.75;}
	.main-footer .btn-grp {position:relative;z-index:12;}
/* form check & radio style */
	.frm-chk {display:none;}
	.frm-chk + label {cursor:pointer;position:relative;display:inline-block;overflow:hidden;height:20px;margin-right:4px;vertical-align:top;font-size:13px;line-height:22px;color:#676567;}
	.f-sizeup .frm-chk + label {font-size:14px;}
	.frm-chk + label.other-line {display:inline-block;overflow:visible;height:auto;margin:0;}
	/*.frm-chk:disabled + label {color:#ababab;}*/
	.frm-chk + label:before {
		position:absolute;left:0;top:50%;content:'';display:block;
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		border:1px solid #d5d5d5;background:#fff;}
	.frm-chk + label:after {
		position:absolute;top:50%;z-index:0;content:'';display:block;
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;}
	.st01:checked + label:before {-webkit-transition:background 0.6s;-moz-transition:background 0.6s;-o-transition:background 0.6s;transition:background 0.6s;}
	/* for checkbox */
	.st01[type='checkbox'] + label {padding-left:27px;}
	.st01[type='checkbox'] + label:before {width:20px;height:20px;margin-top:-10px;border-radius:3px;}
	.st01[type='checkbox'] + label.other-line:before, .st01[type='radio'] + label.other-line:before {top:0;margin-top:0;}
	/*.st01[type='checkbox']:disabled + label:before {border-color:#d5d5d5;background:transparent;}*/
	.st01[type='checkbox']:checked + label:after {left:3px;width:14px;height:10px;margin-top:-5px;border:none;background:url('../img/ico_chk.png') no-repeat;background-size:14px 10px;}
	.st01[type='checkbox']:checked + label.other-line:after {top:0;margin-top:5px;}
	/* for radio */
	.st01[type='radio'] + label {padding-left:24px;}
	.st01[type='radio'] + label:before {width:20px;height:20px;margin-top:-10px;border-radius:20px;border-color:#d6d6d6 !important;background-color:#fff !important;}
	/*.st01[type='radio']:disabled + label:before {border-color:#ddd;background:transparent;}*/
	.st01[type='radio']:checked + label:after {left:6px;width:8px;height:8px;margin-top:-4px;border-radius:8px;}
	.st01[type='radio']:checked + label.other-line:after {top:0;margin-top:6px;}
	/*.st01[type='radio']:checked:disabled + label:after {background:#f0f0f0;}*/
/* form group */
	.frm-grp {padding:18px 20px 0 20px;}
	.frm-grp .row {position:relative;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;margin-top:3px;border:1px solid #e2e2e2;background-color:#fff;}
	.frm-box .row {position:relative;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;margin-top:3px;border:1px solid #e2e2e2;background-color:#fff;}
	.frm-box .mb12{margin-bottom: 12px;}
	.frm-box .mt22{margin-top:22px;}
	.row .click {position:absolute;left:0;top:0;z-index:1;display:block;overflow:hidden;width:100%;height:100%;text-indent:100%;white-space:nowrap;background:url('../img/blank.png') repeat;}
	.frm-box.solo-st {margin-bottom:-7px;}
	.frm-box.solo-st02 {padding-top:18px;margin-bottom:0;}
	.frm-box.solo-st02 .row {margin-top:5px;}
	.frm-box.solo-st02 .row:first-of-type {margin-top:2px;}
	.frm-box .mb5{margin-bottom: 5px;}
	.frm-box .pl5{padding-left: 5px;}
	.frm-box .field {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;position:relative;display:block;}
	.field label {
		display:block;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		position:absolute;left:0;top:0;width:100%;height:36px;padding:0px 0 0 30px;font-size:16px;white-space:nowrap;letter-spacing:-0.1em;color:#cecdc9;line-height: 36px;}
	.age_ni{color:#676767;margin:15px 0 5px;}
	.field .inp-st, .field select {overflow:hidden;width:100%;height:36px;padding:0 25px 0 30px;font-size:16px;letter-spacing:0em;background:transparent;}
	.field select {padding-left:17px;font-size:15px;background:url('../img/bg_select_arrow.png') 100% 50% no-repeat;background-size:23px 6px;}
	.field.active select {padding-left:17px;font-size:15px;background:url('../img/bg_select_arrow_active.png') 100% 50% no-repeat;background-size:23px 6px;}
	.field.one-field .inp-st {padding-left:0;}
	.field.one-txt {width:72px;max-width:72px;min-width:72px;text-align:center;}
	.field.sec-txt-set {width:112px;max-width:112px;min-width:112px;}
	.field.one-field, .field.one-field .inp-st {width:17px;max-width:17px;min-width:17px;padding:0;text-align:center;}
	.field.one-field label {padding-top:0;padding-left:0;line-height:58px;}
	.field.one-field label img {margin-top:15px;}
	.field .sec-txt {
		display:block;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		position:absolute;left:0;top:0;width:100%;height:36px;line-height:36px;}
	.field .sec-txt .sec-code {margin:15px 0 0 3px;}
	.field .txt {
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;position:absolute;left:0;top:0;display:block;
		width:100%;height:36px;padding:10px 0 0 0;color:#d1d3d5;}
	.field .blind {left:-9999px;top:auto;overflow:hidden;}

	/*field2*/
	.frm-box .field2 {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;position:relative;display:block;}
	.field2 label {
		display:block;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		position:absolute;left:0;top:0;width:100%;height:36px;padding:0px 0 0 30px;font-size:16px;white-space:nowrap;letter-spacing:-0.1em;color:#cecdc9;line-height: 36px;}
	.field2 .inp-st, .field2 select {overflow:hidden;width:100%;height:36px;padding:0 25px 0 30px;/*line-height:60px;*/font-size:16px;letter-spacing:0em;background:transparent;}
	.field2 select {padding-left:17px;font-size:15px;background:url('../img/bg_select_arrow.png') 100% 50% no-repeat;background-size:23px 6px;}
	.field2.one-field .inp-st {padding-left:0;}
	.field2.one-txt {width:72px;max-width:72px;min-width:72px;text-align:center;}
	.field2.sec-txt-set {width:112px;max-width:112px;min-width:112px;}
	.field2.one-field, .field2.one-field .inp-st {width:17px;max-width:17px;min-width:17px;padding:0;text-align:center;}
	.field2.one-field label {padding-top:0;padding-left:0;line-height:58px;}
	.field2.one-field label img {margin-top:18px;}
	.field2 .sec-txt {
		display:block;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		position:absolute;left:0;top:0;width:100%;height:40px;line-height:40px;}
	.field2 .sec-txt .sec-code {margin:18px 0 0 3px;}
	.field2 .txt {
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;position:absolute;left:0;top:0;display:block;width:100%;height:40px;padding:10px 0 0 0;color:#d1d3d5;}
	.field2 .blind {left:-9999px;top:auto;overflow:hidden;}
	.frm-box .caution-txt {padding-top:7px;font-size:12px;}
	.row-wrap {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:table;width:100%;}
	.row-wrap .row, .row-wrap .btn-row {margin-top:0;border:none;display:table-cell;vertical-align:top;background-color:transparent;}
	.row-wrap .field {border:1px solid #e2e2e2;background-color:#fff;}
	
	/* column type */
	.col-type {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:table;width:100%;border-collapse:collapse;}
	.col-type .field, .col-type .tit, .choose-btn-list.col-type li {display:table-cell;vertical-align:top;}
	.choose-btn-list {margin-top:15px;}
	.choose-btn-list:first-child {margin-top:0;}
	
	/*.choose-btn-list.col-type li {width:25%;padding-left:2px;}*/ /*변경 , 2018-12-13 */
	.choose-btn-list.col-type li {width:20% !important;padding-left:2px;}
	.choose-btn-list.col-type li:nth-child(4){width:40% !important;}
	
	.choose-btn-list.col-type li:first-child {padding-left:0;}
	.choose-btn-list.col-type a {
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:block;overflow:hidden;
		height:36px;border:1px solid #e2e2e2;line-height:36px;font-size:14px;letter-spacing:-0.04em;font-weight:bold;text-align:center;color:#3f3d40;background-color:#fff;}
	.choose-btn-list.col-type a:active {background-color:#e5e5e5;}
	.choose-btn-list.col-type .click {height:100%;border:none;line-height:auto;background-color:transparent;}
	.choose-btn-list.col-type .click:active {background-color:transparent;}
	.choose-btn-list.col-type .active a:active {background-color:#fff;}
	.choose-btn-list.col-type .row {margin:0;}
	.choose-btn-list.col-type .field {display:block;width:100%;}
	/* .choose-btn-list.col-type .field select {display:block;width:100%;padding-left:13px;padding-right:28px;height:34px;font-size:14px;font-weight:bold;line-height:34px;} *//*변경 , 2018-12-13 */
	.choose-btn-list.col-type .field select {display: block;width: 100%;padding-left: 10px;padding-right: 15px;height: 34px;font-size: 14px;font-weight: bold;line-height: 34px;}
	/* key text box */
	.key-txt-box {margin:-1px 0 11px 0;}
	.key-txt-box dl {position:relative;line-height:22px;letter-spacing:-0.04em;}
	.key-txt-box dt {font-size:13px;color:#2a282b;opacity: 0.8}
	.key-txt-box dd strong {font-size:28px;color: #0c3851;letter-spacing: -0.04em;}
	.key-txt-box .tip-txt {padding:3px 0 7px 0;font-size:13px;color:#a4a3a4;letter-spacing:-0.04em;}
	/* form other style box */
	.frm-box.frm-other-box {padding:2px 0 0 0;}
	.frm-box.frm-other-box .row {margin-top:15px;}
	.frm-box.frm-other-box .mt0{margin-top: 0 !important;}
	.frm-box.frm-other-box .row.dropdown {width:93px;max-width:93px;min-width:93px;padding-right:4px;}
	.frm-box.frm-other-box .row-wrap {margin-top:15px;}
	.frm-box.frm-other-box .row-wrap .row {margin-top:0;}
	.frm-box.frm-other-box .row:first-child, .frm-box.frm-other-box .row-wrap:first-child {margin-top:0;}
	.frm-box.frm-other-box .caution-txt {text-align:right;}
	.frm-box.frm-other-box .row-wrap .btn-row {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding-left:0;padding-right:4px;width:93px;max-width:93px;min-width:93px;}
	.frm-box.frm-other-box .row-wrap .btn-row .ins-btn {color:#fff;background-color:#8f8e8f;}
	.frm-box.frm-other-box .row-wrap .btn-row .ins-btn:active {color:#fff;background-color:#808080;}
	.frm-box .btn_certify{color:#fff;text-align: center;font-size:14px;background: #0c3851;padding: 5px 10px;width: 100%;height: 36px;box-sizing: border-box;}
/* button group */
	.btn-grp {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:table;width:100%;text-align:center;}
	.btn-grp .btn-row {display:table-row;}
	.btn-grp .btn-cell {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:table-cell;padding-left:4px;padding-top:4px;}
	.btn-grp .btn-cell .point {background-color:#0c3851;}
	.btn-grp .btn-cell .point:active {background-color:#0b3249;}
	.btn-grp .btn-cell .dimmed {cursor:default;opacity:0.5;}
	.btn-grp .btn-row:first-child .btn-cell {padding-top:0;}
	.btn-grp .btn-cell:first-child {padding-left:0;}
	.btn-grp .btn-cell.fixed-width {width:89px;max-width:89px;min-width:89px;}
	.btn-grp .btn-cell a, .btn-grp .btn-cell button {display:block;overflow:hidden;height:60px;color:#fff;font-size:18px;line-height:62px;background-color:#4b4a4b;}
	.btn-grp .btn-cell a:active, .btn-grp .btn-cell button:active {color:#e5e5e5;background-color:#434243;}
	.btn-grp .btn-cell .point:active {color:#e5e5e5;}
	.btn-grp .btn-cell .dimmed:active {color:#fff;background-color:#4b4a4b;}
	.btn_fix{position: fixed;bottom: 0;left:0;z-index: 9999;box-sizing: border-box;padding:15px;}
/* radio &amp; checkbox list */
	.rdo-chk-list {padding-top:14px;font-size:13px;}
	.rdo-chk-list li {margin-top:0px;}
	.rdo-chk-list li label {color:#7c7b7d;}
	.rdo-chk-list .sub-txt {padding-left:27px;font-size:14px;line-height:23px;color:#7c7b7d;letter-spacing:-0.04em;}
	.rdo-chk-list .tip-help-box {margin-bottom:6px;}
	.rdo-chk-list .sub-txt a {text-decoration:underline;color:#7c7b7d;font-weight:bold;}
	.rdo-chk-list.other-type.space {margin-bottom:15px;}
	.rdo-chk-list li label {color:#7c7b7d;}
	.rdo-chk-list .sub-txt {padding-left:27px;font-size:14px;line-height:23px;color:#7c7b7d;letter-spacing:-0.04em;}
	.rdo-chk-list .tip-help-box {margin-bottom:6px;}
	.rdo-chk-list .sub-txt a {text-decoration:underline;color:#7c7b7d;font-weight:bold;}
	.rdo-chk-list.other-type {zoom:1;padding:14px 0 0 0;}
	.rdo-chk-list.other-type label {letter-spacing:-0.05em;}
	.rdo-chk-list.other-type:after {content:'';height:0;display:block;visibility:hidden;clear:both;}
	.rdo-chk-list.other-type li {position:relative;float:left;display:inline;margin-left:18px;}
	.rdo-chk-list.other-type.space li {margin-left:16px;}
	.rdo-chk-list.other-type.space li:first-child {margin-left:0;}
	.rdo-chk-list.other-type li:first-child {margin-left:0;}
	.rdo-chk-list.other-type .tip-help-box.active {margin-bottom:5px;}
	.rdo-chk-list .frm-chk + .img-type {height:22px;padding-left:26px;}
	.rdo-chk-list .tpay {display:block;overflow:hidden;width:81px;height:22px;vertical-align:top;white-space:nowrap;text-indent:100%;background:url('../img/bi_tpay.png') no-repeat;background-size:auto 22px;}
	.rdo-chk-list .usim-cert {display:block;overflow:hidden;width:135px;height:21px;vertical-align:top;white-space:nowrap;text-indent:100%;background:url('../img/bi_usim.png') no-repeat;background-size:auto 21px;}
	.rdo-chk-list.other-type02 li {/*margin-top:6px;*/}
	.rdo-chk-list.other-type02 .all {margin-bottom:8px;padding-bottom:8px;border-bottom:1px solid #e2e2e2;}
	.rdo-chk-list.other-type02 label {color:#3e3c3f;}
	.rdo-chk-list .mb10{margin-bottom: 10px;}
/* tip help */
	.tip-help {
		position:relative;display:inline-block;width:23px;margin-left:2px;overflow:hidden;
		vertical-align:top;white-space:nowrap;text-indent:100%;
		background:url('../img/ico_q.png') 50% 1px no-repeat;background-size:17px;}
	.tip-help.active:after {content:'';position:absolute;left:50%;bottom:0;display:block;width:9px;height:6px;margin-left:-5px;background:url('../img/ico_bubble_tail.png') no-repeat;background-size:9px 6px;}
	.tip-help-box {display:none;padding:8px 14px 7px 14px;font-size:13px;line-height:18px;letter-spacing:-0.04em;color:#eee;background-color:#c5c5c5;}
	.tip-help-box.active {display:block;}
/* common linker &amp; list */
	.linker {display:inline-block;padding-right:11px;vertical-align:top;color:#2a282b;background:url('../img/ico_link_arrow.png') 100% 5px no-repeat;background-size:6px 10px;opacity: 0.9}
	.linker2 {display:inline-block;padding-right:11px;vertical-align:middle;color:#2a282b;background-size:6px 10px;opacity: 0.7;font-weight: bold;margin-top:2px; text-decoration: underline !important;}
	.linker_noarrow {display:inline-block;vertical-align:top;color:#2a282b;opacity: 0.9;}
	.frm-box + .linker-list {padding-top:5px;}
	.linker-list {padding-top:16px;/*padding-left:5px;*/line-height:21px;}
	.linker-list .rdo-chk-item {margin-top:4px;}
/* caution */
	.caution {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:table;width:100%;height:100%;}
	.caution .box-cell {display:table-cell;height:100%;vertical-align:middle;text-align:center;color:#676567;}
	.caution .box-cell p {font-size:14px;}
	.caution .box-cell .pb150{padding-bottom: 110px;}
	.caution .box-cell .sub-txt {padding-bottom:150px;letter-spacing:-0.05em;}
	.caution .box-cell.u-plus h1 {background-image:url('../img/bi_u_plus.png');background-size:52px 46px;}
	.caution .box-cell.kt h1 {background-image:url('../img/bi_kt.png');background-size:51px 42px;}
	.caution .box-cell.skt h1 {background-image:url('../img/bi_skt.png');background-size:46px 50px;}
	.caution .box-cell.u-plus p, .caution .box-cell.kt p, .caution .box-cell.skt p {line-height:22px;}
	.caution .box-cell .contact p {padding-bottom:0px;text-align:center;font-size:13px;line-height:16px;color:#8f8e90;}
/* caution-card */
	.caution_cd {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:table;width:100%;height:77%;}
	.caution_cd .box-cell {display:table-cell;height:100%;vertical-align:middle;text-align:center;color:#676567;}
	.caution_cd .box-cell h1 {padding-top:72px;margin:0 0 7px 0;font-size:20px;line-height:24px;background:url('../img/ico_caution.png') 50% 0 no-repeat;background-size:57px 50px;color: #153f57;font-weight: bold;}
	.caution_cd .box-cell p {font-size:14px;}
	.caution_cd .box-cell .pb150{padding-bottom: 150px;}
	.caution_cd .box-cell .sub-txt {padding-bottom:30px;letter-spacing:-0.05em;}
	.caution_cd .box-cell.u-plus h1 {background-image:url('../img/bi_u_plus.png');background-size:52px 46px;}
	.caution_cd .box-cell.kt h1 {background-image:url('../img/bi_kt.png');background-size:51px 42px;}
	.caution_cd .box-cell.skt h1 {background-image:url('../img/bi_skt.png');background-size:46px 50px;}
	.caution_cd .box-cell.u-plus p, .caution_cd .box-cell.kt p, .caution_cd .box-cell.skt p {line-height:22px;}
	.caution_cd .box-cell .contact p {padding-bottom:0px;text-align:center;font-size:13px;line-height:16px;color:#8f8e90;}	
/* agreement */
	.agreement-box {padding:25px 20px 0 20px;color:#666;font-size:12px;line-height:17px;} /*max-height: 590px;overflow-y: auto;}*/
	.agreement-box h1 {margin-bottom:38px;font-size:18px;line-height:22px;color:#2a282b;font-weight:bold !important;}
	.agreement-box h2 {margin-bottom:16px;}
	.agreement-box h3 {margin-bottom:16px;}
	.agreement-box .txt-line {margin-bottom:16px;}

/* password faq box */
	.pw-faq-box {padding:24px 20px 68px 20px;}
	.pw-faq-box h1 {margin-bottom:36px;font-size:18px;line-height:24px;font-weight:bold;color:#2a282b;}
	.pw-faq-box dt, .pw-faq-box dd {color:#666;line-height:17px;}
	.pw-faq-box dt {margin-bottom:1px;font-size:13px;font-weight:bold;}
	.pw-faq-box dd {margin-bottom:14px;font-size:12px;}
/* etc */
	.help-txt {margin-top:11px;font-size:12px;color:#b2afa9;letter-spacing:-0.1em;}
/* common layer popup */
	.cmm-pop-layer {position:fixed;left:0;top:0;z-index:103;width:100%;height:100%;min-height:100%;background:#000;opacity:0.8;}
	.cmm-pop-wrap {
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		position:fixed;left:0;top:50%;z-index:104;width:100%;padding:0 20px;
		-webkit-transform:translateY(-50%);-moz-transform:translateY(-50%);transform:translateY(-50%);}
	.cmm-pop-inner {position:relative;padding-bottom:15px;outline:none;background:#fff;}
	.cmm-pop-wrap .btn-grp {padding:0 15px;}
	.cmm-pop-wrap .btn-grp .btn-cell {padding-left:3px;}
	.cmm-pop-wrap .btn-grp .btn-cell:first-child {padding-left:0;}
	.cmm-pop-wrap .btn-grp .btn-cell a, .cmm-pop-wrap .btn-grp .btn-cell button {height:50px;line-height:52px;min-width:80px;}
	
	/*layer popup 약관*/
	.agree-pop-wrap {
		box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;
		position:fixed;left:0;top:50%;z-index:104;width:100%;height: 100%;
		-webkit-transform:translateY(-50%);-moz-transform:translateY(-50%);transform:translateY(-50%);}

	/* radio &amp; text group */
	.rdo-txt-grp {padding:52px 27px 45px 27px;letter-spacing:-0.04em;}
	.rdo-txt-grp h2 {margin-bottom:37px;text-align:center;font-size:20px;line-height:24px;font-weight:bold;color:#2a282b;opacity: 0.9;}
	.rdo-txt-grp p {margin-top:12px;text-align: center;}
	.rdo-txt-grp .frm-chk + label {font-size:14px;line-height:23px;color:#2a282b;opacity: 0.9}
	.rdo-txt-grp .fc_g{color:#2a282b;opacity: 0.7;}

	/* choose one box */
	.choose-one-box {padding:39px 0 0 0;text-align:center;}
	.choose-one-box h1 {margin-bottom:31px;font-size:20px;line-height:24px;font-weight:bold;color:#3f3d40;}
	.choose-one-box ul {padding:0 63px 34px 63px;}
	.choose-one-box li {margin-top:2px;}
	.choose-one-box a {overflow:hidden;display:block;height:33px;border:1px solid #e2e2e2;line-height:35px;font-size:14px;color:#3f3d40;background-color:#fff;}
	.choose-one-box a:active {background-color:#e5e5e5;}
	.choose-one-box .active a:active {background-color:#0b3249;}
	/*card*/
	.label_tit{display: inline-block;vertical-align: middle;width: 20%;}
	.label_tit > em{font-size: 11px;}
	.label_slc1{display: inline-block;vertical-align: middle;width:77.7%;}
	.label_slc2{display: inline-block;vertical-align: middle;width:31%;}
	.label_slc3{display: inline-block;vertical-align: middle;width:39.4%;}
	.label_slc4{display: inline-block;vertical-align: middle;width:25%;}
	.label_slc5{display: inline-block;vertical-align: middle;width:30.6%;}
	.ni_tit{margin-left: 10px;display: inline-block;vertical-align: middle;}
	.first_bd{border-bottom: 1px solid #e1e2d6;padding-bottom: 5px;}
	.card_info{color:#0c3851;text-align: center;display: inline-block;margin: auto;width:100%;box-sizing: border-box;padding: 6px 0;font-weight: bold;}
	.card_sub_ni{padding-left: 27px;color:rgba(42,40,43,0.7);}
	.vm{vertical-align: middle;display: inline-block;}
	.mr15{margin-right: 15px;}
	.card_cbox{margin-bottom: 10px;}
	.ipt_cardnumber{width:18.7%;display: inline-block;border:0;padding: 9px 0;text-align: center;}
	.pt0{padding-top: 0 !important;}
	
	/*180530*/
	.notice_txt{color: #7c7b7d;}
	.notice_txt > span:first-child{float: left;}
	.notice_txt > span:first-child+span{display: block;overflow: hidden;}
	.notice_tit{color:#7c7b7d;font-weight: bold;}
	.notice_txt em{color: #f44040}
	.pl27{padding-left: 27px;}
	.mt10{margin-top: 11px !important;}
	.mt7{margin-top: 7px !important;}
	.ipt_phonenumber{width:100%;display: inline-block;border:0;padding: 9px 0;text-align: center;}
	.label_slc6{display: inline-block;vertical-align: middle;width:100%;}
	.txt_info{color:#0c3851;text-align: center;display: inline-block;margin: auto;width:100%;box-sizing: border-box;padding: 6px 0;font-weight: bold;font-size: 16px;}
	.highlight{color: #f44040}
	.hyphen {display: inline-block;}
	.ta_center{text-align: center;width: 100%;display: table}
	.table_state{display:table;width:100%;}
	.tbl-box{display: table;width:100%;}
	.tbl-box li{display: table-cell;vertical-align: middle;}
	.tbl-box li:nth-child(1){width:24%}
	.tbl-box li:nth-child(2){width:3%}
	.tbl-box li:nth-child(3){width:35%}
	.tbl-box li:nth-child(4){width:3%}
	.tbl-box li:nth-child(5){width:35%}

	.width-resp{width:100%;display: table;border-collapse: collapse;}
	.width-resp li{display: table-cell;vertical-align: middle;}
	.width-resp li:nth-child(1){width: 25%}
	.width-resp li:nth-child(2){width: 3%}
	.width-resp li:nth-child(3){width: 33.5%}
	.width-resp li:nth-child(4){width: 3%}
	.width-resp li:nth-child(5){width: 33.5%}

/* ----- for mobile ----- */
@media only all and (-webkit-min-device-pixel-ratio:1.5), only all and (min-device-pixel-ratio:1.5), only all and (min--moz-device-pixel-ratio:1.5), only all and (max-width:320px) {
/* theme */
	/* default - navy */
	.default .ani-box {background-image:url('../img/xhdpi/set_loading_navy.png');}
	.default .ani-box.gif {background-image:url('../img/xhdpi/loading_navy.gif');}
	/* theme01 - blue */
	.theme01 .ani-box {background-image:url('../img/xhdpi/set_loading_blue.png');}
	.theme01 .ani-box.gif {background-image:url('../img/xhdpi/loading_blue.gif');}
	/* theme02 - orange */
	.theme02 .ani-box {background-image:url('../img/xhdpi/set_loading_orange.png');}
	.theme02 .ani-box.gif {background-image:url('../img/xhdpi/loading_orange.gif');}
	/* theme03 - green */
	.theme03 .ani-box {background-image:url('../img/xhdpi/set_loading_green.png');}
	.theme03 .ani-box.gif {background-image:url('../img/xhdpi/loading_green.gif');}
	/* theme04 - pink */
	.theme04 .ani-box {background-image:url('../img/xhdpi/set_loading_pink.png');}
	.theme04 .ani-box.gif {background-image:url('../img/xhdpi/loading_pink.gif');}
/* layout */
	.header-grp .payletter {background-image:url('../img/xhdpi/bi_payletter.png');}
	.header-grp .payletter_k {background-image:url('../img/xhdpi/bi_payletter_k.png');}
/* form check & radio style */
	.st01[type='checkbox']:checked + label:after {background-image:url('../img/xhdpi/ico_chk.png');}
/* form group */
	.field select {background-image:url('../img/xhdpi/bg_select_arrow.png');}
	/*.field.active select {background:url('../img/xhdpi/bg_select_arrow_active.png') 100% 50% no-repeat;}*/
	.field.active select {background: url(../img/bg_select_arrow_active.png) 100% 50% no-repeat;} 

	.row-wrap {display:-moz-box;display:-webkit-box;display:-ms-flexbox;display:box;}
	.row-wrap .row, .row-wrap .btn-row {display:block;-moz-box-flex:1.0;-webkit-box-flex:1.0;-ms-flex:1.0;box-flex:1.0; width:50%; }
	/* column type */
	.col-type {display:-moz-box;display:-webkit-box;display:-ms-flexbox;display:box;}
	.col-type .field, .col-type .tit, .choose-btn-list.col-type li {display:block;-moz-box-flex:1.0;-webkit-box-flex:1.0;-ms-flex:1.0;box-flex:1.0;width:50%;}
/* button group */
	.btn-grp {display:block;}
	.btn-grp .btn-row {box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;display:-moz-box;display:-webkit-box;display:-ms-flexbox;display:box;}
	.btn-grp .btn-cell {display:block;-moz-box-flex:1.0;-webkit-box-flex:1.0;-ms-flex:1.0;box-flex:1.0; min-width: 80px;/* width:50%; */ }
/* radio &amp; checkbox list */
	.rdo-chk-list .tpay {background-image:url('../img/xhdpi/bi_tpay.png');}
	.rdo-chk-list .usim-cert {background-image:url('../img/xhdpi/bi_usim.png');}
/* tip help */
	.tip-help {background-image:url('../img/xhdpi/ico_q.png');}
	.tip-help.active:after {background-image:url('../img/xhdpi/ico_bubble_tail.png');}
/* common linker &amp; list */
	.linker {background-image:url('../img/xhdpi/ico_link_arrow.png');}
/* caution */
	.caution .box-cell h1 {background-image:url('../img/xhdpi/ico_caution.png');}
	.caution .box-cell.u-plus h1 {background-image:url('../img/xhdpi/bi_u_plus.png');}
	.caution .box-cell.kt h1 {background-image:url('../img/xhdpi/bi_kt.png');}
	.caution .box-cell.skt h1 {background-image:url('../img/xhdpi/bi_skt.png');}
	.lguplus-btn-icon {
		background-image:url('../img/bi_uplus_agree.png');
		background-size: auto 24px;
		background-repeat: no-repeat;
		padding-left: 93px;
		padding-top: 1px;
	}
}

/* ----- for below 320px ----- */
@media only all and (max-width:320px) {
body {font-size:12px;line-height:16px;}
.sec-code {width:5px;height:5px;}
.loading-box {width:80px;margin:-53px 0 0 -40px;}
.ani-box {width:80px;height:80px;background-size:auto 80px;}
.loading-box strong {padding-top:9px;font-size:12px;}
/* keyframes animation */
@-webkit-keyframes splash {
	from { background-position:0 0; }
	to { background-position:-320px 0; }
}
@keyframes splash {
	from { background-position:0 0; }
	to { background-position:-320px 0; }
}
/* layout */
	.header-grp {padding:24px 18px 13px 18px;}
	.header-grp h1 {width:142px;height:22px;margin-bottom:15px;background-size:142px 22px;}
	.header-grp .date, .header-grp .status {right:18px;top:21px;font-size:11px;}
	.header-grp .def-txt {margin:-4px 0 2px 0;font-size:12px;}
	.simple-pay-history dl {padding-bottom:6px;padding-left:60px;font-size:12px;line-height:19px;}
	.simple-pay-history strong {font-size:17px;}
	.content-grp {padding-bottom:123px;}
	.main-footer {padding:18px;}
	.main-footer .sub-txt {margin-bottom:17px;font-size:12px;}
/* form check & radio style */
	.frm-chk + label {height:18px;font-size:12px;line-height:20px;}
	.f-sizeup .frm-chk + label {font-size:13px;}
	/* for checkbox */
	.st01[type='checkbox'] + label {padding-left:24px;}
	.st01[type='checkbox'] + label:before {width:18px;height:18px;margin-top:-9px;}
	.st01[type='checkbox']:checked + label:after {width:12px;height:8px;margin-top:-4px;background-size:12px 8px;}
	.st01[type='checkbox']:checked + label.other-line:after {margin-top:5px;}
	/* for radio */
	.st01[type='radio'] + label {padding-left:21px;}
	.st01[type='radio'] + label:before {width:18px;height:18px;margin-top:-9px;border-radius:18px;}
	.st01[type='radio']:checked + label:after {left:6px;width:6px;height:6px;margin-top:-3px;border-radius:6px;}
	.st01[type='radio']:checked + label.other-line:after {margin-top:6px;}
/* form group */
	.frm-grp {padding:16px 18px 0 18px;}
	.frm-box.solo-st {margin-bottom:-6px;}
	.frm-box.solo-st02 {padding-top:16px;}
	.frm-box.solo-st02 .row {margin-top:4px;}
	.field label {height:52px;padding:18px 0 0 27px;font-size:14px;}
	.field .inp-st, .field select {height:52px;padding-right:22px;padding-left:27px;line-height:54px;font-size:14px;}
	.field select {padding-left:15px;font-size:13px;background-size:20px 5px;}
	.field.one-txt {width:64px;max-width:64px;min-width:64px;}
	.field.sec-txt-set {width:100px;max-width:100px;min-width:100px;}
	.field.one-field, .field.one-field .inp-st {width:15px;max-width:15px;min-width:15px;}
	.field.one-field label {line-height:52px;}
	.field.one-field label img {margin-top:23px;}
	.field .sec-txt {height:52px;line-height:52px;}
	.field .sec-txt .sec-code {margin:23px 0 0 3px;}
	.field .txt {height:52px;padding:19px 0 0 0;}
	.frm-box .caution-txt {padding-top:6px;font-size:11px;}
	.row-wrap .btn-row {width:72px;min-width:72px;max-width:72px;}
	.row-wrap .btn-row .ins-btn {height:54px;line-height:56px;font-size:14px;}
	/* column type */
	.choose-btn-list {margin-top:13px;}
	.choose-btn-list.col-type a {height:32px;line-height:32px;font-size:12px;}
	.choose-btn-list.col-type .row {margin:0;}
	.choose-btn-list.col-type .field {width:100%;}
	/*.choose-btn-list.col-type .field select {width:100%;padding-left:12px;height:30px;padding-right:25px;font-size:12px;line-height:30px;} */
	 .choose-btn-list.col-type .field select {width: 100%;padding-left: 10px;height: 30px;padding-right: 15px;font-size: 12px;line-height: 30px;}

	/* key text box */
	.key-txt-box {margin:-1px 0 10px 0;}
	.key-txt-box dl {padding-left:64px;line-height:20px;}
	.key-txt-box dt {font-size:12px;}
	.key-txt-box dd strong {font-size:18px;}
	.key-txt-box .tip-txt {padding:3px 0 6px 0;font-size:12px;}
	/* form other style box */
	.frm-box.frm-other-box .row {margin-top:13px;}
	.frm-box.frm-other-box .row.dropdown {width:83px;max-width:83px;min-width:83px;}
	.frm-box.frm-other-box .row-wrap {margin-top:13px;}
	.frm-box.frm-other-box .row-wrap .btn-row {width:83px;max-width:83px;min-width:83px;}
/* button group */
	.btn-grp .btn-cell.fixed-width {width:79px;max-width:79px;min-width:79px;}
	.btn-grp .btn-cell a, .btn-grp .btn-cell button {height:54px;font-size:16px;line-height:56px;}
/* radio &amp; checkbox list */
	.rdo-chk-list {padding-top:13px;font-size:12px;}
	.rdo-chk-list li {margin-top:11px;}
	.rdo-chk-list .sub-txt {margin-top:-5px;padding-left:24px;font-size:12px;line-height:20px;}
	.rdo-chk-list .tip-help-box {margin-bottom:5px;}
	.rdo-chk-list.other-type.space {margin-bottom:13px;}
	.rdo-chk-list .sub-txt {margin-top:-5px;padding-left:24px;font-size:12px;line-height:20px;}
	.rdo-chk-list .tip-help-box {margin-bottom:5px;}

	.rdo-chk-list.other-type {padding-top:12px;}
	.rdo-chk-list.other-type li {margin-left:16px;}
	.rdo-chk-list.other-type.space li {margin-left:14px;}
	.rdo-chk-list.other-type .tip-help-box.active {margin-bottom:4px;}
	.rdo-chk-list .frm-chk + .img-type {height:20px;padding-left:23px;}
	.rdo-chk-list .tpay {width:74px;height:20px;background-size:74px 20px;}
	.rdo-chk-list .usim-cert {width:120px;height:19px;background-size:120px 19px;}
	.rdo-chk-list.other-type02 li {margin-top:5px;}
	.rdo-chk-list.other-type02 .all {margin-bottom:7px;padding-bottom:7px;}
/* tip help */
	.tip-help {width:20px;height:26px;background-position:50% 1px;background-size:15px;}
	.tip-help.active:after {width:8px;height:5px;margin-left:-4px;background-size:8px 5px;}
	.tip-help-box {padding:7px 12px 6px 12px;font-size:12px;line-height:16px;}
/* common linker &amp; list */
	.linker {padding-right:10px;background-position:100% 5px;background-size:5px 9px;}
	.frm-box + .linker-list {padding-top:20px;}
	.linker-list {padding-top:14px;padding-left:4px;line-height:19px;}
/* caution */
	.caution .box-cell h1 {padding-top:64px;margin:0 0 6px 0;font-size:18px;line-height:21px;background-size:50px 44px;}
	.caution .box-cell p {padding-bottom:4px;font-size:12px;}
	.caution .box-cell .sub-txt {padding-bottom:15px;}
	.caution .box-cell.u-plus h1, .caution .box-cell.kt h1, .caution .box-cell.skt h1 {margin-bottom:9px;padding-top:67px;}
	.caution .box-cell.u-plus h1 {background-size:46px 41px;}
	.caution .box-cell.kt h1 {background-size:45px 37px;}
	.caution .box-cell.skt h1 {background-size:41px 45px;}
	.caution .box-cell.u-plus p, .caution .box-cell.kt p, .caution .box-cell.skt p {line-height:20px;}
	.caution .box-cell .contact p {padding-bottom:90px;font-size:12px;line-height:14px;}
/* agreement */
	.agreement-box {padding:22px 18px 0 18px;font-size:11px;line-height:15px;}
	.agreement-box h1 {margin-bottom:34px;font-size:16px;line-height:20px;}
	.agreement-box h2 {margin-bottom:14px;}
	.agreement-box h3 {margin-bottom:14px;}
	.agreement-box .txt-line {margin-bottom:14px;}
/* password faq box */
	.pw-faq-box {padding:21px 18px 60px 18px;}
	.pw-faq-box h1 {margin-bottom:32px;font-size:16px;line-height:21px;}
	.pw-faq-box dt, .pw-faq-box dd {line-height:15px;}
	.pw-faq-box dt {font-size:12px;}
	.pw-faq-box dd {margin-bottom:12px;font-size:11px;}
/* etc */
	.help-txt {margin-top:10px;font-size:11px;}
/* common layer popup */
	.cmm-pop-wrap {padding:0 18px;}
	.cmm-pop-inner {padding-bottom:13px;}
	.cmm-pop-wrap .btn-grp {padding:0 13px;}
	.cmm-pop-wrap .btn-grp .btn-cell a, .cmm-pop-wrap .btn-grp .btn-cell button {height:44px;line-height:46px;}
	/* radio &amp; text group */
	.rdo-txt-grp {padding:45px 24px 40px 24px;}
	.rdo-txt-grp h2 {margin-bottom:33px;font-size:18px;line-height:21px;}
	.rdo-txt-grp p {margin-top:11px;}
	.rdo-txt-grp .frm-chk + label {font-size:12px;line-height:20px;}
	/* choose one box */
	.choose-one-box {padding:35px 0 0 0;}
	.choose-one-box h1 {margin-bottom:28px;font-size:18px;line-height:21px;}
	.choose-one-box ul {padding:0 56px 30px 56px;}
	.choose-one-box a {height:29px;line-height:31px;font-size:12px;}
}

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Label ID="lblForm" runat="server"></asp:Label>
    <div>
    
    <!DOCTYPE html>
    <html lang="ko">
    <head>
    <meta charset="utf-8">
    <title>▷▷▷인터넷 결제의 모든것 페이레터◁◁◁</title>
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <meta name="format-detection" content="telephone=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" type="text/css" href="/css/common.css">
    <style>
        .hide {display:none;}
    </style>
    <!--[if IE 7]>
    <link type="text/css" rel="stylesheet" href="./css/ie7.css" />
    <![endif]-->
    <!--[if IE 8]>
    <link rel="stylesheet" type="text/css" href="./css/ie8.css">
    <![endif]-->
    <!--[if IE 9]>
    <link rel="stylesheet" type="text/css" href="./css/ie9.css">
    <![endif]-->
    <script src="/DesignTemplate/js/jquery-3.2.1.min.js"></script>
    <script>
        var fingerPrint = undefined;        
        var customScheme ="";

        $(function(){
            try 
            {
                new Fingerprint2().get(function (result, components) {
                    fingerPrint = result;
                });
            } 
            catch( e ) {
                console.log( e );
            }
        });
    </script>

    <script>
        var POQ_PGAPI_HOST = "testpgapi.payletter.com";
        var POQ_PG_TOKEN   = "" ;

        setPayState("https://"+ POQ_PGAPI_HOST +"/v1.0/payletter/paylog/state", POQ_PG_TOKEN, PAY_STATE_CERT);
    </script>

    <script>
        $(document).ready(function(){
            
                    document.getElementById("paytype05").style.display = "";
                    document.getElementById("paytype05_label").style.display = "";
                    document.getElementById("paytype06").style.display = "none";
                    document.getElementById("paytype06_label").style.display = "none";
                    $("#btnOk").on("click", function () {
                        $("#<%=form1.ClientID%>").submit();
                    });
        });
    </script>

    </head>
    <body class="default">
    <div id="pageview">
        <div class="wrap">
        <!-- skip navigation -->
        <div class="skip-nav">
        <ul>
            <li><a href="#content">본문 콘텐츠 영역으로 바로가기</a></li>
            <li><a href="#footer">확인 및 결정 영역으로 바로가기</a></li>
            <li><a href="#header">타이틀 상단으로 바로가기</a></li>
        </ul>
        </div>
        <!--// skip navigation -->
        <hr />

        <!-- header -->
        <div id="header" class="header-grp">
            <h1 class="status">
            <!--가맹점 로고-->
                
            </h1>
            <!--로고 korean ver-->
            <!--<h2 class="payletter">PAYLETTER</h2>-->
            <h2 class="payletter_k">페이레터</h2>
            <div class="simple-pay-history">
                <dl>
                    <dt>제품명</dt>
                    <dd>&#51068;&#48152; (&#44592;&#44036;&#51228;)</dd>
                </dl>
                <dl>
                    <dt>결제금액</dt>
                    <dd><!--em>(VAT 포함)</em--> <strong>3,000</strong> <span>원</span></dd>
                </dl>
                
                <dl>
                    <dt>결제일자</dt>
                    <dd>2020.01.09</dd>
                </dl>            
                
            </div>
        </div>
        <!--// header -->
        <hr />

        <!-- content -->
        <div id="content" class="content-grp">
            <!-- form group -->
            <div class="frm-grp">    
                <div class="frm-box">
                    <ul class="choose-btn-list col-type">                
                        <li class="active">
                            <a href="javascript:;" data-carrier="SKT">SKT</a>
                        </li>
                        <li>
                            <a href="javascript:;" data-carrier="KTF">KT</a>
                        </li>			
                        <li>
                            <a href="javascript:;" data-carrier="LGT">LGU+</a>
                        </li>
                        <!-- // 2018-03-12 by msuk : 통신사 추가 종료-->
                        <li id="mvnolist">
                            <div class="row">
                                <span class="field">
                                    <label for="eco" class="blind">결제하실 휴대폰이 알뜰폰일 경우에 선택해 주세요.</label>
                                    <select id="eco">
                                        <option value="MVNO" selected="selected">알뜰폰 선택</option>
                                        <!-- // 2018-03-12 by msuk : 통신사 추가 시작 -->
                                        <option value="CJH" data-carrier="CJH">헬로 모바일</option>	
                                        <option value="SKL" data-carrier="SKL">SK 7mobile</option>
                                        <option value="KCT" data-carrier="KCT">KCT</option>							
                                        <!-- // 2018-03-12 by msuk : 통신사 추가 종료 -->							
                                        <option value="KTF" data-carrier="KTF">KT 알뜰폰</option>							
                                        <option value="LGT" data-carrier="LGT">LG U+알뜰폰</option>
                                        
                                    </select>
                                </span>
                            </div>
                        </li>
                    </ul>
                    <div class="frm-box hide">			
                        <ul class="rdo-chk-list other-type space" id="paySecureType">
                            <li>
                                <input type="radio" class="frm-chk st01" checked="checked" id="paytype01" name="paytype" data-certtype="01">
                                <label for="paytype01" tabindex="0">일반결제</label>
                            </li>									
                            <li id="payTPayApp" data-show-carrier="SKT" class="hide">
                                <!--<input type="radio" class="frm-chk st01" id="paytype04" name="paytype" data-certtype="AE">
                                <label for="paytype04" class="img-type" tabindex="0"><span class="tpay">T pay 간편인증</span></label>-->
                            </li>

                            <li id="payKTPayApp" data-show-carrier="KTF" class="hide">
                                
                                <input type="radio" class="frm-chk st01" id="paytype05" name="paytype" data-certtype="AE" style="display:none;">
                                <label for="paytype05" id="paytype05_label" tabindex="0">KT 인증(App설치)</label>
                                <input type="radio" class="frm-chk st01" id="paytype06" name="paytype" data-certtype="AE" style="display:none;" value="pass">
                                <label for="paytype06" id="paytype06_label" tabindex="0">KT PASS</label>
                            </li>


                            <li id="paySecureTypePasswd" data-show-carrier="SKL|KCT|CJH" class="hide">
                                <input type="radio" class="frm-chk st01" id="paytype02" name="paytype" data-certtype="01">
                                <label for="paytype02" class="other-line" tabindex="0">휴대폰 결제 비밀번호 사용자<a href="javascript:;" class="tip-help" id="password-help">관련 도움말 보기</a></label>
                                <div class="tip-help-box">
                                    해당 내용 설명이 들어 갑니다.
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div class="row" id="divHp">
                        <span class="field">
                            <label for="hp">- 없이 휴대폰번호 입력</label>
                            <input type="tel" id="hp" class="inp-st numberOnly" maxlength="11" autocomplete="off" required="required" data-required-msg="휴대폰 번호를 정확하게 입력해주세요."  data-required-format="^01([016789]?)-?([0-9]{3,4})-?([0-9]{4})$" /> 
                        </span>
                    </div>	
                </div>
                <div class="frm-box solo-st hide" id="payPerNoInput">
                    <p class="age_ni" style="font-size:11px">* 법정생년월일과 성별을 입력해 주세요. (예시 : 900101-1******)</p>
                    <div class="row col-type">
                        <span class="field">
                            <label for="perNo1">Y Y M M D D</label>
                            <input type="tel" id="perNo1" class="inp-st numberOnly" maxlength="6" autocomplete="off" required="required" data-required-msg="본인 생년월일을 정확하게 입력해주세요." data-required-format="[0-9]{6}$"/> 
                        </span>
                        <span class="field one-txt"><span class="txt">-</span></span>
                        <span class="field one-field">
                            <label for="perNo2"><img src="img/xhdpi/ico_secure01.png" class="sec-code" alt="보안 문자"></label>
                            <input type="tel" id="perNo2" class="inp-st numberOnly" maxlength="1" autocomplete="off" required="required" data-required-msg="주민등록번호 뒷자리를 정확하게 입력해주세요." data-required-format="[1-8]{1}"/> 
                        </span>
                        <span class="field sec-txt-set">
                            <span class="sec-txt">
                                <img src="img/xhdpi/ico_secure02.png" class="sec-code" alt="보안 문자">
                                <img src="img/xhdpi/ico_secure02.png" class="sec-code" alt="보안 문자">
                                <img src="img/xhdpi/ico_secure02.png" class="sec-code" alt="보안 문자">
                                <img src="img/xhdpi/ico_secure02.png" class="sec-code" alt="보안 문자">
                                <img src="img/xhdpi/ico_secure02.png" class="sec-code" alt="보안 문자">
                                <img src="img/xhdpi/ico_secure02.png" class="sec-code" alt="보안 문자">
                            </span>
                        </span>
                    </div>
                    <div class="row" id="paySecurePasswdInput" class="hide">
                        <span class="field">
                            <label for="carryPin">비밀번호 입력</label>
                            <input type="password" id="carryPin" class="inp-st numberOnly" maxlength="6" autocomplete="off" style="-webkit-text-security: disc;" required="required" data-required-msg="휴대폰 결제 비밀번호를 정확하게 입력해주세요.">
                        </span>
                    </div>
                </div>

                <ul class="rdo-chk-list other-type02">
                    <li class="all first_bd">
                        <input type="checkbox" class="frm-chk st01" id="all-agree" name="agreelist">
                        <label for="all-agree" tabindex=0>전체동의</label>
                    </li>
                    <li>
                        <input type="checkbox" class="frm-chk st01 checkSelect" id="agree01" name="agreelist" required="required" data-required-msg="필수 동의 항목을 모두 동의하셔야 다음 진행을 하실 수 있습니다.">
                        <label for="agree01" class="other-line agree01" tabindex=0>통신과금서비스 이용약관</label>
                        <a href="#agreement1.html" class="linker linker2">보기</a>
                    </li>
                    <li>
                        <input type="checkbox" class="frm-chk st01 checkSelect" id="agree03" name="agreelist" required="required" data-required-msg="필수 동의 항목을 모두 동의하셔야 다음 진행을 하실 수 있습니다.">
                        <label for="agree03" class="other-line agree03" tabindex=0>개인정보 수집 및 이용동의</label>
                        <a href="#agreement3.html" class="linker linker2">보기</a>
                    </li>
                    <li>
                        <input type="checkbox" class="frm-chk st01 checkSelect" id="agree02" name="agreelist" required="required" data-required-msg="필수 동의 항목을 모두 동의하셔야 다음 진행을 하실 수 있습니다.">
                        <label for="agree02" class="other-line agree02" tabindex=0>개인정보 제 3자 제공동의(이동통신사)</label>
                        <a href="#agreement2.html" class="linker linker2">보기</a>
                    </li>
                    <li data-show-carrier="SKT" class="hide">
                        <input type="checkbox" class="frm-chk st01 checkSelect" id="agree04" name="agreelist">
                        <label for="agree04" class="other-line agree04" tabindex=0>SKT 개인정보 수집 및 이용동의<b>(선택)</b></label>
                        <a href="#agreement4.html" class="linker linker2">보기</a>
                    </li>
                    <li data-show-carrier="SKT" class="hide">
                        <input type="checkbox" class="frm-chk st01 checkSelect" id="agree05" name="agreelist">
                        <label for="agree05" class="other-line agree05" tabindex=0>SKT 마케팅정보 수신동의<b>(선택)</b></label>
                        <a href="#agreement5.html" class="linker linker2">보기</a>
                    </li>
                    <li data-show-carrier="KTF" class="hide">
                        <input type="checkbox" class="frm-chk st01 checkSelect" id="agree06" name="agreelist">
                        <label for="agree06" class="other-line agree06" tabindex=0>KT 마케팅정보 수신동의<b>(선택)</b></label>
                        <a href="#agreement6.html" class="linker linker2">보기</a>
                    </li>

                </ul>
            </div>
            <!--// form group -->
        </div>
        <!--// content -->
        </div>
        <hr />
        <!-- footer -->
        <div id="footer" class="footer-grp">
            <div class="main-footer">
                <div class="btn-grp">
                    <div class="btn-row">
                        <span class="btn-cell fixed-width"><a href="#none" id="btnCnl">취소</a></span>
                        <span class="btn-cell"><a href="#none" id="btnOk" class="point">결제완료</a></span>
                    </div>
                </div>
            </div>
        </div>    
    </div>

    <div id="agreementview" class="hide">
        <div class="wrap">
            <div id="agree-content" class="content-grp"></div>
        </div>
        <hr/>
        <div id="agree-footer" class="footer-grp">
            <div class="main-footer">
                <div class="btn-grp">
                    <div class="btn-row only-one">
                        <span class="btn-cell"><a href="#none" id="agreeBtnOk" class="point">닫기</a></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="appWaiting" class="wrap hide"></div>

    <!-- Layer -->
    <div id="openAgreePayment"></div>

    <!-- Layer common -->
    <div class="cmm-pop-layer hide"></div>
    <div class="cmm-pop-wrap  hide">
        <div class="cmm-pop-inner"></div>
    </div>

    <!-- 통신사 선택 Layer -->
    <div class="cmm-pop-inner hide" id="carrierList">
        <div class="choose-one-box">
            <h1>통신사를 다시 선택해주세요</h1>
            <ul>                    
                <li class="active">
                    <a href="javascript:;" data-carrier="SKT">SKT</a>
                </li>                    
                <li>
                    <a href="javascript:;" data-carrier="KTF">KT</a>
                </li>  
                <li>
                    <a href="javascript:;" data-carrier="LGT">LG U+</a>
                </li>
                <li>
                    <a href="javascript:;" data-carrier="CJH" data-carrier-type="mvno">헬로 모바일</a>
                </li>
                <!-- // 2018-03-12 by msuk : 통신사 추가 시작 -->                    
                <li>
                    <a href="javascript:;" data-carrier="SKL" data-carrier-type="mvno">SK 7mobile</a>
                </li>
                <li>
                    <a href="javascript:;" data-carrier="KCT" data-carrier-type="mvno">KCT</a>
                </li>
                <!-- // 2018-03-12 by msuk : 통신사 추가 종료 -->
                <li>
                    <a href="javascript:;" data-carrier="KTF" data-carrier-type="mvno">KT 알뜰폰</a>
                </li>
                <li>
                    <a href="javascript:;" data-carrier="LGT" data-carrier-type="mvno">LG U+ 알뜰폰</a>
                </li>                    
            </ul>
        </div>

        <div class="btn-grp">
            <div class="btn-row">
                <span class="btn-cell"><a href="javascript:;" class="close-layer" id="popupCancel">취소</a></span>
                <span class="btn-cell"><a href="javascript:;" id="popupOk" class="point">확인</a></span>
            </div>
        </div>
    </div> 

    <!-- 결제 확인  Layer -->
    <div class="cmm-pop-inner hide" id="div-auth-confirm">
        <div class="rdo-txt-grp">
            <h2>결제 완료하시겠어요?</h2>

            <p>
                <input type="checkbox" class="frm-chk st01" id="msgbox_agree01" name="pay-chk">
                <label for="msgbox_agree01" tabindex="0" class="other-line">결제 내용을 확인하였습니다.<br> 휴대폰 결제 요금은 익월 휴대폰요금에<br> 합산 되어 청구됩니다. </label>
            </p>

        </div>
        <div class="btn-grp">
            <div class="btn-row">
                <span class="btn-cell"><a href="javascript:;" class="close-layer" tabindex="0">취소</a></span>
                <span class="btn-cell"><a href="javascript:;" class="point dimmed" id="msgBoxOk" tabindex="0">확인</a></span>
            </div>
        </div>
    </div>

    <!-- MessageBox Layer -->
    <div class="cmm-pop-inner hide" id="div-cnl-payment">
        <div class="rdo-txt-grp">
            <h2 id="title">결제를 취소하시겠어요?</h2>
        </div>
        <div class="btn-grp">
            <div class="btn-row">
                <span class="btn-cell"><a href="javascript:;" class="close-layer" id="cnlCnlBtn" tabindex="0">취소</a></span>
                <span class="btn-cell"><a href="javascript:;" class="point" id="cnlOkBtn" tabindex="0">확인</a></span>
            </div>
        </div>
    </div>

    <div class="cmm-pop-inner hide" id="div-agree-payment">
        <div class="rdo-txt-grp">
            <h2 id="title"></h2>
        </div>
        <div class="btn-grp">
            <div class="btn-row">
                <span class="btn-cell"><a href="javascript:;" class="close-layer" id="agreeCnlBtn" tabindex="0">취소</a></span>
                <span class="btn-cell"><a href="javascript:;" class="point" id="agreeOkBtn" tabindex="0">이용동의</a></span>
            </div>
        </div>
    </div>

    <!-- Layer -->

    <!-- Loading Layer -->
    <div id="impayLoadingBar" class="hide">
        <div class="above-all-layer"></div>
        <div class="loading-box">
            <div class="ani-box gif"></div>
        </div>
    </div>
        
    </script>

    
    <!--// footer -->
    
<script>
    var PGAPI_HOST = "testpgapi.payletter.com";
</script>
<script src="/jscript/iTracerAF_v30/json2.js"></script>
<script src="/jscript/iTracerAF_v30/swfobject-min.js"></script>
<script src="/jscript/iTracerAF_v30/itraceraf.cfg.js"></script>
<script src="/jscript/iTracerAF_v30/itraceraf.js"></script>  
<script src="/jscript/fds.js?v=1"></script>
<script>
    
  initFdsForm("payParamForm", "");

</script>


    </body>
    </html>

    </div>
    </form>
</body>
</html>
