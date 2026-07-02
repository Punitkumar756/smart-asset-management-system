<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Assetsystem.aspx.cs"
    Inherits="Assetsystem" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Office Assets</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
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

    * { margin:0; padding:0; box-sizing:border-box; font-family:'Plus Jakarta Sans',sans-serif; }

    html, body {
        height: 100%;
        margin: 0;
    }

    body {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        background:
            linear-gradient(135deg,rgba(244,243,240,0.88),rgba(234,233,241,0.92)),
            url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1920&q=80');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        padding: 0;
    }

    .page-wrapper {
        flex: 1;
    }

    .main-container,
    .grid-section {
        padding-left: 20px;
        padding-right: 20px;
    }

    /* ── TOP BAR ── */
    .role-badge {
        background: #fff; padding: 7px 16px; border-radius: 20px;
        border: 1px solid #e2e8f0; font-weight: 700; font-size: 13px;
        color: var(--primary-dark); box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }

    /* ── HERO GRID ── */
    .main-container {
        max-width: 1200px; margin: 0 auto 32px;
        display: grid; grid-template-columns: 1.1fr 0.9fr;
        gap: 36px; align-items: start; padding: 0 20px;
    }
    .info-panel { position: sticky; top: 36px; }
    .hero-box {
        background: var(--bg-glass); border: 1px solid var(--border-glass);
        padding: 32px; border-radius: var(--radius-lg); backdrop-filter: blur(24px);
    }
    .hero-box h1 { font-size: 32px; color: var(--primary-dark); font-weight: 800; line-height: 1.2; }
    .hero-box h1 span { color: var(--accent-blue); }
    .hero-box p { margin-top: 12px; color: var(--text-muted); font-size: 14px; line-height: 1.7; }
    .hero-stats { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; margin-top: 24px; }
    .stat-chip {
        background: rgba(93,135,255,0.08); border: 1px solid rgba(93,135,255,0.18);
        border-radius: 12px; padding: 12px; text-align: center;
    }
    .stat-chip .num { font-size: 22px; font-weight: 800; color: var(--accent-blue); }
    .stat-chip .lbl { font-size: 11px; color: var(--text-muted); font-weight: 600; margin-top: 2px; }

    /* ── FILTER CARD ── */
    .card {
        background: var(--bg-glass); border: 1px solid var(--border-glass);
        border-radius: var(--radius-lg); padding: 26px; backdrop-filter: blur(24px);
        box-shadow: 0 16px 40px rgba(0,0,0,0.05);
    }
    .card-title { font-size: 15px; font-weight: 700; color: var(--primary-dark); margin-bottom: 18px; display: flex; align-items: center; gap: 8px; }
    .card-title i { color: var(--accent-blue); font-size: 16px; }
    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

    label { font-size: 12px; font-weight: 600; color: var(--primary-dark); margin-bottom: 6px; display: block; letter-spacing: 0.01em; }

    .input-control {
        width: 100%; height: 42px; padding: 8px 12px;
        border-radius: var(--radius-md); border: 1px solid rgba(0,0,0,0.1);
        font-size: 13px; font-family: 'Plus Jakarta Sans',sans-serif;
        background: rgba(255,255,255,0.75); color: var(--primary-dark);
        transition: border-color .2s, box-shadow .2s;
    }
    .input-control:focus {
        outline: none; border-color: var(--accent-blue);
        box-shadow: 0 0 0 3px rgba(93,135,255,0.15); background: #fff;
    }
    .input-control:disabled { opacity: 0.65; cursor: not-allowed; background: rgba(241,245,249,0.8); }
    .input-control.autofilled {
        background: rgba(93,135,255,0.07) !important;
        border-color: rgba(93,135,255,0.35) !important;
        color: var(--primary-dark) !important; font-weight: 700 !important;
    }

    .autofill-notice {
        display: flex; align-items: center; gap: 7px;
        background: rgba(16,185,129,0.1); border: 1px solid rgba(16,185,129,0.25);
        color: #065f46; border-radius: 8px;
        padding: 8px 14px; font-size: 12px; font-weight: 600; margin-bottom: 14px;
    }

    .btn-primary {
        margin-top: 18px; width: 100%; padding: 12px; border: none;
        border-radius: 25px; background: var(--accent-blue); color: white;
        font-size: 14px; font-weight: 700; cursor: pointer;
        font-family: 'Plus Jakarta Sans',sans-serif;
        transition: background .2s, transform .1s;
        display: flex; align-items: center; justify-content: center; gap: 7px;
    }
    .btn-primary:hover  { background: #4b76ed; }
    .btn-primary:active { transform: scale(0.98); }

    .btn-report {
        margin-top: 10px; width: 100%; padding: 11px;
        border: 2px solid var(--accent-blue); border-radius: 25px;
        background: transparent; color: var(--accent-blue);
        font-size: 14px; font-weight: 700; cursor: pointer;
        font-family: 'Plus Jakarta Sans',sans-serif;
        transition: background .2s, color .2s, transform .1s;
        display: flex; align-items: center; justify-content: center; gap: 7px;
    }
    .btn-report:hover  { background: var(--accent-blue); color: #fff; }
    .btn-report:active { transform: scale(0.98); }

    /* ── GRID SECTION ── */
    .grid-section { width: 95%; max-width: 1700px; margin: 0 auto 32px; }
    .grid-card {
        background: var(--bg-glass); border: 1px solid var(--border-glass);
        border-radius: var(--radius-lg); padding: 26px; backdrop-filter: blur(24px);
        box-shadow: 0 16px 40px rgba(0,0,0,0.05); overflow-x: auto; width: 100%;
    }
    .grid-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
    .grid-title  { font-size: 16px; font-weight: 800; color: var(--primary-dark); }
    .grid-actions { display: flex; align-items: center; gap: 10px; }

    .add-asset-btn {
        display: inline-flex; align-items: center; gap: 7px;
        padding: 9px 20px; background: var(--accent-blue); color: #fff;
        border: none; border-radius: 20px; font-size: 13px; font-weight: 700;
        font-family: 'Plus Jakarta Sans',sans-serif; cursor: pointer; transition: background .2s, transform .1s;
    }
    .add-asset-btn:hover  { background: #4b76ed; }
    .add-asset-btn:active { transform: scale(0.97); }

    /* ── GRIDVIEW TABLE ── */
    .grid-view { width: 100%; border-collapse: collapse; table-layout: auto; }
    .grid-view th {
        background: rgba(15,23,42,0.04); padding: 10px 8px;
        font-size: 12px; font-weight: 700; color: var(--primary-dark);
        text-align: left; border-bottom: 1px solid rgba(0,0,0,0.07); white-space: normal;
    }
    .grid-view td {
        padding: 10px 8px; font-size: 12px; color: var(--text-muted);
        border-bottom: 1px solid rgba(0,0,0,0.05); word-break: break-word; white-space: normal;
    }
    .grid-view tr:last-child td { border-bottom: none; }
    .grid-view tr:hover td     { background: rgba(93,135,255,0.04); }
    .grid-view th.col-center,
    .grid-view td.col-center   { text-align: center; }

    /* ── STATUS & SECTOR BADGES ── */
    .status-badge, .sector-badge {
        display: inline-block; padding: 3px 10px; border-radius: 20px;
        font-size: 11px; font-weight: 600; white-space: nowrap;
    }
    .status-badge.active   { background: #dcfce7; color: #166534; }
    .status-badge.inactive { background: #fee2e2; color: #991b1b; }
    .sector-badge.govt     { background: #e0f2fe; color: #075985; }
    .sector-badge.pvt      { background: #fef9c3; color: #854d0e; }

    /* ── ASSET THUMBNAIL ── */
    .no-img-box {
        width: 42px; height: 42px; border-radius: 8px; background: #f1f5f9;
        border: 1px dashed #cbd5e1; display: flex; align-items: center; justify-content: center; margin: auto;
    }
    .no-img-box i { font-size: 14px; color: #94a3b8; }

    /* ── ACTION ICONS ── */
    .edit-icon         { color: #2563eb; font-size: 15px; cursor: pointer; transition: .2s; }
    .edit-icon:hover   { color: #1d4ed8; transform: scale(1.2); }
    .delete-icon       { color: #dc2626; font-size: 15px; cursor: pointer; transition: .2s; }
    .delete-icon:hover { color: #b91c1c; transform: scale(1.2); }
    .save-icon         { color: #16a34a; font-size: 15px; }
    .cancel-icon       { color: #ea580c; font-size: 15px; }
    .maint-icon        { color: #d97706; font-size: 15px; cursor: pointer; transition: .2s; }
    .maint-icon:hover  { color: #b45309; transform: scale(1.2); }

    /* ── INSERT MODAL ── */
    .modal-overlay {
        display: none; position: fixed; inset: 0;
        background: rgba(10,15,30,0.5); backdrop-filter: blur(4px);
        z-index: 9999; align-items: center; justify-content: center; padding: 20px;
    }
    .modal-overlay.open { display: flex; }
    .modal-box {
        background: #fff; border-radius: var(--radius-lg); padding: 28px 30px;
        width: 720px; max-width: 100%; max-height: 90vh; overflow-y: auto;
        box-shadow: 0 32px 80px rgba(0,0,0,0.18); animation: modalIn .22s ease;
    }
    @keyframes modalIn {
        from { opacity: 0; transform: translateY(18px) scale(0.97); }
        to   { opacity: 1; transform: translateY(0) scale(1); }
    }
    .modal-box::-webkit-scrollbar       { width: 5px; }
    .modal-box::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 4px; }
    .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px; }
    .modal-title  { font-size: 18px; font-weight: 800; color: var(--primary-dark); }
    .modal-sub    { font-size: 12px; color: var(--text-muted); margin-bottom: 6px; }
    .modal-close {
        background: rgba(0,0,0,0.05); border: none; width: 32px; height: 32px;
        border-radius: 50%; font-size: 18px; cursor: pointer; color: var(--text-muted);
        display: flex; align-items: center; justify-content: center;
        transition: background .2s; font-family: 'Plus Jakarta Sans',sans-serif;
    }
    .modal-close:hover { background: rgba(0,0,0,0.1); }
    .section-label {
        font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em;
        color: #94a3b8; margin: 20px 0 12px; padding-bottom: 8px; border-bottom: 1px solid #f1f5f9;
    }
    .modal-grid-3 { display: grid; grid-template-columns: repeat(3,1fr); gap: 13px; }
    .modal-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 13px; }
    .modal-grid-4 { display: grid; grid-template-columns: repeat(4,1fr); gap: 13px; align-items: start; }
    textarea.input-control { height: 76px; resize: vertical; padding-top: 10px; }
    .readonly-field { background: #f1f5f9 !important; cursor: not-allowed; color: #64748b !important; }
    .sector-wrapper { display: flex; gap: 16px; align-items: center; height: 42px; }
    #rblSector label {
        display: inline-flex; align-items: center; gap: 5px;
        font-size: 13px; font-weight: 500; color: var(--primary-dark);
        cursor: pointer; white-space: nowrap; margin: 0;
    }
    #rblSector input[type="radio"] { accent-color: var(--accent-blue); width: 15px; height: 15px; cursor: pointer; }
    .modal-submit {
        margin-top: 22px; width: 100%; padding: 13px; border: none; border-radius: 25px;
        background: var(--accent-blue); color: #fff; font-size: 15px; font-weight: 700;
        font-family: 'Plus Jakarta Sans',sans-serif; cursor: pointer; transition: background .2s, transform .1s;
    }
    .modal-submit:hover  { background: #4b76ed; }
    .modal-submit:active { transform: scale(0.98); }
    .modal-context { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; margin: 10px 0 4px; }
    .modal-context .ctx-label { font-size: 13px; color: var(--text-muted); }
    .ctx-badge {
        display: none; align-items: center; gap: 5px;
        background: #eef0fe; color: #3b4fb8; font-size: 12px; font-weight: 600;
        padding: 4px 12px; border-radius: 999px;
    }
    .ctx-badge i { font-size: 11px; }

    /* ── IMAGE PREVIEW MODAL ── */
    .img-overlay {
        display: none; position: fixed; inset: 0;
        background: rgba(0,0,0,0.78); z-index: 99999;
        align-items: center; justify-content: center; padding: 20px;
    }
.peripheral-chip {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 7px 14px; border-radius: 20px; font-size: 12px; font-weight: 600;
    border: 1.5px solid rgba(93,135,255,0.3); background: rgba(93,135,255,0.05);
    color: var(--primary-dark); cursor: pointer; transition: all 0.15s;
}
.peripheral-chip:hover { border-color: var(--accent-blue); background: rgba(93,135,255,0.1); }
.peripheral-chip input[type="checkbox"] { accent-color: var(--accent-blue); width:14px; height:14px; }
.peripheral-chip:has(input:checked) { background: var(--accent-blue); color:#fff; border-color: var(--accent-blue); }
    .img-overlay.open { display: flex; }
    .img-modal-box {
        background: #fff; border-radius: 16px; padding: 16px;
        max-width: 500px; width: 90%; text-align: center;
    }
    .img-modal-box img { width: 100%; max-height: 380px; object-fit: contain; border-radius: 10px; }
    .img-close-btn {
        margin-top: 12px; padding: 8px 24px; border: none; border-radius: 20px;
        background: var(--accent-blue); color: #fff; font-size: 13px; font-weight: 600; cursor: pointer;
    }

    /* ── OFFICE CHIPS ── */
    .office-chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 2px; }
    .office-chip {
        padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;
        font-family: 'Plus Jakarta Sans',sans-serif; cursor: pointer;
        border: 2px solid rgba(93,135,255,0.3); background: rgba(93,135,255,0.06); color: var(--primary-dark);
        transition: all 0.18s ease;
    }
    .office-chip:hover { border-color: var(--accent-blue); background: rgba(93,135,255,0.12); }
    .office-chip.active {
        background: var(--accent-blue); color: #fff; border-color: var(--accent-blue);
        box-shadow: 0 4px 12px rgba(93,135,255,0.35);
    }

    /* ── NAVBAR ── */
    .audit-navbar {
        position: sticky;
        top: 0;
        z-index: 500;
        width: 100%;
        background: rgba(255,255,255,.72);
        backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(255,255,255,.55);
        box-shadow: 0 2px 16px rgba(0,0,0,.06);
        margin-bottom: 25px;
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
    .nav-brand { display: flex; align-items: center; gap: 10px; }
    .navbar-back-btn {
        background: rgba(255,255,255,.85);
        border: 1px solid #e2e8f0;
        border-radius: 50%;
        width: 36px; height: 36px;
        cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        color: #4b5563;
    }
    .nav-logo { height: 42px; width: auto; }
    .nav-brand-name { font-size: 14px; font-weight: 700; color: var(--primary-dark); }
    .nav-brand-sub  { font-size: 10px; color: var(--text-muted); }
    .nav-links { display: flex; align-items: center; gap: 4px; list-style: none; flex: 1; justify-content: center; }
    .nav-links a {
        display: block; padding: 7px 14px; border-radius: 20px;
        text-decoration: none; font-size: 13px; font-weight: 600; color: var(--text-muted);
    }
    .nav-links a:hover  { background: rgba(93,135,255,.1); color: var(--accent-blue); }
    .nav-links a.active { background: rgba(93,135,255,.12); color: var(--accent-blue); }
    .nav-right { display: flex; align-items: center; gap: 8px; }
    .btn-logout {
        background: var(--primary-dark); color: #fff; text-decoration: none;
        padding: 7px 16px; border-radius: 20px; font-size: 12px; font-weight: 700;
        display: flex; align-items: center; gap: 6px;
    }
    .nav-toggle { display: none; }
    .nav-drawer { display: none; }
    .nav-drawer.open { display: flex; flex-direction: column; background: #fff; padding: 15px; }

    .grid-view th:first-child,
    .grid-view td:first-child {
        width: 60px; min-width: 60px; max-width: 60px; text-align: center;
    }

    /* ════════════════════════════════════════
       REPORT MODAL
       ════════════════════════════════════════ */
    .report-overlay {
        display: none; position: fixed; inset: 0;
        background: rgba(10,15,30,0.55); backdrop-filter: blur(4px);
        z-index: 9998; align-items: flex-start; justify-content: center;
        padding: 32px 20px; overflow-y: auto;
    }
    .report-overlay.open { display: flex; }
    .report-box {
        background: #fff; border-radius: var(--radius-lg);
        width: 100%; max-width: 1100px;
        box-shadow: 0 32px 80px rgba(0,0,0,0.18);
        animation: modalIn .22s ease; overflow: hidden;
    }
    .report-topbar {
        background: var(--primary-dark); padding: 18px 28px;
        display: flex; align-items: center; justify-content: space-between; gap: 12px;
    }
    .report-topbar-left { display: flex; align-items: center; gap: 12px; }
    .report-topbar-left i { color: var(--accent-blue); font-size: 20px; }
    .report-topbar h2 { font-size: 17px; font-weight: 800; color: #fff; margin: 0; }
    .report-topbar p  { font-size: 12px; color: #94a3b8; margin: 2px 0 0; }
    .report-close-btn {
        background: rgba(255,255,255,0.1); border: none;
        width: 34px; height: 34px; border-radius: 50%; color: #fff; font-size: 18px;
        cursor: pointer; display: flex; align-items: center; justify-content: center;
        transition: background .2s; font-family: 'Plus Jakarta Sans',sans-serif; flex-shrink: 0;
    }
    .report-close-btn:hover { background: rgba(255,255,255,0.2); }
    .report-filter-bar {
        background: #f8fafc; border-bottom: 1px solid #e2e8f0;
        padding: 18px 28px; display: flex; align-items: flex-end; gap: 16px; flex-wrap: wrap;
    }
    .report-filter-bar .field-wrap { display: flex; flex-direction: column; gap: 5px; min-width: 180px; }
    .report-filter-bar label {
        font-size: 11px; font-weight: 700; color: #64748b;
        letter-spacing: 0.05em; text-transform: uppercase; margin: 0;
    }
    .report-filter-bar .input-control { background: #fff; height: 38px; font-size: 13px; }
    .btn-apply-filter {
        height: 38px; padding: 0 22px; border: none; border-radius: 20px;
        background: var(--accent-blue); color: #fff; font-size: 13px; font-weight: 700;
        font-family: 'Plus Jakarta Sans',sans-serif; cursor: pointer; transition: background .2s;
        white-space: nowrap; align-self: flex-end;
    }
    .btn-apply-filter:hover { background: #4b76ed; }
    .btn-download-excel {
        height: 38px; padding: 0 22px; border: none; border-radius: 20px;
        background: #16a34a; color: #fff; font-size: 13px; font-weight: 700;
        font-family: 'Plus Jakarta Sans',sans-serif; cursor: pointer; transition: background .2s;
        display: inline-flex; align-items: center; gap: 7px; white-space: nowrap; align-self: flex-end;
    }
    .btn-download-excel:hover { background: #15803d; }
    .report-summary {
        display: flex; gap: 12px; padding: 16px 28px;
        border-bottom: 1px solid #e2e8f0; flex-wrap: wrap;
    }
    .summary-chip {
        background: rgba(93,135,255,0.07); border: 1px solid rgba(93,135,255,0.18);
        border-radius: 12px; padding: 10px 18px; text-align: center; min-width: 110px;
    }
    .summary-chip .s-num { font-size: 20px; font-weight: 800; color: var(--accent-blue); }
    .summary-chip .s-lbl { font-size: 11px; color: var(--text-muted); font-weight: 600; margin-top: 2px; }
    .report-table-area { padding: 20px 28px 28px; overflow-x: auto; }
    .report-empty { text-align: center; padding: 48px 20px; color: #94a3b8; font-size: 14px; }
    .report-empty i { font-size: 36px; display: block; margin-bottom: 10px; color: #cbd5e1; }
    .report-table-area .grid-view { min-width: 900px; }
    .report-table-area .grid-view th { font-size: 11px; }
    .report-table-area .grid-view td { font-size: 12px; }

    /* ── FOOTER ── */
    footer {
        flex-shrink: 0;
        margin-top: auto;
    }

    /* ── RESPONSIVE ── */
     @media (max-width: 1020px) {
     .nav-links, .nav-right { display: none; }
     .nav-toggle {
         display: flex; background: #fff; border: 1px solid #e2e8f0;
         border-radius: 10px; width: 58px; height: 38px;
         align-items: center; justify-content: center; cursor: pointer;
     }
     .nav-inner { height: auto; padding: 12px 16px; }
     .nav-brand-name { display: none; }
     .nav-drawer .nav-links { display: flex; flex-direction: column; align-items: flex-start; }
     .nav-drawer .nav-links a { width: 100%; }
 }
 @media (min-width: 1400px) {
     .main-container { max-width: 1600px; grid-template-columns: 1.2fr 0.8fr; gap: 60px; }
     .grid-section   { max-width: 1600px; }
     .hero-box h1    { font-size: 38px; }
     .stat-chip .num { font-size: 24px; }
 }
    @media (max-width: 1024px) {
        body { padding: 20px 24px; }
        .main-container { grid-template-columns: 1fr; gap: 20px; padding: 0; max-width: 100%; }
        .info-panel { position: static; }
        .hero-box { padding: 24px; }
        .hero-box h1 { font-size: 28px; }
        .hero-box p  { font-size: 13px; }
        .hero-stats     { gap: 10px; }
        .stat-chip .num { font-size: 18px; }
        .stat-chip .lbl { font-size: 10px; }
        .card { padding: 20px; }
        .form-grid { grid-template-columns: 1fr 1fr; gap: 12px; }
        .grid-section { width: 100%; }
        .grid-card { padding: 18px; }
        .grid-view th, .grid-view td { font-size: 11px; padding: 8px 6px; }
        .modal-box { width: 90%; padding: 22px; }
        .modal-grid-3 { grid-template-columns: 1fr 1fr; }
        .modal-grid-4 { grid-template-columns: 1fr 1fr; }
    }
    @media (max-width: 768px) {
        body { padding: 14px 16px; }
        .main-container { grid-template-columns: 1fr; gap: 16px; padding: 0; }
        .hero-box { padding: 20px; }
        .hero-box h1 { font-size: 24px; line-height: 1.3; }
        .hero-box p  { font-size: 13px; margin-top: 8px; }
        .hero-stats { gap: 8px; margin-top: 16px; }
        .stat-chip  { padding: 10px 6px; }
        .stat-chip .num { font-size: 16px; }
        .stat-chip .lbl { font-size: 10px; }
        .card { padding: 16px; }
        .card-title { font-size: 14px; }
        .form-grid  { grid-template-columns: 1fr; gap: 10px; }
        .input-control { font-size: 13px; height: 40px; }
        .btn-primary { padding: 11px; font-size: 13px; margin-top: 12px; }
        .grid-section { width: 100%; padding: 0; }
        .grid-card { padding: 12px; border-radius: 14px; }
        .grid-header { flex-direction: column; align-items: flex-start; gap: 10px; }
        .grid-title  { font-size: 14px; }
        .grid-actions { width: 100%; flex-wrap: wrap; }
        .add-asset-btn { padding: 8px 14px; font-size: 12px; }
        .grid-view { min-width: 650px; }
        .grid-view th, .grid-view td { font-size: 11px; padding: 7px 5px; }
        .modal-box { width: 98%; padding: 18px; max-height: 88vh; }
        .modal-title { font-size: 16px; }
        .modal-grid-3 { grid-template-columns: 1fr; }
        .modal-grid-2 { grid-template-columns: 1fr; }
        .modal-grid-4 { grid-template-columns: 1fr 1fr; }
        .modal-submit { font-size: 14px; padding: 12px; }
        .role-badge { font-size: 12px; padding: 6px 12px; }
        .report-filter-bar { padding: 14px 16px; }
        .report-table-area { padding: 14px 16px; }
        .report-topbar { padding: 14px 16px; }
        .report-summary { padding: 12px 16px; }
    }
    @media (max-width: 480px) {
        body { padding: 10px 12px; }
        .hero-box h1 { font-size: 20px; }
        .hero-box p  { font-size: 12px; }
        .hero-stats { gap: 6px; }
        .stat-chip  { padding: 8px 4px; border-radius: 10px; }
        .stat-chip .num { font-size: 14px; }
        .stat-chip .lbl { font-size: 9px; }
        .card { padding: 14px; border-radius: 14px; }
        .form-grid { grid-template-columns: 1fr; }
        .input-control { height: 38px; font-size: 12px; }
        .btn-primary { font-size: 13px; padding: 10px; margin-top: 12px; }
        .grid-card { padding: 10px; border-radius: 12px; }
        .grid-view { min-width: 580px; }
        .grid-view th, .grid-view td { font-size: 10px; padding: 6px 4px; }
        .add-asset-btn { padding: 7px 12px; font-size: 11px; }
        .modal-box { padding: 14px; }
        .modal-grid-4 { grid-template-columns: 1fr; }
        .section-label { font-size: 9px; margin: 14px 0 8px; }
    }
    .add-asset-btn:disabled {
    opacity: .5;
    cursor: not-allowed;
}
    </style>
</head>
<body>
<form id="form1" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

    <!-- ══════════════════════════════════════
         PAGE WRAPPER — pushes footer to bottom
         ══════════════════════════════════════ -->
    <div class="page-wrapper">

    <!-- ── NAVBAR ── -->
    <nav class="audit-navbar">
        <div class="nav-inner">

            <div class="nav-brand">
                <button type="button"
                        class="navbar-back-btn"
                        onclick="history.back()"
                        title="Go Back">
                    <i class="fa-solid fa-arrow-left"></i>
                </button>

                <img src="https://daytonnaturalresources.com/wp-content/uploads/2024/01/Dayton-Logo-2-1.png"
                     alt="Dayton Logo"
                     class="nav-logo" />

                <div>
                    <div class="nav-brand-name">Dayton Natural Resources</div>
                    <div class="nav-brand-sub">PVT. LTD.</div>
                </div>
            </div>

            <ul class="nav-links">
                <li><a href="<%= ResolveUrl("~/home.aspx") %>">Home</a></li>
                <li><a href="<%= ResolveUrl("~/home.aspx") %>">Company Profile</a></li>
                <li><a href="<%= ResolveUrl("~/Assetsystem.aspx") %>" class="active">Assets</a></li>
                <li><a href="<%= ResolveUrl("~/AuditAsset.aspx") %>">Asset Audit</a></li>
                <li><a href="<%= ResolveUrl("~/home.aspx") %>">Contact</a></li>
            </ul>

            <div class="nav-right">
                <div class="role-badge">
                    <i class="fa-solid fa-circle-user"></i>
                    <asp:Label ID="lblRole" runat="server"></asp:Label>
                </div>
                <a href="<%= ResolveUrl("~/loginpage.aspx") %>" class="btn-logout">
                    Logout
                </a>
            </div>

            <button type="button" class="nav-toggle" onclick="toggleDrawer()">
                <i class="fa-solid fa-bars" id="navToggleIcon"></i>
            </button>

        </div>

        <div class="nav-drawer" id="navDrawer">
            <ul class="nav-links">
                <li><a href="<%= ResolveUrl("~/home1V1.aspx") %>">Home</a></li>
                <li><a href="<%= ResolveUrl("~/Assetsystem.aspx") %>">Assets</a></li>
                <li><a href="<%= ResolveUrl("~/AuditAsset.aspx") %>">Asset Audit</a></li>
            </ul>
            <div class="nav-right" style="display:flex;flex-wrap:wrap;gap:8px;padding-top:10px;border-top:1px solid rgba(0,0,0,.06);">
                <div class="role-badge">
                    <i class="fa-solid fa-circle-user"></i>
                    <asp:Label ID="lblRoleMobile" runat="server"></asp:Label>
                </div>
                <a href="LOGINPAGE.aspx" class="btn-logout" style="width:100%;justify-content:center;">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- ── HERO + FILTER ── -->
    <div class="main-container">

        <div class="info-panel">
            <div class="hero-box">
                <h1>Office <span>Asset</span> System</h1>
                <p>Unified tracking system for Office, Group classification and asset mapping. Manage IT, Furniture and Electronics &mdash; all in one dashboard.</p>
                <div class="hero-stats">
                    <asp:Literal ID="litHeroStats" runat="server"></asp:Literal>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-title">
                <i class="fa-solid fa-filter"></i> Filter Assets
            </div>

            <asp:Panel ID="pnlAutofillNotice" runat="server" Visible="false">
                <div class="autofill-notice">
                    <i class="fa-solid fa-circle-check" style="color:#10b981;"></i>
                    Office pre-filled based on your assignment
                </div>
            </asp:Panel>

            <div class="form-grid">
                <div>
                    <label>Office</label>
                    <asp:DropDownList ID="ddlOffice" runat="server" CssClass="input-control"  onchange="toggleAddAssetButton();">
                    </asp:DropDownList>
                    <asp:Literal ID="litOfficeChips" runat="server"></asp:Literal>
                </div>
                <div>
                    <label>Category</label>
                    <asp:DropDownList ID="ddlGroup" runat="server" CssClass="input-control" onchange="toggleAddAssetButton();">
                        <asp:ListItem Text="Select Category" Value=""            />
                        <asp:ListItem Text="IT"              Value="IT"          />
                        <asp:ListItem Text="Furniture"       Value="Furniture"   />
                        <asp:ListItem Text="Electronics"     Value="Electronics" />
                    </asp:DropDownList>
                </div>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Fetch Assets"
                CssClass="btn-primary" OnClick="btnSubmit_Click" />

            <button type="button" class="btn-report" onclick="openReportModal()">
                <i class="fa-solid fa-chart-bar"></i> View Report
            </button>
        </div>
    </div>

    <!-- ── ASSET GRID ── -->
    <div class="grid-section">
        <div class="grid-card">
            <div class="grid-header">
                <div class="grid-title">
                    <i class="fa-solid fa-table-list" style="color:var(--accent-blue);margin-right:8px;"></i>
                    Asset Details
                </div>
                <div class="grid-actions">
                  <button type="button" id="btnAddAsset"
        class="add-asset-btn"
        onclick="validateAndOpenModal()">
    <i class="fa-solid fa-plus"></i> Add Asset
</button>  
                </div>
            </div>

            <asp:GridView ID="gvAssets" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="ITID"
                CssClass="grid-view"
                OnRowEditing="gvAssets_RowEditing"
                OnRowCancelingEdit="gvAssets_RowCancelingEdit"
                OnRowUpdating="gvAssets_RowUpdating"
                OnRowDeleting="gvAssets_RowDeleting"
                OnRowDataBound="gvAssets_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="ITID" HeaderText="ID" Visible="false" ReadOnly="true" ItemStyle-Width="40px" />

                    <asp:TemplateField HeaderText="SR No.">
                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="ItemName"      HeaderText="Item Name"   ItemStyle-Width="120px" />
                    <asp:BoundField DataField="Brand"         HeaderText="Brand"       ItemStyle-Width="80px"  />
                    <asp:BoundField DataField="Capacity"      HeaderText="Capacity"    ItemStyle-Width="75px"  />
                    <asp:BoundField DataField="SerialNumber"  HeaderText="Serial No"   ItemStyle-Width="90px"  />
                    <asp:BoundField DataField="Quantity"      HeaderText="Qty"         ItemStyle-Width="45px"  />
                    <asp:BoundField DataField="WorkingQty"    HeaderText="Working"     ItemStyle-Width="60px"  />
                    <asp:BoundField DataField="NonWorkingQty" HeaderText="Non-Working" ItemStyle-Width="80px"  />

                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="75px">
                        <ItemTemplate>
                            <span class='<%# Eval("Status").ToString().ToLower()=="active" ? "status-badge active" : "status-badge inactive" %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="input-control" style="height:32px;font-size:12px;">
                                <asp:ListItem Text="Active"   Value="Active"   />
                                <asp:ListItem Text="Inactive" Value="Inactive" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Sector" ItemStyle-Width="75px">
                        <ItemTemplate>
                            <span class='<%# Eval("Sector").ToString()=="Government" ? "sector-badge govt" : "sector-badge pvt" %>'>
                                <%# Eval("Sector").ToString()=="Government" ? "Govt" : "Pvt" %>
                            </span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditSector" runat="server" CssClass="input-control" style="height:32px;font-size:12px;">
                                <asp:ListItem Text="Government" Value="Government" />
                                <asp:ListItem Text="Private"    Value="Private"    />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Department"   HeaderText="Department"  ItemStyle-Width="100px" />
<asp:BoundField DataField="Description"  HeaderText="Description" ItemStyle-Width="120px" />
<asp:BoundField DataField="Remark"       HeaderText="Remark"      ItemStyle-Width="110px" />
<asp:BoundField DataField="InsertedBy"   HeaderText="Inserted By"
    ReadOnly="true" ItemStyle-Width="90px" />
<asp:BoundField DataField="InsertedDate" HeaderText="Date Added"
    ReadOnly="true" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Width="100px" />
                    
		    <asp:BoundField DataField="Peripherals" HeaderText="Peripherals" ItemStyle-Width="130px" />
		    <asp:BoundField
		         DataField="AssetCode"
		         HeaderText="Asset Code"
			 ReadOnly="true" />

                     <asp:TemplateField HeaderText="Image">
    <ItemTemplate>
        <div class="no-img-box"
             style="cursor:pointer;"
             onclick='<%# Eval("ImagePath").ToString().ToLower().EndsWith(".pdf")
                ? "window.open(\"" + ResolveUrl(Eval("ImagePath").ToString()) + "\",\"_blank\")"
                : "openImageModal(\"" + ResolveUrl(Eval("ImagePath").ToString()) + "\")" %>'>

            <i class='<%# Eval("ImagePath").ToString().ToLower().EndsWith(".pdf")
                ? "fa-solid fa-file-pdf"
                : "fa-regular fa-image" %>'></i>

        </div>
    </ItemTemplate>
</asp:TemplateField>

                    <asp:TemplateField HeaderText="Maintenance" ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="col-center">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkMaintenance" runat="server" CausesValidation="false" ToolTip="Log Maintenance"
                                OnClientClick="openMaintenanceModal(this); return false;">
                                <i class="fa-solid fa-screwdriver-wrench maint-icon"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Edit" ItemStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="col-center">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" ToolTip="Edit">
                                <i class="fa-solid fa-pen-to-square edit-icon"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" ToolTip="Save">
                                <i class="fa-solid fa-check save-icon"></i>
                            </asp:LinkButton>
                            &nbsp;
                            <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel" ToolTip="Cancel">
                                <i class="fa-solid fa-xmark cancel-icon"></i>
                            </asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Delete" ItemStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="col-center">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CausesValidation="false" ToolTip="Delete"
                                OnClientClick="return confirm('Are you sure you want to delete this asset?');">
                                <i class="fa-solid fa-trash delete-icon"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- ── INSERT ASSET MODAL ── -->
    <div class="modal-overlay" id="modalOverlay" onclick="handleOverlayClick(event)">
        <div class="modal-box" id="modalBox">
            <div class="modal-header">
                <span class="modal-title">
                    <i class="fa-solid fa-box-open" style="color:var(--accent-blue);margin-right:8px;font-size:16px;"></i>
                    Add New Asset
                </span>
                <button type="button" class="modal-close" onclick="closeModal()" aria-label="Close">&times;</button>
            </div>
            <p class="modal-sub">Fill in all the details below and click <strong>Insert Item</strong> to save.</p>

            <div class="modal-context">
                <span class="ctx-label">Adding to:</span>
                <span class="ctx-badge" id="modalOfficeBadge">
                    <i class="fa-solid fa-building"></i>
                    <span id="modalOfficeText"></span>
                </span>
                <span class="ctx-badge" id="modalGroupBadge">
                    <i class="fa-solid fa-folder"></i>
                    <span id="modalGroupText"></span>
                </span>
            </div>

            <p class="section-label">Item Details</p>
            <div class="modal-grid-3">
                <div>
                    <label>Item Name</label>
                    <asp:TextBox ID="txtItemName" runat="server" CssClass="input-control" placeholder="e.g. Laptop"></asp:TextBox>
                </div>
                <div>
                    <label>Brand</label>
                    <asp:TextBox ID="txtBrand" runat="server" CssClass="input-control" placeholder="e.g. Dell"></asp:TextBox>
                </div>
                <div>
                    <label>Capacity</label>
                    <asp:TextBox ID="txtCapacity" runat="server" CssClass="input-control" placeholder="e.g. 512GB"></asp:TextBox>
                </div>
                <div>
                    <label>Serial Number</label>
                    <asp:TextBox ID="txtSerialNumber" runat="server" CssClass="input-control" placeholder="SN-XXXXXXXX"></asp:TextBox>
			<span id="serialErrorMsg" style="color:#ef4444; font-size:13px; display:none;">
    			This serial number already exists.
			</span>
                </div>
                <div>
                    <label>Type</label>
                    <asp:TextBox ID="txtType" runat="server" CssClass="input-control" placeholder="e.g. Chair"></asp:TextBox>
                </div>
                <div>
                    <label>Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="input-control">
                        <asp:ListItem Text="Select Status" Value=""         />
                        <asp:ListItem Text="Active"        Value="Active"   />
                        <asp:ListItem Text="Inactive"      Value="Inactive" />
                    </asp:DropDownList>
                </div>
            </div>
            <p class="section-label">Department</p>
<div class="modal-grid-3">
    <div>
        <label>Department</label>
        <asp:TextBox ID="txtDepartment" runat="server" CssClass="input-control" placeholder="e.g. HR, IT, Admin"></asp:TextBox>
    </div>
</div>
<p class="section-label">PC Peripherals / Accessories <span style="font-size:10px;font-weight:400;color:#94a3b8;">(optional)</span></p>
<div id="peripheralsGroup" style="display:flex;flex-wrap:wrap;gap:10px;margin-bottom:4px;">
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="CPU" /> CPU</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Mouse" /> Mouse</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Keyboard" /> Keyboard</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Headphone" /> Headphone</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Monitor" /> Monitor</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Webcam" /> Webcam</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="UPS" /> UPS</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Printer" /> Printer</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Scanner" /> Scanner</label>
    <label class="peripheral-chip"><input type="checkbox" name="peripherals" value="Pen Drive" /> Pen Drive</label>
</div>
            <p class="section-label">Description &amp; Remark</p>
            <div class="modal-grid-2">
                <div>
                    <label>Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="input-control" TextMode="MultiLine" Rows="3" placeholder="Brief description…"></asp:TextBox>
                </div>
                <div>
                    <label>Remark</label>
                    <asp:TextBox ID="txtRemark" runat="server" CssClass="input-control" TextMode="MultiLine" Rows="3" placeholder="Any additional notes…"></asp:TextBox>
                </div>
            </div>

            <p class="section-label">Quantity &amp; Condition</p>
            <div class="modal-grid-4">
                <div>
                    <label>Total Quantity</label>
                    <asp:TextBox ID="txtQty" runat="server" CssClass="input-control" placeholder="0" onkeyup="calculateNonWorking()"></asp:TextBox>
                </div>
                <div>
                    <label>Working</label>
                    <asp:TextBox ID="txtWorking" runat="server" CssClass="input-control" placeholder="0" onkeyup="calculateNonWorking()"></asp:TextBox>
                </div>
                <div>
                    <label>Non Working</label>
                    <asp:TextBox ID="txtNonWorking" runat="server" CssClass="input-control readonly-field" ReadOnly="true" placeholder="0"></asp:TextBox>
                </div>
                <div>
                    <label>Sector</label>
                    <div class="sector-wrapper">
                        <asp:RadioButtonList ID="rblSector" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" style="display:flex;gap:14px;">
                            <asp:ListItem Text="Govt"    Value="Government"></asp:ListItem>
                            <asp:ListItem Text="Private" Value="Private"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
            </div>

            <div class="upload-box">
                <asp:FileUpload
                    ID="fuAssetImage"
                    runat="server"
                    accept=".jpg,.jpeg,.png,.gif,.bmp,.webp,.pdf"
                    CssClass="file-upload-hidden"
                    onchange="showFileName(this)" />
                <label for="<%= fuAssetImage.ClientID %>" class="upload-label">
                    <i class="fa-solid fa-cloud-arrow-up"></i>
                    <span id="fileText">Choose Asset Image</span>
                </label>
            </div>

            <asp:Button ID="btnInsert" runat="server" Text="Insert Item" CssClass="modal-submit" OnClick="btnInsert_Click" />
        </div>
    </div>

    <!-- ── REPORT MODAL ── -->
    <div class="report-overlay" id="reportOverlay">
        <div class="report-box">

            <div class="report-topbar">
                <div class="report-topbar-left">
                    <i class="fa-solid fa-chart-bar"></i>
                    <div>
                        <h2>Asset Report</h2>
                        <p id="reportSubtitle">Select office and category, then click Apply Filter</p>
                    </div>
                </div>
                <button type="button" class="report-close-btn" onclick="closeReportModal()" title="Close">&times;</button>
            </div>

            <div class="report-filter-bar">
                <div class="field-wrap">
                    <label>Office</label>
                    <asp:DropDownList ID="ddlReportOffice" runat="server" CssClass="input-control">
                        <asp:ListItem Text="All Offices" Value="0" Selected="True" />
                    </asp:DropDownList>
                </div>
                <div class="field-wrap">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlReportGroup" runat="server" CssClass="input-control">
                        <asp:ListItem Text="All Categories" Value=""            Selected="True" />
                        <asp:ListItem Text="IT"             Value="IT"          />
                        <asp:ListItem Text="Furniture"      Value="Furniture"   />
                        <asp:ListItem Text="Electronics"    Value="Electronics" />
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnApplyFilter" runat="server"
                    Text="Apply Filter"
                    CssClass="btn-apply-filter"
                    OnClick="btnApplyFilter_Click" />
                <asp:Button ID="btnDownloadExcel" runat="server"
                    Text="&#x2B07; Download Excel"
                    CssClass="btn-download-excel"
                    OnClick="btnDownloadExcel_Click" />
            </div>

            <div class="report-summary" id="reportSummary" style="display:none;">
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblTotalItems"   runat="server">0</asp:Label></div>
                    <div class="s-lbl">Total Items</div>
                </div>
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblTotalQty"     runat="server">0</asp:Label></div>
                    <div class="s-lbl">Total Qty</div>
                </div>
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblTotalWorking" runat="server">0</asp:Label></div>
                    <div class="s-lbl">Working</div>
                </div>
                <div class="summary-chip">
                    <div class="s-num"><asp:Label ID="lblTotalNonWork" runat="server">0</asp:Label></div>
                    <div class="s-lbl">Non-Working</div>
                </div>
            </div>

            <div class="report-table-area">
                <asp:Panel ID="pnlReportEmpty" runat="server" Visible="true">
                    <div class="report-empty">
                        <i class="fa-solid fa-filter"></i>
                        Select an office (or keep <strong>All Offices</strong>) and a category, then click <strong>Apply Filter</strong> to view the report.
                    </div>
                </asp:Panel>

                <asp:GridView ID="gvReport" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="grid-view"
                    Visible="false">
                    <Columns>
		    <asp:TemplateField HeaderText="SR No."> <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate> </asp:TemplateField>
                        <asp:BoundField DataField="ITID"          HeaderText="ID"          ItemStyle-Width="45px"  />
                        <asp:BoundField DataField="ItemName"      HeaderText="Item Name"   ItemStyle-Width="130px" />
                        <asp:BoundField DataField="Brand"         HeaderText="Brand"       ItemStyle-Width="90px"  />
                        <asp:BoundField DataField="Capacity"      HeaderText="Capacity"    ItemStyle-Width="80px"  />
                        <asp:BoundField DataField="SerialNumber"  HeaderText="Serial No"   ItemStyle-Width="100px" />
                        <asp:BoundField DataField="Quantity"      HeaderText="Qty"         ItemStyle-Width="50px"  />
                        <asp:BoundField DataField="WorkingQty"    HeaderText="Working"     ItemStyle-Width="65px"  />
                        <asp:BoundField DataField="NonWorkingQty" HeaderText="Non-Working" ItemStyle-Width="85px"  />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="75px">
                            <ItemTemplate>
                                <span class='<%# Eval("Status").ToString().ToLower()=="active" ? "status-badge active" : "status-badge inactive" %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sector" ItemStyle-Width="75px">
                            <ItemTemplate>
                                <span class='<%# Eval("Sector").ToString()=="Government" ? "sector-badge govt" : "sector-badge pvt" %>'>
                                    <%# Eval("Sector").ToString()=="Government" ? "Govt" : "Pvt" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
			<asp:BoundField DataField="Department" HeaderText="Department" />
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="130px" />
                        <asp:BoundField DataField="Remark"      HeaderText="Remark"      ItemStyle-Width="120px" />
                        <asp:BoundField DataField="InsertedBy" HeaderText="Inserted By" ItemStyle-Width="90px" />
                        <asp:BoundField DataField="InsertedDate" HeaderText="Date Added" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Width="100px" />
			<asp:BoundField DataField="Peripherals" HeaderText="Peripherals" ItemStyle-Width="130px" />
                        <asp:TemplateField HeaderText="Image">

    <ItemTemplate>

        <asp:Image ID="imgAsset"
            runat="server"
            Width="70"
            Height="70"
            ImageUrl='<%# Eval("ImagePath") %>' />

    </ItemTemplate>

    <EditItemTemplate>

        <asp:Image ID="imgPreview"
            runat="server"
            Width="70"
            Height="70"
            ImageUrl='<%# Eval("ImagePath") %>' />

        <br />

        <asp:FileUpload
            ID="fuImage"
            runat="server" />

    </EditItemTemplate>

</asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>

    <!-- ── IMAGE PREVIEW MODAL ── -->
    <div class="img-overlay" id="imgOverlay" onclick="closeImageModal()">
        <div class="img-modal-box" onclick="event.stopPropagation()">
            <img id="imgModalPreview" src="" alt="Asset Image" />
            <br />
            <button type="button" class="img-close-btn" onclick="closeImageModal()">Close</button>
        </div>
    </div>

    <%-- Server injects JS to reopen report modal after Apply Filter / Download postback --%>
    <asp:Literal ID="litReopenModal" runat="server"></asp:Literal>

    </div><%-- END .page-wrapper --%>

</form>

<!-- ── FOOTER ── -->
<footer>
    <div style="background:#eff6ff;border-top:2px solid #3b82f6;padding:12px 25px;text-align:center;font-family:'Plus Jakarta Sans',Arial,sans-serif;">
        <p style="font-size:14px;font-weight:600;color:#1d4ed8;margin:0 0 4px;">Dayton Natural Resources Pvt. Ltd.</p>
        <p style="font-size:11px;color:#64748b;margin:0 0 10px;">&copy; 2026 All Infrastructure Records Reserved Securely.</p>
        <p style="font-size:10px;color:#94a3b8;font-family:monospace;margin:0;">Runtime Context: .NET Framework 4.8+ Web Forms Engine &middot; Cryptographic Token Identity Core</p>
    </div>
</footer>

<script type="text/javascript">
    function validateAndOpenModal() {

        var office =
            document.getElementById('<%= ddlOffice.ClientID %>').value;

    var group =
            document.getElementById('<%= ddlGroup.ClientID %>').value;

        if (office == "0" || office == "") {

            Swal.fire({
                icon: 'warning',
                title: 'Office Required',
                text: 'Please select an Office first.'
            });

            return;
        }

        if (group == "") {

            Swal.fire({
                icon: 'warning',
                title: 'Category Required',
                text: 'Please select a Category first.'
            });

            return;
        }

        openModal();
    }
    /* ── Add Asset Modal ── */
    function openModal() {
        var officeSelect = document.getElementById('<%= ddlOffice.ClientID %>');
        var groupSelect  = document.getElementById('<%= ddlGroup.ClientID %>');
        var officeText   = officeSelect.options[officeSelect.selectedIndex].text;
        var groupText    = groupSelect.options[groupSelect.selectedIndex].text;
        var officeBadge  = document.getElementById('modalOfficeBadge');
        var groupBadge   = document.getElementById('modalGroupBadge');

        if (officeSelect.value !== '0' && officeSelect.value !== '') {
            document.getElementById('modalOfficeText').innerText = officeText;
            officeBadge.style.display = 'inline-flex';
        } else { officeBadge.style.display = 'none'; }

        if (groupSelect.value !== '') {
            document.getElementById('modalGroupText').innerText = groupText;
            groupBadge.style.display = 'inline-flex';
        } else { groupBadge.style.display = 'none'; }

        document.getElementById('modalOverlay').classList.add('open');
        document.body.style.overflow = 'hidden';
    }
    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
        document.body.style.overflow = '';
    }
    function handleOverlayClick(e) {
        if (e.target === document.getElementById('modalOverlay')) closeModal();
    }

    /* ── Report Modal ── */
    function openReportModal() {
        var officeVal = document.getElementById('<%= ddlOffice.ClientID %>').value;
        var groupVal  = document.getElementById('<%= ddlGroup.ClientID %>').value;
        if (!groupVal) groupVal = '';

        var rOffice = document.getElementById('<%= ddlReportOffice.ClientID %>');
        var rGroup  = document.getElementById('<%= ddlReportGroup.ClientID %>');

        if (rOffice) rOffice.value = (officeVal && officeVal !== '0') ? officeVal : '0';
        if (rGroup)  rGroup.value  = groupVal;

        document.getElementById('reportOverlay').classList.add('open');
        document.body.style.overflow = 'hidden';
    }
    function closeReportModal() {
        document.getElementById('reportOverlay').classList.remove('open');
        document.body.style.overflow = '';
    }

    /* ── Image Preview Modal ── */
    function openImageModal(src) {
        document.getElementById('imgModalPreview').src = src;
        document.getElementById('imgOverlay').classList.add('open');
    }
    function closeImageModal() {
        document.getElementById('imgOverlay').classList.remove('open');
    }

    /* ── Global keyboard close ── */
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') { closeModal(); closeReportModal(); closeImageModal(); }
    });

    /* ── Click-outside to close report modal ── */
    document.getElementById('reportOverlay').addEventListener('click', function (e) {
        if (e.target === this) closeReportModal();
    });
   


    /* ── Non-Working auto-calc ── */
    function calculateNonWorking() {
        var qty     = parseInt(document.getElementById('<%= txtQty.ClientID %>').value)     || 0;
        var working = parseInt(document.getElementById('<%= txtWorking.ClientID %>').value) || 0;
        var nw = qty - working;
        document.getElementById('<%= txtNonWorking.ClientID %>').value = nw < 0 ? 0 : nw;
    }

    /* ── Maintenance redirect ── */
    function openMaintenanceModal(btn) {
        var row = btn.closest('tr');
        var assetId = row.getAttribute('data-itid');
        var group = document.getElementById('<%= ddlGroup.ClientID %>').value;
        if (!assetId) { alert('Could not find Asset ID. Please fetch assets first.'); return; }
        if (!group) { alert('Please select a group first.'); return; }
        window.location.href = 'Maintenance.aspx?AssetID=' + assetId + '&Group=' + group;
    }

    /* ── Office chip selector ── */
    function selectOfficeChip(btn, officeId) {
        document.querySelectorAll('.office-chip').forEach(function (c) { c.classList.remove('active'); });
        btn.classList.add('active');
        var ddl = document.getElementById('<%= ddlOffice.ClientID %>');
        for (var i = 0; i < ddl.options.length; i++) {
            if (ddl.options[i].value === officeId) { ddl.selectedIndex = i; break; }
        }
    }

    /* ── Mobile nav drawer ── */
    function toggleDrawer() {
        var drawer = document.getElementById("navDrawer");
        var icon = document.getElementById("navToggleIcon");
        drawer.classList.toggle("open");
        icon.className = drawer.classList.contains("open") ? "fa-solid fa-xmark" : "fa-solid fa-bars";
    }
    

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
        document.body.style.overflow = '';
        document.querySelectorAll('#peripheralsGroup input[type="checkbox"]').forEach(function (cb) { cb.checked = false; });
    }

document.addEventListener('DOMContentLoaded', function () {
    var serialInput = document.getElementById('<%= txtSerialNumber.ClientID %>');
    var errorSpan = document.getElementById('serialErrorMsg');
    if (!serialInput || !errorSpan) return;

    serialInput.addEventListener('blur', function () {
        checkSerialNumber();
    });

    function checkSerialNumber() {
        var serial = serialInput.value.trim();

    if (serial === '') {
        errorSpan.style.display = 'none';
    serialInput.style.borderColor = '';
    return;
        }

        var officeDropdown = document.getElementById('<%= ddlOffice.ClientID %>');
        var groupDropdown = document.getElementById('<%= ddlGroup.ClientID %>');

    var officeId = officeDropdown ? officeDropdown.value : '0';
    var group = groupDropdown ? groupDropdown.value : '';

    if (!officeId || officeId === '0' || !group) {
        errorSpan.style.display = 'none';
    serialInput.style.borderColor = '';
    return;
        }

    PageMethods.CheckSerialExists(serial, group, parseInt(officeId, 10),
    function (result) {
                if (result === 'EXISTS') {
        errorSpan.style.display = 'inline';
    serialInput.style.borderColor = '#ef4444';
                } else {
        errorSpan.style.display = 'none';
    serialInput.style.borderColor = '';
                }
            },
    function (error) {
        console.error('Serial check failed:', error);
            }
    );
    }
});
</script>
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</body>
</html>
