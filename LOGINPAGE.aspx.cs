using System;
using System.Data;

public partial class LOGINPAGE : System.Web.UI.Page
{
    BAL_User bal = new BAL_User();

    protected void Page_Load(object sender, EventArgs e)
    {
        // Clear any old session on arriving at login page
        Session.Clear();
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string role = ddlRole.SelectedValue;
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();
        string serverCaptcha = hdnServerCaptcha.Value;
        string userCaptcha = txtCaptchaInput.Text.Trim();

        // ── CAPTCHA CHECK ──────────────────────────────────────────────
        if (serverCaptcha != userCaptcha)
        {
            lblMessage.Text = "Invalid CAPTCHA";
            return;
        }

        // ── CREDENTIAL CHECK ───────────────────────────────────────────
        bool check = bal.Login(username, password, role);

        if (check)
        {
            Session["user"] = username;
            Session["role"] = role;

            if (role == "IT team")
            {
                // Store state & district (single row, first match)
                DataRow dr = bal.GetUserDetails(username, role);
                if (dr != null)
                {
                    Session["state"] = dr["state"] == DBNull.Value ? "" : dr["state"].ToString();
                    Session["district"] = dr["district"] == DBNull.Value ? "" : dr["district"].ToString();
                }
                else
                {
                    Session["state"] = "";
                    Session["district"] = "";
                }

                // ── NEW: store ALL assigned offices as a DataTable ──
                // Each row has OfficeName and OfficeID from the Office table
                DataTable dtOffices = bal.GetUserOffices(username);
                Session["userOffices"] = dtOffices;
            }

            Response.Redirect("home.aspx");
        }
        else
        {
            lblMessage.Text = "Invalid Username or Password";
        }
    }
}