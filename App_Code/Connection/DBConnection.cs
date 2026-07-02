using System;
using System.Configuration;
using MySql.Data.MySqlClient;

public class DBConnection
{
    public MySqlConnection GetConnection()
    {
        string cs = ConfigurationManager.ConnectionStrings["connectStr"].ConnectionString;

        if (string.IsNullOrEmpty(cs))
            throw new Exception("Connection string 'conn' missing in web.config");

        return new MySqlConnection(cs);
    }
}