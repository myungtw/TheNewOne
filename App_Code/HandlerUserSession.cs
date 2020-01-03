using System;
using System.Web;

using bill.payletter.com.CommonModule;

namespace bill.payletter.com.Session
{
    //================================================================
    // FileName        : HandlerUserSession.cs
    // Description     : User Cookie Decrypt & Check.
    // Copyright 2017 by PayLetter Inc. All rights reserved.
    // Author          : shshin@payletter.com, 2017-09-12
    // Modify History  : shshin@payletter.com, 2017-10-25, _blnSerialYN 추가
    //================================================================
    public class HandlerUserSession
    {
        #region private Variables
        private bool   _isLogin         = false;
        private Int16  _intSiteCode     = 0;
        private int    _intUserNo       = 0;
        private string _strUserID       = string.Empty;
        private string _strUserName     = string.Empty;

        private string _strBirthDate    = string.Empty;
        private Int16  _intGender       = 0;
        private string _strGender       = string.Empty;
        private string _strEmail        = string.Empty;
        
        private string _strUserNick     = string.Empty;
        private string _strUserNickIMG  = string.Empty;
        private string _strCookieDomain = string.Empty;

        private bool   _blnSerialYN     = false;
        #endregion

        ///----------------------------------------------------------------------
        /// <summary>
        /// 이용자 정보 초기화        
        /// </summary>
        ///----------------------------------------------------------------------
        public void ClearUserInfo()
        {
            _isLogin        = false;
            _intUserNo      = 0;
            _strUserID      = string.Empty;
            _strUserName    = string.Empty;
            _strGender      = string.Empty;

            _strEmail       = string.Empty;
            _strBirthDate   = string.Empty;
            _strUserNick    = string.Empty;
            _strUserNickIMG = string.Empty;
            _intSiteCode    = 0;

            return;
        }
        
        ///----------------------------------------------------------------------
        /// <summary>
        /// Get User number 
        /// </summary>
        ///----------------------------------------------------------------------
        public int intUserNo
        {
            get { return _intUserNo; }
        }

        public string strUserID
        {
            get { return _strUserID; }
        }
        
        public string strUserNick
        {
            get { return _strUserNick; }
        }

        public string strUserName
        {
            get { return _strUserName; }
        }

        public string strBirthDate
        {
            get { return _strBirthDate; }
        }

        public Int16 intGender
        {
            get { return _intGender; }
        }

        public string strEmail
        {
            get { return _strEmail; }
        }

        public string strUserNickIMG
        {
            get { return _strUserNickIMG; }
        }

        public bool isLogin
        {
            get { return _isLogin; }
        }

        public bool blnSerialYN
        {
            get { return _blnSerialYN; }
        }
    }

}