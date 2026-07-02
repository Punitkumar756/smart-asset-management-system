<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="PrintBarcodes.aspx.cs"
    Inherits="PrintBarcodes" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Asset Barcode Print</title>

    <style>
        body {
            font-family: Arial;
            margin: 20px;
        }

        .filter-box {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            background: #f8f8f8;
        }

        .filter-box label {
            font-weight: bold;
            margin-right: 5px;
        }

        .filter-row {
            margin-bottom: 10px;
        }

        .barcode-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .barcode-table th {
            background: #f0f0f0;
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
            font-weight: bold;
        }

        .barcode-table td {
            padding: 10px;
            border: 1px solid #ccc;
            vertical-align: middle;
            text-align: center;
        }

        .barcode-table tr:nth-child(even) {
            background: #f9f9f9;
        }

        .col-assetcode {
            width: 20%;
            font-weight: bold;
            font-size: 14px;
        }

        .col-barcode {
            width: 45%;
        }

        .col-info {
            width: 35%;
            text-align: left;
            font-size: 13px;
        }

        .info-name {
            font-weight: bold;
            margin-bottom: 4px;
        }

        .info-detail {
            color: #555;
            font-size: 12px;
            margin-bottom: 2px;
        }

        @media print {
    /* Hide navbar, filters, buttons */
    .no-print,
    .navbar {
        display: none !important;
    }

    /* Remove all top spacing so print starts from top */
    html, body {
        margin: 0 !important;
        padding: 0 !important;
    }

    /* Remove the margin from the body tag */
    body {
        margin: 0 !important;
        padding: 0 !important;
    }

    .barcode-table {
        margin-top: 0 !important;
    }

    .barcode-table td,
    .barcode-table th {
        border: 1px solid #000;
    }

    /* Avoid page break inside a barcode row */
    .barcode-table tr {
        page-break-inside: avoid;
    }
}
    </style>
</head>

<body>

    <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
    body { background: #f4f3f0; min-height: 100vh; }

    .navbar {
        display: flex; justify-content: space-between; align-items: center;
        padding: 18px 6%;
        background: rgba(255,255,255,0.4);
        backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(255,255,255,0.5);
        width: 100%; position: sticky; top: 0; z-index: 100;
    }
    .brand-unit { display: flex; align-items: center; gap: 12px; }
    .brand-headline { font-size: 16px; font-weight: 700; color: #0f172a; }
    .nav-links { display: flex; gap: 32px; list-style: none; align-items: center; }
    .nav-links a { color: #4b5563; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s; }
    .nav-links a:hover { color: #5d87ff; }
    .nav-links a.active { color: #5d87ff; font-weight: 700; }

    @media (max-width: 768px) {
        .navbar { flex-direction: column; text-align: center; padding: 15px; gap: 12px; }
        .brand-unit { flex-direction: column; }
        .nav-links { flex-wrap: wrap; justify-content: center; gap: 10px; }
    }
</style>

<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<nav class="navbar">
    <div class="brand-unit">
        <img src="https://daytonnaturalresources.com/wp-content/uploads/2024/01/Dayton-Logo-2-1.png"
             alt="Dayton Logo" style="height:50px;width:auto;object-fit:contain;">
        <div class="brand-headline">Dayton Natural Resources.PVT.LTD</div>
    </div>

    <ul class="nav-links">
        <li><a href="home.aspx">Home</a></li>
        <li><a href="home.aspx#corporate-about-section">Company Profile</a></li>
        <li><a href="AuditAsset.aspx">Asset Audit System</a></li>
        <li><a href="PrintBarcodes.aspx" class="active">Print Barcodes</a></li>
        <li><a href="home.aspx#contact-section">Contact</a></li>
    </ul>

    <div style="display:flex;align-items:center;gap:10px;">
        <a href="LOGINPAGE.aspx"
           style="background:#0f172a;color:#fff;text-decoration:none;padding:8px 18px;border-radius:20px;
                  display:flex;align-items:center;gap:7px;font-size:13px;font-weight:700;">
            Logout
        </a>
    </div>
</nav>

<form id="form1" runat="server">



<div class="filter-box no-print">

    <div class="filter-row">
        <label>Username :</label>
        <%-- Now shows "John (ID: 5)" so duplicate names are distinguishable --%>
        <asp:DropDownList ID="ddlUser" runat="server"></asp:DropDownList>

        &nbsp;&nbsp;

        <label>Office :</label>
        <asp:DropDownList ID="ddlOffice" runat="server"></asp:DropDownList>

        &nbsp;&nbsp;

        <label>Category :</label>
        <asp:DropDownList ID="ddlCategory" runat="server">
            <asp:ListItem Value="">All</asp:ListItem>
            <asp:ListItem Value="IT">IT</asp:ListItem>
            <asp:ListItem Value="Furniture">Furniture</asp:ListItem>
            <asp:ListItem Value="Electronics">Electronics</asp:ListItem>
        </asp:DropDownList>
    </div>

    <div class="filter-row">
        <label>From Date :</label>
        <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>

        &nbsp;&nbsp;

        <label>To Date :</label>
        <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
    </div>

    <div class="filter-row">
        <asp:Button ID="btnSearch" runat="server"
            Text="Show Assets"
            OnClick="btnSearch_Click" />

        &nbsp;

        <asp:Button ID="btnPrint" runat="server"
            Text="Print"
            OnClick="btnPrint_Click" />
    </div>

</div>

<asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>

<br />

<table class="barcode-table">
    <thead>
    <tr>
        <th>Asset Code</th>
        <th>Information</th>
        <th>Barcode</th>
        <th>QR Code</th>
    </tr>
</thead>
<tbody>
    <asp:Repeater ID="rptBarcode" runat="server">
        <ItemTemplate>
            <tr>
                <td class="col-assetcode">
                    <%# Eval("AssetCode") %>
                </td>

                <td class="col-info">
                    <div class="info-name"><%# Eval("ItemName") %></div>
                    <div class="info-detail">Category &nbsp;&nbsp;&nbsp;: <%# Eval("Category") %></div>
                    <div class="info-detail">Office &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%# Eval("OfficeName") %></div>
                    <div class="info-detail">Serial No &nbsp;&nbsp;: <%# string.IsNullOrEmpty(Eval("SerialNumber").ToString()) ? "N/A" : Eval("SerialNumber").ToString() %></div>
                    <div class="info-detail">Description : <%# string.IsNullOrEmpty(Eval("Description").ToString()) ? "N/A" : Eval("Description").ToString() %></div>
                </td>

                <td class="col-barcode">
                    <asp:Image ID="Image1" runat="server"
                        ImageUrl='<%# Eval("BarcodeImage") %>'
                        Width="220" Height="70" />
                    <div style="font-size:11px;color:#555;margin-top:4px;text-align:center;">
                        <%# Eval("AssetCode") %>
                    </div>
                </td>

                <td class="col-barcode">
                    <asp:Image ID="Image2" runat="server"
                        ImageUrl='<%# Eval("QRImage") %>'
                        Width="100" Height="100" />
                    <div style="font-size:10px;color:#555;margin-top:4px;text-align:center;">
                        Scan for details
                    </div>
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
</tbody>
</table>



</form>

</body>
</html>
