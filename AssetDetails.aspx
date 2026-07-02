<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetDetails.aspx.cs" Inherits="AssetDetails" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Asset Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Plus Jakarta Sans',sans-serif; }
        body { background:#f4f3f0; min-height:100vh; padding:20px; }
        .card {
            max-width:500px; margin:40px auto;
            background:#fff; border-radius:24px;
            padding:30px; box-shadow:0 20px 60px rgba(0,0,0,0.08);
        }
        .badge {
            display:inline-block; padding:4px 14px; border-radius:20px;
            font-size:11px; font-weight:700; text-transform:uppercase;
            background:rgba(93,135,255,0.1); color:#5d87ff; margin-bottom:16px;
        }
        h2 { font-size:22px; font-weight:800; color:#0f172a; margin-bottom:20px; }
        .info-row {
            display:flex; justify-content:space-between;
            padding:12px 0; border-bottom:1px solid rgba(0,0,0,0.05);
            font-size:14px;
        }
        .info-row:last-child { border-bottom:none; }
        .info-label { color:#4b5563; font-weight:600; }
        .info-value { color:#0f172a; font-weight:700; text-align:right; max-width:60%; }
        .asset-code {
            background:#0f172a; color:#fff; border-radius:12px;
            padding:16px; text-align:center; margin-bottom:24px;
            font-size:18px; font-weight:800; letter-spacing:1px;
        }
        .error-box {
            text-align:center; padding:40px 20px; color:#ef4444;
            font-size:16px; font-weight:600;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="card">
        <asp:Panel ID="pnlDetails" runat="server" Visible="false">
            <div class="badge"><asp:Literal ID="litCategory" runat="server" /></div>
            <div class="asset-code"><asp:Literal ID="litAssetCode" runat="server" /></div>
            <h2><asp:Literal ID="litItemName" runat="server" /></h2>
            <div class="info-row">
                <span class="info-label">Office</span>
                <span class="info-value"><asp:Literal ID="litOffice" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Brand</span>
                <span class="info-value"><asp:Literal ID="litBrand" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Serial No</span>
                <span class="info-value"><asp:Literal ID="litSerial" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Category</span>
                <span class="info-value"><asp:Literal ID="litCat" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Status</span>
                <span class="info-value"><asp:Literal ID="litStatus" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Quantity</span>
                <span class="info-value"><asp:Literal ID="litQty" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Description</span>
                <span class="info-value"><asp:Literal ID="litDesc" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Inserted By</span>
                <span class="info-value"><asp:Literal ID="litInsertedBy" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="info-label">Inserted Date</span>
                <span class="info-value"><asp:Literal ID="litInsertedDate" runat="server" /></span>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="error-box">Asset not found for code: <asp:Literal ID="litErrorCode" runat="server" /></div>
        </asp:Panel>
    </div>
</form>
</body>
</html>