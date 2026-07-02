using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Configuration;
using System.Data.OleDb;

public partial class testconnection_db : System.Web.UI.Page
{
    protected void btnRun_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();

        dt.Columns.Add("Name");
        dt.Columns.Add("Type");
        dt.Columns.Add("IP");
        dt.Columns.Add("Status");
        dt.Columns.Add("Message");

        // ===== MYSQL =====
        TestMySQL(dt, "TCILDMA");
        TestMySQL(dt, "TCILDMA_Replica");
        TestMySQL(dt, "connectStr");

        // ===== EXCEL =====
        TestExcel(dt, "Excel03ConString", "Excel 2003");
        TestExcel(dt, "Excel07ConString", "Excel 2007+");

        // ===== CONFIG =====
        TestConfig(dt, "ServiceID");

        grid.DataSource = dt;
        grid.DataBind();
    }

    // ---------------- MYSQL TEST ----------------
    private void TestMySQL(DataTable dt, string name)
    {
        string status, msg, ip;

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings[name].ConnectionString;

            ip = ExtractServer(connStr);

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                status = "PASS";
                msg = "Connected Successfully";
            }
        }
        catch (Exception ex)
        {
            ip = "Unknown";
            status = "FAIL";
            msg = ex.Message;
        }

        AddRow(dt, name, "MySQL DB", ip, status, msg);
    }

    // ---------------- EXCEL TEST ----------------
    private void TestExcel(DataTable dt, string name, string type)
    {
        string status, msg;

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings[name].ConnectionString;

            using (OleDbConnection conn = new OleDbConnection(connStr))
            {
                conn.Open();
                status = "PASS";
                msg = "Excel Provider OK";
            }
        }
        catch (Exception ex)
        {
            status = "FAIL";
            msg = ex.Message;
        }

        AddRow(dt, name, type, "N/A", status, msg);
    }

    // ---------------- CONFIG TEST ----------------
    private void TestConfig(DataTable dt, string name)
    {
        string status, msg;

        try
        {
            string value = ConfigurationManager.ConnectionStrings[name].ConnectionString;

            status = "PASS";
            msg = "Value = " + value;
        }
        catch
        {
            status = "FAIL";
            msg = "Missing config";
        }

        AddRow(dt, name, "Config Value", "N/A", status, msg);
    }

    // ---------------- ADD ROW ----------------
    private void AddRow(DataTable dt, string name, string type, string ip, string status, string msg)
    {
        DataRow row = dt.NewRow();
        row["Name"] = name;
        row["Type"] = type;
        row["IP"] = ip;
        row["Status"] = status;
        row["Message"] = msg;
        dt.Rows.Add(row);
    }

    // ---------------- EXTRACT IP / SERVER ----------------
    private string ExtractServer(string connStr)
    {
        try
        {
            // server=192.168.70.230;
            string lower = connStr.ToLower();

            int start = lower.IndexOf("server=");
            if (start == -1) return "Unknown";

            start += 7;

            int end = connStr.IndexOf(';', start);
            if (end == -1) end = connStr.Length;

            return connStr.Substring(start, end - start);
        }
        catch
        {
            return "Unknown";
        }
    }

    // ---------------- ROW COLOR ----------------
    protected void grid_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
    {
        if (e.Row.RowType == System.Web.UI.WebControls.DataControlRowType.DataRow)
        {
            string status = e.Row.Cells[3].Text;

            if (status.ToLower().Contains("pass"))
            {
                e.Row.CssClass = "status-pass";
            }
            else
            {
                e.Row.CssClass = "status-fail";
            }
        }
    }
}