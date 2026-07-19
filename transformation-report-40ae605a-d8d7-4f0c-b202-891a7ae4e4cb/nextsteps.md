# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build output reports zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework Core), verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target database.
- **Migrations** are up to date. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually verify that core application features function as expected, including:

- Page rendering
- Database read and write operations
- Any authentication or authorization flows

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following:

- `Web.config` transformations or settings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.{Environment}.json`.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately on the target machine (e.g., `Development`, `Staging`, or `Production`).

---

## 7. Check for Platform-Specific API Usage

Even without build errors, runtime exceptions can occur if the code uses APIs that behave differently across platforms. Review the codebase for:

- File path construction — use `Path.Combine` rather than hardcoded separators.
- Registry access (`Microsoft.Win32.Registry`) — not available on Linux or macOS.
- Windows-specific authentication mechanisms.

Run the .NET Upgrade Assistant compatibility analyzer if a more thorough scan is needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze Bookstore.Web
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target hosting environment (e.g., IIS, Kestrel behind a reverse proxy, or a Linux server).

---

## 9. Configure the Hosting Environment

- **IIS (Windows):** Ensure the ASP.NET Core Hosting Bundle is installed and the application pool is set to **No Managed Code**.
- **Linux/macOS:** Configure a reverse proxy (e.g., Nginx or Apache) to forward requests to the Kestrel server, and set up a process manager (e.g., systemd) to keep the application running.