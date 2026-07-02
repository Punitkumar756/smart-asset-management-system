using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;

public class DAL_User
{
    MySqlConnection con;

    public DAL_User()
    {
        con = new MySqlConnection(
            ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString);
    }

    // ── EXISTING: do not touch ──
    public DataTable CheckLogin(string username, string password, string role)
    {
        MySqlDataAdapter da = new MySqlDataAdapter(
            "SELECT * FROM users WHERE username=@u AND password=@p AND role=@r", con);
        da.SelectCommand.Parameters.AddWithValue("@u", username);
        da.SelectCommand.Parameters.AddWithValue("@p", password);
        da.SelectCommand.Parameters.AddWithValue("@r", role);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ── Fetch state, district for IT team after login ──
    public DataTable GetUserDetails(string username, string role)
    {
        MySqlDataAdapter da = new MySqlDataAdapter(
            "SELECT state, district FROM users WHERE username=@u AND role=@r LIMIT 1", con);
        da.SelectCommand.Parameters.AddWithValue("@u", username);
        da.SelectCommand.Parameters.AddWithValue("@r", role);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    // ── NEW: Fetch ALL assigned offices for an IT team user ──
    // Reads distinct office names from users table and joins with Office table to get OfficeID
    // ── Fetch ALL assigned offices for an IT team user ──
    // Reads directly from users table, then tries to get OfficeID from Office table
    public DataTable GetUserOffices(string username)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("OfficeName");
        dt.Columns.Add("OfficeID");

        using (MySqlConnection con = new MySqlConnection(
            ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString))
        {
            con.Open();

            // Step 1: get all distinct office names for this user
            MySqlCommand cmd = new MySqlCommand(
                @"SELECT DISTINCT office 
              FROM users 
              WHERE username = @u 
              AND role = 'IT Team' 
              AND office IS NOT NULL 
              AND office != ''
              ORDER BY office", con);
            cmd.Parameters.AddWithValue("@u", username);

            List<string> officeNames = new List<string>();
            using (MySqlDataReader rdr = cmd.ExecuteReader())
            {
                while (rdr.Read())
                    officeNames.Add(rdr["office"].ToString().Trim());
            }

            // Step 2: for each office name, look up its OfficeID
            foreach (string officeName in officeNames)
            {
                MySqlCommand cmdId = new MySqlCommand(
                    @"SELECT OfficeID FROM Office 
                  WHERE TRIM(OfficeName) = TRIM(@n) 
                  LIMIT 1", con);
                cmdId.Parameters.AddWithValue("@n", officeName);

                object result = cmdId.ExecuteScalar();
                string officeId = result != null ? result.ToString() : "0";

                dt.Rows.Add(officeName, officeId);
            }
        }

        return dt;
    }
}