using System;
using System.Configuration;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;

public partial class home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // ── Session guard ──
        if (Session["user"] == null)
        {
            Response.Redirect("~/LOGINPAGE.aspx");
            return;
        }

        string role = Session["role"] != null ? Session["role"].ToString() : string.Empty;

        string username = Session["user"] != null ? Session["user"].ToString() : "";
        lblRole.Text = username;

        // ── Show Add User button for Admins only ──
        if (role == "Admin")
        {
            pnlAddUserBtn.Visible = true;
        }

        if (!IsPostBack)
        {
            LoadStates();       // main page State dropdown
            LoadModalStates();  // Add User modal State dropdown

            // ── IT Team: lock state & district to their assigned location ──
            if (role == "IT team")
            {
                pnlAutofillNotice.Visible = true;
                PreFillITTeamLocation();
            }
            // ── Admin: all fields open, nothing locked ──
        }
        else
        {
            // On postback, keep the autofill notice visible for IT team
            if (role == "IT team")
            {
                pnlAutofillNotice.Visible = true;
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // MAIN PAGE – State / District / Pincode lookup
    // ─────────────────────────────────────────────────────────────────

    private void LoadStates()
    {
        string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
        using (MySqlConnection con = new MySqlConnection(cs))
        using (MySqlCommand cmd = new MySqlCommand("SELECT StateID, StateName FROM States ORDER BY StateName", con))
        {
            con.Open();
            MySqlDataReader dr = cmd.ExecuteReader();
            ddlState.Items.Clear();
            ddlState.Items.Add(new ListItem("-- Select State --", ""));
            while (dr.Read())
                ddlState.Items.Add(new ListItem(dr["StateName"].ToString(), dr["StateID"].ToString()));
        }
    }



    protected void ddlState_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlDistrict.Items.Clear();
        ddlDistrict.Items.Add(new ListItem("Choose District", ""));
        ddlDistrict.Enabled = false;

        if (string.IsNullOrEmpty(ddlState.SelectedValue)) return;

        string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
        using (MySqlConnection con = new MySqlConnection(cs))
        using (MySqlCommand cmd = new MySqlCommand(
            "SELECT DistrictID, DistrictName FROM Districts WHERE StateID=@sid ORDER BY DistrictName", con))
        {
            cmd.Parameters.AddWithValue("@sid", ddlState.SelectedValue);
            con.Open();
            MySqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
                ddlDistrict.Items.Add(new ListItem(dr["DistrictName"].ToString(), dr["DistrictID"].ToString()));
        }
        ddlDistrict.Enabled = true;
    }

    protected void ddlDistrict_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Optionally auto-load offices or trigger further cascades here
    }

    protected void btnFetchDetails_Click(object sender, EventArgs e)
    {
        string pinCode = txtPinCode.Text.Trim();
        string stateId = ddlState.SelectedValue;
        string districtId = ddlDistrict.SelectedValue;

        // Validate: either pincode OR state+district must be provided
        if (string.IsNullOrEmpty(pinCode) && (string.IsNullOrEmpty(stateId) || string.IsNullOrEmpty(districtId)))
        {
            lblStateMessage.Text = "Please select a State and District, or enter a PIN Code.";
            lblStateMessage.Visible = true;
            pnlWorkspace.Visible = false;
            return;
        }
        lblStateMessage.Visible = false;

        try
        {
            string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();

                // ── Resolve districtId from pincode if needed ──
                if (!string.IsNullOrEmpty(pinCode) && string.IsNullOrEmpty(districtId))
                {
                    using (MySqlCommand cmd = new MySqlCommand(
                        "SELECT DistrictID FROM PinCodes WHERE PinCode=@pin", con))
                    {
                        cmd.Parameters.AddWithValue("@pin", pinCode);
                        object result = cmd.ExecuteScalar();
                        if (result == null)
                        {
                            lblStateMessage.Text = "PIN Code not found in the system.";
                            lblStateMessage.Visible = true;
                            pnlWorkspace.Visible = false;
                            return;
                        }
                        districtId = result.ToString();
                    }
                }

                
               

            }
            Session["SelectedState"] = ddlState.SelectedItem.Text;
            Session["SelectedDistrict"] = ddlDistrict.SelectedItem.Text;
            Session["PinCode"] = txtPinCode.Text.Trim();

            Response.Redirect("~/NewFolder1/Assetsystem.aspx");
        }
        catch (Exception ex)
        {
            lblStateMessage.Text = "Error fetching data: " + ex.Message;
            lblStateMessage.Visible = true;
            pnlWorkspace.Visible = false;
        }
    }

    protected void btnGenerateReport_Click(object sender, EventArgs e)
    {
        Response.ContentType = "text/plain";
        Response.AddHeader("Content-Disposition", "attachment; filename=NodeReport.txt");
        Response.Write("Report generation not yet implemented.");
        Response.End();
    }

    // ─────────────────────────────────────────────────────────────────
    // IT TEAM – Auto-fill and LOCK location from session
    // Only called on first page load (!IsPostBack) for IT team role
    // ─────────────────────────────────────────────────────────────────

    private void PreFillITTeamLocation()
    {
        string stateName = Session["state"] != null ? Session["state"].ToString() : string.Empty;
        string districtName = Session["district"] != null ? Session["district"].ToString() : string.Empty;

        if (!string.IsNullOrEmpty(stateName))
        {
            // Match by text (StateName) since session stores the name, not the ID
            ListItem stateItem = ddlState.Items.FindByText(stateName);
            if (stateItem != null)
            {
                ddlState.SelectedValue = stateItem.Value;
                ddlState.CssClass += " autofilled";
                ddlState.Enabled = false;

                // Populate the district dropdown for this state
                ddlDistrict.Items.Clear();
                string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
                using (MySqlConnection con = new MySqlConnection(cs))
                using (MySqlCommand cmd = new MySqlCommand(
                    "SELECT DistrictID, DistrictName FROM Districts WHERE StateID=@sid ORDER BY DistrictName", con))
                {
                    cmd.Parameters.AddWithValue("@sid", stateItem.Value);
                    con.Open();
                    MySqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                        ddlDistrict.Items.Add(new ListItem(dr["DistrictName"].ToString(), dr["DistrictID"].ToString()));
                }
            }
        }

        if (!string.IsNullOrEmpty(districtName))
        {
            // Match by text (DistrictName) since session stores the name, not the ID
            ListItem distItem = ddlDistrict.Items.FindByText(districtName);
            if (distItem != null)
            {
                ddlDistrict.SelectedValue = distItem.Value;
            }
            ddlDistrict.CssClass += " autofilled";
            ddlDistrict.Enabled = false;
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // ADD USER MODAL – Admin only
    // ─────────────────────────────────────────────────────────────────

    private void LoadModalStates()
    {
        string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
        using (MySqlConnection con = new MySqlConnection(cs))
        using (MySqlCommand cmd = new MySqlCommand("SELECT StateID, StateName FROM States ORDER BY StateName", con))
        {
            con.Open();
            MySqlDataReader dr = cmd.ExecuteReader();
            ddlNewState.Items.Clear();
            ddlNewState.Items.Add(new ListItem("-- Select State --", ""));
            while (dr.Read())
                ddlNewState.Items.Add(new ListItem(dr["StateName"].ToString(), dr["StateID"].ToString()));
        }
    }

    protected void ddlNewDistrict_SelectedIndexChanged(object sender, EventArgs e)
    {
        ViewState["ModalOpen"] = "1";
        cblOffices.Items.Clear();
        pnlOfficeCheckboxes.Style["display"] = "none";
        lblNoOffices.Visible = false;

        if (string.IsNullOrEmpty(ddlNewDistrict.SelectedValue)) return;

        string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
        using (MySqlConnection con = new MySqlConnection(cs))
        using (MySqlCommand cmd = new MySqlCommand(
            "SELECT OfficeID, OfficeName FROM Office WHERE District=@did ORDER BY OfficeName", con))
        {
            cmd.Parameters.AddWithValue("@did", ddlNewDistrict.SelectedItem.Text);
            con.Open();
            MySqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
                cblOffices.Items.Add(new ListItem(dr["OfficeName"].ToString(), dr["OfficeID"].ToString()));
        }

        if (cblOffices.Items.Count > 0)
            pnlOfficeCheckboxes.Style["display"] = "block";
        else
            lblNoOffices.Visible = true;
    }

    protected void ddlNewState_SelectedIndexChanged(object sender, EventArgs e)
    {
        ViewState["ModalOpen"] = "1";
        ddlNewDistrict.Items.Clear();
        ddlNewDistrict.Items.Add(new ListItem("-- Select District --", ""));
        cblOffices.Items.Clear();
        pnlOfficeCheckboxes.Style["display"] = "none";
        lblNoOffices.Visible = false;
        ddlNewDistrict.Enabled = false;

        if (string.IsNullOrEmpty(ddlNewState.SelectedValue)) return;

        string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
        using (MySqlConnection con = new MySqlConnection(cs))
        using (MySqlCommand cmd = new MySqlCommand(
            "SELECT DistrictID, DistrictName FROM Districts WHERE StateID=@sid ORDER BY DistrictName", con))
        {
            cmd.Parameters.AddWithValue("@sid", ddlNewState.SelectedValue);
            con.Open();
            MySqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
                ddlNewDistrict.Items.Add(new ListItem(dr["DistrictName"].ToString(), dr["DistrictID"].ToString()));
        }
        ddlNewDistrict.Enabled = true;
    }

    protected void btnCreateUser_Click(object sender, EventArgs e)
    {
        ViewState["ModalOpen"] = "1";

        string username = txtNewUsername.Text.Trim();
        string password = txtNewPassword.Text.Trim();
        string role = ddlNewRole.SelectedValue;
        string stateId = ddlNewState.SelectedValue;
        string distId = ddlNewDistrict.SelectedValue;

        // Collect selected offices
        var selectedOffices = new System.Collections.Generic.List<string>();
        foreach (ListItem item in cblOffices.Items)
            if (item.Selected) selectedOffices.Add(item.Text);

        if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password)
            || string.IsNullOrEmpty(role) || string.IsNullOrEmpty(stateId)
            || string.IsNullOrEmpty(distId) || selectedOffices.Count == 0)
        {
            ShowModalAlert("All fields are required and at least one office must be selected.", "error");
            return;
        }

        try
        {
            string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                // Insert one row per selected office (matches your existing table pattern)
                foreach (string officeName in selectedOffices)
                {
                    using (MySqlCommand cmd = new MySqlCommand(
                        @"INSERT INTO users (username, password, role, state, district, office)
                      VALUES (@u, @p, @r, @s, @d, @o)", con))
                    {
                        cmd.Parameters.AddWithValue("@u", username);
                        cmd.Parameters.AddWithValue("@p", password);
                        cmd.Parameters.AddWithValue("@r", role);
                        cmd.Parameters.AddWithValue("@s", ddlNewState.SelectedItem.Text);
                        cmd.Parameters.AddWithValue("@d", ddlNewDistrict.SelectedItem.Text);
                        cmd.Parameters.AddWithValue("@o", officeName);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            // Reset form on success
            ViewState["ModalOpen"] = "0";
            txtNewUsername.Text = "";
            txtNewPassword.Text = "";
            ddlNewRole.SelectedIndex = 0;
            LoadModalStates();
            ddlNewDistrict.Items.Clear();
            ddlNewDistrict.Items.Add(new ListItem("-- Select District --", ""));
            ddlNewDistrict.Enabled = false;
            cblOffices.Items.Clear();
            pnlOfficeCheckboxes.Style["display"] = "none";
            lblNoOffices.Visible = false;

            string msg = selectedOffices.Count == 1
    ? "User created successfully with 1 office."
    : "User created successfully with " + selectedOffices.Count + " office assignments.";
            ShowModalAlert(msg, "success");
            ViewState["ModalOpen"] = "1";
        }
        catch (Exception ex)
        {
            ShowModalAlert("Error: " + ex.Message, "error");
        }
    }

    private void ShowModalAlert(string message, string type)
    {
        lblModalAlert.Text = message;
        lblModalAlert.CssClass = "modal-alert " + type;
        lblModalAlert.Visible = true;
    }
}