# Smart Asset Management System

A compact ASP.NET Web Forms application to manage organization assets, maintenance, audits, and barcode printing.

## Overview

This project is an on-premises Web Forms app (ASPX + code-behind) that stores asset records in MySQL, supports maintenance scheduling, audit trails, Excel import/export, and barcode printing. It ships with third-party assemblies in `Bin/` and frontend assets under `css/`, `js/`, and `bootstrap/`.

# Smart Asset Management System

![ASP.NET](https://img.shields.io/badge/ASP.NET-Web%20Forms-blue.svg)
![MySQL](https://img.shields.io/badge/MySQL-5.7%20%7C%208.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Prototype-brightgreen.svg)

An on-premises ASP.NET Web Forms application to manage physical assets, maintenance schedules, audits, Excel import/exports, and barcode printing.

Quick highlights:

- Asset registry with detailed views and attachments
- Maintenance scheduling + history per asset
- Audit workflows and reporting
- Barcode generation and bulk printing
- Excel import/export (ClosedXML)

## Table of contents

1. [Quick start](#quick-start)
2. [Features](#features)
3. [Tech stack](#tech-stack)
4. [Configuration](#configuration)
5. [Starter SQL schema](#starter-sql-schema)
6. [Project structure](#project-structure)
7. [Troubleshooting](#troubleshooting)
8. [Contributing](#contributing)
9. [License](#license)

## Quick Start

These steps get the app running locally for development on Windows using Visual Studio.

Prerequisites:

- Windows
- Visual Studio 2017/2019/2022 with ASP.NET workload
- MySQL Server (5.7 or 8.0 recommended)

Steps:

1. Open the project folder in Visual Studio (or open the solution/file if present).
2. Restore NuGet packages (build will auto-restore if configured).
3. Update database connection in `Web.config` (example below).
4. Create the MySQL database and run the starter schema (see below).
5. Ensure `Uploads/` is writable by the IIS app pool identity.
6. Build and run (F5) in Visual Studio.

### Run with IIS Express

Open the project in Visual Studio and press `F5` to run with IIS Express. For full IIS, see the IIS notes below.

## Features

Core features:

- 🔎 Asset management: add, edit, search, and view assets with tags, location, and metadata.
- 🛠 Maintenance: schedule work orders, track history and status per asset.
- 🧾 Audits: perform inventory audits, log discrepancies and resolve items.
- 🖨 Barcode printing: generate printable barcodes and bulk-print asset labels.
- 📥 CSV / Excel import-export: bulk import/export using ClosedXML.
- 📎 Attachments: store images and documents per asset in `Uploads/`.
- 📊 Reporting: export assets and audit reports to Excel/CSV.

Optional/advanced (may require custom setup):

- Role-based access control (if integrated with custom auth)
- Scheduled background tasks (via Windows Scheduler / Windows Service)

## Tech Stack

### Platform & Runtime

- Windows + IIS / IIS Express
- .NET Framework (see project properties for exact target)
- ASP.NET Web Forms (ASPX + C# code-behind)

### Backend & Libraries

- Database: MySQL (MySql.Data)
- Excel: ClosedXML + DocumentFormat.OpenXml
- Barcode/graphics: SkiaSharp, BarcodeLib (bundled DLLs)
- Crypto: BouncyCastle (bundled)
- Compression: K4os.LZ4 (bundled)

### Frontend

- Bootstrap (bundled), jQuery, custom JS/CSS

### Packaging / Dependencies

- NuGet packages referenced in `packages.config`
- Several runtime DLLs pre-bundled in `Bin/` for deployment convenience

If you'd like exact versions for each DLL in `Bin/`, I can generate a `packages.txt` listing.

## Configuration

Add or update the MySQL connection string inside `Web.config` under `<connectionStrings>`.

Example connection snippet (replace placeholders):

```xml
<connectionStrings>
	<add name="MySqlConn"
			 connectionString="Server=localhost;Database=smart_assets;Uid=youruser;Pwd=yourpassword;"
			 providerName="MySql.Data.MySqlClient" />
</connectionStrings>
```

Important:

- Use an account with appropriate privileges for schema creation and CRUD operations.
- Do not commit credentials to source control — keep them in a secure store.



## Project Structure (trimmed)

```
smart-asset-management-system/
├─ App_Code/
│  ├─ BLL/
│  ├─ Connection/
│  └─ DLL/
├─ assets/
│  ├─ Assetsystem.aspx
│  ├─ Assetsystem.aspx.cs
│  ├─ Maintenance.aspx
│  └─ Maintenance.aspx.cs
├─ Bin/
├─ css/
├─ js/
├─ bootstrap/
├─ Scripts/
├─ Uploads/
├─ webfonts/
├─ images/
├─ AssetDetails.aspx
├─ AssetDetails.aspx.cs
├─ home.aspx
├─ LOGINPAGE.aspx
├─ Web.config
└─ packages.config
```

## Running under IIS

- Create a new IIS site or convert the folder to an application under an existing site.
- Set the application pool to the correct .NET CLR version.
- Give the app pool identity write permissions to `Uploads/` if the app stores files.

## Troubleshooting

- Missing assembly errors: verify `Bin/` contains required DLLs or restore packages via NuGet.
- Database connection issues: confirm `Web.config` credentials, server reachability, and that the database/schema exists.
- File upload permissions: ensure NTFS permissions allow the IIS app pool identity to write to `Uploads/`.

If you want, I can run a quick check and produce a `packages.txt` listing the DLLs present in `Bin/`.

## Contributing

Contributions are welcome.

Suggested workflow:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-change`)
3. Commit and push
4. Open a Pull Request with a clear description and repro steps

Please include Visual Studio version and .NET target when submitting issues or PRs.

## License

This repository currently uses the MIT badge. Add a `LICENSE` file to the repository to declare the license formally — tell me which license you'd like and I can add it.

---

If you'd like, I can also:

- Add a concrete `schema.sql` file to the repo with full tables (Audits, Users, Attachments, Maintenance history).
- Add a `LICENSE` file (MIT/Apache-2.0/GPL).
- Generate `packages.txt` listing `Bin/` assemblies and versions.

Tell me which of those you'd like me to add and I'll create the files.
- MySql.Data.dll
- ClosedXML.dll
- DocumentFormat.OpenXml.dll
- SkiaSharp.dll
- BouncyCastle.Cryptography.dll
- Google.Protobuf.dll

If you want, I can enumerate all assemblies currently in `Bin/` or create a `packages.txt` listing.

## Quick Start

1. Open the project folder in Visual Studio (open the solution if present).
2. Restore NuGet packages (build will auto-restore packages if configured).
3. Update the connection string in `Web.config` (example below).
4. Create the MySQL database and apply the starter schema (example below).
5. Ensure `Uploads/` is writable by the app (IIS app pool identity).
6. Build and run the project (F5) in Visual Studio.

`

## Running in IIS (short notes)

- Create an IIS site or application pointing to the project folder.
- Set the application pool to use the correct .NET CLR version and identity.
- Ensure `Uploads/` has appropriate write permissions for the app pool identity.

## Troubleshooting

- Missing DLL errors: verify the assemblies in `Bin/` or restore NuGet packages.
- Database errors: confirm `Web.config` connection string and that MySQL accepts remote/local connections.
- File permission errors: check NTFS ACLs for `Uploads/` and any log locations.

## Project Layout (important items)

- `App_Code/` — application libraries (BLL, connection helpers).
- `assets/`, `Assetsystem.aspx`, `AssetDetails.aspx` — asset-management pages.
- `Bin/` — shipped third-party assemblies.
- `Uploads/` — attachments and imports.
- `Web.config` — application configuration and connection strings.

## Development Tips

- Use the Package Manager Console for package updates: `Update-Package`.
- Inspect and set the target .NET Framework via Project Properties in Visual Studio.
- Preserve the third-party DLLs in `Bin/` if the project was deployed without NuGet package references.

## Contribution & License

Contributions welcome. Please open issues for bugs or feature requests and submit pull requests for fixes. Add a `LICENSE` file to indicate terms; common choices: MIT, Apache-2.0.

## Next Steps I can help with

- Add an example `Web.config` with named placeholders and comments.
- Create a more complete SQL schema (maintenance, audits, users) as `.sql` file.
- Add a `LICENSE` file (tell me which license to use).

If you'd like any of the above, tell me which one to add and I'll create the file.

