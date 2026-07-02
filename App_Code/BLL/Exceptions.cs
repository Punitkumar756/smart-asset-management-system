using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

public class ErrorHandler
{
    public ErrorHandler()
    {
    }

    public static void ErrorsEntry(string Errordes, string Errorsource, string Errorno)
    {
        string str = ConfigurationSettings.AppSettings["LogLocation"];
        string path1 = str.Substring(0, str.LastIndexOf("\\"));
        string path2 = str.Substring(0, str.LastIndexOf(".txt")) + "-" + DateTime.Today.ToString("dd-MM-yyyy") + ".txt";
        try
        {
            if (!Directory.Exists(path1))
                Directory.CreateDirectory(path1);
            StreamWriter streamWriter = File.AppendText(path2);
            streamWriter.WriteLine("====================" + DateTime.Now.ToLongDateString() + "  " + DateTime.Now.ToLongTimeString());
            streamWriter.WriteLine(Errordes.ToString());
            streamWriter.WriteLine(Errorsource.ToString());
            streamWriter.WriteLine(Errorno.ToString());
            streamWriter.Flush();
            streamWriter.Close();
        }
        catch (UnauthorizedAccessException ex)
        {
        }
    }

    public static void LogEntry(string from, long difference)
    {
        string str1 = ConfigurationSettings.AppSettings["LogLocation"];
        string path = str1.Substring(0, str1.LastIndexOf("\\"));
        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);
        StreamWriter streamWriter1 = File.AppendText(ConfigurationSettings.AppSettings["LogLocation"]);
        streamWriter1.WriteLine("Operation Name           " + from.ToString());
        StreamWriter streamWriter2 = streamWriter1;
        string str2 = "Date Time Start          ";
        DateTime now = DateTime.Now;
        string str3 = now.ToString("yyyy/MM/dd hh:mm:ss:fff");
        string str4 = str2 + str3;
        streamWriter2.WriteLine(str4);
        StreamWriter streamWriter3 = streamWriter1;
        string str5 = "Date Time End            ";
        now = DateTime.Now;
        string str6 = now.ToString("yyyy/MM/dd hh:mm:ss:fff");
        string str7 = str5 + str6;
        streamWriter3.WriteLine(str7);
        streamWriter1.WriteLine("Difference               " + difference.ToString());
        streamWriter1.WriteLine("---------------------------------------------------------------");
        streamWriter1.Flush();
        streamWriter1.Close();
    }

    public static void ErrorsEntry(string errString)
    {
        try
        {
        }
        catch (SqlException ex)
        {
        }
        catch (Exception ex)
        {
        }
    }
}
