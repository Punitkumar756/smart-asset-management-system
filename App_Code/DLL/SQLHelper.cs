using MySql.Data.MySqlClient;
using System.Configuration;
using System.Data;


namespace TCILTrackDMA.DLL
{
    public abstract class SQLHelper
    {
        private static readonly string CONN_STRING = ConfigurationManager.ConnectionStrings["TCILDMA"].ConnectionString;
        private static readonly string CONN_STRING_replica = ConfigurationManager.ConnectionStrings["TCILDMA_Replica"].ConnectionString;

        public static int ExecuteNonQuery(MySqlCommand cmd, CommandType cmdType, string cmdText)
        {
            using (MySqlConnection conn = new MySqlConnection(CONN_STRING))
            {
                SQLHelper.PrepareCommand(cmd, conn, (MySqlTransaction)null, cmdType, cmdText);
                return cmd.ExecuteNonQuery();
            }
        }

        public static MySqlDataReader ExecuteReader_replica(MySqlCommand cmd, CommandType cmdType, string cmdText)
        {
            MySqlConnection conn = new MySqlConnection(SQLHelper.CONN_STRING_replica);
            try
            {
                SQLHelper.PrepareCommand(cmd, conn, (MySqlTransaction)null, cmdType, cmdText);
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch
            {
                //Do Log
                conn.Close();
                throw;
            }
        }

        public static MySqlDataReader ExecuteReader(MySqlCommand cmd, CommandType cmdType, string cmdText)
        {
            MySqlConnection conn = new MySqlConnection(SQLHelper.CONN_STRING);
            try
            {
                SQLHelper.PrepareCommand(cmd, conn, (MySqlTransaction)null, cmdType, cmdText);
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch(System.Exception ex)
            {
                //Do Log
                conn.Close();
                throw;
            }
        }
        private static void PrepareCommand(MySqlCommand cmd, MySqlConnection conn, MySqlTransaction trans, CommandType cmdType, string cmdText)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();
            cmd.Connection = conn;
            cmd.CommandText = cmdText;
            if (trans != null)
                cmd.Transaction = trans;
            cmd.CommandType = cmdType;
        }
    }
}