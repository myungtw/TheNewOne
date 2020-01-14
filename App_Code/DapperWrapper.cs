using Dapper;

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace bill.payletter.com.CommonModule
{
    public class DapperWrapper
    {
        private string _connenctionStr;

        public DapperWrapper(string conn)
        {
            _connenctionStr = conn;
        }

        //리스트용(레코드셋 반환)
        #region Query
        public DapperResult QuerySP(string storedProcedure, dynamic param = null, SqlTransaction transaction = null, bool buffered = true, int? commandTimeout = null)
        {
            DapperResult         pl_objResult = null;
            IEnumerable<dynamic> pl_objData   = null;
            dynamic[]            pl_arrDatas  = null;

            try
            {
                pl_objResult = new DapperResult();

                using (SqlConnection connection = new SqlConnection(_connenctionStr))
                {
                    connection.Open();
                    
                    //Dapper 요청 로깅
                    //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][S] Param: {1}", storedProcedure, GetSerializeString(param)));

                    pl_objData = connection.Query(storedProcedure, param: (object)param, transaction: transaction, buffered: buffered, commandTimeout: GetTimeout(commandTimeout), commandType: CommandType.StoredProcedure);
                }

                //Dapper 응답 데이터
                if (pl_objData == null)
                {
                    return pl_objResult;
                }

                //RecordCount
                pl_objResult.intCount = (int)pl_objData.GetType().GetProperty("Count").GetValue(pl_objData, null);
                if (pl_objResult.intCount > 0)
                {
                    //DataTable 변환
                    pl_arrDatas = pl_objData.ToArray();
                    foreach (var data in (IDictionary<string, object>)pl_arrDatas[0])
                    {
                        pl_objResult.objDT.Columns.Add(data.Key, (data.Value ?? string.Empty).GetType());
                    }
                    foreach (var data in pl_arrDatas)
                    {
                        pl_objResult.objDT.Rows.Add(((IDictionary<string, object>)data).Values.ToArray());
                    }
                }
            }
            catch (Exception pl_objEx)
            {
                pl_objResult.intErrCode = -9999;
                pl_objResult.strErrMsg  = pl_objEx.ToString();
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][E] RetVal: {1}, ErrMsg: {2}", storedProcedure, pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }
            finally
            {
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][R] Param: {1}", storedProcedure, GetSerializeString(param)));
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][R] DataTable: {1}{2}", storedProcedure, pl_objResult.intCount.Equals(0) ? "" : "\r\n", AdmModule.GetDataTableToString(pl_objResult.objDT)));
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][R] RetVal: {1}, ErrMsg: {2}", storedProcedure, pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }

            return pl_objResult;
        }

        public DapperResult QuerySQL(string sql, dynamic param = null, SqlTransaction transaction = null, bool buffered = true, int? commandTimeout = null)
        {
            DapperResult         pl_objResult = null;
            IEnumerable<dynamic> pl_objData   = null;
            dynamic[]            pl_arrDatas  = null;

            try
            {
                pl_objResult = new DapperResult();

                //Dapper 요청 SQL 로깅
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][S] SQL: {0}", sql));

                using (SqlConnection connection = new SqlConnection(_connenctionStr))
                {
                    connection.Open();

                    //Dapper 요청 로깅
                    //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][S] Param: {0}", GetSerializeString(param)));

                    pl_objData = connection.Query(sql, param: (object)param, transaction: transaction, buffered: buffered, commandTimeout: GetTimeout(commandTimeout), commandType: CommandType.Text);
                }

                //Dapper 응답 데이터
                if (pl_objData == null)
                {
                    return pl_objResult;
                }

                //RecordCount
                pl_objResult.intCount = (int)pl_objData.GetType().GetProperty("Count").GetValue(pl_objData, null);
                if (pl_objResult.intCount > 0)
                {
                    //DataTable 변환
                    pl_arrDatas = pl_objData.ToArray();
                    foreach (var data in (IDictionary<string, object>)pl_arrDatas[0])
                    {
                        pl_objResult.objDT.Columns.Add(data.Key, (data.Value ?? string.Empty).GetType());
                    }
                    foreach (var data in pl_arrDatas)
                    {
                        pl_objResult.objDT.Rows.Add(((IDictionary<string, object>)data).Values.ToArray());
                    }
                }
            }
            catch (Exception pl_objEx)
            {
                pl_objResult.intErrCode = -9999;
                pl_objResult.strErrMsg  = pl_objEx.ToString();
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][E] RetVal: {0}, ErrMsg: {1}", pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }
            finally
            {
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][R] Param: {0}", GetSerializeString(param)));
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][R] DataTable: {0}{1}", pl_objResult.intCount.Equals(0) ? "" : "\r\n", AdmModule.GetDataTableToString(pl_objResult.objDT)));
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][R] RetVal: {0}, ErrMsg: {1}", pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }

            return pl_objResult;
        }
        #endregion

        //CRUD 용(레코드셋 반환 없음)
        #region Execute
        public DapperResult ExecuteSP(string storedProcedure, dynamic param = null, SqlTransaction transaction = null, int? commandTimeout = null)
        {
            DapperResult         pl_objResult = null;

            try
            {
                pl_objResult = new DapperResult();

                using (SqlConnection connection = new SqlConnection(_connenctionStr))
                {
                    connection.Open();

                    //Dapper 요청 로깅
                    //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][S] Param: {1}", storedProcedure, GetSerializeString(param)));

                    connection.Execute(storedProcedure, param: (object)param, transaction: transaction, commandTimeout: GetTimeout(commandTimeout), commandType: CommandType.StoredProcedure);
                }
            }
            catch (Exception pl_objEx)
            {
                pl_objResult.intErrCode = -9999;
                pl_objResult.strErrMsg  = pl_objEx.ToString();
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][E] RetVal: {1}, ErrMsg: {2}", storedProcedure, pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }
            finally
            {
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][R] Param: {1}", storedProcedure, GetSerializeString(param)));
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[{0}][R] RetVal: {1}, ErrMsg: {2}", storedProcedure, pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }

            return pl_objResult;
        }

        public DapperResult ExecuteSQL(string sql, dynamic param = null, SqlTransaction transaction = null, int? commandTimeout = null)
        {
            DapperResult pl_objResult = null;

            try
            {
                pl_objResult = new DapperResult();

                //Dapper 요청 SQL 로깅
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][S] SQL: {0}", sql));

                using (SqlConnection connection = new SqlConnection(_connenctionStr))
                {
                    connection.Open();

                    //Dapper 요청 로깅
                    //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][S] Param: {0}", GetSerializeString(param)));

                    connection.Execute(sql, param: (object)param, transaction: transaction, commandTimeout: GetTimeout(commandTimeout), commandType: CommandType.Text);
                }
            }
            catch (Exception pl_objEx)
            {
                pl_objResult.intErrCode = -9999;
                pl_objResult.strErrMsg  = pl_objEx.ToString();
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][E] RetVal: {0}, ErrMsg: {1}", pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }
            finally
            {
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][R] Param: {0}", GetSerializeString(param)));
                //AdmModule.WriteLog("Dapper", BOQWebLib.LogAction.LogType.Info, string.Format("[SQL][R] RetVal: {0}, ErrMsg: {1}", pl_objResult.intErrCode, pl_objResult.strErrMsg));
            }

            return pl_objResult;
        }
        #endregion

        #region Connection String & Timeout
        public void SetConnectionString(string connectionString)
        {
            this._connenctionStr = connectionString;
        }

        public int ConnectionTimeout { get; set; }

        public int GetTimeout(int? commandTimeout = null)
        {
            if (commandTimeout.HasValue)
                return commandTimeout.Value;

            return ConnectionTimeout;
        }
        #endregion
        
        private void CombineParameters(ref dynamic param, dynamic outParam = null)
        {
            if (outParam != null)
            {
                if (param != null)
                {
                    param = new DynamicParameters(param);
                    ((DynamicParameters)param).AddDynamicParams(outParam);
                }
                else
                {
                    param = outParam;
                }
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// DynamicParameters을 Serialize하게 변경 (변수명1=변수1&변수명2=변수2...)
        /// </summary>
        ///----------------------------------------------------------------------
        public static string GetSerializeString(DynamicParameters objReq)
        {
            string               pl_strResult = string.Empty;
            IEnumerable<dynamic> pl_objData   = null;
            
            if (objReq == null)
            {
                return pl_strResult;
            }
            
            pl_objData = objReq.ParameterNames.Select(x => string.Format("{0}={1}", x, objReq.Get<dynamic>(x))).ToArray();
            pl_strResult = string.Join("&", pl_objData);

            return pl_strResult;
        }

    }

    public class DapperResult
    {
        public int               intErrCode { get; set; }
        public string            strErrMsg  { get; set; }
        public int               intCount   { get; set; }
        public DataTable         objDT      { get; set; }

        public DapperResult()
        {
            intErrCode = 0;
            strErrMsg  = string.Empty;
            intCount   = 0;
            objDT      = new DataTable();
        }
    }
}
