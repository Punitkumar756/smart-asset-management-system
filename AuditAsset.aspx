<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AuditAsset.aspx.cs" Inherits="AuditAsset" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <title>Asset Audit System</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <!--
        ICON FONT — SELF-HOSTED
        ────────────────────────────────────────────────────────
        CDN link replaced. Tofu/"?" glyphs happen when the icon
        font's webfont files (woff2/ttf) fail to download even
        though the CSS itself loads — common on locked-down
        internal networks. Self-hosting removes that dependency.

        REQUIRED FOLDER STRUCTURE (copy from the FA download zip):
          /Content/fontawesome/css/all.min.css
          /Content/fontawesome/webfonts/  (entire folder, all files)

        Adjust the href below if your project uses a different
        root path / virtual directory.
    -->
    <link rel="stylesheet" href="Content/fontawesome/css/all.min.css" />

    <script src="https://unpkg.com/@zxing/library@0.18.6/umd/index.min.js"></script>

    <style>
        /* ══════════════════════════════════════════════
           1. CSS VARIABLES
        ══════════════════════════════════════════════ */
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

        /* ══════════════════════════════════════════════
           2. RESET & BASE
        ══════════════════════════════════════════════ */
        *, *::before, *::after {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        html { scroll-behavior: smooth; }

        body {
            min-height: 100vh;
            background:
                linear-gradient(135deg, rgba(244,243,240,0.88), rgba(234,233,241,0.92)),
                url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
        }

        /* ══════════════════════════════════════════════
           ICON FALLBACK HELPERS
           If the Font Awesome glyph fails to render (tofu),
           .icon-emoji supplies a visible emoji instead. Both
           sit side by side so once fonts work, just hide the
           emoji span via the .ico-fallback-off class on <body>
           if you want a cleaner look (optional, not required).
        ══════════════════════════════════════════════ */
        .icon-emoji {
            font-style: normal;
            font-family: "Segoe UI Emoji","Apple Color Emoji","Noto Color Emoji",sans-serif;
            margin-right: 4px;
            line-height: 1;
        }

        /* ══════════════════════════════════════════════
           3. NAVBAR
        ══════════════════════════════════════════════ */
        .audit-navbar {
            position: sticky;
            top: 0;
            z-index: 500;
            width: 100%;
            background: rgba(255,255,255,0.72);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255,255,255,0.55);
            box-shadow: 0 2px 16px rgba(0,0,0,0.06);
        }

        .nav-inner {
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 32px;
            height: var(--nav-h);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .navbar-back-btn {
            background: rgba(255,255,255,0.85);
            border: 1px solid #e2e8f0;
            border-radius: 50%;
            width: 36px; height: 36px;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            color: #4b5563; font-size: 13px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: background .2s;
            flex-shrink: 0;
        }
        .navbar-back-btn:hover { background: #f1f5f9; }

        .nav-logo { height: 42px; width: auto; object-fit: contain; display: block; }

        .nav-brand-name {
            font-size: 14px; font-weight: 700; color: var(--primary-dark);
            white-space: nowrap; line-height: 1.25;
        }
        .nav-brand-sub {
            font-size: 10px; font-weight: 500; color: var(--text-muted);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 4px;
            list-style: none;
            flex: 1;
            justify-content: center;
            flex-wrap: nowrap;
        }
        .nav-links a {
            display: block;
            padding: 7px 14px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 13px; font-weight: 600;
            color: var(--text-muted);
            white-space: nowrap;
            transition: background .18s, color .18s;
        }
        .nav-links a:hover { background: rgba(93,135,255,0.1); color: var(--accent-blue); }
        .nav-links a.active {
            background: rgba(93,135,255,0.12);
            color: var(--accent-blue);
        }

        .nav-right {
            display: flex; align-items: center; gap: 8px;
            flex-shrink: 0;
        }

        .role-badge {
            background: #fff;
            padding: 5px 12px;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            font-weight: 700; font-size: 11px;
            color: var(--primary-dark);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: inline-flex; align-items: center; gap: 5px;
            white-space: nowrap;
        }
        .role-badge.accent {
            background: rgba(93,135,255,0.07);
            border-color: rgba(93,135,255,0.22);
            color: var(--accent-blue);
        }

        .btn-logout {
            background: var(--primary-dark); color: #fff;
            text-decoration: none;
            padding: 7px 16px;
            border-radius: 20px;
            font-size: 12px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: background .2s;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .btn-logout:hover { background: #1e293b; }

        .nav-toggle {
            display: none;
            background: rgba(255,255,255,0.85);
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            width: 38px; height: 38px;
            cursor: pointer;
            align-items: center; justify-content: center;
            font-size: 16px; color: var(--primary-dark);
            flex-shrink: 0;
        }

        .nav-drawer {
            display: none;
            flex-direction: column;
            background: rgba(255,255,255,0.96);
            border-top: 1px solid rgba(0,0,0,0.06);
            padding: 12px 20px 18px;
            gap: 6px;
        }
        .nav-drawer.open { display: flex; }

        .nav-drawer .nav-links {
            flex-direction: column;
            align-items: flex-start;
            justify-content: flex-start;
            gap: 2px;
        }
        .nav-drawer .nav-links a {
            width: 100%;
            border-radius: 10px;
            padding: 10px 14px;
        }
        .nav-drawer .nav-right {
            flex-wrap: wrap;
            padding-top: 10px;
            border-top: 1px solid rgba(0,0,0,0.06);
            gap: 8px;
        }
        .nav-drawer .btn-logout { width: 100%; justify-content: center; }

        /* ══════════════════════════════════════════════
           4. PAGE CONTENT WRAPPER
        ══════════════════════════════════════════════ */
        .page-content {
            max-width: 1280px;
            margin: 0 auto;
            padding: 28px 32px 40px;
        }

        .page-breadcrumb {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px; font-weight: 600;
            color: var(--text-muted);
            background: rgba(255,255,255,0.55);
            padding: 5px 14px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.65);
            margin-bottom: 22px;
        }
        .page-breadcrumb span { color: var(--accent-blue); }

        /* ══════════════════════════════════════════════
           5. HERO ROW
        ══════════════════════════════════════════════ */
        .hero-row {
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 28px;
            align-items: start;
            margin-bottom: 28px;
        }
        .info-panel { position: sticky; top: calc(var(--nav-h) + 16px); }

        .hero-box {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            padding: 32px;
            border-radius: var(--radius-lg);
            backdrop-filter: blur(24px);
        }
        .hero-box h1 { font-size: 28px; color: var(--primary-dark); font-weight: 800; line-height: 1.2; }
        .hero-box h1 span { color: var(--accent-blue); }
        .hero-box p  { margin-top: 10px; color: var(--text-muted); font-size: 13.5px; line-height: 1.7; }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 10px;
            margin-top: 22px;
        }
        .stat-chip {
            background: rgba(93,135,255,0.08);
            border: 1px solid rgba(93,135,255,0.18);
            border-radius: 12px;
            padding: 12px 8px;
            text-align: center;
        }
        .stat-chip .num { font-size: 20px; font-weight: 800; color: var(--accent-blue); }
        .stat-chip .lbl { font-size: 10px; color: var(--text-muted); font-weight: 600; margin-top: 2px; }

        /* ══════════════════════════════════════════════
           6. GLASS CARD
        ══════════════════════════════════════════════ */
        .card {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            padding: 26px;
            backdrop-filter: blur(24px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.05);
        }
        .card-title {
            font-size: 14px; font-weight: 700; color: var(--primary-dark);
            margin-bottom: 18px;
            display: flex; align-items: center; gap: 8px;
            padding-bottom: 14px;
            border-bottom: 1px solid rgba(0,0,0,0.06);
        }
        .card-title i { color: var(--accent-blue); }

        /* ══════════════════════════════════════════════
           7. FORM ELEMENTS
        ══════════════════════════════════════════════ */
        label {
            font-size: 12px; font-weight: 600; color: var(--primary-dark);
            margin-bottom: 6px; display: block; letter-spacing: 0.01em;
        }
        .input-control {
            width: 100%; height: 42px; padding: 8px 12px;
            border-radius: var(--radius-md);
            border: 1px solid rgba(0,0,0,0.1);
            font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif;
            background: rgba(255,255,255,0.75); color: var(--primary-dark);
            transition: border-color .2s, box-shadow .2s;
        }
        .input-control:focus {
            outline: none; border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(93,135,255,0.15); background: #fff;
        }
        .form-group  { margin-bottom: 14px; }
        .form-row    { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        .scan-input-row { display: flex; gap: 8px; align-items: stretch; }
        .scan-field-wrap { position: relative; flex: 1; min-width: 0; }
        .scan-field-wrap .s-icon {
            position: absolute; left: 12px; top: 50%;
            transform: translateY(-50%); color: #94a3b8; font-size: 13px; pointer-events: none;
        }
        .scan-field-wrap .input-control { padding-left: 34px; }

        /* ══════════════════════════════════════════════
           8. BUTTONS
        ══════════════════════════════════════════════ */
        .btn {
            border: none; padding: 10px 22px; border-radius: 25px; cursor: pointer;
            font-weight: 700; font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif;
            transition: background .2s, transform .1s;
            display: inline-flex; align-items: center; gap: 7px;
        }
        .btn:active { transform: scale(0.97); }
        .btn-primary   { background: var(--accent-blue); color: #fff; }
        .btn-primary:hover { background: #4b76ed; }
        .btn-success   { background: #13deb9; color: #fff; }
        .btn-success:hover { background: #0fc9a7; }
        .btn-secondary { background: rgba(0,0,0,0.06); color: var(--text-muted); }
        .btn-secondary:hover { background: rgba(0,0,0,0.1); }
        .btn-full { width: 100%; justify-content: center; margin-top: 6px; }

        .btn-scan-cam {
            height: 42px; padding: 0 16px;
            border-radius: var(--radius-md);
            background: linear-gradient(135deg,#5d87ff,#4b76ed);
            color: #fff; border: none; cursor: pointer;
            font-weight: 700; font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif;
            display: inline-flex; align-items: center; gap: 6px;
            white-space: nowrap; flex-shrink: 0;
            transition: all .2s; box-shadow: 0 4px 14px rgba(93,135,255,0.35);
        }
        .btn-scan-cam:hover  { background: linear-gradient(135deg,#4b76ed,#3b65d4); box-shadow: 0 6px 18px rgba(93,135,255,0.45); }
        .btn-scan-cam:active { transform: scale(0.97); }

        .btn-report {
            background: linear-gradient(135deg,#7c3aed,#6d28d9);
            color: #fff; border: none; padding: 10px 20px; border-radius: 25px;
            font-weight: 700; font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif;
            cursor: pointer; display: inline-flex; align-items: center; gap: 7px;
            box-shadow: 0 4px 14px rgba(124,58,237,0.35); transition: all .2s; white-space: nowrap;
        }
        .btn-report:hover  { background: linear-gradient(135deg,#6d28d9,#5b21b6); }
        .btn-report:active { transform: scale(0.97); }

        /* ══════════════════════════════════════════════
           9. ASSET INFO TABLE
        ══════════════════════════════════════════════ */
        .asset-info-table { width: 100%; border-collapse: collapse; }
        .asset-info-table tr { border-bottom: 1px solid rgba(0,0,0,0.05); }
        .asset-info-table tr:last-child { border-bottom: none; }
        .asset-info-table td { padding: 9px 6px; font-size: 13px; }
        .asset-info-table td:first-child { color: var(--text-muted); font-weight: 600; width: 44%; font-size: 12px; }
        .asset-info-table td:last-child  { color: var(--primary-dark); font-weight: 600; }
        .asset-empty { text-align: center; padding: 38px 20px; color: #94a3b8; }
        .asset-empty i { font-size: 40px; margin-bottom: 10px; opacity: .35; display: block; }
        .asset-empty .icon-emoji { font-size: 40px; margin-bottom: 10px; opacity: .55; display: block; }
        .asset-empty p { font-size: 13px; line-height: 1.6; }

        /* ══════════════════════════════════════════════
           10. STATUS & CONDITION BADGES
        ══════════════════════════════════════════════ */
        .status-badge, .condition-badge {
            display: inline-block; padding: 3px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600; white-space: nowrap;
        }
        .status-Found       { background: rgba(19,222,185,0.15); color: #0f6e56; }
        .status-Missing     { background: rgba(251,150,120,0.15); color: #854F0B; }
        .status-Damaged     { background: rgba(229,57,53,0.12);   color: #A32D2D; }
        .status-UnderRepair { background: rgba(93,135,255,0.12);  color: #3b5bdb; }
        .condition-Excellent { background: rgba(19,222,185,0.15); color: #0f6e56; }
        .condition-Good      { background: rgba(93,135,255,0.12); color: #3b5bdb; }
        .condition-Fair      { background: rgba(251,150,120,0.15); color: #854F0B; }
        .condition-Poor      { background: rgba(229,57,53,0.12);  color: #A32D2D; }

        /* ══════════════════════════════════════════════
           11. FEEDBACK MESSAGES
        ══════════════════════════════════════════════ */
        .message-success {
            background: rgba(19,222,185,0.12); color: #0f6e56;
            padding: 11px 16px; border-radius: 12px; margin-bottom: 18px;
            font-weight: 600; font-size: 13px; border-left: 3px solid #13deb9;
            display: flex; align-items: center; gap: 8px;
        }
        .message-error {
            background: rgba(229,57,53,0.1); color: #a32d2d;
            padding: 11px 16px; border-radius: 12px; margin-bottom: 18px;
            font-weight: 600; font-size: 13px; border-left: 3px solid #e53935;
            display: flex; align-items: center; gap: 8px;
        }

        /* ══════════════════════════════════════════════
           12. LAYOUT HELPERS
        ══════════════════════════════════════════════ */
        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px; }

        .section-label {
            font-size: 10px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.08em; color: #94a3b8; margin: 18px 0 12px;
            padding-bottom: 8px; border-bottom: 1px solid rgba(0,0,0,0.06);
        }

        /* ══════════════════════════════════════════════
           13. AUDIT FORM — CONDITION / STATUS CARDS
        ══════════════════════════════════════════════ */
        .audit-card-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 10px; }
        .audit-card {
            border: 1.5px solid rgba(0,0,0,0.09);
            border-radius: 12px; padding: 14px 10px;
            background: rgba(255,255,255,0.7); cursor: pointer;
            transition: all .2s; text-align: center;
            font-weight: 600; font-size: 13px; color: var(--text-muted);
            display: flex; flex-direction: column; align-items: center; gap: 6px;
        }
        .audit-card:hover { border-color: var(--accent-blue); background: rgba(93,135,255,0.06); }
        .audit-card i { font-size: 20px; }
        .audit-card .icon-emoji { font-size: 20px; margin-right: 0; }
        .audit-card input[type=radio] { accent-color: var(--accent-blue); width: 15px; height: 15px; }

        .remarks-box {
            width: 100%; min-height: 90px; padding: 11px 13px;
            border-radius: var(--radius-md); border: 1px solid rgba(0,0,0,0.1);
            font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif;
            resize: vertical; background: rgba(255,255,255,0.75);
            transition: border-color .2s, box-shadow .2s;
        }
        .remarks-box:focus {
            outline: none; border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(93,135,255,0.15); background: #fff;
        }

        .audit-footer {
            display: flex; gap: 12px; margin-top: 20px;
            padding-top: 18px; border-top: 1px solid rgba(0,0,0,0.06);
        }

        /* ══════════════════════════════════════════════
           14. AUDIT HISTORY TABLE
        ══════════════════════════════════════════════ */
        .history-title-row {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 18px; padding-bottom: 14px; border-bottom: 1px solid rgba(0,0,0,0.06);
        }
        .history-title-row .card-title { margin-bottom: 0; padding-bottom: 0; border-bottom: none; }

        .table-scroll { overflow-x: auto; }

        .grid-view { width: 100%; border-collapse: collapse; min-width: 760px; }
        .grid-view th {
            background: rgba(15,23,42,0.04); padding: 11px 12px;
            font-size: 11px; font-weight: 700; color: var(--primary-dark);
            text-align: left; border-bottom: 1px solid rgba(0,0,0,0.07); white-space: nowrap;
        }
        .grid-view td {
            padding: 10px 12px; font-size: 12px; color: var(--text-muted);
            border-bottom: 1px solid rgba(0,0,0,0.05); vertical-align: middle;
        }
        .grid-view tr:last-child td { border-bottom: none; }
        .grid-view tr:hover td { background: rgba(93,135,255,0.04); }

        /* ══════════════════════════════════════════════
           15. REPORT MODAL
        ══════════════════════════════════════════════ */
        .report-overlay {
            display: none; position: fixed; inset: 0; z-index: 9999;
            background: rgba(15,23,42,0.85); backdrop-filter: blur(8px);
            align-items: center; justify-content: center;
        }
        .report-overlay.active { display: flex; }

        .report-modal {
            background: #fff; border-radius: 22px; padding: 28px;
            width: min(520px,94vw); box-shadow: 0 28px 70px rgba(0,0,0,0.3);
            animation: modalIn .22s ease; max-height: 90vh; overflow-y: auto;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.93) translateY(14px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }

        .report-modal-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 22px; padding-bottom: 16px; border-bottom: 1px solid rgba(0,0,0,0.07);
        }
        .report-modal-title {
            font-weight: 800; font-size: 17px; color: var(--primary-dark);
            display: flex; align-items: center; gap: 9px;
        }
        .report-modal-title i { color: #7c3aed; }

        .report-close-btn {
            background: rgba(0,0,0,0.07); border: none; border-radius: 50%;
            width: 34px; height: 34px; cursor: pointer; font-size: 15px; color: #4b5563;
            display: flex; align-items: center; justify-content: center; transition: background .2s;
        }
        .report-close-btn:hover { background: rgba(0,0,0,0.14); }

        .admin-badge {
            background: linear-gradient(135deg,rgba(124,58,237,0.1),rgba(109,40,217,0.12));
            border: 1px solid rgba(124,58,237,0.25); border-radius: 12px;
            padding: 11px 15px; margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px;
            font-size: 12px; font-weight: 600; color: #5b21b6;
        }
        .admin-badge i { font-size: 15px; color: #7c3aed; }

        .report-select, .report-input {
            width: 100%; height: 42px; padding: 8px 12px;
            border-radius: var(--radius-md); border: 1px solid rgba(0,0,0,0.12);
            font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif;
            background: rgba(255,255,255,0.9); color: var(--primary-dark);
            transition: border-color .2s, box-shadow .2s; cursor: pointer;
        }
        .report-select:focus, .report-input:focus {
            outline: none; border-color: #7c3aed; box-shadow: 0 0 0 3px rgba(124,58,237,0.15);
        }

        .report-divider {
            font-size: 10px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.08em; color: #94a3b8;
            margin: 18px 0 12px; padding-bottom: 8px; border-bottom: 1px solid rgba(0,0,0,0.06);
        }

        .report-actions { display: flex; gap: 10px; margin-top: 22px; padding-top: 18px; border-top: 1px solid rgba(0,0,0,0.07); }
        .btn-generate {
            flex: 1; justify-content: center;
            background: linear-gradient(135deg,#7c3aed,#6d28d9); color: #fff;
            border-radius: 12px; padding: 12px; font-size: 14px;
            box-shadow: 0 4px 14px rgba(124,58,237,0.3);
        }
        .btn-generate:hover { background: linear-gradient(135deg,#6d28d9,#5b21b6); }
        .btn-print {
            flex: 1; justify-content: center;
            background: linear-gradient(135deg,#0f172a,#1e293b); color: #fff;
            border-radius: 12px; padding: 12px; font-size: 14px;
        }
        .btn-print:hover { background: linear-gradient(135deg,#1e293b,#334155); }
        .btn-download {
            flex: 1; justify-content: center;
            background: linear-gradient(135deg,#059669,#047857); color: #fff;
            border-radius: 12px; padding: 12px; font-size: 14px;
            box-shadow: 0 4px 14px rgba(5,150,105,0.3);
        }
        .btn-download:hover { background: linear-gradient(135deg,#047857,#065f46); }

        .report-preview-wrap {
            margin-top: 18px; background: rgba(124,58,237,0.03);
            border: 1px solid rgba(124,58,237,0.12); border-radius: 14px; overflow: hidden;
        }
        .report-preview-header {
            background: linear-gradient(135deg,#7c3aed,#6d28d9); color: #fff;
            padding: 14px 18px; font-size: 13px; font-weight: 700;
            display: flex; align-items: center; gap: 8px;
        }
        .report-preview-body { padding: 4px 0; max-height: 260px; overflow-y: auto; }

        .report-row {
            display: grid;
            grid-template-columns: 28px 1fr 76px 76px 76px 1fr;
            gap: 8px; padding: 9px 16px; font-size: 12px;
            border-bottom: 1px solid rgba(0,0,0,0.04); align-items: center;
        }
        .report-row:last-child  { border-bottom: none; }
        .report-row:hover       { background: rgba(124,58,237,0.04); }
        .report-col-head { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: #94a3b8; }
        .report-num  { font-weight: 700; color: #7c3aed; font-size: 11px; }
        .report-name { font-weight: 600; color: var(--primary-dark); }
        .report-date { color: var(--text-muted); }
        .report-empty-msg { text-align: center; padding: 28px; color: #94a3b8; font-size: 13px; font-weight: 600; }
        .report-empty-msg i { font-size: 30px; display: block; margin-bottom: 8px; opacity: .35; }
        .report-empty-msg .icon-emoji { font-size: 30px; display: block; margin-bottom: 8px; opacity: .55; }

        /* ══════════════════════════════════════════════
           16. SCANNER MODAL
        ══════════════════════════════════════════════ */
        .scan-overlay {
            display: none; position: fixed; inset: 0; z-index: 9999;
            background: rgba(15,23,42,0.85); backdrop-filter: blur(8px);
            align-items: center; justify-content: center;
        }
        .scan-overlay.active { display: flex; }

        .scan-modal {
            background: #fff; border-radius: 22px; padding: 26px;
            width: min(460px,94vw); box-shadow: 0 28px 70px rgba(0,0,0,0.3);
            animation: modalIn .22s ease;
        }
        .scan-tabs {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 6px; margin-bottom: 20px;
            background: rgba(0,0,0,0.05); border-radius: 12px; padding: 4px;
        }
        .scan-tab {
            padding: 9px 12px; border: none; border-radius: 10px; cursor: pointer;
            font-family: 'Plus Jakarta Sans', sans-serif; font-size: 13px; font-weight: 600;
            color: var(--text-muted); background: transparent; transition: all .2s;
            display: flex; align-items: center; justify-content: center; gap: 7px;
        }
        .scan-tab.active { background: #fff; color: var(--accent-blue); box-shadow: 0 2px 10px rgba(0,0,0,0.1); }

        .scan-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .scan-title  { font-weight: 700; font-size: 15px; color: var(--primary-dark); display: flex; align-items: center; gap: 8px; }
        .scan-title i { color: var(--accent-blue); }
        .scan-close {
            background: rgba(0,0,0,0.07); border: none; border-radius: 50%;
            width: 34px; height: 34px; cursor: pointer; font-size: 15px; color: #4b5563;
            display: flex; align-items: center; justify-content: center; transition: background .2s;
        }
        .scan-close:hover { background: rgba(0,0,0,0.14); }

        #panelCamera { display: block; }
        #panelUpload  { display: none; }

        .cam-viewport { position: relative; border-radius: 14px; overflow: hidden; background: #000; aspect-ratio: 4/3; }
        #scannerVideo { width: 100%; height: 100%; object-fit: cover; display: block; }
        .cam-window {
            position: absolute; top: 14%; left: 11%; right: 11%; bottom: 14%;
            border-radius: 10px; pointer-events: none;
            box-shadow: 0 0 0 9999px rgba(0,0,0,0.42);
        }
        .cam-window::before, .cam-window::after, .cam-window .c-bl, .cam-window .c-br {
            content: ''; position: absolute; width: 22px; height: 22px;
            border-color: #fff; border-style: solid;
        }
        .cam-window::before { top: -2px; left: -2px;   border-width: 3px 0 0 3px; border-radius: 6px 0 0 0; }
        .cam-window::after  { top: -2px; right: -2px;  border-width: 3px 3px 0 0; border-radius: 0 6px 0 0; }
        .cam-window .c-bl   { bottom: -2px; left: -2px;  border-width: 0 0 3px 3px; border-radius: 0 0 0 6px; }
        .cam-window .c-br   { bottom: -2px; right: -2px; border-width: 0 3px 3px 0; border-radius: 0 0 6px 0; }

        .scan-line {
            position: absolute; left: 12%; right: 12%; height: 2px;
            background: linear-gradient(90deg,transparent,#5d87ff 35%,#5d87ff 65%,transparent);
            border-radius: 2px; pointer-events: none;
            animation: scanAnim 2.2s ease-in-out infinite;
            box-shadow: 0 0 8px rgba(93,135,255,0.8);
        }
        @keyframes scanAnim {
            0%   { top: 15%; opacity: 0; }
            8%   { opacity: 1; }
            92%  { opacity: 1; }
            100% { top: 85%; opacity: 0; }
        }
        .cam-viewport.flash { animation: flashGreen .45s ease; }
        @keyframes flashGreen {
            0%   { box-shadow: 0 0 0 0   rgba(19,222,185,0); }
            40%  { box-shadow: 0 0 0 8px rgba(19,222,185,0.6); }
            100% { box-shadow: 0 0 0 0   rgba(19,222,185,0); }
        }

        .upload-drop {
            border: 2px dashed rgba(93,135,255,0.35); border-radius: 14px;
            padding: 32px 20px; text-align: center; cursor: pointer;
            transition: all .2s; background: rgba(93,135,255,0.03); position: relative;
        }
        .upload-drop:hover, .upload-drop.dragover { border-color: var(--accent-blue); background: rgba(93,135,255,0.07); }
        .upload-drop input[type=file] { position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%; }
        .upload-drop-icon { font-size: 36px; color: rgba(93,135,255,0.5); margin-bottom: 10px; }
        .upload-drop-icon .icon-emoji { font-size: 36px; opacity: .7; }
        .upload-drop p { font-size: 13px; color: var(--text-muted); font-weight: 600; line-height: 1.6; }
        .upload-drop span { color: var(--accent-blue); }

        .upload-preview { display: none; margin-top: 14px; text-align: center; }
        .upload-preview img { max-width: 100%; max-height: 180px; border-radius: 10px; border: 1px solid rgba(0,0,0,0.08); object-fit: contain; }
        .upload-preview .file-name { font-size: 12px; color: var(--text-muted); margin-top: 6px; font-weight: 600; }

        .btn-decode {
            width: 100%; margin-top: 14px; justify-content: center;
            background: linear-gradient(135deg,#5d87ff,#4b76ed);
            color: #fff; border-radius: 12px; padding: 11px;
            box-shadow: 0 4px 14px rgba(93,135,255,0.3);
        }
        .btn-decode:hover    { background: linear-gradient(135deg,#4b76ed,#3b65d4); }
        .btn-decode:disabled { opacity: 0.5; cursor: not-allowed; }

        .scan-status {
            margin-top: 14px; text-align: center; font-size: 13px;
            font-weight: 600; color: #4b5563; min-height: 22px; transition: color .2s;
        }
        .scan-status.ok  { color: #0f6e56; }
        .scan-status.err { color: #a32d2d; }

        .scan-footer { display: flex; gap: 10px; margin-top: 16px; }
        .scan-footer .btn { flex: 1; justify-content: center; border-radius: 12px; padding: 10px; }

        /* ══════════════════════════════════════════════
           17. FOOTER
        ══════════════════════════════════════════════ */
        .site-footer {
            background: #eff6ff;
            border-top: 2px solid #3b82f6;
            padding: 24px 32px;
            text-align: center;
        }
        .site-footer .f-company { font-size: 14px; font-weight: 700; color: #1d4ed8; margin-bottom: 4px; }
        .site-footer .f-copy    { font-size: 11px; color: #64748b; margin-bottom: 8px; }
        .site-footer .f-runtime { font-size: 10px; color: #94a3b8; font-family: monospace; }

        /* ══════════════════════════════════════════════
           18. PRINT
        ══════════════════════════════════════════════ */
        @media print {
            body * { visibility: hidden !important; }
            #printSection, #printSection * { visibility: visible !important; }
            #printSection {
                position: fixed !important; inset: 0 !important;
                background: #fff !important; padding: 30px 40px !important; z-index: 99999 !important;
            }
        }

        /* ══════════════════════════════════════════════
           19. RESPONSIVE BREAKPOINTS
        ══════════════════════════════════════════════ */
        @media (max-width: 1100px) {
            .nav-brand-name { display: none; }
        }
        @media (max-width: 960px) {
            .hero-row  { grid-template-columns: 1fr; }
            .two-col   { grid-template-columns: 1fr; }
            .hero-stats { grid-template-columns: repeat(2,1fr); }
            .audit-card-grid { grid-template-columns: repeat(2,1fr); }
            .form-row  { grid-template-columns: 1fr; }
            .info-panel { position: static; }
            .history-title-row { flex-direction: column; align-items: flex-start; gap: 12px; }
        }
        @media (max-width: 820px) {
            :root { --nav-h: auto; }
            .nav-inner { height: auto; padding: 12px 16px; flex-wrap: wrap; }
            .nav-links  { display: none; }
            .nav-right  { display: none; }
            .nav-toggle { display: flex; }
        }
        @media (max-width: 600px) {
            .page-content { padding: 18px 14px 32px; }
            .site-footer  { padding: 18px 14px; }
            .site-footer .f-company { font-size: 13px; }
            .site-footer .f-runtime { word-break: break-word; line-height: 1.5; }
        }
        @media (max-width: 480px) {
            .hero-box { padding: 20px; }
            .hero-box h1 { font-size: 22px; }
            .card { padding: 18px; }
            .audit-card-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- ══════════════════════════════════════════════
         NAVBAR
    ══════════════════════════════════════════════ -->
    <nav class="audit-navbar">
        <div class="nav-inner">

            <div class="nav-brand">
                <button type="button" class="navbar-back-btn" onclick="history.back()" title="Go Back">
                    <i class="fa-solid fa-arrow-left"></i><i class="icon-emoji" aria-hidden="true">⬅️</i>
                </button>
                <img src="https://daytonnaturalresources.com/wp-content/uploads/2024/01/Dayton-Logo-2-1.png"
                     alt="Dayton Logo" class="nav-logo" />
                <div>
                    <div class="nav-brand-name">Dayton Natural Resources</div>
                    <div class="nav-brand-sub">PVT. LTD.</div>
                </div>
            </div>

            <ul class="nav-links" id="navLinkList">
                <li><a href="home.aspx">Home</a></li>
                <li><a href="home.aspx#corporate-about-section">Company Profile</a></li>
                <li><a href="AuditAsset.aspx" class="active">Asset Audit</a></li>
                <li><a href="home.aspx#contact-section">Contact</a></li>
            </ul>

            <div class="nav-right" id="navRight">
                <div class="role-badge accent">
                    <i class="fa-solid fa-calendar-check"></i><i class="icon-emoji" aria-hidden="true">📅</i>
                    <asp:Label ID="Label1" runat="server" />
                </div>
                <div class="role-badge">
                    <i class="fa-solid fa-circle-user"></i><i class="icon-emoji" aria-hidden="true">👤</i>
                    <asp:Label ID="lblLoggedInUser" runat="server" />
                    <asp:Label ID="lblNavUser" runat="server" Visible="false" />
                </div>
                <a href="LOGINPAGE.aspx" class="btn-logout">
                    <i class="fa-solid fa-right-from-bracket"></i><i class="icon-emoji" aria-hidden="true">🚪</i> Logout
                </a>
            </div>

            <button type="button" class="nav-toggle" id="navToggle" onclick="toggleDrawer()" aria-label="Menu">
                <i class="fa-solid fa-bars" id="navToggleIcon"></i><i class="icon-emoji" aria-hidden="true">☰</i>
            </button>

        </div>

        <div class="nav-drawer" id="navDrawer">
            <ul class="nav-links">
                <li><a href="home.aspx">Home</a></li>
                <li><a href="home.aspx#corporate-about-section">Company Profile</a></li>
                <li><a href="AuditAsset.aspx" class="active">Asset Audit</a></li>
                <li><a href="home.aspx#contact-section">Contact</a></li>
            </ul>
            <div class="nav-right" style="display:flex; flex-wrap:wrap; gap:8px; padding-top:10px; border-top:1px solid rgba(0,0,0,0.06);">
                <div class="role-badge accent">
                    <i class="fa-solid fa-calendar-check"></i><i class="icon-emoji" aria-hidden="true">📅</i>
                    <asp:Label ID="Label2" runat="server" />
                </div>
                <div class="role-badge">
                    <i class="fa-solid fa-circle-user"></i><i class="icon-emoji" aria-hidden="true">👤</i>
                    <asp:Label ID="lblLoggedInUserMobile" runat="server" />
                </div>
                <a href="LOGINPAGE.aspx" class="btn-logout" style="width:100%; justify-content:center;">
                    <i class="fa-solid fa-right-from-bracket"></i><i class="icon-emoji" aria-hidden="true">🚪</i> Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- ══════════════════════════════════════════════
         PAGE CONTENT
    ══════════════════════════════════════════════ -->
    <div class="page-content">

        <div class="page-breadcrumb">
            Dashboard &rsaquo; <span>Asset Audit</span>
        </div>

        <!-- HERO ROW -->
        <div class="hero-row">

            <div class="info-panel">
                <div class="hero-box">
                    <h1>Asset <span>Audit</span> System</h1>
                    <p>Scan or enter an asset code to instantly load details and complete a physical verification. Track audit history and monitor asset health across all groups.</p>
                    <div class="hero-stats">
                        <div class="stat-chip">
                            <div class="num"><asp:Label ID="lblTotalAssets" runat="server" Text="0" /></div>
                            <div class="lbl">📦 Total Assets</div>
                        </div>
                        <div class="stat-chip">
                            <div class="num"><asp:Label ID="lblAudited" runat="server" Text="0" /></div>
                            <div class="lbl">✅ Audited</div>
                        </div>
                        <div class="stat-chip">
                            <div class="num"><asp:Label ID="lblMissing" runat="server" Text="0" /></div>
                            <div class="lbl">❌ Missing</div>
                        </div>
                        <div class="stat-chip">
                            <div class="num"><asp:Label ID="lblDamaged" runat="server" Text="0" /></div>
                            <div class="lbl">⚠️ Damaged</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-title">
                    <i class="fa-solid fa-magnifying-glass"></i><i class="icon-emoji" aria-hidden="true">🔍</i> Search Asset by Code
                </div>

                <asp:Label ID="lblMessage" runat="server" />

                <div class="form-group">
                    <label>Asset Code</label>
                    <div class="scan-input-row">
                        <div class="scan-field-wrap">
                            <i class="fa-solid fa-barcode s-icon"></i>
                            <asp:TextBox ID="txtAssetCode" runat="server"
                                CssClass="input-control"
                                placeholder="Paste, type, or scan asset code"
                                AutoPostBack="true"
                                OnTextChanged="btnSearch_Click" />
                        </div>
                        <button type="button" class="btn-scan-cam" onclick="openScanModal()" title="Scan barcode">
                            <i class="fa-solid fa-barcode"></i><i class="icon-emoji" aria-hidden="true">📷</i> Scan
                        </button>
                    </div>
                </div>

                <asp:Button ID="btnSearch" runat="server"
                    Text="Fetch Asset"
                    CssClass="btn btn-primary btn-full"
                    OnClick="btnSearch_Click" />
            </div>

        </div>

        <!-- ASSET INFO + AUDIT FORM -->
        <div class="two-col">

            <div class="card">
                <div class="card-title">
                    <i class="fa-solid fa-clipboard-list"></i><i class="icon-emoji" aria-hidden="true">📋</i> Asset Information
                </div>

                <div id="divEmpty" runat="server">
                    <div class="asset-empty">
                        <i class="fa-solid fa-box-open"></i>
                        <i class="icon-emoji" aria-hidden="true" style="display:block;font-size:40px;margin-bottom:10px;opacity:.55;">📦</i>
                        <p>Enter an asset code above<br />to load asset details here.</p>
                    </div>
                </div>

                <asp:DropDownList ID="ddlOffice"     runat="server" style="display:none;" />
                <asp:DropDownList ID="ddlDepartment" runat="server" style="display:none;" />

                <div id="divAssetInfo" runat="server" visible="false">
                    <table class="asset-info-table">
                        <tr><td>Asset ID</td>        <td><asp:Label ID="lblAssetID"     runat="server" /></td></tr>
                        <tr><td>Asset Code</td>      <td><asp:Label ID="lblAssetCode"   runat="server" /></td></tr>
                        <tr><td>Asset Name</td>      <td><asp:Label ID="lblAssetName"   runat="server" /></td></tr>
                        <tr><td>Category</td>        <td><asp:Label ID="lblCategory"    runat="server" /></td></tr>
                        <tr><td>Office</td>          <td><asp:Label ID="lblOffice"      runat="server" /></td></tr>
                        <tr><td>Department</td>      <td><asp:Label ID="lblDepartment"  runat="server" /></td></tr>
                        <tr><td>Brand</td>           <td><asp:Label ID="lblBrand"       runat="server" /></td></tr>
			<tr><td>Capacity</td>        <td><asp:Label ID="lblCapacity"    runat="server" /></td></tr>
                        <tr><td>Serial Number</td>   <td><asp:Label ID="lblSerial"      runat="server" /></td></tr>
                        <tr><td>Total Quantity</td>  <td><asp:Label ID="lblQuantity"    runat="server" /></td></tr>
                        <tr><td>Working Qty</td>     <td><asp:Label ID="lblWorkingQty"  runat="server" /></td></tr>
                        <tr><td>Non-Working Qty</td> <td><asp:Label ID="lblNonWorking"  runat="server" /></td></tr>
                        <tr><td>Current Status</td>  <td><asp:Label ID="lblStatus"      runat="server" /></td></tr>
                        <tr><td>Sector</td>          <td><asp:Label ID="lblSector"      runat="server" /></td></tr>
                        <tr><td>Description</td>     <td><asp:Label ID="lblDescription" runat="server" /></td></tr>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-title">
                    <i class="fa-solid fa-circle-check"></i><i class="icon-emoji" aria-hidden="true">✅</i> Audit Verification
                </div>

                <div class="form-row" style="margin-bottom:4px;">
                    <div class="form-group">
                        <label>Audit Date</label>
                        <asp:TextBox ID="TextBox1" runat="server" CssClass="input-control"
                            ReadOnly="true"
                            style="background:rgba(93,135,255,0.05); color:var(--accent-blue); font-weight:700; cursor:default;" />
                    </div>
                    <div class="form-group">
                        <label>Auditor Name</label>
                        <asp:TextBox ID="txtAuditor" runat="server" CssClass="input-control"
                            ReadOnly="true"
                            style="background:rgba(93,135,255,0.05); color:var(--accent-blue); font-weight:700; cursor:default;" />
                    </div>
                </div>

                <p class="section-label">Physical Verification Status</p>
                <div class="audit-card-grid">
                    <label class="audit-card">
                        <i class="fa-solid fa-circle-check" style="color:#13deb9;"></i><i class="icon-emoji" aria-hidden="true">✅</i>
                        <asp:RadioButton ID="rbFound"   runat="server" GroupName="Status" /> Found
                    </label>
                    <label class="audit-card">
                        <i class="fa-solid fa-circle-xmark" style="color:#e53935;"></i><i class="icon-emoji" aria-hidden="true">❌</i>
                        <asp:RadioButton ID="rbMissing" runat="server" GroupName="Status" /> Missing
                    </label>
                    <label class="audit-card">
                        <i class="fa-solid fa-triangle-exclamation" style="color:#fb9678;"></i><i class="icon-emoji" aria-hidden="true">⚠️</i>
                        <asp:RadioButton ID="rbDamaged" runat="server" GroupName="Status" /> Damaged
                    </label>
                    <label class="audit-card">
                        <i class="fa-solid fa-screwdriver-wrench" style="color:#5d87ff;"></i><i class="icon-emoji" aria-hidden="true">🔧</i>
                        <asp:RadioButton ID="rbRepair"  runat="server" GroupName="Status" /> Under Repair
                    </label>
                </div>

                <p class="section-label">Asset Condition</p>
                <div class="audit-card-grid">
                    <label class="audit-card">
                        <i class="fa-solid fa-star" style="color:#f59e0b;"></i><i class="icon-emoji" aria-hidden="true">⭐</i>
                        <asp:RadioButton ID="rbExcellent" runat="server" GroupName="Condition" /> Excellent
                    </label>
                    <label class="audit-card">
                        <i class="fa-solid fa-thumbs-up" style="color:#13deb9;"></i><i class="icon-emoji" aria-hidden="true">👍</i>
                        <asp:RadioButton ID="rbGood" runat="server" GroupName="Condition" /> Good
                    </label>
                    <label class="audit-card">
                        <i class="fa-solid fa-hand" style="color:#fb9678;"></i><i class="icon-emoji" aria-hidden="true">🤚</i>
                        <asp:RadioButton ID="rbFair" runat="server" GroupName="Condition" /> Fair
                    </label>
                    <label class="audit-card">
                        <i class="fa-solid fa-thumbs-down" style="color:#e53935;"></i><i class="icon-emoji" aria-hidden="true">👎</i>
                        <asp:RadioButton ID="rbPoor" runat="server" GroupName="Condition" /> Poor
                    </label>
                </div>

                <p class="section-label">
                    Remarks
                    <span style="text-transform:none; font-size:10px; color:#b0bec5;">(optional)</span>
                </p>
                <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="3"
                    CssClass="remarks-box"
                    placeholder="Enter any observations or notes about this asset…" />

                <div class="audit-footer">
                    <asp:Button ID="btnSave"  runat="server" Text="Complete Audit" CssClass="btn btn-success"   OnClick="btnSave_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset Form"     CssClass="btn btn-secondary" OnClick="btnReset_Click" />
                </div>
            </div>

        </div>

        <!-- AUDIT HISTORY -->
        <div class="card" style="margin-bottom:40px;">
            <div class="history-title-row">
                <div class="card-title">
                    <i class="fa-solid fa-clock-rotate-left"></i><i class="icon-emoji" aria-hidden="true">🕒</i> Audit History
                </div>
                <asp:Panel ID="pnlReportBtn" runat="server" Visible="false">
                    <button type="button" class="btn-report" onclick="openReportModal()">
                        <i class="fa-solid fa-file-chart-column"></i><i class="icon-emoji" aria-hidden="true">📊</i> Generate Report
                    </button>
                </asp:Panel>
            </div>
            <div class="table-scroll">
                <asp:GridView ID="gvAudit" runat="server"
                    AutoGenerateColumns="False" CssClass="grid-view"
                    EmptyDataText="No audit records found.">
                    <Columns>
                        <asp:BoundField DataField="AuditID"     HeaderText="Audit ID"   />
                        <asp:BoundField DataField="AssetCode"   HeaderText="Asset Code" />
                        <asp:BoundField DataField="AssetName"   HeaderText="Asset Name" />
                        <asp:BoundField DataField="AuditDate"   HeaderText="Audit Date" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge status-<%# Eval("AuditStatus").ToString().Replace(" ","") %>'>
                                    <%# Eval("AuditStatus") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Condition">
                            <ItemTemplate>
                                <span class='status-badge condition-<%# Eval("AuditCondition") %>'>
                                    <%# Eval("AuditCondition") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="AuditorName" HeaderText="Auditor" />
                        <asp:BoundField DataField="Remarks"     HeaderText="Remarks" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div><!-- /.page-content -->

    <!-- HIDDEN FIELDS & SERVER HELPERS -->
    <asp:HiddenField ID="hfAuditorList"  runat="server" />
    <asp:HiddenField ID="hfAuditTime"    runat="server" />
    <asp:HiddenField ID="hfReportResult" runat="server" />

    <asp:Button ID="btnReportPostback" runat="server" OnClick="btnReportPostback_Click"
        Style="position:absolute;left:-9999px;width:1px;height:1px;overflow:hidden;" />

    <!-- REPORT MODAL -->
    <div id="reportOverlay" class="report-overlay">
        <div class="report-modal">
            <div class="report-modal-header">
                <div class="report-modal-title">
                    <i class="fa-solid fa-file-chart-column"></i><i class="icon-emoji" aria-hidden="true">📊</i> Audit Report Generator
                </div>
                <button type="button" class="report-close-btn" onclick="closeReportModal()">
                    <i class="fa-solid fa-xmark"></i><i class="icon-emoji" aria-hidden="true">✖️</i>
                </button>
            </div>

            <div class="admin-badge">
                <i class="fa-solid fa-shield-halved"></i><i class="icon-emoji" aria-hidden="true">🛡️</i>
                Admin Access &mdash; Reports are visible only to administrators.
            </div>

            <div class="report-divider">Select Auditor</div>
            <div class="form-group">
                <label style="margin-bottom:6px;">Auditor Name</label>
                <select id="ddlReportAuditor" class="report-select">
                    <option value="">— Select an auditor —</option>
                </select>
            </div>

            <div class="report-divider">
                Date Range
                <span style="text-transform:none; font-size:10px; color:#b0bec5;">(optional)</span>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px;">
                <div class="form-group">
                    <label>From Date</label>
                    <input type="date" id="rptFromDate" class="report-input" />
                </div>
                <div class="form-group">
                    <label>To Date</label>
                    <input type="date" id="rptToDate" class="report-input" />
                </div>
            </div>

            <div id="reportPreviewWrap" style="display:none;">
                <div class="report-preview-wrap">
                    <div class="report-preview-header">
                        <i class="fa-solid fa-table-list"></i><i class="icon-emoji" aria-hidden="true">📋</i>
                        <span id="reportPreviewTitle">Preview</span>
                    </div>
                    <div class="report-preview-body" id="reportPreviewBody"></div>
                </div>
            </div>

            <div class="report-actions">
                <button type="button" class="btn btn-generate" id="btnGenerateReport" onclick="generateReport()">
                    <i class="fa-solid fa-filter"></i><i class="icon-emoji" aria-hidden="true">🔎</i> Apply Filter
                </button>
                <button type="button" class="btn btn-print" id="btnPrintReport"
                        onclick="printReport()" style="display:none;">
                    <i class="fa-solid fa-print"></i><i class="icon-emoji" aria-hidden="true">🖨️</i> Print / PDF
                </button>
                <button type="button" class="btn btn-download" id="btnDownloadReport"
                        onclick="downloadReportCSV()" style="display:none;">
                    <i class="fa-solid fa-file-arrow-down"></i><i class="icon-emoji" aria-hidden="true">⬇️</i> CSV
                </button>
            </div>
        </div>
    </div>

    <!-- Hidden print section -->
    <div id="printSection" style="display:none;">
        <asp:Panel ID="pnlPrintReport" runat="server"></asp:Panel>
    </div>

    <!-- SCANNER MODAL -->
    <div id="scanOverlay" class="scan-overlay">
        <div class="scan-modal">
            <div class="scan-header">
                <div class="scan-title">
                    <i class="fa-solid fa-barcode"></i><i class="icon-emoji" aria-hidden="true">📷</i> Scan Barcode
                </div>
                <button type="button" class="scan-close" onclick="closeScanModal()">
                    <i class="fa-solid fa-xmark"></i><i class="icon-emoji" aria-hidden="true">✖️</i>
                </button>
            </div>

            <div class="scan-tabs">
                <button type="button" class="scan-tab active" id="tabCamera" onclick="switchTab('camera')">
                    <i class="fa-solid fa-camera"></i><i class="icon-emoji" aria-hidden="true">📷</i> Live Camera
                </button>
                <button type="button" class="scan-tab" id="tabUpload" onclick="switchTab('upload')">
                    <i class="fa-solid fa-image"></i><i class="icon-emoji" aria-hidden="true">🖼️</i> Upload Image
                </button>
            </div>

            <div id="panelCamera">
                <div class="cam-viewport" id="camViewport">
                    <video id="scannerVideo" playsinline muted></video>
                    <div class="cam-window">
                        <div class="c-bl"></div>
                        <div class="c-br"></div>
                    </div>
                    <div class="scan-line"></div>
                </div>
                <select id="cameraSelect" class="cam-select" onchange="switchCamera(this.value)"
                    style="display:none; width:100%; margin-top:10px; padding:9px 12px; border-radius:10px;
                           border:1px solid rgba(0,0,0,0.1); font-size:13px; font-family:'Plus Jakarta Sans',sans-serif;
                           color:var(--primary-dark); background:rgba(255,255,255,0.85); cursor:pointer;"></select>
            </div>

            <div id="panelUpload">
                <div class="upload-drop" id="uploadDrop"
                     ondragover="event.preventDefault();this.classList.add('dragover')"
                     ondragleave="this.classList.remove('dragover')"
                     ondrop="handleDrop(event)">
                    <input type="file" id="fileBarcode" accept="image/*" onchange="handleFileSelect(this)" />
                    <div class="upload-drop-icon"><i class="fa-solid fa-cloud-arrow-up"></i><i class="icon-emoji" aria-hidden="true">☁️</i></div>
                    <p>Drag &amp; drop a barcode image here<br/>or <span>click to browse</span></p>
                </div>
                <div class="upload-preview" id="uploadPreview">
                    <img id="previewImg" src="" alt="preview" />
                    <div class="file-name" id="previewName"></div>
                </div>
                <button type="button" class="btn btn-decode" id="btnDecode"
                        onclick="decodeUploadedImage()" disabled>
                    <i class="fa-solid fa-magnifying-glass"></i><i class="icon-emoji" aria-hidden="true">🔍</i> Decode Barcode
                </button>
            </div>

            <div class="scan-status" id="scanStatus"></div>

            <div class="scan-footer">
                <button type="button" class="btn btn-secondary" onclick="closeScanModal()">
                    <i class="fa-solid fa-xmark"></i><i class="icon-emoji" aria-hidden="true">✖️</i> Cancel
                </button>
                <button type="button" class="btn btn-primary" id="btnTorch"
                        onclick="toggleTorch()" style="display:none;">
                    <i class="fa-solid fa-bolt"></i><i class="icon-emoji" aria-hidden="true">⚡</i> Torch
                </button>
            </div>
        </div>
    </div>

</form>

<!-- FOOTER -->
<footer class="site-footer">
    <p class="f-company">Dayton Natural Resources Pvt. Ltd.</p>
    <p class="f-copy">&copy; 2026 All Infrastructure Records Reserved Securely.</p>
    <p class="f-runtime">Runtime Context: .NET Framework 4.8+ Web Forms Engine &middot; Cryptographic Token Identity Core</p>
</footer>

<script>
    /* ═══════════════════════════════════════════
       HAMBURGER TOGGLE
    ═══════════════════════════════════════════ */
    function toggleDrawer() {
        var d = document.getElementById('navDrawer');
        var i = document.getElementById('navToggleIcon');
        var open = d.classList.toggle('open');
        i.className = open ? 'fa-solid fa-xmark' : 'fa-solid fa-bars';
    }

    /* ═══════════════════════════════════════════
       REPORT MODAL
    ═══════════════════════════════════════════ */
    var _auditorList = [];
    var _lastReportRows = [];
    var _lastReportAuditor = '';
    var _lastReportFrom = '';
    var _lastReportTo = '';

    function initAuditorList() {
        var hf = document.getElementById('<%= hfAuditorList.ClientID %>');
        if (!hf || !hf.value) return;
        try { _auditorList = JSON.parse(hf.value); } catch(e) { _auditorList = []; }
        var sel = document.getElementById('ddlReportAuditor');
        sel.innerHTML = '<option value="">— Select an auditor —</option>';
        for (var i = 0; i < _auditorList.length; i++) {
            var opt = document.createElement('option');
            opt.value = opt.text = _auditorList[i];
            sel.appendChild(opt);
        }
    }

    function openReportModal(preserveFilters) {
        initAuditorList();
        if (!document.getElementById('reportOverlay').classList.contains('active') && !preserveFilters) {
            document.getElementById('reportPreviewWrap').style.display = 'none';
            document.getElementById('btnPrintReport').style.display = 'none';
            document.getElementById('btnDownloadReport').style.display = 'none';
            document.getElementById('ddlReportAuditor').value = '';
            document.getElementById('rptFromDate').value = '';
            document.getElementById('rptToDate').value = '';
            setGenerateBtnState(false);
        }
        document.getElementById('reportOverlay').classList.add('active');
    }

    function closeReportModal() {
        document.getElementById('reportOverlay').classList.remove('active');
    }

    function setGenerateBtnState(loading) {
        var btn = document.getElementById('btnGenerateReport');
        if (loading) {
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i><i class="icon-emoji" aria-hidden="true">⏳</i> Loading\u2026';
        } else {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-filter"></i><i class="icon-emoji" aria-hidden="true">🔎</i> Apply Filter';
        }
    }

    function generateReport() {
        var auditor  = document.getElementById('ddlReportAuditor').value.trim();
        var fromDate = document.getElementById('rptFromDate').value.trim();
        var toDate   = document.getElementById('rptToDate').value.trim();
        if (!auditor) { alert('Please select an auditor to generate the report.'); return; }
        setGenerateBtnState(true);
        document.getElementById('<%= hfAuditTime.ClientID %>').value = 'RPT|' + auditor + '|' + fromDate + '|' + toDate;
        document.getElementById('<%= btnReportPostback.ClientID %>').click();
    }

    function showReportPreview(rows, auditorName, fromDate, toDate) {
        setGenerateBtnState(false);

        _lastReportRows    = rows || [];
        _lastReportAuditor = auditorName;
        _lastReportFrom    = fromDate;
        _lastReportTo      = toDate;

        var wrap  = document.getElementById('reportPreviewWrap');
        var body  = document.getElementById('reportPreviewBody');
        var title = document.getElementById('reportPreviewTitle');

        var label = 'Auditor: ' + auditorName;
        if (fromDate) label += '  |  From: ' + fromDate;
        if (toDate)   label += '  \u2192  ' + toDate;
        title.innerText = label;

        if (!rows || rows.length === 0) {
            body.innerHTML =
                '<div class="report-empty-msg">' +
                '<i class="fa-solid fa-inbox"></i>' +
                '<i class="icon-emoji" aria-hidden="true" style="display:block;font-size:30px;margin-bottom:8px;opacity:.55;">📭</i>' +
                'No audit records found for the selected filters.' +
                '</div>';
            wrap.style.display = 'block';
            document.getElementById('btnPrintReport').style.display   = 'none';
            document.getElementById('btnDownloadReport').style.display = 'none';
            openReportModal(true);
            return;
        }

        var html =
            '<div class="report-row">' +
            '<span class="report-col-head">#</span>' +
            '<span class="report-col-head">Asset</span>' +
            '<span class="report-col-head">Date</span>' +
            '<span class="report-col-head">Status</span>' +
            '<span class="report-col-head">Condition</span>' +
            '<span class="report-col-head">Remarks</span>' +
            '</div>';

        for (var i = 0; i < rows.length; i++) {
            var r = rows[i];
            html +=
                '<div class="report-row">' +
                '<span class="report-num">' + (i + 1) + '</span>' +
                '<span class="report-name">' + escHtml(r.AssetCode) +
                '<br/><span style="font-weight:500;color:#6b7280;font-size:11px;">' + escHtml(r.AssetName) + '</span></span>' +
                '<span class="report-date">' + escHtml(r.AuditDate) + '</span>' +
                '<span><span class="status-badge status-' + r.AuditStatus.replace(/ /g,'') + '">' + escHtml(r.AuditStatus) + '</span></span>' +
                '<span><span class="status-badge condition-' + escHtml(r.AuditCondition) + '">' + escHtml(r.AuditCondition) + '</span></span>' +
                '<span style="color:#6b7280;font-size:12px;">' + escHtml(r.Remarks || '') + '</span>' +
                '</div>';
        }

        body.innerHTML = html;
        wrap.style.display = 'block';
        document.getElementById('btnPrintReport').style.display   = 'inline-flex';
        document.getElementById('btnDownloadReport').style.display = 'inline-flex';
        openReportModal(true);
    }

    function escHtml(s) {
        if (!s) return '';
        return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    function printReport() {
        var ps = document.getElementById('printSection');
        ps.style.display = 'block';
        window.print();
        ps.style.display = 'none';
    }

    /* ═══════════════════════════════════════════
       CSV DOWNLOAD
    ═══════════════════════════════════════════ */
    function downloadReportCSV() {
        if (!_lastReportRows || !_lastReportRows.length) {
            alert('No report data to download. Please generate the report first.');
            return;
        }
        var safeName = _lastReportAuditor.replace(/[^a-zA-Z0-9]/g,'_');
        var fileName = 'Audit_Report_' + safeName +
            (_lastReportFrom ? '_' + _lastReportFrom : '') +
            (_lastReportTo   ? '_to_' + _lastReportTo : '') + '.csv';

        var lines = [['S.No','Asset Code','Asset Name','Audit Date','Status','Condition','Remarks'].map(csvCell).join(',')];
        for (var i = 0; i < _lastReportRows.length; i++) {
            var r = _lastReportRows[i];
            lines.push([i+1, r.AssetCode, r.AssetName, r.AuditDate, r.AuditStatus, r.AuditCondition, r.Remarks||''].map(csvCell).join(','));
        }
        lines.push('');
        lines.push(csvCell('Auditor') + ',' + csvCell(_lastReportAuditor));
        if (_lastReportFrom) lines.push(csvCell('From Date') + ',' + csvCell(_lastReportFrom));
        if (_lastReportTo)   lines.push(csvCell('To Date')   + ',' + csvCell(_lastReportTo));
        lines.push(csvCell('Total Records') + ',' + _lastReportRows.length);
        lines.push(csvCell('Generated On')  + ',' + csvCell(new Date().toLocaleString()));

        var blob = new Blob(['\uFEFF' + lines.join('\r\n')], { type:'text/csv;charset=utf-8;' });
        var url  = URL.createObjectURL(blob);
        var a    = document.createElement('a');
        a.href = url; a.download = fileName;
        document.body.appendChild(a); a.click();
        document.body.removeChild(a); URL.revokeObjectURL(url);
    }

    function csvCell(val) {
        if (val === null || val === undefined) return '';
        var s = String(val);
        if (s.indexOf(',') !== -1 || s.indexOf('"') !== -1 || s.indexOf('\n') !== -1)
            s = '"' + s.replace(/"/g,'""') + '"';
        return s;
    }

    /* ═══════════════════════════════════════════
       BARCODE SCANNER
    ═══════════════════════════════════════════ */
    var codeReader = null;
    var uploadFile = null;
    var activeTab  = 'camera';

    function openScanModal() {
        document.getElementById('scanOverlay').classList.add('active');
        if (activeTab === 'camera') startCamera();
    }
    function closeScanModal() {
        stopCamera();
        document.getElementById('scanOverlay').classList.remove('active');
    }
    function switchTab(tab) {
        activeTab = tab;
        document.getElementById('tabCamera').classList.toggle('active', tab === 'camera');
        document.getElementById('tabUpload').classList.toggle('active', tab === 'upload');
        document.getElementById('panelCamera').style.display = (tab === 'camera') ? 'block' : 'none';
        document.getElementById('panelUpload').style.display = (tab === 'upload') ? 'block' : 'none';
        if (tab === 'camera') startCamera(); else stopCamera();
    }
    function startCamera() {
        stopCamera();
        try {
            codeReader = new ZXing.BrowserMultiFormatReader();
            codeReader.listVideoInputDevices().then(function(devices) {
                if (!devices || !devices.length) { setStatus('No camera found', 'err'); return; }
                codeReader.decodeFromVideoDevice(devices[0].deviceId, 'scannerVideo', function(result) {
                    if (result) {
                        document.getElementById('camViewport').classList.add('flash');
                        setTimeout(function(){ document.getElementById('camViewport').classList.remove('flash'); }, 500);
                        onScanned(result.text);
                    }
                });
            }).catch(function(err){ setStatus('Camera Error: ' + err, 'err'); });
        } catch(ex){ setStatus('ZXing Error: ' + ex.message, 'err'); }
    }
    function stopCamera() {
        if (codeReader) { try { codeReader.reset(); } catch(e){} codeReader = null; }
    }
    function switchCamera(deviceId) {
        stopCamera();
        codeReader = new ZXing.BrowserMultiFormatReader();
        codeReader.decodeFromVideoDevice(deviceId, 'scannerVideo', function(result){
            if (result) onScanned(result.text);
        });
    }
    function toggleTorch() { alert('Torch not supported in this build.'); }
    function handleFileSelect(input) {
        if (!input.files.length) return;
        loadUploadedFile(input.files[0]);
    }
    function handleDrop(e) {
        e.preventDefault();
        document.getElementById('uploadDrop').classList.remove('dragover');
        if (!e.dataTransfer.files.length) return;
        loadUploadedFile(e.dataTransfer.files[0]);
    }
    function loadUploadedFile(file) {
        uploadFile = file;
        var reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('previewImg').src              = e.target.result;
            document.getElementById('previewName').innerHTML       = file.name;
            document.getElementById('uploadPreview').style.display = 'block';
            document.getElementById('btnDecode').disabled          = false;
        };
        reader.readAsDataURL(file);
    }
    function decodeUploadedImage() {
        if (!uploadFile) { setStatus('Select image first', 'err'); return; }
        var img = document.getElementById('previewImg');
        try {
            var reader = new ZXing.BrowserMultiFormatReader();
            reader.decodeFromImageElement(img)
                .then(function(result){ if (result) onScanned(result.text); })
                .catch(function(){ setStatus('Barcode not found in image', 'err'); });
        } catch(ex){ setStatus(ex.message, 'err'); }
    }
    function onScanned(code) {
        setStatus('Scanned: ' + code, 'ok');
        document.getElementById('<%= txtAssetCode.ClientID %>').value = code;
        setTimeout(function(){
            closeScanModal();
            __doPostBack('<%= txtAssetCode.UniqueID %>', '');
        }, 500);
    }
    function setStatus(msg, type) {
        var el = document.getElementById('scanStatus');
        el.innerHTML = msg;
        el.className = 'scan-status' + (type ? ' ' + type : '');
    }

    /* ═══════════════════════════════════════════
       INITIALISATION
    ═══════════════════════════════════════════ */
    document.addEventListener('DOMContentLoaded', function () {

        var todayStr = new Date().toISOString().split('T')[0];
        document.getElementById('rptFromDate').setAttribute('max', todayStr);
        document.getElementById('rptToDate').setAttribute('max', todayStr);

        document.getElementById('scanOverlay').addEventListener('click', function (e) {
            if (e.target === this) closeScanModal();
        });
        document.getElementById('reportOverlay').addEventListener('click', function (e) {
            if (e.target === this) closeReportModal();
        });

        initAuditorList();

        var hfResult = document.getElementById('<%= hfReportResult.ClientID %>');
        if (hfResult && hfResult.value) {
            try {
                var rpt = JSON.parse(hfResult.value);
                if (rpt && rpt.auditor) {
                    initAuditorList();
                    document.getElementById('ddlReportAuditor').value = rpt.auditor || '';
                    document.getElementById('rptFromDate').value = rpt.fromDate || '';
                    document.getElementById('rptToDate').value = rpt.toDate || '';
                    showReportPreview(rpt.rows || [], rpt.auditor, rpt.fromDate || '', rpt.toDate || '');
                }
            } catch (ex) {
                console.error('Report parse error:', ex);
            }
            hfResult.value = '';
        }
    });
</script>

</body>
</html>
