using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web.Hosting;
public class DAL_Home
{
    string conStr = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;

    // ================= STATES =================
    public DataTable GetStates()
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlDataAdapter da = new MySqlDataAdapter("SP_GetStates", con);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= DISTRICTS =================
    public DataTable GetDistrictsByState(int StateID)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlDataAdapter da = new MySqlDataAdapter("SP_GetDistrictsByState", con);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;
        da.SelectCommand.Parameters.AddWithValue("@p_StateID", StateID);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= PINCODES =================
    public DataTable GetPincodes(int districtID)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        string query = "SELECT Pincode FROM Pincodes WHERE DistrictID=@DistrictID";
        MySqlDataAdapter da = new MySqlDataAdapter(query, con);
        da.SelectCommand.Parameters.AddWithValue("@DistrictID", districtID);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

       public DataTable GetAdminStats()
    {
        string query = @"
        SELECT
            (SELECT COUNT(*) FROM Office) AS OfficeCount,
            (
                (SELECT COUNT(*) FROM IT)
                +
                (SELECT COUNT(*) FROM Furniture)
                +
                (SELECT COUNT(*) FROM Electronics)
            ) AS AssetCount";

        DataTable dt = new DataTable();

        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }
        }

        return dt;
    }

    public DataTable GetAdminStatsByDistrict(string district)
    {
        string query = @"
SELECT

(
    SELECT COUNT(*)
    FROM Office
    WHERE District = @District
) AS OfficeCount,

(
    (SELECT COUNT(*)
     FROM IT I
     INNER JOIN `Group` G
         ON I.GroupID = G.Id
     INNER JOIN Office O
         ON G.OfficeID = O.OfficeID
     WHERE O.District = @District)

    +

    (SELECT COUNT(*)
     FROM Furniture F
     INNER JOIN `Group` G
         ON F.GroupID = G.Id
     INNER JOIN Office O
         ON G.OfficeID = O.OfficeID
     WHERE O.District = @District)

    +

    (SELECT COUNT(*)
     FROM Electronics E
     INNER JOIN `Group` G
         ON E.GroupID = G.Id
     INNER JOIN Office O
         ON G.OfficeID = O.OfficeID
     WHERE O.District = @District)
) AS AssetCount";

        DataTable dt = new DataTable();

        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@District", district);

                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }
        }

        return dt;
    }

    // ================= BRANCHES =================
    public DataTable GetBranches(string pincode)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        string query = "SELECT BranchID,BranchName FROM Branches WHERE Pincode=@Pincode";
        MySqlDataAdapter da = new MySqlDataAdapter(query, con);
        da.SelectCommand.Parameters.AddWithValue("@Pincode", pincode);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= ASSETS =================
    public DataTable GetAssets()
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlDataAdapter da = new MySqlDataAdapter("SP_GetAllAssets", con);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= STAFF =================
    public DataTable GetStaff()
    {
        MySqlConnection con = new MySqlConnection(conStr);
        string query = "SELECT * FROM Staff";
        MySqlDataAdapter da = new MySqlDataAdapter(query, con);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= ASSIGNMENTS =================
    public DataTable GetAssignments()
    {
        MySqlConnection con = new MySqlConnection(conStr);
        string query = "SELECT * FROM Assignments";
        MySqlDataAdapter da = new MySqlDataAdapter(query, con);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= OFFICE + GROUP ASSETS =================
    public DataTable GetAssetsByOfficeAndGroup(int officeId, string groupName)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlDataAdapter da = new MySqlDataAdapter("GetAssets", con);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;
        da.SelectCommand.Parameters.AddWithValue("@p_OfficeID", officeId);
        da.SelectCommand.Parameters.AddWithValue("@p_GroupName", groupName);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= INSERT ASSET =================
    //public void InsertAsset(
    //    string item,
    //    string brand,
    //    string capacity,
    //    string description,
    //    string serialNumber,
    //    string type,
    //    int qty,
    //    int workingQty,
    //    int nonWorkingQty,
    //    string status,
    //    string remark,
    //    string sector,
    //    int officeId,
    //    string group,
      //    string insertedBy)
    //{
    //    MySqlConnection con = new MySqlConnection(conStr);
    //    MySqlCommand cmd = new MySqlCommand("SP_InsertAsset", con);
    //    cmd.CommandType = CommandType.StoredProcedure;
    //    cmd.Parameters.AddWithValue("@p_ItemName", item);
    //    cmd.Parameters.AddWithValue("@p_Brand", brand);
    //    cmd.Parameters.AddWithValue("@p_Capacity", capacity);
    //    cmd.Parameters.AddWithValue("@p_Description", description);
    //    cmd.Parameters.AddWithValue("@p_SerialNumber", serialNumber);
    //    cmd.Parameters.AddWithValue("@p_Type", type);
    //cmd.Parameters.AddWithValue("@p_InsertedBy", insertedBy);
    //    cmd.Parameters.AddWithValue("@p_Qty", qty);
    //    cmd.Parameters.AddWithValue("@p_WorkingQty", workingQty);
    //    cmd.Parameters.AddWithValue("@p_NonWorkingQty", nonWorkingQty);
    //    cmd.Parameters.AddWithValue("@p_Status", status);
    //    cmd.Parameters.AddWithValue("@p_Remark", remark);
    //    cmd.Parameters.AddWithValue("@p_Sector", sector);
    //    cmd.Parameters.AddWithValue("@p_OfficeID", officeId);
    //    cmd.Parameters.AddWithValue("@p_GroupName", group);
    //    con.Open();
    //    cmd.ExecuteNonQuery();
    //    con.Close();
    //}//

    public string InsertAsset(
 string item,
 string brand,
 string capacity,
 string description,
 string serialNumber,
 string group,
 int qty,
 int workingQty,
 int nonWorkingQty,
 string status,
 string remark,
 string sector,
 int officeId,
 string department,
 string type,
 string insertedBy,
string peripherals)
    {
        string assetCode = "";

        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            using (MySqlCommand cmd = new MySqlCommand("SP_InsertAsset", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@p_ItemName", item);
                cmd.Parameters.AddWithValue("@p_Brand", brand);
                cmd.Parameters.AddWithValue("@p_Capacity", capacity);
                cmd.Parameters.AddWithValue("@p_Description", description);
                cmd.Parameters.AddWithValue("@p_SerialNumber", serialNumber);
                cmd.Parameters.AddWithValue("@p_GroupName", group);
                cmd.Parameters.AddWithValue("@p_Qty", qty);
                cmd.Parameters.AddWithValue("@p_WorkingQty", workingQty);
                cmd.Parameters.AddWithValue("@p_NonWorkingQty", nonWorkingQty);
                cmd.Parameters.AddWithValue("@p_Status", status);
                cmd.Parameters.AddWithValue("@p_Remark", remark);
                cmd.Parameters.AddWithValue("@p_Sector", sector);
                cmd.Parameters.AddWithValue("@p_OfficeID", officeId);
                cmd.Parameters.AddWithValue("@p_Department", department);
                cmd.Parameters.AddWithValue("@p_Type", type);
cmd.Parameters.AddWithValue("@p_InsertedBy", insertedBy);
cmd.Parameters.AddWithValue("@p_Peripherals", peripherals ?? "");
                con.Open();
              
                    object result = cmd.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    assetCode = result.ToString();
                }

                con.Close();
            }
        }

        return assetCode;
    }

    // ================= UPDATE ASSET =================
    public void UpdateAsset(
        int id,
        string itemName,
        string brand,
        string capacity,
        string description,
        string serialNumber,
        int qty,
        int workingQty,
        int nonWorkingQty,
        string status,
        string remark,
        string sector,
        string type,
        string department,
        string imagePath,
	int officeId)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlCommand cmd = new MySqlCommand("SP_UpdateAsset", con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@p_ID", id);
        cmd.Parameters.AddWithValue("@p_ItemName", itemName);
        cmd.Parameters.AddWithValue("@p_Brand", brand);
        cmd.Parameters.AddWithValue("@p_Capacity", capacity);
        cmd.Parameters.AddWithValue("@p_Description", description);
        cmd.Parameters.AddWithValue("@p_SerialNumber", serialNumber);
        cmd.Parameters.AddWithValue("@p_Qty", qty);
        cmd.Parameters.AddWithValue("@p_WorkingQty", workingQty);
        cmd.Parameters.AddWithValue("@p_NonWorkingQty", nonWorkingQty);
        cmd.Parameters.AddWithValue("@p_Status", status);
        cmd.Parameters.AddWithValue("@p_Remark", remark);
        cmd.Parameters.AddWithValue("@p_Sector", sector);
        cmd.Parameters.AddWithValue("@p_GroupName", type);
        cmd.Parameters.AddWithValue("@p_Department", department);
        cmd.Parameters.AddWithValue("@p_ImagePath", imagePath);
	cmd.Parameters.AddWithValue("@p_officeId", officeId);
        con.Open();
        cmd.ExecuteNonQuery();
        con.Close();
    }

public bool IsSerialNumberExists(string serialNumber, string group, int officeId, int excludeId)
{
    if (string.IsNullOrWhiteSpace(serialNumber))
        return false;

    string tableName;
    string idColumn;

    if (group == "IT")
    {
        tableName = "IT";
        idColumn = "ITID";
    }
    else if (group == "Electronics")
    {
        tableName = "Electronics";
        idColumn = "ElectronicsID";
    }
    else
    {
        // Furniture has no SerialNumber column — nothing to check
        return false;
    }

    string query =
        "SELECT COUNT(*) FROM " + tableName + " t " +
        "INNER JOIN `Group` g ON t.GroupID = g.Id " +
        "WHERE t.SerialNumber = @SerialNumber " +
        "AND g.OfficeID = @OfficeID " +
        "AND t." + idColumn + " <> @ExcludeId";

    using (MySqlConnection con = new MySqlConnection(conStr))
    using (MySqlCommand cmd = new MySqlCommand(query, con))
    {
        cmd.Parameters.AddWithValue("@SerialNumber", serialNumber.Trim());
        cmd.Parameters.AddWithValue("@OfficeID", officeId);
        cmd.Parameters.AddWithValue("@ExcludeId", excludeId);

        con.Open();
        int count = Convert.ToInt32(cmd.ExecuteScalar());
        return count > 0;
    }
}
    // ================= DELETE ASSET =================
    public void DeleteAsset(int id, string group)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlCommand cmd = new MySqlCommand("SP_DeleteAsset", con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@p_ID", id);
        cmd.Parameters.AddWithValue("@p_GroupName", group);
        con.Open();
        cmd.ExecuteNonQuery();
        con.Close();
    }

    // ================= INSERT MAINTENANCE =================
    public void InsertMaintenance(
    int itid,
    string itemType,
    DateTime updatedDate,
    string status,
    string maintenanceType,
    DateTime nextMaintenanceDate,
    string description,
    string remark) // ADD THIS
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlCommand cmd = new MySqlCommand("SP_InsertMaintenance", con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@p_ITID", itid);
        cmd.Parameters.AddWithValue("@p_ItemType", itemType);
        cmd.Parameters.AddWithValue("@p_UpdatedDate", updatedDate);
        cmd.Parameters.AddWithValue("@p_Status", status);
        cmd.Parameters.AddWithValue("@p_MaintenanceType", maintenanceType);
        cmd.Parameters.AddWithValue("@p_NextMaintenanceDate", nextMaintenanceDate);
        cmd.Parameters.AddWithValue("@p_Description", description);
        cmd.Parameters.AddWithValue("@p_Remark", remark); // ADD THIS
        con.Open();
        cmd.ExecuteNonQuery();
        con.Close();
    }

    // ================= OFFICES BY DISTRICT =================
    public DataTable GetOfficesByDistrict(string district)
    {
        DataTable dt = new DataTable();

        try
        {
            using (MySqlConnection con = new MySqlConnection(conStr))
            {
                using (MySqlCommand cmd = new MySqlCommand("SP_GetOfficesByDistrict", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@p_District", district);

                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return dt;
    }
    // ================= GET MAINTENANCE BY ITID =================
    public DataTable GetMaintenanceByITID(int itid, string itemType)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlDataAdapter da = new MySqlDataAdapter("SP_GetMaintenanceByITID", con);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;
        da.SelectCommand.Parameters.AddWithValue("@p_ITID", itid);
        da.SelectCommand.Parameters.AddWithValue("@p_ItemType", itemType);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= GET ASSET BY ID =================
    public DataTable GetAssetById(int itid, string group)
    {
        MySqlConnection con = new MySqlConnection(conStr);

        string tableName = "IT";
        string idColumn = "ITID";
        bool hasDescription = true;

        if (group == "Furniture")
        {
            tableName = "Furniture";
            idColumn = "FurnitureID";
            hasDescription = true;
        }
        else if (group == "Electronics")
        {
            tableName = "Electronics";
            idColumn = "ElectronicsID";
            hasDescription = true;
        }

        string columns = hasDescription ? "ItemName, Description" : "ItemName";

        // Fetch LATEST record by ID — always gets current data
        string query =
            "SELECT " + columns +
            " FROM " + tableName +
            " WHERE " + idColumn + " = @ITID" +
            " ORDER BY " + idColumn + " DESC LIMIT 1";

        MySqlDataAdapter da = new MySqlDataAdapter(query, con);
        da.SelectCommand.Parameters.AddWithValue("@ITID", itid);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    public void InsertImage(
string assetCode,
string fileName,
string filePath)
    {
        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            using (MySqlCommand cmd = new MySqlCommand("SP_InsertImage", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@p_AssetCode", assetCode);
                cmd.Parameters.AddWithValue("@p_FileName", fileName);
                cmd.Parameters.AddWithValue("@p_FilePath", filePath);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    // ================= GET IT TEAM USERS =================
    public DataTable GetITTeamUsers()
    {
        DataTable dt = new DataTable();

        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            string query = @"
            SELECT id, username
            FROM users
            WHERE role = 'IT Team'
            ORDER BY username";

            MySqlDataAdapter da = new MySqlDataAdapter(query, con);
            da.Fill(dt);
        }

        return dt;
    }

    public void InsertUser(
    string username,
    string password,
    string role,
    string state,
    string district,
    string office)
    {
        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            string query = @"
        INSERT INTO users
        (
            username,
            password,
            role,
            state,
            district,
            office
        )
        VALUES
        (
            @username,
            @password,
            @role,
            @state,
            @district,
            @office
        )";

            MySqlCommand cmd = new MySqlCommand(query, con);

            cmd.Parameters.AddWithValue("@username", username);
            cmd.Parameters.AddWithValue("@password", password);
            cmd.Parameters.AddWithValue("@role", role);
            cmd.Parameters.AddWithValue("@state", state);
            cmd.Parameters.AddWithValue("@district", district);
            cmd.Parameters.AddWithValue("@office", office);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }

    public DataTable GetOffices()
    {
        DataTable dt = new DataTable();

        try
        {
            using (MySqlConnection con = new MySqlConnection(conStr))
            using (MySqlDataAdapter da = new MySqlDataAdapter(
                "SELECT OfficeID, OfficeName FROM Office ORDER BY OfficeName", con))
            {
                da.Fill(dt);
            }
        }
        catch (Exception)
        {
            throw;
        }

        return dt;
    }

    public DataTable GetAllAssetNames()
    {
        string query = @"
  SELECT ItemName FROM IT
  UNION
  SELECT ItemName FROM Furniture
  UNION
  SELECT ItemName FROM Electronics
  ORDER BY ItemName";

        DataTable dt = new DataTable();

        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            MySqlDataAdapter da = new MySqlDataAdapter(query, con);
            da.Fill(dt);
        }

        return dt;
    }

    // ================= GET MAINTENANCE REPORT =================
    public DataTable GetMaintenanceReport(string assetName)
    {
        MySqlConnection con = new MySqlConnection(conStr);
        MySqlDataAdapter da = new MySqlDataAdapter("SP_GetMaintenanceReport", con);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;
        da.SelectCommand.Parameters.AddWithValue("@p_AssetName", assetName ?? "");
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ================= GET REPORT DATA =================
    public DataTable GetReportData(int officeId, string groupName, int userId)
    {
        DataTable dt = new DataTable();

        using (MySqlConnection con = new MySqlConnection(conStr))
        {
            string itSelect = @"
        SELECT
            it.ITID AS ITID,
            it.ItemName,
            it.Brand,
            it.Capacity,
            it.SerialNumber,
            'IT' AS GroupName,
            it.Quantity,
            it.WorkingQty,
            it.NonWorkingQty,
            it.Status,
            it.Sector,
            it.Description,
            it.Remark,
            '' AS OfficeName,
            NOW() AS UpdatedDate
        FROM IT it";

            string furnitureSelect = @"
        SELECT
            f.FurnitureID AS ITID,
            f.ItemName,
            f.Brand,
            '' AS Capacity,
            f.SerialNumber,
            'Furniture' AS GroupName,
            f.Quantity,
            f.WorkingQty,
            f.NonWorkingQty,
            f.Status,
            f.Sector,
            f.Description,
            f.Remark,
            '' AS OfficeName,
            NOW() AS UpdatedDate
        FROM Furniture f";

            string electronicsSelect = @"
        SELECT
            el.ElectronicsID AS ITID,
            el.ItemName,
            el.Brand,
            el.Capacity,
            el.SerialNumber,
            'Electronics' AS GroupName,
            el.Quantity,
            el.WorkingQty,
            el.NonWorkingQty,
            el.Status,
            el.Sector,
            el.Description,
            el.Remark,
            '' AS OfficeName,
            NOW() AS UpdatedDate
        FROM Electronics el";

            string finalQuery;

            if (string.IsNullOrEmpty(groupName))
            {
                finalQuery = itSelect
                           + " UNION ALL " + furnitureSelect
                           + " UNION ALL " + electronicsSelect
                           + " ORDER BY GroupName, ItemName";
            }
            else if (groupName == "IT")
            {
                finalQuery = itSelect + " ORDER BY ItemName";
            }
            else if (groupName == "Furniture")
            {
                finalQuery = furnitureSelect + " ORDER BY ItemName";
            }
            else
            {
                finalQuery = electronicsSelect + " ORDER BY ItemName";
            }

            MySqlDataAdapter da = new MySqlDataAdapter(finalQuery, con);
            da.Fill(dt);
        }

        return dt;
    }
}

