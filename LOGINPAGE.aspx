<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LOGINPAGE.aspx.cs" Inherits="LOGINPAGE" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dayton Natural Resources .PVT .LTD</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            min-height: 100vh;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #f1f5f9;
            padding: 16px;
        }

        /* ── WRAPPER ── */
        .portal-wrapper {
            background: #ffffff;
            box-shadow: 0 30px 70px rgba(15, 23, 42, 0.15);
            width: 100%;
            max-width: 1100px;
            border-radius: 20px;
            overflow: hidden;
            animation: paneEntrance 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes paneEntrance {
            from { opacity: 0; transform: scale(0.98) translateY(10px); }
            to   { opacity: 1; transform: scale(1)    translateY(0);    }
        }

        /* ── TWO-COLUMN GRID ── */
        .executive-grid {
            display: flex;
            flex-direction: row;
            width: 100%;
            min-height: 560px;
        }

        /* ── LEFT / SLIDESHOW ── */
        .slideshow-sidebar {
            width: 46%;
            position: relative;
            overflow: hidden;
            background: #0f172a;
            flex-shrink: 0;
        }

        .slide-track { width: 100%; height: 100%; position: relative; }

        .slide-item {
            position: absolute; inset: 0;
            opacity: 0; transform: scale(1.12); filter: brightness(0.7);
            background-size: cover; background-position: center;
            animation: dynamicSlideshow 15s infinite ease-in-out;
        }
        .slide-item:nth-child(1) {
            background-image: url('https://images.unsplash.com/photo-1497215728101-856f4ea42174?auto=format&fit=crop&w=800&q=80');
            animation-delay: 0s;
        }
        .slide-item:nth-child(2) {
            background-image: url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80');
            animation-delay: 5s;
        }
        .slide-item:nth-child(3) {
            background-image: url('https://images.unsplash.com/photo-1606857521015-7f9fcf423740?auto=format&fit=crop&w=800&q=80');
            animation-delay: 10s;
        }

        @keyframes dynamicSlideshow {
            0%  { opacity: 0; transform: scale(1.12); }
            10% { opacity: 1; }
            33% { opacity: 1; transform: scale(1.03); }
            43% { opacity: 0; transform: scale(1); }
            100%{ opacity: 0; }
        }

        .slide-overlay-content {
            position: absolute; inset: 0; z-index: 5;
            padding: 36px;
            display: flex; flex-direction: column; justify-content: space-between;
            background: linear-gradient(to bottom, rgba(15,23,42,0.2) 0%, rgba(15,23,42,0.82) 100%);
            color: #ffffff;
        }

        .brand-unit { display: flex; align-items: center; gap: 12px; }

        .company-logo {
            width: 52px; height: 52px; object-fit: contain; padding: 6px;
            background: rgba(255,255,255,0.12); backdrop-filter: blur(10px);
            border-radius: 10px; border: 1px solid rgba(255,255,255,0.2);
        }

        .brand-headline { font-size: 14px; font-weight: 700; letter-spacing: -0.2px; }
        .brand-headline span { opacity: 0.75; display: block; font-size: 11px; font-weight: 400; }

        .slide-overlay-content h1 { font-size: 26px; line-height: 1.35; font-weight: 800; letter-spacing: -0.5px; }
        .slide-overlay-content p  { font-size: 12.5px; opacity: 0.82; line-height: 1.65; margin-top: 8px; }

        /* Mobile brand bar (only visible on small screens) */
        .mobile-brand-bar {
            display: none;
            align-items: center;
            gap: 10px;
            padding: 16px 20px;
            border-bottom: 1px solid #e2e8f0;
            background: #0f172a;
        }
        .mobile-brand-bar .company-logo { width: 40px; height: 40px; }
        .mobile-brand-bar .brand-headline { font-size: 13px; color: #fff; }
        .mobile-brand-bar .brand-headline span { font-size: 10px; }

        /* ── RIGHT / FORM PANEL ── */
        .interaction-panel {
            flex: 1;
            padding: 36px 44px;
            display: flex; flex-direction: column; justify-content: center;
            background: #ffffff;
            overflow-y: auto;
        }

        .interaction-panel h2 { font-size: 22px; font-weight: 700; color: #0f172a; letter-spacing: -0.4px; }
        .interaction-panel > p  { color: #64748b; font-size: 13px; margin-top: 3px; margin-bottom: 20px; }

        .input-group { margin-bottom: 13px; }
        .input-group label {
            display: block; font-size: 10.5px; color: #475569;
            font-weight: 600; margin-bottom: 5px;
            text-transform: uppercase; letter-spacing: 0.4px;
        }

        .control-input {
            width: 100%; padding: 10px 14px;
            background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;
            color: #0f172a; font-size: 13px; font-weight: 500;
            outline: none; transition: all 0.2s ease;
        }
        .control-input option { background: #ffffff; color: #0f172a; }
        .control-input:focus {
            border-color: #0f172a; background: #ffffff;
            box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.06);
        }

        .captcha-slab {
            background: #f8fafc; border: 1px solid #e2e8f0;
            padding: 12px; border-radius: 10px; margin-bottom: 16px;
        }
        .captcha-slab label {
            font-size: 10.5px; color: #475569; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.4px;
        }
        .captcha-flex-row { display: flex; gap: 10px; align-items: center; margin-top: 6px; }
        .captcha-render-box {
            flex: 1; background: #ffffff; color: #0f172a;
            padding: 8px; text-align: center; font-size: 20px; font-weight: 700;
            letter-spacing: 8px; border-radius: 6px; user-select: none;
            border: 1px solid #e2e8f0;
        }
        .refresh-action {
            padding: 9px 14px; background: #ffffff;
            border: 1px solid #cbd5e1; color: #475569;
            border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600;
            transition: all 0.15s;
        }
        .refresh-action:hover { background: #f1f5f9; color: #0f172a; }

        .submit-action-btn {
            width: 100%; padding: 12px; background: #0f172a;
            border: none; border-radius: 8px; color: #ffffff;
            font-size: 14px; font-weight: 600; cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.12);
        }
        .submit-action-btn:hover {
            background: #1e293b; transform: translateY(-0.5px);
            box-shadow: 0 6px 16px rgba(15, 23, 42, 0.16);
        }

        .alert-label {
            display: block; margin-top: 10px;
            text-align: center; font-size: 12px; font-weight: 600;
        }

        /* ══════════════════════════════
           RESPONSIVE BREAKPOINTS
        ══════════════════════════════ */

        /* Tablet: 769px – 1024px */
        @media screen and (max-width: 1024px) {
            .portal-wrapper { max-width: 860px; }
            .interaction-panel { padding: 28px 32px; }
            .slide-overlay-content h1 { font-size: 22px; }
        }

        /* Mobile: ≤ 768px — hide sidebar, show brand bar at top */
        @media screen and (max-width: 768px) {
            body { padding: 12px; align-items: flex-start; padding-top: 24px; }

            .portal-wrapper {
                border-radius: 16px;
                min-height: unset;
            }

            .executive-grid { flex-direction: column; min-height: unset; }

            .slideshow-sidebar { display: none; }

            .mobile-brand-bar { display: flex; }

            .interaction-panel {
                width: 100%;
                padding: 24px 20px 28px;
                justify-content: flex-start;
            }

            .interaction-panel h2 { font-size: 20px; }
            .interaction-panel > p  { font-size: 12px; margin-bottom: 16px; }

            .captcha-render-box { font-size: 17px; letter-spacing: 6px; }
        }

        /* Small phones: ≤ 400px */
        @media screen and (max-width: 400px) {
            body { padding: 8px; padding-top: 16px; }
            .interaction-panel { padding: 20px 16px 24px; }
            .submit-action-btn { font-size: 13px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" style="width:100%; display:flex; justify-content:center; align-items:flex-start;">
        <asp:HiddenField ID="hdnServerCaptcha" runat="server" />

        <div class="portal-wrapper">
            <div class="executive-grid">

                <!-- Mobile brand bar (only on small screens) -->
                <div class="mobile-brand-bar">
                    <img src="1.png" alt="DNR Logo" class="company-logo" />
                    <div class="brand-headline">
                        DNR
                        <span>Dayton Natural Resources Pvt. Ltd.</span>
                    </div>
                </div>

                <!-- LEFT: Slideshow (hidden on mobile) -->
                <div class="slideshow-sidebar">
                    <div class="slide-track">
                        <div class="slide-item"></div>
                        <div class="slide-item"></div>
                        <div class="slide-item"></div>
                    </div>
                    <div class="slide-overlay-content">
                        <div class="brand-unit">
                            <img src="1.png" alt="DNR Logo" class="company-logo" />
                            <div class="brand-headline">
                                DNR
                                <span>Dayton Natural Resources Pvt. Ltd.</span>
                            </div>
                        </div>
                        <div>
                            <h1>Intelligent Asset<br>Management System</h1>
                            <p>Streamlined dynamic framework crafted to monitor global server deployments, lifecycle tracking, and instant clearance checks.</p>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: Login Form -->
                <div class="interaction-panel">
                    <h2>Welcome Back</h2>
                    <p>Enter organizational clearance credentials.</p>

                    <div class="input-group">
                        <label>Organizational Assignment</label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="control-input">
                            <asp:ListItem Text="-- Select System Privilege --" Value="" />
                            <asp:ListItem Text="Admin" Value="Admin" />
                            <asp:ListItem Text="IT Team" Value="IT team" />
                        </asp:DropDownList>
                    </div>

                    <div class="input-group">
                        <label>User Name</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="control-input" placeholder="Your username identifier" autocomplete="off"></asp:TextBox>
                    </div>

                    <div class="input-group">
                        <label>Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="control-input" TextMode="Password" placeholder="Your account password"></asp:TextBox>
                    </div>

                    <div class="captcha-slab">
                        <label>Anti-Bot Assertion</label>
                        <div class="captcha-flex-row">
                            <div class="captcha-render-box" id="lblCaptcha">XXXXXX</div>
                            <button type="button" class="refresh-action" onclick="generateCaptcha()">Refresh</button>
                        </div>
                        <div class="input-group" style="margin-top:10px; margin-bottom:0;">
                            <asp:TextBox ID="txtCaptchaInput" runat="server" CssClass="control-input" placeholder="Type characters shown above" autocomplete="off"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="SIGN IN TO ENVIRONMENT" CssClass="submit-action-btn" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblMessage" runat="server" CssClass="alert-label"></asp:Label>
                </div>

            </div>
        </div>
    </form>

    <script>
        function generateCaptcha() {
            const chars = "ABCDEFGHJKLMNOPQRSTUVWXYZabcdefghkmnpqrstuvwxyz23456789";
            let text = "";
            for (let i = 0; i < 6; i++) {
                text += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            document.getElementById("lblCaptcha").innerText = text;
            document.getElementById("<%= hdnServerCaptcha.ClientID %>").value = text;
            document.getElementById("<%= txtCaptchaInput.ClientID %>").value = "";
        }
        window.onload = function () { generateCaptcha(); };
    </script>
</body>
</html>