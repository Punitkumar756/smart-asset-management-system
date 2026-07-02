using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Net.NetworkInformation;

public partial class AssetDetails : System.Web.UI.Page
{
    private readonly string conStr =
        ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        string assetCode = Request.QueryString["code"];
        if (!string.IsNullOrEmpty(assetCode))
            LoadAssetDetails(assetCode);
        else
        {
            pnlError.Visible = true;
            litErrorCode.Text = "No asset code provided.";
        }
    }

    private void LoadAssetDetails(string assetCode)
    {
        try
        {
            using (MySqlConnection con = new MySqlConnection(conStr))
            {
                string query = @"
                    SELECT
                        A.AssetCode, A.ItemName, A.Brand, A.SerialNumber,
                        A.Quantity, A.Status, A.Description, A.InsertedBy,
                        A.InsertedDate, A.Sector,
                        'IT' AS Category,
                        O.OfficeName
                    FROM IT A
                    INNER JOIN `Group` G ON A.GroupID = G.ID
                    INNER JOIN Office O ON G.OfficeID = O.OfficeID
                    WHERE A.AssetCode = @AssetCode

                    UNION ALL

                    SELECT
                        A.AssetCode, A.ItemName, A.Brand, A.SerialNumber,
                        A.Quantity, A.Status, A.Description, A.InsertedBy,
                        A.InsertedDate, A.Sector,
                        'Furniture' AS Category,
                        O.OfficeName
                    FROM Furniture A
                    INNER JOIN `Group` G ON A.GroupID = G.ID
                    INNER JOIN Office O ON G.OfficeID = O.OfficeID
                    WHERE A.AssetCode = @AssetCode

                    UNION ALL

                    SELECT
                        A.AssetCode, A.ItemName, A.Brand, A.SerialNumber,
                        A.Quantity, A.Status, A.Description, A.InsertedBy,
                        A.InsertedDate, A.Sector,
                        'Electronics' AS Category,
                        O.OfficeName
                    FROM Electronics A
                    INNER JOIN `Group` G ON A.GroupID = G.ID
                    INNER JOIN Office O ON G.OfficeID = O.OfficeID
                    WHERE A.AssetCode = @AssetCode

                    LIMIT 1";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@AssetCode", assetCode);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    pnlDetails.Visible = true;

                    litAssetCode.Text = row["AssetCode"].ToString();
                    litItemName.Text = row["ItemName"].ToString();
                    litCategory.Text = row["Category"].ToString();
                    litCat.Text = row["Category"].ToString();
                    litOffice.Text = row["OfficeName"].ToString();
                    litBrand.Text = string.IsNullOrEmpty(row["Brand"].ToString()) ? "N/A" : row["Brand"].ToString();
                    litSerial.Text = string.IsNullOrEmpty(row["SerialNumber"].ToString()) ? "N/A" : row["SerialNumber"].ToString();
                    litStatus.Text = row["Status"].ToString();
                    litQty.Text = row["Quantity"].ToString();
                    litDesc.Text = string.IsNullOrEmpty(row["Description"].ToString()) ? "N/A" : row["Description"].ToString();
                    litInsertedBy.Text = row["InsertedBy"].ToString();
                    litInsertedDate.Text = Convert.ToDateTime(row["InsertedDate"]).ToString("dd-MMM-yyyy");
                }
                else
                {
                    pnlError.Visible = true;
                    litErrorCode.Text = assetCode;
                }
            }
        }
        catch (Exception ex)
        {
            pnlError.Visible = true;
            litErrorCode.Text = "Error: " + ex.Message;
        }
    }
}