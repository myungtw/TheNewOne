using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

using bill.payletter.com.CommonModule;

///////////////////////////////////////////////////////////////////////////////
/// FileName        : DBConnBase.cs
/// Description     : DataBase의 종류에 상관없이 DB 작업을 관리
/// Copyright ⓒ 2007 by PayLetter Inc. All rights reserved.
/// Author          : zzangy@payletter.com, 2007-07-02
/// Modify History  : Just Created.
///////////////////////////////////////////////////////////////////////////////
namespace bill.payletter.com.DataAccess
{
    ///================================================================================
    /// Name           : DBConnBase
    /// Description    : <summary>DataBase의 종류에 상관없이 DB 작업을 관리한다.</summary>
    /// Author         : zzangy@payletter.com, 2007-07-02
    /// Modify History : Just Created.
    ///================================================================================
    public class DBConnBase
    {
        #region Public Variables

        public SqlConnection objConn;
        public SqlCommand objCmd;
        public SqlDataReader objDR;
        public SqlCommandBuilder objCB;
        public SqlTransaction objTran;

        public DataSet objDS;
        public DataTable objDT;
        public DataRow objDTRow;
        public CommandType _commandType = CommandType.Text;

        public Dictionary<int, Dictionary<string, string>> objDic;
        public Dictionary<string, string> objDicItem;

        #endregion

        #region Private Variables

        private EditMode _editMode;
        private ReadWriteType _readWriteType;
        private int _intTablePosition;
        private int _intRowPosition;
        private int _intParamPosIndex;

        private int _intPageSize;
        private int _intPagePosition;
        private int _intPageCount;

        #endregion

        #region Method

