using System;
using System.Data;

public class BAL_User
{
    DAL_User dal = new DAL_User();

    // ── EXISTING ──
    public bool Login(string username, string password, string role)
    {
        DataTable dt = dal.CheckLogin(username, password, role);
        return dt.Rows.Count > 0;
    }

    // ── EXISTING ──
    public DataRow GetUserDetails(string username, string role)
    {
        DataTable dt = dal.GetUserDetails(username, role);
        if (dt != null && dt.Rows.Count > 0)
            return dt.Rows[0];
        return null;
    }

    // ── NEW: returns DataTable of all offices assigned to this IT user ──
    public DataTable GetUserOffices(string username)
    {
        return dal.GetUserOffices(username);
    }
}