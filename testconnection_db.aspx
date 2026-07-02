<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testconnection_db.aspx.cs" Inherits="testconnection_db" %>

<!DOCTYPE html>
<html>
<head>
    <title>System Diagnostic Console</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #0f172a;
            color: #e2e8f0;
            font-family: Segoe UI;
        }

        .container {
            margin-top: 30px;
        }

        .title {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .card-box {
            background: #1e293b;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.4);
        }

        .btn-run {
            background: #22c55e;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: bold;
        }

        .btn-run:hover {
            background: #16a34a;
        }

        .gridview table {
            width: 100%;
            background: #0b1220;
            color: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .gridview th {
            background: #334155;
            color: #fff;
            padding: 12px;
        }

        .gridview td {
            padding: 10px;
            border-bottom: 1px solid #1f2937;
        }

        .status-pass {
            color: #22c55e;
            font-weight: bold;
        }

        .status-fail {
            color: #ef4444;
            font-weight: bold;
        }

        .tab-btn {
            background: #1e293b;
            color: white;
            border: none;
            padding: 10px 15px;
            margin-right: 5px;
            border-radius: 8px;
        }

        .tab-btn:hover {
            background: #334155;
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

<div class="container">

    <!-- HEADER -->
    <div class="header-bar">
        <div class="title">🧪 Diagnostic Control Console</div>

        <asp:Button ID="btnRun" runat="server" Text="▶ Run Diagnostics"
            CssClass="btn-run"
            OnClick="btnRun_Click" />
    </div>

    <!-- STATUS INFO -->
    <div class="card-box">
        <h5>System Overview</h5>
        <p>Run diagnostics to test MySQL, Excel providers, and configuration health.</p>
    </div>

    <!-- GRID -->
    <div class="card-box gridview">
        <asp:GridView ID="grid" runat="server" AutoGenerateColumns="false" OnRowDataBound="grid_RowDataBound">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Service" />
                <asp:BoundField DataField="Type" HeaderText="Type" />
                <asp:BoundField DataField="IP" HeaderText="IP / Host" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="Message" HeaderText="Details" />
            </Columns>
        </asp:GridView>
    </div>

</div>

</form>

</body>
</html>