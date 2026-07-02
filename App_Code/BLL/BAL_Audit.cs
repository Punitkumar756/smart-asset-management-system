using System;
using System.Data;

public class BAL_Audit
{
    DAL_Audit objDAL = new DAL_Audit();

    // ── Dashboard counts ─────────────────────────────────────────────
    public DataTable GetDashboardCounts()
    {
        return objDAL.GetDashboardCounts();
    }

    // ── Full audit history ───────────────────────────────────────────
    public DataTable GetAuditHistory()
    {
        return objDAL.GetAuditHistory();
    }

    // ── Fetch asset by code ──────────────────────────────────────────
    public DataTable GetAssetByCode(string assetCode)
    {
        if (string.IsNullOrEmpty(assetCode)) return null;
        return objDAL.GetAssetByCode(assetCode);
    }

    // ── Save audit record ────────────────────────────────────────────
    public int SaveAudit(
        string assetCode,
        string assetName,
        DateTime auditDate,
        string auditorName,
        string auditStatus,
        string auditCondition,
        string remarks)
    {
        return objDAL.SaveAudit(
            assetCode,
            assetName,
            auditDate,
            auditorName,
            auditStatus,
            auditCondition,
            remarks);
    }

    // ── Distinct auditor names (for admin report dropdown) ───────────
    public DataTable GetAuditorList()
    {
        return objDAL.GetAuditorList();
    }

    // ── Report: audits by a specific auditor, optional date range ────
    public DataTable GetAuditReportByAuditor(
        string auditorName,
        DateTime? fromDate,
        DateTime? toDate)
    {
        if (string.IsNullOrEmpty(auditorName)) return null;
        return objDAL.GetAuditReportByAuditor(auditorName, fromDate, toDate);
    }
}