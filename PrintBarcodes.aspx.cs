using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZXing;

public partial class PrintBarcodes : System.Web.UI.Page
{
    private readonly string conStr =
        ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Loadusers();
            LoadOffices();
            txtFromDate.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
            txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }
    }

    private void Loadusers()
    {
        try
        {
            using (MySqlConnection con = new MySqlConnection(conStr))
            {
                string query = "SELECT username FROM users ORDER BY username";
                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlUser.DataSource = dt;
                ddlUser.DataTextField = "username";
                ddlUser.DataValueField = "username";
                ddlUser.DataBind();
                ddlUser.Items.Insert(0, new ListItem("All users", ""));
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
        }
    }

    private void LoadOffices()
    {
        try
        {
            using (MySqlConnection con = new MySqlConnection(conStr))
            {
                string query = "SELECT OfficeID, OfficeName FROM Office ORDER BY OfficeName";
                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlOffice.DataSource = dt;
                ddlOffice.DataTextField = "OfficeName";
                ddlOffice.DataValueField = "OfficeID";
                ddlOffice.DataBind();
                ddlOffice.Items.Insert(0, new ListItem("All Offices", ""));
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadBarcodes();
    }

    private void LoadBarcodes()
    {
        try
        {
            DataTable dt = new DataTable();

            using (MySqlConnection con = new MySqlConnection(conStr))
            {
                MySqlCommand cmd = new MySqlCommand("GetFilteredBarcodes", con);
                cmd.CommandType = CommandType.StoredProcedure;

                // Username — empty string means "All users"
                cmd.Parameters.AddWithValue("@p_Username",
                    string.IsNullOrEmpty(ddlUser.SelectedValue) ? "" : ddlUser.SelectedValue);

                // OfficeID — 0 means "All Offices"
                cmd.Parameters.AddWithValue("@p_OfficeID",
                    string.IsNullOrEmpty(ddlOffice.SelectedValue) ? 0 : int.Parse(ddlOffice.SelectedValue));

                // Category — empty string means "All"
                cmd.Parameters.AddWithValue("@p_Category",
                    string.IsNullOrEmpty(ddlCategory.SelectedValue) ? "" : ddlCategory.SelectedValue);

                // Date range
                cmd.Parameters.AddWithValue("@p_FromDate", txtFromDate.Text.Trim());
                cmd.Parameters.AddWithValue("@p_ToDate", txtToDate.Text.Trim());

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
            }

            if (!dt.Columns.Contains("BarcodeImage"))
                dt.Columns.Add("BarcodeImage", typeof(string));

            if (!dt.Columns.Contains("QRImage"))
                dt.Columns.Add("QRImage", typeof(string));

            foreach (DataRow row in dt.Rows)
            {
                string assetCode = Convert.ToString(row["AssetCode"]);
                if (!string.IsNullOrEmpty(assetCode))
                {
                    row["BarcodeImage"] = GenerateBarcode(assetCode);
                    row["QRImage"] = GenerateQRCode(assetCode);
                }
            }

            rptBarcode.DataSource = dt;
            rptBarcode.DataBind();
            lblMessage.Text = dt.Rows.Count + " barcode(s) found.";
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Error: " + ex.Message;
        }
    }

    private string GenerateBarcode(string barcodeText)
    {
        BarcodeWriter writer = new BarcodeWriter();
        writer.Format = BarcodeFormat.CODE_128;

        Bitmap bitmap = writer.Write(barcodeText);

        using (MemoryStream ms = new MemoryStream())
        {
            bitmap.Save(ms, ImageFormat.Png);
            return "data:image/png;base64," + Convert.ToBase64String(ms.ToArray());
        }
    }

    private string GenerateQRCode(string assetCode)
    {
        string url = "http://118.185.129.94:8080/AssetDetails.aspx?code=" + assetCode;

        BarcodeWriter writer = new BarcodeWriter();
        writer.Format = BarcodeFormat.QR_CODE;
        writer.Options = new ZXing.Common.EncodingOptions
        {
            Width = 120,
            Height = 120,
            Margin = 1
        };

        Bitmap bitmap = writer.Write(url);

        using (MemoryStream ms = new MemoryStream())
        {
            bitmap.Save(ms, ImageFormat.Png);
            return "data:image/png;base64," + Convert.ToBase64String(ms.ToArray());
        }
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(
            this,
            GetType(),
            "Print",
            "window.print();",
            true);
    }
}