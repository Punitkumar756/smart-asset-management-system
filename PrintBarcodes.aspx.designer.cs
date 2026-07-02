using System.Web.UI.WebControls;

public partial class PrintBarcodes
{
    protected DropDownList ddlUser;
    protected DropDownList ddlOffice;
    protected DropDownList ddlCategory;
    protected TextBox txtFromDate;
    protected TextBox txtToDate;
    protected Button btnSearch;
    protected Button btnPrint;
    protected Label lblMessage;
    protected Repeater rptBarcode;
}