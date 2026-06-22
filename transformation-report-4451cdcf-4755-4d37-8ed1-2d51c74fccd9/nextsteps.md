# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps focus on validating correctness and preparing for deployment.

---

## 1. Restore and Build Verification

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build --configuration Release
```

Ensure there are no warnings that may indicate deprecated APIs or compatibility issues that could surface at runtime.

---

## 2. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify business logic and data access behavior remain intact:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

- Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework implementation and the new cross-platform .NET runtime.
- Pay particular attention to tests covering `Bookstore.Data`, as data access layers (e.g., Entity Framework) often require configuration changes during migration.

---

## 3. Validate Runtime Behavior

### 3a. Database Connectivity

- Confirm that the connection strings in `appsettings.json` (or equivalent configuration) are correct for the target environment.
- If Entity Framework Core was introduced during transformation, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 3b. Application Startup

Run the web application locally and confirm it starts without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise core functionality such as browsing, searching, and any data entry forms.
- Check the console output and application logs for any runtime errors or unhandled exceptions.

---

## 4. Review Configuration Changes

- Confirm that `Web.config` settings (if any existed in the legacy project) have been properly migrated to `appsettings.json` or `appsettings.{Environment}.json`.
- Verify that any custom HTTP handlers, modules, or `Global.asax` logic has been correctly ported to ASP.NET Core middleware or startup configuration in `Program.cs` / `Startup.cs`.

---

## 5. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently or be unavailable on non-Windows platforms. Review the following areas:

- **File paths**: Ensure `Path.Combine` is used instead of hardcoded backslashes.
- **Registry access**: Any use of `Microsoft.Win32.Registry` will not function on Linux or macOS.
- **Windows Authentication**: If used, confirm it is supported in the target deployment environment.

You can use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 6. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all expected assets, static files, and configuration files are present.
- Verify that the correct runtime identifier (RID) is targeted if deploying to a specific OS, for example:

```bash
dotnet publish -r linux-x64 --self-contained false
```