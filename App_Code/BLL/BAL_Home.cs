using DocumentFormat.OpenXml.Bibliography;
using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Web.Hosting;

public class BAL_Home
{
    private string connStr =
    ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;

    DAL_Home objDAL = new DAL_Home();

    // ================= STATES =================
    public DataTable GetStates()
    {
        return objDAL.GetStates();
    }

    // ================= DISTRICTS =================
    public DataTable FetchDistrictsByState(int StateID)
    {
        return objDAL.GetDistrictsByState(StateID);
    }

    // ================= OFFICES =================
    
    public DataTable GetOfficesByDistrict(string district)
    {
        DataTable dt = new DataTable();

        try
        {
            using (MySqlConnection con = new MySqlConnection(connStr))
            {
                using (MySqlCommand cmd = new MySqlCommand("SP_GetOfficesByDistrict", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("p_District", district);

                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
        }
        catch (Exception)
        {
            throw;
        }

        return dt;
    }

    // ================= ADMIN STATS =================
   public DataTable GetAdminStats()
{
    return objDAL.GetAdminStats();
}

public DataTable GetAdminStatsByDistrict(string district)
{
    return objDAL.GetAdminStatsByDistrict(district);
}
    // ================= PINCODES =================
    public DataTable FetchPincodes(int districtID)
    {
        return objDAL.GetPincodes(districtID);
    }

    // ================= BRANCHES =================
    public DataTable FetchBranches(string pincode)
    {
        return objDAL.GetBranches(pincode);
    }

    // ================= ASSETS =================
    public DataTable FetchAssets()
    {
        return objDAL.GetAssets();
    }

    public DataTable GetAssetsByOfficeAndGroup(int officeId, string groupName)
    {
        return objDAL.GetAssetsByOfficeAndGroup(officeId, groupName);
    }

    // ================= STAFF =================
    public DataTable FetchStaff()
    {
        return objDAL.GetStaff();
    }

    // ================= ASSIGNMENTS =================
    public DataTable FetchAssignments()
    {
        return objDAL.GetAssignments();
    }

    // ================= INSERT ASSET =================

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
   return objDAL.InsertAsset(
        item,
        brand,
       capacity,
        description,
      serialNumber,
       group,
      qty,
       workingQty,
        nonWorkingQty,
        status,
        remark,
        sector,
        officeId,
        department,
        type,
        insertedBy,
        peripherals);

    }

    public void InsertImage(
    string assetCode,
    string fileName,
    string filePath)
    {
        objDAL.InsertImage(
            assetCode,
            fileName,
            filePath);
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
        string type, string department,string imagePath,int officeId
        )
    {
        objDAL.UpdateAsset(
            id, itemName, brand, capacity, description,
            serialNumber, qty, workingQty, nonWorkingQty,
            status, remark, sector, type, department, imagePath, officeId);
    }

public bool IsSerialNumberExists(string serialNumber, string group, int officeId, int excludeId)
{
    return objDAL.IsSerialNumberExists(serialNumber, group, officeId, excludeId);
}

    // ================= DELETE ASSET =================
    public void DeleteAsset(int id, string group)
    {
        objDAL.DeleteAsset(id, group);
    }

    // ================= MAINTENANCE =================
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
        objDAL.InsertMaintenance(
            itid, itemType, updatedDate, status,
            maintenanceType, nextMaintenanceDate,
            description, remark); // ADD remark
    }

    public DataTable GetMaintenanceByITID(int itid, string itemType)
    {
        return objDAL.GetMaintenanceByITID(itid, itemType);
    }

    // ================= OFFICES =================
    public DataTable GetOffices()
    {
        DataTable dt = new DataTable();

        try
        {
            using (MySqlConnection con = new MySqlConnection(connStr))
            {
                con.Open();

                using (MySqlCommand cmd = new MySqlCommand(
                    "SELECT OfficeID, OfficeName FROM Office ORDER BY OfficeName", con))
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
        }
        catch { }

        return dt;
    }

    // ================= GET ASSET =================
    public DataTable GetAssetById(int itid, string group)
    {
        return objDAL.GetAssetById(itid, group);
    }

    // ================= REPORT USERS =================
    public DataTable GetITTeamUsers()
    {
        return objDAL.GetITTeamUsers();
    }

    // ================= REPORT DATA =================
    public DataTable GetReportData(int officeId, string groupName, int userId)
    {
        return objDAL.GetReportData(officeId, groupName, userId);
    }

    // ================= GET MAINTENANCE REPORT =================
    public DataTable GetMaintenanceReport(string assetName)
    {
        return objDAL.GetMaintenanceReport(assetName);
    }

    public DataTable GetAllAssetNames()
    {
        return objDAL.GetAllAssetNames();
    }

    // ================= INSERT USER =================
    public void InsertUser(
        string username,
        string password,
        string role,
        string state,
        string district,
        string office)
    {
        objDAL.InsertUser(
            username,
            password,
            role,
            state,
            district,
            office);
    }
}