        ///----------------------------------------------------------------------
        /// <summary>
        /// DB Connection 연결을 위한 ConnectionString을 조회 한다.
        /// </summary>
        /// <param name="strConn"></param>
        /// <returns></returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public string GetDBConnStr(string strConn)
        {
            if (strConn == null)
            {
                string strConnStr = ConfigurationManager.AppSettings["BOQBILL_DB"];
                if (strConnStr == null)
                {
                    throw new Exception("web.config Setting Miss >> configuration>appSettings> [BOQBILL_DB]");
                }

                strConn = strConnStr;
            }
            else
            {
                string strConnStr = ConfigurationManager.AppSettings[strConn];
                if (strConnStr == null)
                {
                    throw new Exception("web.config Setting Miss >> configuration>appSettings> [" + strConn + "]");
                }

                strConn = strConnStr;
            }

            ConnectionStringSettings ConnStrSet = ConfigurationManager.ConnectionStrings[strConn];
            if (ConnStrSet == null)
            {
                throw new Exception(String.Format("web.config Setting Miss >> configuration>connectionStrings> [{0}]", strConn));
            }

            if (ConnStrSet.ConnectionString == null)
            {
                throw new Exception(String.Format("web.config Setting Miss >> configuration>connectionStrings>name> [{0}]", ConnStrSet.ConnectionString));
            }


            return UserGlobal.GetDecryptStr(ConnStrSet.ConnectionString);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// DB Connection 연결 한다. 
        /// 이미 연결된 경우 연결을 닫은 후 재연결 한다.
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Open()
        {
            this.Open(null);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// DB Connection 연결 한다. 
        /// 이미 연결된 경우 연결을 닫은 후 재연결 한다.
        /// </summary>
        /// <param name="strConn">AppSettings.config에 정의된 키</param>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Open(string strConn)
        {
            CloseReader();
            CloseTable();

            if (objConn == null)
            {
                objConn = new SqlConnection(GetDBConnStr(strConn));
            }
            if (objConn.State != ConnectionState.Closed)
            {
                objConn.Close();
            }

            if (objConn.State == ConnectionState.Closed)
            {
                objConn.Open();
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 연결된 DB Connection을 닫는다.
        /// 이때, DB 자원과 연결된 모든 자원 및 데이타를 해제 한다.
        /// [DataReader, DataTable, Transaction]
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Close()
        {
            CloseTable();
            CloseReader();

            if (objTran != null)
            {
                objTran.Rollback();
                objTran = null;
            }

            if (objCmd != null)
            {
                this.ClearParameter();
                objCmd.Dispose();
                objCmd = null;
            }

            if (objConn != null && objConn.State != ConnectionState.Closed)
            {
                objConn.Close();
            }

            objConn.Dispose();
            objConn = null;

        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// ReadOnly로 연결한 DataReader를 닫는다.
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void CloseReader()
        {
            if (objDR != null)
            {
                objDR.Close();
            }
            objDR = null;

            _intPageSize = 0;
            _intPageCount = 0;
            _intPagePosition = 0;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 편집전용으로 연결한 DataTable을 해제한다.
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        /// ----------------------------------------------------------------------
        public void CloseTable()
        {
            if (objDT != null)
            {
                objDTRow = null;

                objDT.Dispose();
                objDT = null;
            }
            if (objDS != null)
            {
                objDS.Dispose();
                objDS = null;
            }
            if (objCB != null)
            {
                if (objCB.DataAdapter != null)
                {
                    objCB.DataAdapter.Dispose();
                    objCB.DataAdapter = null;
                }

                objCB.Dispose();
                objCB = null;
            }

            _readWriteType = ReadWriteType.ReadOnly;
            _intTablePosition = -1;
            _intRowPosition = -1;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// ReadOnly로 연결한 DataReader를 닫고, Dictionary를 해제한다..
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-08-20
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void CloseDictionary()
        {
            CloseReader();
            if (objDic != null)
            {
                objDic.Clear();
            }
            objDic = null;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 지정한 위치의 쿼리 결과로 이동한다.
        /// </summary>
        /// <param name="pPosition">이동위치</param>
        /// <returns>이동결과</returns>
        /// Author         : zzangy@payletter.com, 2007-11-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool MoveResultSet(int pPosition)
        {
            if (_readWriteType == ReadWriteType.ReadOnly || pPosition < 0 || pPosition >= objDS.Tables.Count)
            {
                return false;
            }

            _intRowPosition = -1;
            _intTablePosition = pPosition;
            objDT = objDS.Tables[pPosition];
            return true;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 다음 쿼리 결과로 이동한다.(ADO의 NextResult)
        /// </summary>
        /// <returns>이동결과</returns>
        /// Author         : zzangy@payletter.com, 2007-11-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool NextResultSet()
        {
            return MoveResultSet(++_intTablePosition);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SQL Query 문장을 실행
        /// </summary>
        /// <param name="pSql"></param>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void SetQuery(string pSql)
        {
            SetQuery(pSql, 0);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SQL Query 문장을 실행
        /// </summary>
        /// <param name="pSql"></param>
        /// <param name="pCursorType"></param>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------   
        public void SetQuery(string pSql, ReadWriteType pCursorType)
        {
            SetQuery(pSql, pCursorType, CommandBehavior.Default);
        }


        ///----------------------------------------------------------------------
        /// <summary>
        /// SQL Query 문장을 실행
        /// <param name="pSql"></param>
        /// <param name="pCursorType"></param>
        /// <param name="pCommBehavior"></param>
        /// </summary>
        /// <remarks> CommandBehavior 의 동작모드 설명
        ///     CloseConnection  : 데이터 판독기가 닫힐 때 연결을 자동으로 닫습니다.  
        ///     Default          : 이 옵션을 설정할 경우 매개 변수를 지정하지 않고 ExecuteReader를 호출할 때와 같은 결과가 발생합니다.  
        ///     KeyInfo          : 이 쿼리는 열 메타데이터 및 기본 키 정보만 반환합니다.  
        ///     SchemaOnly       : 이 쿼리는 열 메타데이터만 반환합니다. 
        ///     SequentialAccess : 이 명령을 지정하면 판독기는 데이터를 순차적 스트림으로 로드합니다.  
        ///     SingleResult     : 첫 번째 결과 집합만 반환됩니다.  
        ///     SingleRow        : 이 쿼리는 단일 행을 반환해야 합니다.  
        /// </remarks>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------     
        public void SetQuery(string pSql, ReadWriteType pCursorType, CommandBehavior pCommBehavior)
        {
            _editMode = EditMode.None;

            if (this.CommandType != CommandType.StoredProcedure)
            {
                this.ClearParameter();
            }

            if (pCursorType == ReadWriteType.ReadWrite || _readWriteType == ReadWriteType.ReadWrite)
            {
                CloseTable();

                if (objCmd == null)
                {
                    objCmd = new SqlCommand(pSql);
                }
                else
                {
                    objCmd.CommandText = pSql;
                }
                objCmd.CommandType = this.CommandType;

                objCmd.Connection = objConn;
                if (objTran != null)
                {
                    objCmd.Transaction = objTran;
                }

                objDS = new DataSet();
                //objDT = new DataTable();
                objCB = new SqlCommandBuilder(new SqlDataAdapter(objCmd));

                objCB.DataAdapter.Fill(objDS);
                if (objDS.Tables.Count > 0)
                {
                    objDT = objDS.Tables[0];

                    _readWriteType = ReadWriteType.ReadWrite;
                    _intTablePosition = 0;
                    _intRowPosition = -1;

                    //페이징 처리
                    if (_intPageSize > 0 && objDT.Rows.Count > 0)
                    {
                        _intPageCount = (int)Math.Floor((objDT.Rows.Count - 1) / (double)_intPageSize) + 1;
                        if (_intPagePosition > _intPageCount)
                        {
                            _intPagePosition = _intPageCount;
                        }
                        this.MoveAbsolute((_intPageSize * (_intPagePosition - 1)) - 1);
                    }
                    else
                    {
                        _intPageCount = 0;
                        _intPageSize = 0;
                        _intPagePosition = 0;
                    }
                }
            }
            else
            {
                //CloseReader();

                if (objCmd == null)
                {
                    objCmd = new SqlCommand(pSql);
                }
                else
                {
                    objCmd.CommandText = pSql;
                }
                objCmd.CommandType = this.CommandType;

                objCmd.Connection = objConn;

                if (objTran != null)
                {
                    objCmd.Transaction = objTran;
                }

                objDR = objCmd.ExecuteReader(pCommBehavior);
                CloseReader();              // add public27@payletter.com

                _readWriteType = ReadWriteType.ReadOnly;
                _intPageCount = 0;
                _intPageSize = 0;
                _intPagePosition = 0;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SELECT가 아닌 INSERT, UPDATE, DELETE 등의 데이타 작업및 StoredProcedure 등을 실행한다.
        /// </summary>
        /// <param name="pSql">쿼리문장 또는 StoredProcedure명</param>
        /// <returns>실행 반영된 행수 또는 StoredProcedure의 return 값</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public int ExecuteNonQuery(string pSql)
        {
            CloseReader();
            CloseTable();

            if (objCmd == null)
            {
                objCmd = new SqlCommand(pSql);
            }
            else
            {
                objCmd.CommandText = pSql;
            }
            objCmd.CommandType = this.CommandType;

            objCmd.Connection = objConn;

            if (objTran != null)
            {
                objCmd.Transaction = objTran;
            }

            return objCmd.ExecuteNonQuery();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재 설정된 StoredProcedure 파라메터를 가져온다.
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DBParam GetParam()
        {
            return GetParam(-1);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 해당 인덱스의 StoredProcedure 파라미터를 가져온다.
        /// </summary>
        /// <param name="pParamPosIndex"></param>
        /// <returns></returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DBParam GetParam(int pParamPosIndex)
        {
            if (pParamPosIndex >= objCmd.Parameters.Count)
            {
                throw new Exception("Parameter Over!");
            }
            else
            {
                if (objCmd.Parameters.Count == 0)
                {
                    throw new Exception("Empty Parameter.");
                }

                if (pParamPosIndex != -1)
                {
                    _intParamPosIndex = pParamPosIndex;
                }
            }

            return new DBParam(objCmd.Parameters[_intParamPosIndex]);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 파라미터에 해당하는 StoredProcedure 파라메터를 가져온다.
        /// </summary>
        /// <param name="pParamName"></param>
        /// <returns></returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DBParam GetParam(string pParamName)
        {
            try
            {
                _intParamPosIndex = objCmd.Parameters.IndexOf(pParamName.Replace("@", ""));
            }
            catch
            {
                throw new Exception("'" + pParamName.Replace("@", "") + "' Not Found!");
            }

            return new DBParam(objCmd.Parameters[_intParamPosIndex]);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// StoredProcedure 파라메터를 생성한다.
        /// </summary>
        /// <returns>생성된 StoredProcedure 파라메터</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DBParam AddParam()
        {
            if (objCmd == null)
            {
                objCmd = new SqlCommand();
                objCmd.Connection = objConn;
            }

            this.ParamPosIndex = objCmd.Parameters.Count;

            objCmd.Parameters.Add(new SqlParameter());

            return new DBParam(objCmd.Parameters[this.ParamPosIndex]);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// StoredProcedure 파라메터를 생성하고 파라메터명과 값을 할당한다.
        /// </summary>
        /// <param name="pName">파라메터명(StoredProcedure에 선언된 Name)</param>
        /// <param name="pValue">파라메터에 입력할 값</param>
        /// <returns>생성된 StoredProcedure 파라메터</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DBParam AddParam(string pName, object pValue)
        {
            DBParam param = AddParam();

            param.Name = pName.Replace("@", "");
            param.Column = pName.Replace("@", "");
            param.Value = pValue;

            return param;
        }

        /*
        /// <summary>
        /// StoredProcedure 파라메터를 생성하고 파라메터명과 값과 입출력 방향을 할당한다.
        /// </summary>
        /// <param name="pName">파라메터명(StoredProcedure에 선언된 Name)</param>
        /// <param name="pValue">파라메터에 입력할 값</param>
        /// <param name="pDirection">파라메터의 입출력방향(in, out, inout)</param>
        /// <returns></returns>
        public DBParam AddParam(string pName, object pValue, ParameterDirection pDirection)
        {
            DBParam param = AddParam(pName, pValue);

            param.Direction = pDirection;
            if(pDirection == ParameterDirection.InputOutput || pDirection == ParameterDirection.Output)
            {
                if (param.Size == 0)
                {
                    param.Size = 255;
                }
            }

            return param;
        }
        */

        ///----------------------------------------------------------------------
        /// <summary>
        /// pDBType 은 다음을 참고한다. : http://msdn2.microsoft.com/ko-kr/library/bbw6zyha(VS.80).aspx
        /// </summary>
        /// <param name="pName"></param>
        /// <param name="pDBType">http://msdn2.microsoft.com/ko-kr/library/bbw6zyha(VS.80).aspx</param>
        /// <param name="pValue"></param>
        /// <param name="pSize"></param>
        /// <param name="pDirection"></param>
        /// <param name="pPrecision"></param>
        /// <param name="pScale"></param>
        /// <returns></returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DBParam AddParam(string pName, DbType pDBType, object pValue, int pSize, ParameterDirection pDirection, byte pPrecision, byte pScale)
        {
            DBParam param = this.AddParam();

            param.Name = pName.Replace("@", "");
            param.Column = pName.Replace("@", "");
            param.Type = pDBType;
            param.Value = pValue;
            param.Size = pSize;
            param.Direction = pDirection;
            param.Precision = pPrecision;
            param.Scale = pScale;

            return param;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재 추가된 모든 StoredProcedure 파라메터를 지운다.
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void ClearParameter()
        {
            if (objCmd != null)
            {
                objCmd.Parameters.Clear();
            }
            _intParamPosIndex = -1;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SetQuery에 의해 실행한 결과를 DataTable로 반환한다.
        /// </summary>
        /// <returns>DataTable</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DataTable GetPageData()
        {
            DataTable rDT = objDT.Clone();

            while (this.ReadOnPage())
            {
                rDT.ImportRow(objDT.Rows[this.CurRow]);
            }

            return rDT;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SetQuery에 의해 실행한 결과를 DataTable로 반환한다(데이터테이블의 마지막 행을 페이지에 항상 출력한다).
        /// </summary>
        /// <returns>DataTable</returns>
        /// Author         : moondae@payletter.com, 2007-10-20
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public DataTable GetPageData_AddLastRow()
        {
            DataTable rDT = objDT.Clone();

            while (this.ReadOnPage())
            {
                rDT.ImportRow(objDT.Rows[this.CurRow]);
            }
            if (_intPageCount != _intPagePosition)
                rDT.ImportRow(objDT.Rows[objDT.Rows.Count - 1]);

            return rDT;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SetQuery에 의해 실행한 결과를 Dictionary에 저장한다.
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-08-08
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void SetDictionaryData()
        {
            objDic = new Dictionary<int, Dictionary<string, string>>();

            int IntLoopRecord = 0;
            int IntLoopField = 0;

            while (Read())
            {
                objDicItem = new Dictionary<string, string>();

                for (IntLoopField = 0; IntLoopField < objDR.FieldCount; IntLoopField++)
                {
                    objDicItem.Add(objDR.GetName(IntLoopField).ToUpper(), objDR.GetValue(IntLoopField).ToString());
                }

                objDic.Add(IntLoopRecord, objDicItem);
                objDicItem = null;
                IntLoopRecord++;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SetQuery에 의해 실행한 결과를 Dictionary에 저장한다.
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-08-08
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void SetDictionaryData(string pSql)
        {
            SetQuery(pSql, 0);
            SetDictionaryData();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SetQuery에 의해 실행한 결과를 1 Record 읽어오고 커서를 다음으로 넘긴다.
        /// </summary>
        /// <returns>
        /// 읽기를 실행한 결과
        /// true  : 데이타를 정상적으로 읽음
        /// false : 읽을 데이타 없음
        /// </returns>
        /// <remarks>읽기전용 모드(ReadCursorType.ReadOnly)시에 읽을 데이타가 없는데 또 Read()를 호출하면 에러발생</remarks>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool Read()
        {
            if (_readWriteType == ReadWriteType.ReadOnly)
            {
                if (objDR == null)
                {
                    objDR = objCmd.ExecuteReader();
                }
                return objDR.Read();
            }
            else if (_readWriteType == ReadWriteType.ReadWrite)
            {
                return ReadNext();
            }

            return false;
        }

        public bool ReadOnPage()
        {
            if (_readWriteType == ReadWriteType.ReadWrite)
            {
                if (objDT.Rows.Count - 1 > _intRowPosition)
                {
                    _intRowPosition++;
                    if (_intRowPosition < (_intPageSize * _intPagePosition))
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    _intRowPosition = -1;
                    return false;
                }

            }
            else
            {
                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서를 다음으로 옮긴다
        /// </summary>
        /// <returns>커서를 옮긴결과, ReadOnly 모드일때는 무조건 false</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool ReadNext()
        {
            if (_readWriteType == ReadWriteType.ReadWrite && objDT.Rows.Count - 1 > _intRowPosition)
            {
                _intRowPosition++;
                return true;
            }
            else
            {
                _intRowPosition = -1;
                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서를 이전으로 옮긴다.
        /// </summary>
        /// <returns>커서를 옮길 수 없거나, ReadOnly 모드일때는 false</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool ReadPrevious()
        {
            if (_readWriteType == ReadWriteType.ReadWrite && _intRowPosition > 0)
            {
                _intRowPosition--;
                return true;
            }
            else
            {
                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서를 맨처음으로 옮긴다
        /// </summary>
        /// <returns>커서를 옮길 수 없거나, ReadOnly 모드일때는 false</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool MoveFirst()
        {
            if (_readWriteType == ReadWriteType.ReadWrite)
            {
                if (objDT.Rows.Count > 0)
                {
                    _intRowPosition = 0;
                    return true;
                }
                else
                {
                    _intRowPosition = -1;
                    return false;
                }
            }
            return false;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서를 맨마지막으로 옮긴다
        /// </summary>
        /// <returns>커서를 옮길 수 없거나, ReadOnly 모드일때는 false</returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool MoveLast()
        {
            if (_readWriteType == ReadWriteType.ReadWrite)
            {
                if (objDT.Rows.Count > 0)
                {
                    _intRowPosition = objDT.Rows.Count - 1;
                    return true;
                }
                else
                {
                    _intRowPosition = -1;
                    return false;
                }
            }
            return false;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서를 지정행으로 옮긴다.
        /// 0 base position
        /// </summary>
        /// <param name="pRowPosition"></param>
        /// <returns></returns>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public bool MoveAbsolute(int pRowPosition)
        {
            if (_readWriteType == ReadWriteType.ReadWrite)
            {
                if (objDT.Rows.Count > 0 && objDT.Rows.Count > pRowPosition && pRowPosition >= 0)
                {
                    _intRowPosition = pRowPosition;
                    return true;
                }
                else
                {
                    _intRowPosition = -1;
                    return false;
                }
            }
            return false;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재의 Connection에서 트랜잭션을 시작한다.
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void BeginTrans()
        {
            BeginTrans(IsolationLevel.ReadCommitted);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재의 Connection에서 트랜잭션은 pLevel모드로 시작한다.
        /// </summary>
        /// <param name="pLevel"></param>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void BeginTrans(IsolationLevel pLevel)
        {
            objTran = objConn.BeginTransaction(pLevel);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 트랜잭션 커밋
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Commit()
        {
            objTran.Commit();
            objTran = null;
            objCmd.Transaction = null;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 트랜잭션 롤백
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Rollback()
        {
            if (objTran != null)
            {
                objTran.Rollback();
            }
            objTran = null;
            objCmd.Transaction = null;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 개체 소멸시 DB Connection 등 모든 자원 해제
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        ~DBConnBase()
        {
            try
            {
                this.Close();
            }
            catch(Exception ex)
            {   
            }

        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 신규 데이타를 입력시킨다.(ReadWrite일때만 가능)
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void AddNew()
        {
            if (_readWriteType == ReadWriteType.ReadOnly)
            {
                throw new Exception("Not Edit Mode.");
            }

            _editMode = EditMode.Add;
            objDTRow = objDT.NewRow();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재행의 데이타를 수정한다.(ReadWrite일때만 가능)
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Edit()
        {
            if (_readWriteType != ReadWriteType.ReadWrite)
            {
                throw new Exception("Not Edit Mode.");
            }

            if (_intRowPosition == -1)
            {
                if (this.ReadNext())
                {
                    _editMode = EditMode.Modify;
                    objDTRow = objDT.Rows[_intRowPosition];
                    objDTRow.BeginEdit();
                }
                else
                {
                    _editMode = EditMode.Add;
                    objDTRow = objDT.NewRow();
                }
            }
            else
            {
                _editMode = EditMode.Modify;
                objDTRow = objDT.Rows[_intRowPosition];
                objDTRow.BeginEdit();
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재행을 삭제한다.(ReadWrite일때만 가능)
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Delete()
        {
            if (_readWriteType != ReadWriteType.ReadWrite)
            {
                throw new Exception("Not Delete Mode.");
            }

            if (_intRowPosition == -1)
            {
                if (this.ReadNext())
                {
                    _editMode = EditMode.Delete;
                    objDT.Rows[_intRowPosition].Delete();
                    _intRowPosition--;
                }
                else
                {
                    this.Close();
                    throw new Exception("Empty Row.");
                }
            }
            else
            {
                _editMode = EditMode.Delete;
                objDT.Rows[_intRowPosition].Delete();
                _intRowPosition--;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Add, Edit, Delete 한 결과를 실제 DB 에 반영처리한다.(ReadWrite일때만 가능)
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Update()
        {
            if (_editMode == EditMode.None || _readWriteType != ReadWriteType.ReadWrite)
            {
                throw new Exception("Not Edit Mode.");
            }

            if (_editMode == EditMode.Modify)
            {
                objDTRow.EndEdit();

                objCB.DataAdapter.UpdateCommand = objCB.GetUpdateCommand();
            }
            else if (_editMode == EditMode.Add)
            {
                objDT.Rows.Add(objDTRow);
                _intRowPosition = objDT.Rows.Count - 1;

                objCB.DataAdapter.InsertCommand = objCB.GetInsertCommand();
            }
            else if (_editMode == EditMode.Delete)
            {
                objCB.DataAdapter.DeleteCommand = objCB.GetDeleteCommand();
            }


            objCB.DataAdapter.Update(objDT.GetChanges());

            objDT.AcceptChanges();

            objDTRow = null;
            _editMode = EditMode.None;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Add, Edit, Delete하던 작업을 취소한다.((ReadWrite일때만 가능))
        /// </summary>
        /// Author         : zzangy@payletter.com, 2007-07-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public void Cancel()
        {
            if (_readWriteType == ReadWriteType.ReadWrite)
            {
                if (_editMode == EditMode.Modify)
                {
                    objDTRow.CancelEdit();
                }
                else if (_editMode == EditMode.Add)
                {
                    objDTRow = null;
                }
            }

            _editMode = EditMode.None;
        }

        #endregion

        #region Attribute
        ///----------------------------------------------------------------------
        /// <summary>
        /// DB와의 작업시 작업명령의 타입
        /// SQL Query, StoredProcedure, Table명
        /// </summary>
        ///----------------------------------------------------------------------
        public CommandType CommandType
        {
            get { return _commandType; }
            set { _commandType = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서타입
        /// </summary>
        ///----------------------------------------------------------------------    
        public ReadWriteType CursorType
        {
            set { _readWriteType = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재 작업중인 StoredProcedure 파라메터의 인덱스를 정한다.
        /// </summary>
        ///----------------------------------------------------------------------
        public int ParamPosIndex
        {
            get { return _intParamPosIndex; }
            set { _intParamPosIndex = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 결과집합에 행이 있는지 유무를 리턴
        /// </summary>
        /// <returns></returns>
        ///----------------------------------------------------------------------
        public bool isHasRows
        {
            get
            {
                if (_readWriteType == ReadWriteType.ReadOnly)
                {
                    if (objDR != null)
                    {
                        return objDR.HasRows;
                    }
                }
                else if (_readWriteType == ReadWriteType.ReadWrite)
                {
                    if (objDT != null && objDT.Rows.Count != 0)
                    {
                        return true;
                    }
                }

                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 페이징 크기
        /// </summary>
        ///----------------------------------------------------------------------
        public int PageSize
        {
            get { return _intPageSize; }
            set { _intPageSize = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 총 페이지 수
        /// </summary>
        ///----------------------------------------------------------------------
        public int PageCount
        {
            get { return _intPageCount; }
            set { _intPageCount = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재 페이지
        /// </summary>
        ///----------------------------------------------------------------------
        public int PagePosition
        {
            get { return _intPagePosition; }
            set
            {
                _intPagePosition = value;

                //페이징
                if (_intPageSize > 0 && this.RecordCount > 0)
                {
                    if (_intPagePosition > _intPageCount)
                    {
                        _intPagePosition = _intPageCount;
                    }
                    this.MoveAbsolute((_intPageSize * (_intPagePosition - 1)) - 1);
                }
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 현재행을 설정하거나 가져온다.(ReadWrite일때만 가능)
        /// </summary>
        ///----------------------------------------------------------------------
        public int CurRow
        {
            get { return _intRowPosition; }
            set { _intRowPosition = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 커서가 맨마지막에 있는지 여부
        /// </summary>
        ///----------------------------------------------------------------------
        public bool isLast
        {
            get
            {
                if (_readWriteType == ReadWriteType.ReadWrite)
                {
                    if (_intRowPosition == objDT.Rows.Count - 1)
                    {
                        return true;
                    }
                }
                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SetQuery 실행한 결과 갯수(ReadWrite일때만 가능)
        /// </summary>
        ///----------------------------------------------------------------------
        public int RecordCount
        {
            get
            {
                if (_readWriteType == ReadWriteType.ReadWrite)
                {
                    return objDT.Rows.Count;
                }

                return -1;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// EditMode가 신규 입력인지 여부를 리턴
        /// </summary>
        ///----------------------------------------------------------------------
        public bool isAddNew
        {
            get
            {
                if (_editMode == EditMode.Add)
                    return true;
                else
                    return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 필드명에 해당하는 컬럼 데이타를 읽어온다.
        /// </summary>
        /// <param name="pFieldName"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------
        public object this[string pFieldName]
        {
            get
            {
                if (_readWriteType == ReadWriteType.ReadOnly)
                {
                    return objDR[pFieldName];
                }
                else
                {
                    return objDT.Rows[_intRowPosition][pFieldName];
                }
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 필드 인덱스에 해당하는 컬럼 데이타를 읽어온다.
        /// </summary>
        /// <param name="pFieldIndex"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------
        public object this[int pFieldIndex]
        {
            get
            {
                if (_readWriteType == ReadWriteType.ReadOnly)
                {
                    return objDR[pFieldIndex];
                }
                else
                {
                    return objDT.Rows[_intRowPosition][pFieldIndex];
                }
            }
        }

        public string GetString(int pFieldIndex)
        {
            return Convert.ToString(this[pFieldIndex]);
        }
        public string GetString(string pFieldName)
        {
            return Convert.ToString(this[pFieldName]);
        }

        public int GetInt(int pFieldIndex)
        {
            return Convert.ToInt32(this[pFieldIndex]);
        }
        public int GetInt(string pFieldName)
        {
            return Convert.ToInt32(this[pFieldName]);
        }

        public Int16 GetInt16(int pFieldIndex)
        {
            return Convert.ToInt16(this[pFieldIndex]);
        }
        public Int16 GetInt16(string pFieldName)
        {
            return Convert.ToInt16(this[pFieldName]);
        }

        public bool GetBool(int pFieldIndex)
        {
            return Convert.ToBoolean(this[pFieldIndex]);
        }
        public bool GetBool(string pFieldName)
        {
            return Convert.ToBoolean(this[pFieldName]);
        }

        public decimal GetDecimal(int pFieldIndex)
        {
            return Convert.ToDecimal(this[pFieldIndex]);
        }
        public decimal GetDecimal(string pFieldName)
        {
            return Convert.ToDecimal(this[pFieldName]);
        }

        public DateTime GetDateTime(int pFieldIndex)
        {
            return Convert.ToDateTime(this[pFieldIndex]);
        }
        public DateTime GetDateTime(string pFieldName)
        {
            return Convert.ToDateTime(this[pFieldName]);
        }

        #endregion
    }


    ///================================================================================
    /// Name           : ReadWriteType
    /// Description    : <summary>DB의 결과를 가져오는 방식
    ///                  ReadOnly  : DataReader를 사용한 읽기전용 모드
    ///                  ReadWrite : DataTable에 결과를 할당한 편집/커서이동이 자유로운 모드</summary>
    ///================================================================================
    public enum ReadWriteType
    {
        ReadOnly = 0,
        ReadWrite = 1
    }

    ///================================================================================
    /// Name           : EditMode
    /// Description    : <summary>ReadWriteType이 ReadWrite 일때 편집모드
    ///                  None   : 편집모드 아님
    ///                  Add    : 신규모드
    ///                  Modify : 수정모드
    ///                  Delete : 삭제모드</summary>
    ///================================================================================
    public enum EditMode
    {
        None = 0,
        Add = 1,
        Modify = 2,
        Delete = 3
    }

    ///================================================================================
    /// Name           : DBParam
    /// Description    : <summary>StoredProcedure에 사용할 파라메터를 Wrapping 한다.
    ///                  DB의 종류에 상관없이 사용가능하도록 한다.</summary>
    ///================================================================================
    public class DBParam
    {
        private SqlParameter _param;

        public DBParam(SqlParameter pParam)
        {
            _param = pParam;
        }

        /*
         * public DBParam(OracleParameter pParam)
        {
            _param = pParam;
        }
        */

        ///----------------------------------------------------------------------
        /// <summary>
        /// 파라메터 고유 ID
        /// </summary>
        ///----------------------------------------------------------------------
        public string Name
        {
            get { return _param.ParameterName; }
            set { _param.ParameterName = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// StoredProcedure 에서 사용한 파라메터 명
        /// </summary>
        ///----------------------------------------------------------------------
        public string Column
        {
            get { return _param.SourceColumn; }
            set { _param.SourceColumn = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 파라메터 값
        /// </summary>
        ///----------------------------------------------------------------------
        public object Value
        {
            get { return _param.Value; }
            set { _param.Value = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 데이터 타입
        /// Type은 다음을 참고한다. : http://msdn2.microsoft.com/ko-kr/library/bbw6zyha(VS.80).aspx
        /// </summary>
        ///----------------------------------------------------------------------
        public DbType Type // SqlDbType Type
        {
            get { return _param.DbType; }
            set { _param.DbType = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 문자열의 경우 문자열 길이
        /// </summary>
        ///----------------------------------------------------------------------
        public int Size
        {
            get { return _param.Size; }
            set { _param.Size = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 숫자의 최대자릿수
        /// </summary>
        ///----------------------------------------------------------------------
        public byte Precision
        {
            get { return _param.Precision; }
            set { _param.Precision = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 소수 자릿수
        /// </summary>
        ///----------------------------------------------------------------------
        public byte Scale
        {
            get { return _param.Scale; }
            set { _param.Scale = value; }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 파라메터의 입출력방향(in, out, inout)
        /// </summary>
        ///----------------------------------------------------------------------
        public ParameterDirection Direction
        {
            get { return _param.Direction; }
            set { _param.Direction = value; }
        }
    }
}
