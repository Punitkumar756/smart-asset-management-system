using ClosedXML.Excel;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Assetsystem : System.Web.UI.Page
{
    BAL_Home objBAL = new BAL_Home();

    // =====================================================================
    //  HELPER PROPERTY
    // =====================================================================
    private string UserRole
    {
        get
        {
            return Session["role"] != null ? Session["role"].ToString() : "";
        }
    }

    // =====================================================================
    //  PAGE LOAD
    // =====================================================================
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user"] == null)
        {
            Response.Redirect("~/LOGINPAGE.aspx");
            return;
        }

        lblRole.Text = Session["user"].ToString();

        LoadOfficesFromDB();

        string role = Session["role"] != null
            ? Session["role"].ToString()
            : "";

        // Runs on EVERY request (not just first load) so it survives postbacks
        if (role != "Admin")
        {
            foreach (DataControlField col in gvAssets.Columns)
            {
                if (col.HeaderText == "Delete")
                {
                    col.Visible = false;
                    break;
                }
            }
        }

        if (!IsPostBack)
        {
            if (role == "IT team")
                AutoFillOfficeForITTeam();

            LoadHeroStats(role);
        }
    }
    // =====================================================================
    //  LOAD OFFICES — runs on EVERY request (postback and first load)
    //
    //  WHY: DropDownList ViewState stores the selected INDEX not the VALUE.
    //  If the list is empty on any postback the selection is lost entirely.
    //  We rebuild the list every time, save the selected value first, and
    //  restore it by VALUE after the rebuild so it survives correctly.
    // =====================================================================
    private void LoadOfficesFromDB()
    {
        string district = Session["SelectedDistrict"] != null
            ? Session["SelectedDistrict"].ToString() : "";

        // ── Save current selected VALUES before clearing ─────────────────
        // On first load these will be empty strings which is fine.
        // On postback these hold whatever the user selected.
        string savedOffice = ddlOffice.SelectedValue;
        string savedReportOffice = ddlReportOffice.SelectedValue;

        DataTable dt = objBAL.GetOfficesByDistrict(district);

        // ── Rebuild asset page dropdown ──────────────────────────────────
        ddlOffice.Items.Clear();
        ddlOffice.Items.Add(new ListItem("-- Select Office --", "0"));

        if (UserRole == "IT team")
        {
            DataTable userOffices = Session["userOffices"] as DataTable;
            if (userOffices != null)
                foreach (DataRow row in userOffices.Rows)
                    ddlOffice.Items.Add(new ListItem(
                        row["OfficeName"].ToString(),
                        row["OfficeID"].ToString()));
        }
        else
        {
            if (dt != null)
                foreach (DataRow row in dt.Rows)
                    ddlOffice.Items.Add(new ListItem(
                        row["OfficeName"].ToString(),
                        row["OfficeID"].ToString()));
        }

        // ── Rebuild report dropdown ──────────────────────────────────────
        ddlReportOffice.Items.Clear();

        if (UserRole == "IT team")
        {
            ddlReportOffice.Items.Add(new ListItem("All Assigned Offices", "0"));
            DataTable userOffices = Session["userOffices"] as DataTable;
            if (userOffices != null)
                foreach (DataRow row in userOffices.Rows)
                    ddlReportOffice.Items.Add(new ListItem(
                        row["OfficeName"].ToString(),
                        row["OfficeID"].ToString()));
        }
        else
        {
            ddlReportOffice.Items.Add(new ListItem("All Offices", "0"));
            if (dt != null)
                foreach (DataRow row in dt.Rows)
                    ddlReportOffice.Items.Add(new ListItem(
                        row["OfficeName"].ToString(),
                        row["OfficeID"].ToString()));
        }

        // ── Restore selected VALUE (not index) ───────────────────────────
        // FindByValue means even if list order changes the right item is
        // selected. This is what keeps the IT team's chosen office intact
        // across every postback (Fetch, Edit, Delete, Insert, etc.).
        if (!string.IsNullOrEmpty(savedOffice) && savedOffice != "0")
        {
            ListItem li = ddlOffice.Items.FindByValue(savedOffice);
            if (li != null) ddlOffice.SelectedValue = savedOffice;
        }

        if (!string.IsNullOrEmpty(savedReportOffice) && savedReportOffice != "0")
        {
            ListItem li = ddlReportOffice.Items.FindByValue(savedReportOffice);
            if (li != null) ddlReportOffice.SelectedValue = savedReportOffice;
        }
    }

    // =====================================================================
    //  HERO STATS
    // =====================================================================
    private void LoadHeroStats(string role)
    {
        int officeCount = 0;
        int categoryCount = 3;
        int assetCount = 0;

        if (role == "Admin")
        {
            string district =
    Session["SelectedDistrict"] != null
    ? Session["SelectedDistrict"].ToString()
    : "";

            DataTable dtStats =
                objBAL.GetAdminStatsByDistrict(district);
            if (dtStats != null && dtStats.Rows.Count > 0)
            {
                DataRow r = dtStats.Rows[0];
                if (dtStats.Columns.Contains("OfficeCount"))
                    int.TryParse(r["OfficeCount"].ToString(), out officeCount);
                if (dtStats.Columns.Contains("AssetCount"))
                    int.TryParse(r["AssetCount"].ToString(), out assetCount);
            }
        }
        else if (role == "IT team")
        {
            DataTable dtOffices = Session["userOffices"] as DataTable;
            if (dtOffices != null)
            {
                officeCount = dtOffices.Rows.Count;
                foreach (DataRow officeRow in dtOffices.Rows)
                {
                    int oid = Convert.ToInt32(officeRow["OfficeID"]);
                    DataTable dtA = objBAL.GetAssetsByOfficeAndGroup(oid, "");
                    if (dtA != null) assetCount += dtA.Rows.Count;
                }
            }
        }


        litHeroStats.Text = string.Format(
            @"<div class='stat-chip'>
            <div class='num'>{0}</div>
            <div class='lbl'>Offices</div>
          </div>
          <div class='stat-chip'>
            <div class='num'>{1}</div>
            <div class='lbl'>Categories</div>
          </div>
          <div class='stat-chip'>
            <div class='num'>{2}</div>
            <div class='lbl'>Assets</div>
          </div>",
            officeCount,
            categoryCount,
            assetCount.ToString()
        );
    }
    private void UpdateHeroAssetCount(int assetCount)
    {
        litHeroStats.Text = string.Format(
            @"<div class='stat-chip'>
            <div class='num'>{0}</div>
            <div class='lbl'>Offices</div>
          </div>

          <div class='stat-chip'>
            <div class='num'>{1}</div>
            <div class='lbl'>Categories</div>
          </div>

          <div class='stat-chip'>
            <div class='num'>{2}</div>
            <div class='lbl'>Assets</div>
          </div>",
            1,
            3,
            assetCount
        );
    }
    // =====================================================================
    //  AUTO-FILL OFFICE FOR IT TEAM  (first load only)
    //  Note: this runs AFTER LoadOfficesFromDB() has already built the
    //  list, so we just set the selection — no need to rebuild the list.
    // =====================================================================
    private void AutoFillOfficeForITTeam()
    {
        DataTable dtOffices = Session["userOffices"] as DataTable;
        if (dtOffices == null || dtOffices.Rows.Count == 0) return;

        // If only one office assigned, auto-select it
        if (dtOffices.Rows.Count == 1)
        {
            string onlyOfficeId = dtOffices.Rows[0]["OfficeID"].ToString();
            ListItem li = ddlOffice.Items.FindByValue(onlyOfficeId);
            if (li != null) ddlOffice.SelectedValue = onlyOfficeId;
        }

        ddlOffice.Enabled = true;
        ddlOffice.CssClass = "input-control";
        ddlOffice.Style.Remove("display");

        litOfficeChips.Text = "";
        pnlAutofillNotice.Visible = true;
    }

    // =====================================================================
    //  NORMALIZE PK COLUMN NAME
    // =====================================================================
    private DataTable NormalizeColumns(DataTable dt)
    {
        if (dt == null) return dt;
        string[] pkVariants = { "IT_ID", "Id", "AssetID", "asset_id", "itid" };
        if (!dt.Columns.Contains("ITID"))
            foreach (string variant in pkVariants)
                if (dt.Columns.Contains(variant))
                {
                    dt.Columns[variant].ColumnName = "ITID";
                    break;
                }
        return dt;
    }

    // =====================================================================
    //  FETCH ASSETS
    // =====================================================================
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        int officeId = Convert.ToInt32(ddlOffice.SelectedValue);
        string group = ddlGroup.SelectedValue;

        if (officeId == 0 && string.IsNullOrEmpty(group))
        {
            ShowWarning("Please select both Office and Category.");
            return;
        }

        if (officeId == 0)
        {
            ShowWarning("Please select an Office.");
            return;
        }

        if (string.IsNullOrEmpty(group))
        {
            ShowWarning("Please select a Category.");
            return;
        }

        DataTable dt = objBAL.GetAssetsByOfficeAndGroup(officeId, group);

        dt = NormalizeColumns(dt);

        gvAssets.DataSource = dt;
        gvAssets.DataBind();
        UpdateHeroAssetCount(dt.Rows.Count);


    }

    private void ShowWarning(string message)
    {
        ScriptManager.RegisterStartupScript(
            this, GetType(), Guid.NewGuid().ToString(),
            "Swal.fire({icon:'warning',title:'Required Selection',text:'" +
            message.Replace("'", "\\'") + "',confirmButtonColor:'#f59e0b'});",
            true);
    }

    // =====================================================================
    //  ROW DATA BOUND
    // =====================================================================
    protected void gvAssets_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow) return;

        try
        {
            string itid = DataBinder.Eval(e.Row.DataItem, "ITID").ToString();
            e.Row.Attributes["data-itid"] = itid;
        }
        catch { }

        if ((e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
        {
            string statusValue = "";
            try { statusValue = DataBinder.Eval(e.Row.DataItem, "Status").ToString().Trim(); }
            catch { }
            DropDownList ddlEditStatus = (DropDownList)e.Row.FindControl("ddlEditStatus");
            if (ddlEditStatus != null) SafeSetDropDown(ddlEditStatus, statusValue);

            string sectorValue = "";
            try { sectorValue = DataBinder.Eval(e.Row.DataItem, "Sector").ToString().Trim(); }
            catch { }
            DropDownList ddlEditSector = (DropDownList)e.Row.FindControl("ddlEditSector");
            if (ddlEditSector != null) SafeSetDropDown(ddlEditSector, sectorValue);
        }
    }

    private void SafeSetDropDown(DropDownList ddl, string value)
    {
        if (string.IsNullOrEmpty(value)) return;
        ListItem item = ddl.Items.FindByValue(value);
        if (item == null)
            foreach (ListItem li in ddl.Items)
                if (li.Value.Equals(value, StringComparison.OrdinalIgnoreCase)) { item = li; break; }
        if (item == null)
            foreach (ListItem li in ddl.Items)
                if (li.Text.Equals(value, StringComparison.OrdinalIgnoreCase)) { item = li; break; }
        if (item != null) ddl.SelectedValue = item.Value;
    }

    // =====================================================================
    //  INSERT ASSET
    // =====================================================================
    protected void btnInsert_Click(object sender, EventArgs e)
    {
        if (ddlOffice.SelectedValue == "0" ||
    string.IsNullOrEmpty(ddlGroup.SelectedValue))
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "msg",
                "alert('Please select Office and Category first.');",
                true);

            return;
        }
        string item = txtItemName.Text.Trim();
        string brand = txtBrand.Text.Trim();
        string capacity = txtCapacity.Text.Trim();
        string description = txtDescription.Text.Trim();
        string serialNumber = txtSerialNumber.Text.Trim();
        string status = ddlStatus.SelectedValue;
        string sector = rblSector.SelectedValue;
        string remark = txtRemark.Text.Trim();
        string department = txtDepartment.Text.Trim();
        string type = txtType.Text.Trim();

        int officeId = Convert.ToInt32(ddlOffice.SelectedValue);

        string group = ddlGroup.SelectedValue;

        string insertedBy = Session["user"] != null
            ? Session["user"].ToString()
            : "";

        string[] selectedPeripherals = Request.Form.GetValues("peripherals");

        string peripherals = selectedPeripherals != null
            ? string.Join(", ", selectedPeripherals)
            : "";

        int qty = 0;
        int.TryParse(txtQty.Text.Trim(), out qty);

        int workingQty = 0;
        int.TryParse(txtWorking.Text.Trim(), out workingQty);

        if (qty <= 0)
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "qtyErr1",
                "Swal.fire({icon:'warning',title:'Invalid Quantity',text:'Total Quantity must be greater than zero.'});",
                true);

            return;
        }

        if (workingQty > qty)
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "qtyErr2",
                "Swal.fire({icon:'warning',title:'Invalid Quantity',text:'Working Quantity cannot exceed Total Quantity.'});",
                true);

            return;
        }

        int nonWorkingQty = qty - workingQty;

        try
        {
            string assetCode = objBAL.InsertAsset(
                item, brand, capacity, description, serialNumber,
                group, qty, workingQty, nonWorkingQty,
                status, remark, sector, officeId, department, type, insertedBy, peripherals);

            if (string.IsNullOrEmpty(assetCode))
                throw new Exception("Asset code not returned from SP_InsertAsset.");

            if (fuAssetImage.HasFile)
            {
                string folderPath = Server.MapPath("~/images/");
                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                string extension = Path.GetExtension(fuAssetImage.FileName);
                string fileName = assetCode + "_" +
                                   DateTime.Now.ToString("yyyyMMddHHmmss") + extension;

                fuAssetImage.SaveAs(Path.Combine(folderPath, fileName));
                objBAL.InsertImage(assetCode, fileName, "~/images/" + fileName);
            }

            ClearModalFields();
            LoadHeroStats(UserRole);

            ScriptManager.RegisterStartupScript(this, GetType(), "inserted",
                "setTimeout(function(){Swal.fire({icon:'success'," +
                "title:'Asset Added Successfully'," +
                "html:'<div style=\"font-size:18px;\">Asset Code:<br>" +
                "<b style=\"color:#2563eb;font-size:28px;\">" + assetCode + "</b></div>'," +
                "confirmButtonText:'OK'});},300);", true);

            btnSubmit_Click(sender, e);
        }
        catch (Exception ex)
        {
            string msg = ex.Message;

            if (msg.Contains("Serial Number already exists"))
            {
                msg = "This Serial Number already exists for this office and category.";
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "insertErr",
                "Swal.fire({icon:'error',title:'Insert Failed',text:'" +
                msg.Replace("'", "\\'") + "'});", true);
        }
    }

    // =====================================================================
    //  EDIT / CANCEL / UPDATE / DELETE
    // =====================================================================
    protected void gvAssets_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvAssets.EditIndex = e.NewEditIndex;
        btnSubmit_Click(null, null);
    }

    protected void gvAssets_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvAssets.EditIndex = -1;
        btnSubmit_Click(null, null);
    }

    protected void gvAssets_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(gvAssets.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvAssets.Rows[e.RowIndex];

            string itemName = GetCellText(row, 2);
            string brand = GetCellText(row, 3);
            string capacity = GetCellText(row, 4);
            string serialNumber = GetCellText(row, 5);

            int qty = 0;
            int.TryParse(GetCellText(row, 6), out qty);

            int workingQty = 0;
            int.TryParse(GetCellText(row, 7), out workingQty);

            if (workingQty > qty)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "editQtyErr",
                    "Swal.fire({icon:'warning',title:'Invalid Quantity'," +
                    "text:'Working Quantity cannot exceed Total Quantity.'});", true);
                return;
            }

            int nonWorkingQty = qty - workingQty;

            DropDownList ddlEditStatus = (DropDownList)row.FindControl("ddlEditStatus");
            DropDownList ddlEditSector = (DropDownList)row.FindControl("ddlEditSector");
            string status = ddlEditStatus != null ? ddlEditStatus.SelectedValue : "";
            string sector = ddlEditSector != null ? ddlEditSector.SelectedValue : "";

            string department = GetCellText(row, 11);
            string description = GetCellText(row, 12);
            string remark = GetCellText(row, 13);
            string group = ddlGroup.SelectedValue;
            int officeId = Convert.ToInt32(ddlOffice.SelectedValue);   // ← NEW

            FileUpload fuImage = (FileUpload)row.FindControl("fuImage");

            string imagePath = "";

            if (fuImage != null && fuImage.HasFile)
            {
                string extension = Path.GetExtension(fuImage.FileName).ToLower();

                string[] allowedExtensions = { ".jpg", ".jpeg", ".png" };

                if (!allowedExtensions.Contains(extension))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "imgErrEdit",
                        "Swal.fire({icon:'warning',title:'Invalid Image Format'," +
                        "text:'Only JPG, JPEG and PNG images are allowed.'});", true);
                    return;
                }

                string fileName = Path.GetFileName(fuImage.FileName);
                imagePath = "~/Images/" + fileName;
                fuImage.SaveAs(Server.MapPath(imagePath));
            }

            objBAL.UpdateAsset(id, itemName, brand, capacity, description,
                               serialNumber, qty, workingQty, nonWorkingQty,
                               status, remark, sector, group, department, imagePath,
                               officeId);   // ← NEW

            gvAssets.EditIndex = -1;
            btnSubmit_Click(null, null);
        }
        catch (Exception ex)
        {
            string msg = ex.Message;

            if (msg.Contains("Serial Number already exists"))
            {
                msg = "This Serial Number is already assigned to another asset in this office.";
            }

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "updErr",
                "Swal.fire({icon:'error',title:'Update Failed',text:'" +
                msg.Replace("'", "\\'") +
                "'});",
                true);
        }
    }

    protected void gvAssets_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(gvAssets.DataKeys[e.RowIndex].Value);
        objBAL.DeleteAsset(id, ddlGroup.SelectedValue);
        btnSubmit_Click(null, null);
    }

    protected void gvAssets_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Maintenance")
            Response.Redirect("Maintenance.aspx?AssetID=" + e.CommandArgument
                              + "&Group=" + ddlGroup.SelectedValue);
    }

    // =====================================================================
    //  REPORT — APPLY FILTER
    // =====================================================================
    protected void btnApplyFilter_Click(object sender, EventArgs e)
    {
        int officeId = 0;
        int.TryParse(ddlReportOffice.SelectedValue, out officeId);
        if (officeId < 0) officeId = 0;

        string group = ddlReportGroup.SelectedValue;

        DataTable dt = BuildReportData(officeId, group);
        dt = NormalizeColumns(dt);

        if (dt == null || dt.Rows.Count == 0)
        {
            pnlReportEmpty.Visible = true;
            gvReport.Visible = false;
            lblTotalItems.Text = "0";
            lblTotalQty.Text = "0";
            lblTotalWorking.Text = "0";
            lblTotalNonWork.Text = "0";
            ReopenReportModal(false);
            return;
        }

        gvReport.DataSource = dt;
        gvReport.DataBind();
        gvReport.Visible = true;
        pnlReportEmpty.Visible = false;

        int totalQty = 0, totalWorking = 0, totalNonWork = 0;
        foreach (DataRow dr in dt.Rows)
        {
            int q = 0, w = 0, nw = 0;
            int.TryParse(dr["Quantity"] == DBNull.Value ? "0" : dr["Quantity"].ToString(), out q);
            int.TryParse(dr["WorkingQty"] == DBNull.Value ? "0" : dr["WorkingQty"].ToString(), out w);
            int.TryParse(dr["NonWorkingQty"] == DBNull.Value ? "0" : dr["NonWorkingQty"].ToString(), out nw);
            totalQty += q;
            totalWorking += w;
            totalNonWork += nw;
        }

        lblTotalItems.Text = dt.Rows.Count.ToString();
        lblTotalQty.Text = totalQty.ToString();
        lblTotalWorking.Text = totalWorking.ToString();
        lblTotalNonWork.Text = totalNonWork.ToString();

        string officeLabel = (officeId == 0)
            ? (UserRole == "IT team" ? "All Assigned Offices" : "All Offices")
            : (ddlReportOffice.SelectedItem != null ? ddlReportOffice.SelectedItem.Text : "");

        string groupLabel = string.IsNullOrEmpty(group) ? "All Categories" : group;

        ScriptManager.RegisterStartupScript(this, GetType(), "setSubtitle",
            "document.getElementById('reportSubtitle').innerText = '" +
            officeLabel.Replace("'", "\\'") + " \u00b7 " +
            groupLabel.Replace("'", "\\'") + "';", true);

        ReopenReportModal(true);
    }

    // =====================================================================
    //  REPORT — DOWNLOAD XLSX
    // =====================================================================
    protected void btnDownloadExcel_Click(object sender, EventArgs e)
{
    int officeId = 0;
    int.TryParse(ddlReportOffice.SelectedValue, out officeId);
    if (officeId < 0) officeId = 0;

    string group = ddlReportGroup.SelectedValue;

    DataTable dt = BuildReportData(officeId, group);
    dt = NormalizeColumns(dt);

    if (dt == null || dt.Rows.Count == 0)
    {
        ReopenReportModal(gvReport.Visible);
        ScriptManager.RegisterStartupScript(this, GetType(), "noData",
            "alert('No records found for the selected filters.');", true);
        return;
    }

    using (XLWorkbook wb = new XLWorkbook())
    {
        string sheetName = string.IsNullOrEmpty(group) ? "All Assets" : group + " Assets";
        IXLWorksheet ws = wb.Worksheets.Add(sheetName);

        string officeName = (officeId == 0)
            ? (UserRole == "IT team" ? "All Assigned Offices" : "All Offices")
            : (ddlReportOffice.SelectedItem != null ? ddlReportOffice.SelectedItem.Text : "All");
        string catName = string.IsNullOrEmpty(group) ? "All Categories" : group;

        // Title
        ws.Cell(1, 1).Value = "Office Asset Report";
        ws.Range(1, 1, 1, 18).Merge();
        ws.Cell(1, 1).Style.Font.Bold = true;
        ws.Cell(1, 1).Style.Font.FontSize = 14;
        ws.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        ws.Cell(1, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#0f172a");
        ws.Cell(1, 1).Style.Font.FontColor = XLColor.White;

        // Subtitle
        ws.Cell(2, 1).Value = string.Format(
            "Office: {0}   |   Category: {1}   |   Generated: {2}",
            officeName, catName, DateTime.Now.ToString("dd-MMM-yyyy HH:mm"));
        ws.Range(2, 1, 2, 18).Merge();
        ws.Cell(2, 1).Style.Font.Italic = true;
        ws.Cell(2, 1).Style.Font.FontSize = 10;
        ws.Cell(2, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#e0f2fe");
        ws.Cell(2, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

        // Headers
        string[] headers = {
        "Sr No","ID","Item Name","Brand","Capacity","Serial No",
        "Total Qty","Working","Non-Working","Status","Sector",
        "Office","Category","Department","Description","Remark","Inserted By","Inserted Date"
    };
        for (int c = 0; c < headers.Length; c++)
        {
            var hCell = ws.Cell(4, c + 1);
            hCell.Value = headers[c];
            hCell.Style.Font.Bold = true;
            hCell.Style.Fill.BackgroundColor = XLColor.FromHtml("#5d87ff");
            hCell.Style.Font.FontColor = XLColor.White;
            hCell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            hCell.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
        }

        // Data rows
        int dataRow = 5;
        int srNo = 1;
        bool alt = false;
        XLColor altColor = XLColor.FromHtml("#f8fafc");

        foreach (DataRow row in dt.Rows)
        {
            ws.Cell(dataRow, 1).Value = srNo;
            ws.Cell(dataRow, 2).Value = SafeCol(row, "ITID");
            ws.Cell(dataRow, 3).Value = SafeCol(row, "ItemName");
            ws.Cell(dataRow, 4).Value = SafeCol(row, "Brand");
            ws.Cell(dataRow, 5).Value = SafeCol(row, "Capacity");
            ws.Cell(dataRow, 6).Value = SafeCol(row, "SerialNumber");
            ws.Cell(dataRow, 7).Value = row["Quantity"] == DBNull.Value ? 0 : Convert.ToInt32(row["Quantity"]);
            ws.Cell(dataRow, 8).Value = row["WorkingQty"] == DBNull.Value ? 0 : Convert.ToInt32(row["WorkingQty"]);
            ws.Cell(dataRow, 9).Value = row["NonWorkingQty"] == DBNull.Value ? 0 : Convert.ToInt32(row["NonWorkingQty"]);
            ws.Cell(dataRow, 10).Value = SafeCol(row, "Status");
            ws.Cell(dataRow, 11).Value = SafeCol(row, "Sector");
            ws.Cell(dataRow, 12).Value = SafeCol(row, "OfficeName", "Office");
            ws.Cell(dataRow, 13).Value = SafeCol(row, "AssetGroup", "GroupName", "Category");
            ws.Cell(dataRow, 14).Value = SafeCol(row, "Department");
            ws.Cell(dataRow, 15).Value = SafeCol(row, "Description");
            ws.Cell(dataRow, 16).Value = SafeCol(row, "Remark");
            ws.Cell(dataRow, 17).Value = SafeCol(row, "InsertedBy", "CreatedBy", "AddedBy");

                // InsertedDate — parse as DateTime so Excel formats it as a date cell, not text
                string rawDate = SafeCol(row, "InsertedDate", "CreatedDate", "AddedDate");
            DateTime parsedDate;
            if (DateTime.TryParse(rawDate, out parsedDate))
            {
                ws.Cell(dataRow, 18).Value = parsedDate;
                ws.Cell(dataRow, 18).Style.DateFormat.Format = "dd-MMM-yyyy";
            }
            else
            {
                ws.Cell(dataRow, 18).Value = rawDate;
            }

            if (alt) ws.Row(dataRow).Style.Fill.BackgroundColor = altColor;

            string sv = SafeCol(row, "Status").ToUpper();
            if (sv == "ACTIVE")
            {
                ws.Cell(dataRow, 10).Style.Fill.BackgroundColor = XLColor.FromHtml("#dcfce7");
                ws.Cell(dataRow, 10).Style.Font.FontColor = XLColor.FromHtml("#166534");
            }
            else if (sv == "INACTIVE")
            {
                ws.Cell(dataRow, 10).Style.Fill.BackgroundColor = XLColor.FromHtml("#fee2e2");
                ws.Cell(dataRow, 10).Style.Font.FontColor = XLColor.FromHtml("#991b1b");
            }

            ws.Range(dataRow, 1, dataRow, 18).Style.Border.OutsideBorder = XLBorderStyleValues.Hair;
            alt = !alt;
            dataRow++;
            srNo++;
        }

        // Summary
        int sumRow = dataRow + 1;
        ws.Cell(sumRow, 1).Value = "TOTAL ASSETS:";
        ws.Cell(sumRow, 2).Value = dt.Rows.Count;
        ws.Cell(sumRow, 1).Style.Font.Bold = true;
        ws.Cell(sumRow, 2).Style.Font.Bold = true;
        ws.Cell(sumRow, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#0f172a");
        ws.Cell(sumRow, 1).Style.Font.FontColor = XLColor.White;
        ws.Cell(sumRow, 2).Style.Fill.BackgroundColor = XLColor.FromHtml("#5d87ff");
        ws.Cell(sumRow, 2).Style.Font.FontColor = XLColor.White;

        ws.Columns().AdjustToContents();

        string fileName = string.Format("AssetReport_{0}_{1}.xlsx",
            officeName.Replace(" ", "_"),
            DateTime.Now.ToString("yyyyMMdd_HHmm"));

        Response.Clear();
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
        using (MemoryStream ms = new MemoryStream())
        {
            wb.SaveAs(ms);
            ms.WriteTo(Response.OutputStream);
        }
        Response.Flush();
        Response.End();
    }
}

    protected void btnDownloadReport_Click(object sender, EventArgs e)
    {
        btnDownloadExcel_Click(sender, e);
    }

    // =====================================================================
    //  BUILD REPORT DATA  (shared by Apply Filter + Download Excel)
    // =====================================================================
    private DataTable BuildReportData(int officeId, string group)
{
    DataTable dt = new DataTable();

    if (UserRole == "IT team")
    {
        DataTable userOffices = Session["userOffices"] as DataTable;
        if (userOffices == null) return dt;

        if (officeId == 0)
        {
            foreach (DataRow row in userOffices.Rows)
            {
                int oid = Convert.ToInt32(row["OfficeID"]);
                DataTable temp = objBAL.GetAssetsByOfficeAndGroup(oid, group);
                if (temp == null) continue;
                if (dt.Columns.Count == 0) dt = temp.Clone();
                dt.Merge(temp);
            }
        }
        else
        {
            dt = objBAL.GetAssetsByOfficeAndGroup(officeId, group);
        }
    }
    else
    {
        // ── FIX: when officeId == 0, loop through only the district's offices ──
        if (officeId == 0)
        {
            string district = Session["SelectedDistrict"] != null
                ? Session["SelectedDistrict"].ToString() : "";

            DataTable districtOffices = objBAL.GetOfficesByDistrict(district);
            if (districtOffices == null) return dt;

            foreach (DataRow row in districtOffices.Rows)
            {
                int oid = Convert.ToInt32(row["OfficeID"]);
                DataTable temp = objBAL.GetAssetsByOfficeAndGroup(oid, group);
                if (temp == null) continue;
                if (dt.Columns.Count == 0) dt = temp.Clone();
                dt.Merge(temp);
            }
        }
        else
        {
            dt = objBAL.GetAssetsByOfficeAndGroup(officeId, group);
        }
    }

    return dt;
}

    // =====================================================================
    //  HELPERS
    // =====================================================================
    private void ReopenReportModal(bool showSummary)
    {
        string s = showSummary
            ? "document.getElementById('reportSummary').style.display='flex';"
            : "document.getElementById('reportSummary').style.display='none';";

        ScriptManager.RegisterStartupScript(this, GetType(), "reopenReport",
            "document.getElementById('reportOverlay').classList.add('open');" +
            "document.body.style.overflow='hidden';" + s, true);
    }

    private string GetCellText(GridViewRow row, int cellIndex)
    {
        try
        {
            if (row.Cells[cellIndex].Controls.Count > 0)
            {
                TextBox tb = row.Cells[cellIndex].Controls[0] as TextBox;
                if (tb != null) return tb.Text.Trim();
            }
            return row.Cells[cellIndex].Text.Trim();
        }
        catch { return ""; }
    }

    private void ClearModalFields()
    {
        txtItemName.Text = "";
        txtBrand.Text = "";
        txtCapacity.Text = "";
        txtSerialNumber.Text = "";
        txtType.Text = "";
        txtDescription.Text = "";
        txtRemark.Text = "";
        txtQty.Text = "";
        txtWorking.Text = "";
        txtNonWorking.Text = "";
        ddlStatus.SelectedIndex = 0;
        rblSector.SelectedIndex = -1;
        txtDepartment.Text = "";
    }



    private string SafeCol(DataRow row, params string[] colNames)
    {
        foreach (string col in colNames)
            if (row.Table.Columns.Contains(col) && row[col] != DBNull.Value)
                return row[col].ToString().Trim();
        return "";
    }
protected string GetPeripherals(object dataItem)
{
    System.Data.DataRowView row = dataItem as System.Data.DataRowView;
    if (row == null) return "";
    if (!row.Row.Table.Columns.Contains("Peripherals")) return "";
    return row["Peripherals"] == DBNull.Value ? "" : row["Peripherals"].ToString();
}
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CheckSerialExists(string serialNumber, string group, int officeId)
    {
        BAL_Home bal = new BAL_Home();
        bool exists = bal.IsSerialNumberExists(serialNumber, group, officeId, 0);
        return exists ? "EXISTS" : "OK";
    }

}