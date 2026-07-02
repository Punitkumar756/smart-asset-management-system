using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;

public class DAL_Audit
{
    private string connStr = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;

    // ── Dashboard counts ─────────────────────────────────────────────
    public DataTable GetDashboardCounts()
    {
        DataTable dt = new DataTable();
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            string query = @"
                SELECT
                    (SELECT COUNT(*) FROM IT) +
                    (SELECT COUNT(*) FROM Furniture) +
                    (SELECT COUNT(*) FROM Electronics)                                AS TotalAssets,
                    (SELECT COUNT(*) FROM AuditMaster)                               AS Audited,
                    (SELECT COUNT(*) FROM AuditMaster WHERE AuditStatus='Missing')   AS Missing,
                    (SELECT COUNT(*) FROM AuditMaster WHERE AuditStatus='Damaged')   AS Damaged";

            MySqlDataAdapter da = new MySqlDataAdapter(query, con);
            da.Fill(dt);
        }
        return dt;
    }

    // ── Full audit history (latest 200 rows) ─────────────────────────
    public DataTable GetAuditHistory()
    {
        DataTable dt = new DataTable();
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            string query =
                "SELECT AuditID, AssetCode, AssetName, " +
                "DATE_FORMAT(AuditDate,'%d %b %Y %H:%i') AS AuditDate, " +
                "AuditStatus, AuditCondition, AuditorName, " +
                "IFNULL(Remarks,'') AS Remarks " +
                "FROM AuditMaster " +
                "ORDER BY AuditID DESC " +
                "LIMIT 200";

            MySqlDataAdapter da = new MySqlDataAdapter(query, con);
            da.Fill(dt);
        }
        return dt;
    }

    // ── Fetch asset by code ──────────────────────────────────────────
    public DataTable GetAssetByCode(string assetCode)
    {
        if (string.IsNullOrEmpty(assetCode) || assetCode.Length < 4)
            return null;

        string prefix = assetCode.Substring(2, 2).ToUpper();
        string tableName;
        string pkColumn;

        switch (prefix)
        {
            case "IT": tableName = "IT"; pkColumn = "ITID"; break;
            case "FU": tableName = "Furniture"; pkColumn = "FurnitureID"; break;
            case "EL": tableName = "Electronics"; pkColumn = "ElectronicsID"; break;
            default: return null;
        }

        // Furniture has no Capacity column — use empty string as fallback
        string capacityColumn = (tableName == "Furniture") ? "'' AS Capacity" : "Capacity AS Capacity";

        DataTable dt = new DataTable();
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            string query =
                "SELECT " +
                "    " + pkColumn + "      AS AssetID, " +
                "    AssetCode             AS AssetCode, " +
                "    ItemName              AS AssetName, " +
                "    Brand                 AS Brand, " +
                "    SerialNumber          AS SerialNumber, " +
                "    Quantity              AS Quantity, " +
                "    WorkingQty            AS WorkingQty, " +
                "    NonWorkingQty         AS NonWorkingQty, " +
                "    Status                AS Status, " +
                "    Sector                AS Sector, " +
                "    Description           AS Description, " +
                "    Department            AS Department, " +
                "    " + capacityColumn +        // ← NEW: Capacity
                " FROM " + tableName +
                " WHERE AssetCode = @AssetCode " +
                " LIMIT 1";

            MySqlCommand cmd = new MySqlCommand(query, con);
            cmd.Parameters.AddWithValue("@AssetCode", assetCode);
            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            da.Fill(dt);
        }
        return dt;
    }

    // ── Save audit via stored procedure ──────────────────────────────
    public int SaveAudit(
        string assetCode,
        string assetName,
        DateTime auditDate,
        string auditorName,
        string auditStatus,
        string auditCondition,
        string remarks)
    {
        int rowsAffected = 0;
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            MySqlCommand cmd = new MySqlCommand("SP_SaveAudit", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("p_AssetCode", assetCode);
            cmd.Parameters.AddWithValue("p_AssetName", assetName);
            cmd.Parameters.AddWithValue("p_AuditDate", auditDate);
            cmd.Parameters.AddWithValue("p_AuditorName", auditorName);
            cmd.Parameters.AddWithValue("p_AuditStatus", auditStatus);
            cmd.Parameters.AddWithValue("p_AuditCondition", auditCondition);
            cmd.Parameters.AddWithValue("p_Remarks", remarks);

            con.Open();
            rowsAffected = cmd.ExecuteNonQuery();
        }
        return rowsAffected;
    }

    // ── Distinct auditor names (for admin report dropdown) ───────────
    public DataTable GetAuditorList()
    {
        DataTable dt = new DataTable();
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            string query =
                "SELECT DISTINCT AuditorName " +
                "FROM AuditMaster " +
                "WHERE AuditorName IS NOT NULL AND AuditorName <> '' " +
                "ORDER BY AuditorName ASC";

            MySqlDataAdapter da = new MySqlDataAdapter(query, con);
            da.Fill(dt);
        }
        return dt;
    }

    // ── Report: filter by auditor + optional date range ──────────────
    public DataTable GetAuditReportByAuditor(
        string auditorName,
        DateTime? fromDate,
        DateTime? toDate)
    {
        DataTable dt = new DataTable();
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            string where = " WHERE AuditorName = @AuditorName";
            if (fromDate.HasValue)
                where += " AND DATE(AuditDate) >= @FromDate";
            if (toDate.HasValue)
                where += " AND DATE(AuditDate) <= @ToDate";

            string query =
                "SELECT AuditID, AssetCode, AssetName, " +
                "DATE_FORMAT(AuditDate,'%d %b %Y') AS AuditDate, " +
                "AuditStatus, AuditCondition, AuditorName, " +
                "IFNULL(Remarks,'') AS Remarks " +
                "FROM AuditMaster" +
                where +
                " ORDER BY AuditDate DESC, AuditID DESC";

            MySqlCommand cmd = new MySqlCommand(query, con);
            cmd.Parameters.AddWithValue("@AuditorName", auditorName);

            if (fromDate.HasValue)
                cmd.Parameters.AddWithValue("@FromDate", fromDate.Value.ToString("yyyy-MM-dd"));
            if (toDate.HasValue)
                cmd.Parameters.AddWithValue("@ToDate", toDate.Value.ToString("yyyy-MM-dd"));

            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            da.Fill(dt);
        }
        return dt;
    }
}