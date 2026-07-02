using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Maintenance : System.Web.UI.Page
{
    BAL_Home objBAL = new BAL_Home();

    // =====================================================================
    //  PAGE LOAD
    // =====================================================================
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["AssetID"] != null &&
                Request.QueryString["Group"] != null)
            {
                txtITID.Text = Request.QueryString["AssetID"].ToString();
                txtGroup.Text = Request.QueryString["Group"].ToString();

                DataTable dtAsset = objBAL.GetAssetById(
                    Convert.ToInt32(txtITID.Text),
                    txtGroup.Text);

                if (dtAsset != null && dtAsset.Rows.Count > 0)
                {
                    assetNameDisplay.InnerText =
                        dtAsset.Rows[0]["ItemName"].ToString();

                    if (dtAsset.Columns.Contains("Description"))
                        txtDescription.Text =
                            dtAsset.Rows[0]["Description"].ToString();
                    else
                        txtDescription.Text = "";
                }

                BindMaintenance();
            }

            LoadReportFilter(); // ✅ Now this will work!
        }
    }

    // =====================================================================
    //  BIND MAINTENANCE HISTORY
    // =====================================================================
    private void BindMaintenance()
    {
        if (txtITID.Text.Trim() == "") return;

        DataTable dt = objBAL.GetMaintenanceByITID(
            Convert.ToInt32(txtITID.Text),
            txtGroup.Text);

        gvMaintenance.DataSource = dt;
        gvMaintenance.DataBind();
    }

    // =====================================================================
    //  UPDATE / INSERT MAINTENANCE RECORD
    // =====================================================================
    protected void btnUpdateRecord_Click(object sender, EventArgs e)
    {
        int itid = Convert.ToInt32(txtITID.Text.Trim());
        string itemType = txtGroup.Text.Trim();
        string status = ddlMaintenanceStatus.SelectedValue;
        string maintenanceType = ddlMaintenanceType.SelectedValue;
        string description = txtDescription.Text.Trim();
        string remark = txtRemark.Text.Trim();

        DateTime updatedDate = DateTime.Now;
        DateTime nextDate = DateTime.Now.AddMonths(1);

        if (!string.IsNullOrEmpty(txtNextMaintenanceDate.Text))
            DateTime.TryParse(txtNextMaintenanceDate.Text, out nextDate);

        objBAL.InsertMaintenance(
            itid, itemType, updatedDate, status,
            maintenanceType, nextDate, description, remark);

        BindMaintenance();

        txtRemark.Text = "";
        txtNextMaintenanceDate.Text = "";
        ddlMaintenanceStatus.SelectedIndex = 0;
        ddlMaintenanceType.SelectedIndex = 0;
    }

    // =====================================================================
    //  LOAD REPORT FILTER DROPDOWN
    // =====================================================================
    private void LoadReportFilter()
    {
        DataTable dt = objBAL.GetAllAssetNames();

        ddlReportFilter.Items.Clear();
        ddlReportFilter.Items.Add(
            new ListItem("-- All Records --", "")
        );

        foreach (DataRow row in dt.Rows)
        {
            ddlReportFilter.Items.Add(
                new ListItem(
                    row["ItemName"].ToString(),
                    row["ItemName"].ToString()
                ));
        }
    }

    // =====================================================================
    //  APPLY REPORT FILTER
    // =====================================================================
    protected void btnApplyReport_Click(object sender, EventArgs e)
    {
        string assetName = ddlReportFilter.SelectedValue;
        DataTable dt = objBAL.GetMaintenanceReport(assetName);

        if (dt == null || dt.Rows.Count == 0)
        {
            gvReport.Visible = false;
            pnlReportEmpty.Visible = true;
            lblTotalRecords.Text = "0";
            lblWorking.Text = "0";
            lblNotWorking.Text = "0";
        }
        else
        {
            gvReport.DataSource = dt;
            gvReport.DataBind();
            gvReport.Visible = true;
            pnlReportEmpty.Visible = false;

            int working = 0, notWorking = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (row["Status"].ToString() == "Working") working++;
                else notWorking++;
            }

            lblTotalRecords.Text = dt.Rows.Count.ToString();
            lblWorking.Text = working.ToString();
            lblNotWorking.Text = notWorking.ToString();
        }

        // ✅ Reopen modal after postback
        litReopenModal.Text = @"<script>
            document.getElementById('reportOverlay').classList.add('open');
            document.body.style.overflow='hidden';
        </script>";
    }

    // =====================================================================
    //  DOWNLOAD EXCEL
    // =====================================================================
    protected void btnDownloadExcel_Click(object sender, EventArgs e)
    {
        string assetName = ddlReportFilter.SelectedValue;
        DataTable dt = objBAL.GetMaintenanceReport(assetName);

        if (dt == null || dt.Rows.Count == 0) return;

        StringBuilder sb = new StringBuilder();
        sb.AppendLine("Transaction ID,Asset Code,Asset Name,Category,Updated Date,Status,Maintenance Type,Next Maintenance Date,Description,Remark");

        foreach (DataRow row in dt.Rows)
        {
            sb.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9}",
                row["TransactionID"],
                row["AssetCode"],
                row["AssetName"],
                row["ItemType"],
                row["UpdatedDate"],
                row["Status"],
                row["MaintenanceType"],
                row["NextMaintenanceDate"],
                row["Description"],
                row["Remark"]));
        }

        Response.Clear();
        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader("Content-Disposition",
            "attachment; filename=MaintenanceReport_" +
            DateTime.Now.ToString("yyyyMMdd_HHmm") + ".csv");
        Response.Write(sb.ToString());
        Response.End();
    }
}