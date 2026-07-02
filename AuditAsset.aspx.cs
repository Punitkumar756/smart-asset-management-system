using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class AuditAsset : System.Web.UI.Page
{
    BAL_Audit objBAL = new BAL_Audit();

    // ── Page Load ───────────────────────────────────────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user"] == null)
        {
            Response.Redirect("LOGINPAGE.aspx");
            return;
        }

        string loggedInUser = Session["user"].ToString();
        lblLoggedInUser.Text = loggedInUser;
        lblNavUser.Text = loggedInUser;

        string role = Session["role"] != null ? Session["role"].ToString() : "";
        bool isAdmin = role.Equals("Admin", StringComparison.OrdinalIgnoreCase);

        // Show "Generate Report" button for admin only
        pnlReportBtn.Visible = isAdmin;

        if (!IsPostBack)
        {
            txtAuditor.Text = loggedInUser;
            TextBox1.Text = DateTime.Now.ToString("yyyy-MM-dd");
            Label1.Text = DateTime.Now.ToString("dd MMM yyyy");

            BindDashboard();
            BindAuditHistory();

            if (isAdmin)
                LoadAuditorList();
        }
        else
        {
            BindDashboard();
            BindAuditHistory();

            if (isAdmin)
                LoadAuditorList();
        }
    }

    // ── Load auditor names into hidden field (JSON array) ────────────
    private void LoadAuditorList()
    {
        DataTable dt = objBAL.GetAuditorList();
        if (dt == null || dt.Rows.Count == 0)
        {
            hfAuditorList.Value = "[]";
            return;
        }

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i > 0) sb.Append(",");
            string name = dt.Rows[i]["AuditorName"].ToString()
                            .Replace("\\", "\\\\")
                            .Replace("\"", "\\\"");
            sb.Append("\"").Append(name).Append("\"");
        }
        sb.Append("]");
        hfAuditorList.Value = sb.ToString();
    }

    // ── Report button click handler ──────────────────────────────────
    protected void btnReportPostback_Click(object sender, EventArgs e)
    {
        string role = Session["role"] != null ? Session["role"].ToString() : "";
        bool isAdmin = role.Equals("Admin", StringComparison.OrdinalIgnoreCase);
        if (!isAdmin) return;

        string hfVal = hfAuditTime.Value;
        if (!string.IsNullOrEmpty(hfVal) && hfVal.StartsWith("RPT|"))
        {
            try
            {
                ProcessReportRequest(hfVal);
            }
            catch (Exception ex)
            {
                ShowMessage("Report error: " + ex.Message, "error");
            }
            hfAuditTime.Value = "";
        }
    }

    // ── Process report postback ──────────────────────────────────────
    private void ProcessReportRequest(string hfVal)
    {
        // Format: RPT|AuditorName|FromDate|ToDate
        string[] parts = hfVal.Split('|');
        if (parts.Length < 4) return;

        string auditorName = parts[1].Trim();
        string fromStr = parts[2].Trim();
        string toStr = parts[3].Trim();

        if (string.IsNullOrEmpty(auditorName)) return;

        DateTime? dtFrom = null;
        DateTime? dtTo = null;
        DateTime parsed;

        if (!string.IsNullOrEmpty(fromStr) && DateTime.TryParse(fromStr, out parsed))
            dtFrom = parsed;
        if (!string.IsNullOrEmpty(toStr) && DateTime.TryParse(toStr, out parsed))
            dtTo = parsed;

        DataTable dt = objBAL.GetAuditReportByAuditor(auditorName, dtFrom, dtTo);

        // Build JSON rows for the JS preview
        StringBuilder sbRows = new StringBuilder("[");
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (i > 0) sbRows.Append(",");
                DataRow row = dt.Rows[i];
                sbRows.Append("{");
                sbRows.Append("\"AssetCode\":\"").Append(Escape(row["AssetCode"].ToString())).Append("\",");
                sbRows.Append("\"AssetName\":\"").Append(Escape(row["AssetName"].ToString())).Append("\",");
                sbRows.Append("\"AuditDate\":\"").Append(Escape(row["AuditDate"].ToString())).Append("\",");
                sbRows.Append("\"AuditStatus\":\"").Append(Escape(row["AuditStatus"].ToString())).Append("\",");
                sbRows.Append("\"AuditCondition\":\"").Append(Escape(row["AuditCondition"].ToString())).Append("\",");
                sbRows.Append("\"Remarks\":\"").Append(Escape(row["Remarks"] != null ? row["Remarks"].ToString() : "")).Append("\"");
                sbRows.Append("}");
            }
        }
        sbRows.Append("]");

        // Build printable HTML panel
        BuildPrintSection(auditorName, fromStr, toStr, dt);

        // Store report result data in hidden field for JavaScript to pick up on page load
        StringBuilder sbResult = new StringBuilder();
        sbResult.Append("{");
        sbResult.Append("\"auditor\":\"").Append(Escape(auditorName)).Append("\",");
        sbResult.Append("\"fromDate\":\"").Append(Escape(fromStr)).Append("\",");
        sbResult.Append("\"toDate\":\"").Append(Escape(toStr)).Append("\",");
        sbResult.Append("\"rows\":").Append(sbRows.ToString());
        sbResult.Append("}");
        hfReportResult.Value = sbResult.ToString();
    }

    // ── Build printable section ──────────────────────────────────────
    private void BuildPrintSection(string auditor, string fromDate, string toDate, DataTable dt)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("<div style='font-family:Arial,sans-serif; padding:20px;'>");

        // Header
        sb.Append("<div style='display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; padding-bottom:14px; border-bottom:2px solid #5d87ff;'>");
        sb.Append("<div>");
        sb.Append("<h2 style='font-size:22px; color:#0f172a; margin:0;'>Audit Report</h2>");
        sb.Append("<p style='font-size:13px; color:#6b7280; margin:4px 0 0;'>Asset Audit Management System</p>");
        sb.Append("</div>");
        sb.Append("<div style='text-align:right;'>");
        sb.AppendFormat("<p style='font-size:12px; color:#6b7280; margin:0;'>Generated: {0}</p>",
            DateTime.Now.ToString("dd MMM yyyy, hh:mm tt"));
        sb.AppendFormat("<p style='font-size:12px; color:#6b7280; margin:0;'>Generated By: {0}</p>",
            Server.HtmlEncode(Session["user"] != null ? Session["user"].ToString() : ""));
        sb.Append("</div></div>");

        // Parameters block
        sb.Append("<div style='background:#f8f9ff; border:1px solid #e2e8f0; border-radius:10px; padding:14px 18px; margin-bottom:20px; display:flex; gap:30px;'>");
        sb.AppendFormat(
            "<div><span style='font-size:11px;font-weight:700;color:#94a3b8;text-transform:uppercase;'>Auditor</span>" +
            "<br/><span style='font-size:14px;font-weight:700;color:#0f172a;'>{0}</span></div>",
            Server.HtmlEncode(auditor));
        if (!string.IsNullOrEmpty(fromDate))
            sb.AppendFormat(
                "<div><span style='font-size:11px;font-weight:700;color:#94a3b8;text-transform:uppercase;'>From</span>" +
                "<br/><span style='font-size:14px;font-weight:700;color:#0f172a;'>{0}</span></div>",
                Server.HtmlEncode(fromDate));
        if (!string.IsNullOrEmpty(toDate))
            sb.AppendFormat(
                "<div><span style='font-size:11px;font-weight:700;color:#94a3b8;text-transform:uppercase;'>To</span>" +
                "<br/><span style='font-size:14px;font-weight:700;color:#0f172a;'>{0}</span></div>",
                Server.HtmlEncode(toDate));
        int total = (dt != null) ? dt.Rows.Count : 0;
        sb.AppendFormat(
            "<div><span style='font-size:11px;font-weight:700;color:#94a3b8;text-transform:uppercase;'>Total Records</span>" +
            "<br/><span style='font-size:14px;font-weight:700;color:#5d87ff;'>{0}</span></div>", total);
        sb.Append("</div>");

        // Table
        sb.Append("<table style='width:100%; border-collapse:collapse; font-size:13px;'>");
        sb.Append("<thead><tr style='background:#0f172a; color:#fff;'>");
        foreach (string col in new[] { "#", "Asset Code", "Asset Name", "Audit Date", "Status", "Condition", "Remarks" })
            sb.AppendFormat("<th style='padding:10px 12px; text-align:left; font-size:11px;'>{0}</th>", col);
        sb.Append("</tr></thead><tbody>");

        if (dt != null && dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                DataRow row = dt.Rows[i];
                string bg = (i % 2 == 0) ? "#ffffff" : "#f8f9ff";
                sb.AppendFormat("<tr style='background:{0}; border-bottom:1px solid #e2e8f0;'>", bg);
                sb.AppendFormat("<td style='padding:9px 12px; color:#94a3b8; font-weight:600;'>{0}</td>", i + 1);
                sb.AppendFormat("<td style='padding:9px 12px; font-weight:700; color:#0f172a;'>{0}</td>", Server.HtmlEncode(row["AssetCode"].ToString()));
                sb.AppendFormat("<td style='padding:9px 12px; color:#374151;'>{0}</td>", Server.HtmlEncode(row["AssetName"].ToString()));
                sb.AppendFormat("<td style='padding:9px 12px; color:#6b7280;'>{0}</td>", Server.HtmlEncode(row["AuditDate"].ToString()));
                sb.AppendFormat("<td style='padding:9px 12px;'>{0}</td>", Server.HtmlEncode(row["AuditStatus"].ToString()));
                sb.AppendFormat("<td style='padding:9px 12px;'>{0}</td>", Server.HtmlEncode(row["AuditCondition"].ToString()));
                sb.AppendFormat("<td style='padding:9px 12px; color:#6b7280;'>{0}</td>",
                    Server.HtmlEncode(row["Remarks"] != null ? row["Remarks"].ToString() : ""));
                sb.Append("</tr>");
            }
        }
        else
        {
            sb.Append("<tr><td colspan='7' style='text-align:center; padding:28px; color:#94a3b8;'>No records found.</td></tr>");
        }

        sb.Append("</tbody></table></div>");

        pnlPrintReport.Controls.Clear();
        pnlPrintReport.Controls.Add(new LiteralControl(sb.ToString()));
    }

    private string Escape(string s)
    {
        if (s == null) return "";
        return s.Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\r", "")
                .Replace("\n", " ");
    }

    // ── Dashboard ───────────────────────────────────────────────────
    private void BindDashboard()
    {
        DataTable dt = objBAL.GetDashboardCounts();
        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            lblTotalAssets.Text = row["TotalAssets"].ToString();
            lblAudited.Text = row["Audited"].ToString();
            lblMissing.Text = row["Missing"].ToString();
            lblDamaged.Text = row["Damaged"].ToString();
        }
    }

    // ── Audit History ───────────────────────────────────────────────
    private void BindAuditHistory()
    {
        DataTable dt = objBAL.GetAuditHistory();
        gvAudit.DataSource = dt;
        gvAudit.DataBind();
    }

    // ── Search ──────────────────────────────────────────────────────
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string code = txtAssetCode.Text.Trim().ToUpper();

        if (string.IsNullOrEmpty(code))
        {
            ShowMessage("Please enter an Asset Code.", "error");
            return;
        }

        if (code.Length < 4)
        {
            ShowMessage("Invalid asset code. Must be at least 4 characters.", "error");
            return;
        }

        DataTable dt = objBAL.GetAssetByCode(code);

        if (dt == null)
        {
            ShowMessage("Unknown asset category in code: " + code, "error");
            return;
        }

        if (dt.Rows.Count > 0)
        {
            PopulateAssetInfo(dt.Rows[0]);
            ViewState["CurrentAssetCode"] = code;
            ViewState["CurrentAssetName"] = lblAssetName.Text;
            divEmpty.Visible = false;
            divAssetInfo.Visible = true;
            ShowMessage("Asset loaded successfully.", "success");
        }
        else
        {
            ShowMessage("No asset found for code: " + code, "error");
            ClearAssetInfo();
            divEmpty.Visible = true;
            divAssetInfo.Visible = false;
        }
    }

    // ── Populate asset labels ────────────────────────────────────────
    private void PopulateAssetInfo(DataRow row)
    {
        lblAssetID.Text = row["AssetID"].ToString();
        lblAssetCode.Text = row["AssetCode"].ToString();
        lblAssetName.Text = row["AssetName"].ToString();
        lblBrand.Text = row["Brand"].ToString();
        lblSerial.Text = row["SerialNumber"].ToString();
        lblQuantity.Text = row["Quantity"].ToString();
        lblWorkingQty.Text = row["WorkingQty"].ToString();
        lblNonWorking.Text = row["NonWorkingQty"].ToString();
        lblStatus.Text = row["Status"].ToString();
        lblSector.Text = row["Sector"].ToString();
        lblDescription.Text = row["Description"].ToString();
        lblCapacity.Text = row.Table.Columns.Contains("Capacity")
            ? row["Capacity"].ToString()
            : "";

        string code = row["AssetCode"].ToString().ToUpper();

        // Derive Category from asset code prefix (positions 2-3)
        if (code.Length >= 4)
        {
            switch (code.Substring(2, 2))
            {
                case "IT": lblCategory.Text = "IT Equipment"; break;
                case "FU": lblCategory.Text = "Furniture"; break;
                case "EL": lblCategory.Text = "Electronics"; break;
                default: lblCategory.Text = ""; break;
            }
        }

        // Derive Office from asset code prefix (positions 0-1)
        if (code.Length >= 2)
        {
            switch (code.Substring(0, 2))
            {
                case "NH": lblOffice.Text = "NHM"; break;
                case "TC": lblOffice.Text = "TCIL"; break;
                case "GV": lblOffice.Text = "GVK"; break;
                case "TE": lblOffice.Text = "TELEMANAS"; break;
                default: lblOffice.Text = code.Substring(0, 2); break;
            }
        }

        // Department from database column
        lblDepartment.Text = row.Table.Columns.Contains("Department")
            ? row["Department"].ToString()
            : "";
    }

    // ── Save Audit ──────────────────────────────────────────────────
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string assetCode = ViewState["CurrentAssetCode"] != null ? ViewState["CurrentAssetCode"].ToString() : "";
        string assetName = ViewState["CurrentAssetName"] != null ? ViewState["CurrentAssetName"].ToString() : "";

        if (string.IsNullOrEmpty(assetCode))
        {
            ShowMessage("Please search and load an asset first.", "error");
            return;
        }

        if (string.IsNullOrEmpty(txtAuditor.Text.Trim()))
        {
            ShowMessage("Auditor name is missing. Please log in again.", "error");
            return;
        }

        string status = GetStatus();
        string condition = GetCondition();

        if (string.IsNullOrEmpty(status))
        {
            ShowMessage("Please select a Physical Verification Status.", "error");
            return;
        }

        if (string.IsNullOrEmpty(condition))
        {
            ShowMessage("Please select an Asset Condition.", "error");
            return;
        }

        try
        {
            int result = objBAL.SaveAudit(
                assetCode,
                assetName,
                DateTime.Now,
                txtAuditor.Text.Trim(),
                status,
                condition,
                txtRemarks.Text.Trim());

            if (result > 0)
            {
                BindDashboard();
                BindAuditHistory();
                ClearForm();
                ShowMessage("Audit completed and saved successfully!", "success");
            }
            else
            {
                ShowMessage("Audit could not be saved. Please try again.", "error");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error: " + ex.Message, "error");
        }
    }

    // ── Reset ───────────────────────────────────────────────────────
    protected void btnReset_Click(object sender, EventArgs e)
    {
        ClearForm();
        ShowMessage("Form reset successfully.", "success");
    }

    // ── Helpers ─────────────────────────────────────────────────────
    private string GetStatus()
    {
        if (rbFound.Checked) return "Found";
        if (rbMissing.Checked) return "Missing";
        if (rbDamaged.Checked) return "Damaged";
        if (rbRepair.Checked) return "Under Repair";
        return null;
    }

    private string GetCondition()
    {
        if (rbExcellent.Checked) return "Excellent";
        if (rbGood.Checked) return "Good";
        if (rbFair.Checked) return "Fair";
        if (rbPoor.Checked) return "Poor";
        return null;
    }

    private void ShowMessage(string msg, string type)
    {
        lblMessage.Text = msg;
        lblMessage.CssClass = "message-" + type;
    }

    private void ClearForm()
    {
        txtAssetCode.Text = "";
        txtRemarks.Text = "";
        TextBox1.Text = DateTime.Now.ToString("yyyy-MM-dd");

        if (Session["user"] != null)
            txtAuditor.Text = Session["user"].ToString();

        ViewState["CurrentAssetCode"] = null;
        ViewState["CurrentAssetName"] = null;

        rbFound.Checked = false;
        rbMissing.Checked = false;
        rbDamaged.Checked = false;
        rbRepair.Checked = false;

        rbExcellent.Checked = false;
        rbGood.Checked = false;
        rbFair.Checked = false;
        rbPoor.Checked = false;

        divEmpty.Visible = true;
        divAssetInfo.Visible = false;
        lblMessage.Text = "";

        ClearAssetInfo();
    }

    private void ClearAssetInfo()
    {
        lblAssetID.Text = "";
        lblAssetCode.Text = "";
        lblAssetName.Text = "";
        lblCategory.Text = "";
        lblOffice.Text = "";
        lblDepartment.Text = "";
        lblBrand.Text = "";
        lblSerial.Text = "";
        lblQuantity.Text = "";
        lblWorkingQty.Text = "";
        lblNonWorking.Text = "";
        lblStatus.Text = "";
        lblSector.Text = "";
        lblDescription.Text = "";

        // ── NEW: Clear Capacity ──────────────────────────────────────
        lblCapacity.Text = "";
    }
}