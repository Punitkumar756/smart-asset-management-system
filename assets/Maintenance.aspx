<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Maintenance.aspx.cs"
    Inherits="Maintenance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maintenance System</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Content/fontawesome/css/all.min.css" />
    <style>
        :root {
            --primary-dark: #0f172a;
            --accent-blue:  #5d87ff;
            --text-muted:   #4b5563;
            --bg-glass:     rgba(255,255,255,0.6);
            --border-glass: rgba(255,255,255,0.75);
            --radius-lg:    20px;
            --radius-md:    10px;
            --nav-h:        68px;
        }

        *, *::before, *::after {
            margin:0; padding:0; box-sizing:border-box;
            font-family:'Plus Jakarta Sans', sans-serif;
        }

        html { scroll-behavior:smooth; }

        body {
            min-height:100vh;
            background:
                linear-gradient(135deg, rgba(244,243,240,0.88), rgba(234,233,241,0.92)),
                url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1920&q=80');
            background-size:cover;
            background-position:center;
            background-attachment:fixed;
            overflow-x:hidden;
        }

        /* ── ICON FALLBACK ──
           If Font Awesome glyphs fail (tofu/? chars) on locked-down
           internal networks, .icon-emoji shows a visible emoji instead.
           Self-hosting /Content/fontawesome/ removes the CDN dependency. */
        .icon-emoji {
            font-style: normal;
            font-family: "Segoe UI Emoji","Apple Color Emoji","Noto Color Emoji",sans-serif;
            margin-right: 4px;
            line-height: 1;
        }

        /* ── NAVBAR ── */
        .audit-navbar {
            position:sticky;
            top:0;
            z-index:500;
            width:100%;
            background:rgba(255,255,255,0.72);
            backdrop-filter:blur(20px);
            -webkit-backdrop-filter:blur(20px);
            border-bottom:1px solid rgba(255,255,255,0.55);
            box-shadow:0 2px 16px rgba(0,0,0,0.06);
            margin-bottom:25px;
        }
        .nav-inner {
            max-width:1400px;
            margin:auto;
            height:68px;
            padding:0 25px;
            display:flex;
            align-items:center;
            justify-content:space-between;
        }
        .nav-brand { display:flex; align-items:center; gap:12px; }
        .navbar-back-btn {
            width:38px; height:38px; border-radius:50%;
            border:1px solid #e2e8f0;
            background:rgba(255,255,255,0.85);
            cursor:pointer;
            display:flex; align-items:center; justify-content:center;
            color:#4b5563; font-size:13px;
            box-shadow:0 2px 8px rgba(0,0,0,0.06);
            transition:background .2s;
        }
        .navbar-back-btn:hover { background:#f1f5f9; }
        .nav-logo { height:42px; width:auto; }
        .nav-brand-name { font-size:14px; font-weight:700; color:#0f172a; }
        .nav-brand-sub  { font-size:11px; color:#64748b; }
        .nav-links { display:flex; gap:8px; list-style:none; }
        .nav-links a {
            text-decoration:none; color:#475569;
            font-size:13px; font-weight:600;
            padding:8px 14px; border-radius:20px;
            transition:background .18s, color .18s;
        }
        .nav-links a:hover,
        .nav-links a.active { background:rgba(93,135,255,0.12); color:#5d87ff; }
        .btn-logout {
            background:#0f172a; color:#fff;
            text-decoration:none; padding:9px 16px;
            border-radius:20px; font-size:12px; font-weight:700;
            display:inline-flex; align-items:center; gap:6px;
            box-shadow:0 2px 8px rgba(0,0,0,0.15);
            transition:background .2s;
        }
        .btn-logout:hover { background:#1e293b; }

        /* ── PAGE WRAPPER ── */
        .page-content { max-width:1500px; margin:0 auto; padding:0 25px 40px; }

        /* ── GLASS CARD ── */
        .card {
            background:var(--bg-glass);
            border:1px solid var(--border-glass);
            border-radius:var(--radius-lg);
            padding:24px;
            backdrop-filter:blur(24px);
            box-shadow:0 16px 40px rgba(0,0,0,0.05);
            margin-bottom:20px;
        }

        /* ── GRID CARD (history) ── */
        .grid-card {
            background:var(--bg-glass);
            border:1px solid var(--border-glass);
            border-radius:24px; padding:30px;
            backdrop-filter:blur(24px);
            box-shadow:0 5px 20px rgba(0,0,0,0.06);
            overflow-x:auto;
        }

        label {
            font-size:13px; font-weight:600;
            color:var(--primary-dark); margin-bottom:6px; display:block;
        }

        .input-control {
            width:100%; height:46px; padding:10px 12px;
            border:1px solid rgba(0,0,0,0.1); border-radius:var(--radius-md);
            font-size:14px; font-family:'Plus Jakarta Sans',sans-serif;
            background:rgba(255,255,255,0.75); color:var(--primary-dark);
            transition:border-color .2s, box-shadow .2s;
        }
        .input-control:hover { border-color:#cbd5e1; }
        .input-control:focus {
            outline:none; border-color:var(--accent-blue);
            box-shadow:0 0 0 3px rgba(93,135,255,0.15);
            background:#fff;
        }
        textarea.input-control { min-height:90px; resize:none; }

        .btn {
            height:42px; padding:0 24px; border:none;
            border-radius:25px; background:var(--accent-blue);
            color:white; font-size:13px; font-weight:700;
            font-family:'Plus Jakarta Sans',sans-serif;
            cursor:pointer; display:inline-flex; align-items:center; gap:7px;
            box-shadow:0 4px 14px rgba(93,135,255,0.35);
            transition:background .2s, transform .1s;
        }
        .btn:hover { background:#4b76ed; transform:translateY(-1px); }
        .btn:active { transform:scale(0.97); }

        /* ── SECTION HEADER ── */
        .section-header {
            display:flex; align-items:center; justify-content:space-between;
            margin-bottom:20px;
        }
        .section-header-left { display:flex; align-items:center; gap:12px; }
        .section-header h2 { font-size:20px; font-weight:800; color:#0f172a; }
        .section-icon {
            width:46px; height:46px; border-radius:14px;
            background:rgba(93,135,255,0.12); color:#5d87ff;
            display:flex; align-items:center; justify-content:center;
            font-size:18px; flex-shrink:0;
        }

        .asset-name-row    { margin-bottom:16px; }
        .asset-name-row h2 { font-size:24px; font-weight:800; color:#0f172a; }
        .field-group       { margin-bottom:0; }

        /* ── 2-COLUMN FORM ── */
        .form-row-2 {
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:20px;
            margin-bottom:16px;
        }

        /* ── HISTORY GRID ── */
        .grid-section { max-width:1500px; margin:0 auto; padding:0 25px 40px; }
        .grid-view { width:100%; border-collapse:collapse; }
        .grid-view th {
            background:rgba(15,23,42,0.04); padding:12px 15px;
            font-size:12px; font-weight:700; color:var(--primary-dark);
            text-align:left; border-bottom:1px solid rgba(0,0,0,0.07);
            white-space:nowrap;
        }
        .grid-view td {
            padding:12px 15px; border-bottom:1px solid rgba(0,0,0,0.05);
            font-size:13px; color:#334155; vertical-align:middle;
        }
        .grid-view tr:last-child td { border-bottom:none; }
        .grid-view tr:hover td { background:rgba(93,135,255,0.04); }

        /* ── VIEW REPORT BUTTON ── */
        .btn-report {
            display:inline-flex; align-items:center; gap:8px;
            padding:10px 22px;
            border:2px solid #2563eb;
            border-radius:20px; background:transparent;
            color:#2563eb; font-size:13px; font-weight:700;
            cursor:pointer; transition:.2s;
            font-family:'Plus Jakarta Sans',sans-serif;
        }
        .btn-report:hover { background:#2563eb; color:#fff; }

        /* ── REPORT MODAL ── */
        .report-overlay {
            display:none; position:fixed; inset:0;
            background:rgba(10,15,30,0.55); backdrop-filter:blur(4px);
            z-index:9999; align-items:flex-start; justify-content:center;
            padding:32px 20px; overflow-y:auto;
        }
        .report-overlay.open { display:flex; }
        .report-box {
            background:#fff; border-radius:20px;
            width:100%; max-width:1200px;
            box-shadow:0 32px 80px rgba(0,0,0,.18);
            animation:modalIn .22s ease; overflow:hidden;
        }
        @keyframes modalIn {
            from { opacity:0; transform:translateY(18px) scale(0.97); }
            to   { opacity:1; transform:translateY(0) scale(1); }
        }
        .report-topbar {
            background:#0f172a; padding:18px 28px;
            display:flex; align-items:center; justify-content:space-between;
        }
        .report-topbar-left { display:flex; align-items:center; gap:12px; }
        .report-topbar-left i { color:#5d87ff; font-size:20px; }
        .report-topbar h2 { font-size:17px; font-weight:800; color:#fff; margin:0; }
        .report-topbar p  { font-size:12px; color:#94a3b8; margin:2px 0 0; }
        .report-close-btn {
            background:rgba(255,255,255,.1); border:none;
            width:34px; height:34px; border-radius:50%; color:#fff;
            font-size:18px; cursor:pointer;
            display:flex; align-items:center; justify-content:center;
            font-family:'Plus Jakarta Sans',sans-serif;
        }
        .report-close-btn:hover { background:rgba(255,255,255,.2); }
        .report-filter-bar {
            background:#f8fafc; border-bottom:1px solid #e2e8f0;
            padding:18px 28px; display:flex; align-items:flex-end; gap:16px; flex-wrap:wrap;
        }
        .report-filter-bar .field-wrap { display:flex; flex-direction:column; gap:5px; min-width:220px; }
        .report-filter-bar label { font-size:11px; font-weight:700; color:#64748b; letter-spacing:.05em; text-transform:uppercase; margin:0; }
        .report-filter-bar .input-control { background:#fff; height:38px; font-size:13px; }
        .btn-apply {
            height:38px; padding:0 22px; border:none; border-radius:20px;
            background:#2563eb; color:#fff; font-size:13px; font-weight:700;
            font-family:'Plus Jakarta Sans',sans-serif; cursor:pointer; align-self:flex-end;
        }
        .btn-apply:hover { background:#1d4ed8; }
        .btn-excel {
            height:38px; padding:0 22px; border:none; border-radius:20px;
            background:#16a34a; color:#fff; font-size:13px; font-weight:700;
            font-family:'Plus Jakarta Sans',sans-serif; cursor:pointer;
            display:inline-flex; align-items:center; gap:7px; align-self:flex-end;
        }
        .btn-excel:hover { background:#15803d; }
        .report-summary {
            display:flex; gap:12px; padding:16px 28px;
            border-bottom:1px solid #e2e8f0; flex-wrap:wrap;
        }
        .summary-chip {
            background:rgba(93,135,255,.07); border:1px solid rgba(93,135,255,.18);
            border-radius:12px; padding:10px 18px; text-align:center; min-width:110px;
        }
        .summary-chip .s-num { font-size:20px; font-weight:800; color:#5d87ff; }
        .summary-chip .s-lbl { font-size:11px; color:#4b5563; font-weight:600; margin-top:2px; }
        .report-table-area { padding:20px 28px 28px; overflow-x:auto; }
        .report-empty { text-align:center; padding:48px 20px; color:#94a3b8; font-size:14px; }
        .report-empty i { font-size:36px; display:block; margin-bottom:10px; color:#cbd5e1; }

        /* ── RESPONSIVE ── */
        @media(max-width:768px) {
            .form-row-2 { grid-template-columns:1fr; }
            .btn { width:100%; justify-content:center; }
        }
    </style>
</head>
<body>

<form id="form2" runat="server">

    <!-- ── NAVBAR ── -->
    <nav class="audit-navbar">
        <div class="nav-inner">

            <div class="nav-brand">
                <button type="button" class="navbar-back-btn" onclick="history.back()">
                    <i class="fa-solid fa-arrow-left"></i><i class="icon-emoji" aria-hidden="true">⬅️</i>
                </button>
                <img src="/1.png" alt="Dayton Logo" class="nav-logo" />
                <div>
                    <div class="nav-brand-name">Dayton Natural Resources</div>
                    <div class="nav-brand-sub">Maintenance Management System</div>
                </div>
            </div>

            <ul class="nav-links">
                <li><a href="<%= ResolveUrl("~/home.aspx") %>">Home</a></li>
                <li><a href="Assetsystem.aspx">Assets</a></li>
                <li><a href="Maintenance.aspx" class="active">Maintenance</a></li>
            </ul>

            <div class="nav-right">
                <a href="<%= ResolveUrl("~/loginpage.aspx") %>" class="btn-logout">
                    <i class="fa-solid fa-right-from-bracket"></i><i class="icon-emoji" aria-hidden="true">🚪</i> Logout
                </a>
            </div>

        </div>
    </nav>

    <!-- ── MAINTENANCE FORM ── -->
    <div class="page-content">
        <div class="card">

            <div class="section-header">
                <div class="section-header-left">
                    <div class="section-icon"><i class="fa-regular fa-clipboard"></i><i class="icon-emoji" aria-hidden="true">📋</i></div>
                    <h2>Maintenance Details</h2>
                </div>
            </div>

            <div class="asset-name-row">
                <h2 id="assetNameDisplay" runat="server"></h2>
            </div>

            <asp:TextBox ID="txtITID"  runat="server" Visible="false"></asp:TextBox>
            <asp:TextBox ID="txtGroup" runat="server" Visible="false"></asp:TextBox>

            <!-- ── OPTION B REVISED LAYOUT ── -->
            <div class="form-row-2">

                <!-- LEFT: Description → Remark → Update button -->
                <div style="display:flex; flex-direction:column; gap:16px;">
                    <div class="field-group">
                        <label>Description</label>
                        <asp:TextBox ID="txtDescription" runat="server"
                            CssClass="input-control" TextMode="MultiLine" Rows="4" ReadOnly="true">
                        </asp:TextBox>
                    </div>
                    <div class="field-group">
                        <label>Remark</label>
                        <asp:TextBox ID="txtRemark" runat="server"
                            CssClass="input-control" TextMode="MultiLine" Rows="4"
                            placeholder="Enter maintenance remark...">
                        </asp:TextBox>
                    </div>
                    <div>
                        <asp:Button ID="btnUpdateRecord" runat="server"
                            Text="Update Record" CssClass="btn"
                            OnClick="btnUpdateRecord_Click" />
                    </div>
                </div>

                <!-- RIGHT: Dropdowns -->
                <div style="display:flex; flex-direction:column; gap:16px;">
                    <div class="field-group">
                        <label>Status</label>
                        <asp:DropDownList ID="ddlMaintenanceStatus" runat="server" CssClass="input-control">
                            <asp:ListItem Text="Select Status" Value=""            />
                            <asp:ListItem Text="Working"       Value="Working"     />
                            <asp:ListItem Text="Not Working"   Value="Not Working" />
                        </asp:DropDownList>
                    </div>
                    <div class="field-group">
                        <label>Type of Maintenance</label>
                        <asp:DropDownList ID="ddlMaintenanceType" runat="server" CssClass="input-control">
                            <asp:ListItem Text="Select Type"            Value=""                      />
                            <asp:ListItem Text="Preventive Maintenance" Value="Preventive Maintenance" />
                            <asp:ListItem Text="Corrective Maintenance" Value="Corrective Maintenance" />
                            <asp:ListItem Text="Repair"                 Value="Repair"                />
                            <asp:ListItem Text="Replacement"            Value="Replacement"           />
                            <asp:ListItem Text="Inspection"             Value="Inspection"            />
                            <asp:ListItem Text="Service"                Value="Service"               />
                            <asp:ListItem Text="No Issue"               Value="No Issue"              />
                        </asp:DropDownList>
                    </div>
                    <div class="field-group">
                        <label>Next Maintenance Date</label>
                        <asp:TextBox ID="txtNextMaintenanceDate" runat="server"
                            CssClass="input-control" TextMode="Date">
                        </asp:TextBox>
                    </div>
                </div>

            </div>
            <!-- ── END LAYOUT ── -->

        </div>

        <!-- ── HISTORY GRID ── -->
        <div class="grid-card">
            <div class="section-header">
                <div class="section-header-left">
                    <div class="section-icon"><i class="fa-solid fa-clock-rotate-left"></i><i class="icon-emoji" aria-hidden="true">🕒</i></div>
                    <h2>Maintenance History</h2>
                </div>
                <button type="button" class="btn-report" onclick="openReportModal()">
                    <i class="fa-solid fa-chart-bar"></i><i class="icon-emoji" aria-hidden="true">📊</i> View Report
                </button>
            </div>

            <asp:GridView ID="gvMaintenance" runat="server"
                AutoGenerateColumns="False" CssClass="grid-view">
                <Columns>
                    <asp:BoundField DataField="TransactionID"       HeaderText="Transaction ID"        />
                    <asp:BoundField DataField="AssetCode"           HeaderText="Asset Code"            />
                    <asp:BoundField DataField="AssetName"           HeaderText="Asset Name"            />
                    <asp:BoundField DataField="UpdatedDate"         HeaderText="Updated Date"          DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:BoundField DataField="Status"              HeaderText="Status"                />
                    <asp:BoundField DataField="MaintenanceType"     HeaderText="Maintenance Type"      />
                    <asp:BoundField DataField="NextMaintenanceDate" HeaderText="Next Maintenance Date" DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:BoundField DataField="Description"         HeaderText="Description"           />
                    <asp:BoundField DataField="Remark"              HeaderText="Remark"                />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- ── REPORT MODAL ── -->
    <div class="report-overlay" id="reportOverlay">
        <div class="report-box">

            <div class="report-topbar">
                <div class="report-topbar-left">
                    <i class="fa-solid fa-chart-bar"></i><i class="icon-emoji" aria-hidden="true">📊</i>
                    <div>
                        <h2>Maintenance Report</h2>
                        <p>Filter by asset name or view all records</p>
                    </div>
                </div>
                <button type="button" class="report-close-btn" onclick="closeReportModal()">&times;</button>
            </div>

            <div class="report-filter-bar">
                <div class="field-wrap">
                    <label>Filter by Asset Name</label>
                    <asp:DropDownList ID="ddlReportFilter" runat="server" CssClass="input-control">
                        <asp:ListItem Text="-- All Records --" Value="" />
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnApplyReport" runat="server"
                    Text="Apply Filter" CssClass="btn-apply"
                    OnClick="btnApplyReport_Click" />
                <asp:Button ID="btnDownloadExcel" runat="server"
                    Text="⬇ Download Excel" CssClass="btn-excel"
                    OnClick="btnDownloadExcel_Click" />
            </div>

            <div class="report-summary">
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblTotalRecords" runat="server">0</asp:Label></div>
                    <div class="s-lbl">Total Records</div>
                </div>
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblWorking" runat="server">0</asp:Label></div>
                    <div class="s-lbl">Working</div>
                </div>
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblNotWorking" runat="server">0</asp:Label></div>
                    <div class="s-lbl">Not Working</div>
                </div>
            </div>

            <div class="report-table-area">
                <asp:Panel ID="pnlReportEmpty" runat="server" Visible="true">
                    <div class="report-empty">
                        <i class="fa-solid fa-filter"></i><i class="icon-emoji" aria-hidden="true">🔎</i>
                        Select an asset name or keep <strong>All Records</strong> and click <strong>Apply Filter</strong>
                    </div>
                </asp:Panel>

                <asp:GridView ID="gvReport" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="grid-view" Visible="false">
                    <Columns>
                        <asp:BoundField DataField="TransactionID"       HeaderText="Transaction ID"        />
                        <asp:BoundField DataField="AssetCode"           HeaderText="Asset Code"            />
                        <asp:BoundField DataField="AssetName"           HeaderText="Asset Name"            />
                        <asp:BoundField DataField="ItemType"            HeaderText="Category"              />
                        <asp:BoundField DataField="UpdatedDate"         HeaderText="Updated Date"          DataFormatString="{0:dd-MM-yyyy}" />
                        <asp:BoundField DataField="Status"              HeaderText="Status"                />
                        <asp:BoundField DataField="MaintenanceType"     HeaderText="Maintenance Type"      />
                        <asp:BoundField DataField="NextMaintenanceDate" HeaderText="Next Maintenance Date" DataFormatString="{0:dd-MM-yyyy}" />
                        <asp:BoundField DataField="Description"         HeaderText="Description"           />
                        <asp:BoundField DataField="Remark"              HeaderText="Remark"                />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Reopen modal after postback -->
    <asp:Literal ID="litReopenModal" runat="server"></asp:Literal>

    <script type="text/javascript">
        function openReportModal() {
            document.getElementById('reportOverlay').classList.add('open');
            document.body.style.overflow = 'hidden';
        }
        function closeReportModal() {
            document.getElementById('reportOverlay').classList.remove('open');
            document.body.style.overflow = '';
        }
        document.getElementById('reportOverlay').addEventListener('click', function (e) {
            if (e.target === this) closeReportModal();
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeReportModal();
        });
    </script>

</form>

<!-- ── FOOTER ── -->
<footer>
    <div style="background:#eff6ff; border-top:2px solid #3b82f6; padding:28px 25px;
                text-align:center; font-family:'Plus Jakarta Sans',Arial,sans-serif;">
        <p style="font-size:14px; font-weight:600; color:#1d4ed8; margin:0 0 4px;">Dayton Natural Resources Pvt. Ltd.</p>
        <p style="font-size:11px; color:#64748b; margin:0 0 10px;">&copy; 2026 All Infrastructure Records Reserved Securely.</p>
        <p style="font-size:10px; color:#94a3b8; font-family:monospace; margin:0;">Runtime Context: .NET Framework 4.8+ Web Forms Engine &middot; Cryptographic Token Identity Core</p>
    </div>
</footer>

</body>
</html>