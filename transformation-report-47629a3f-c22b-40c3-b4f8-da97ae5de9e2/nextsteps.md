# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Repeat this check for:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 2. Restore and Build the Solution

Run the following commands from the root of the solution to confirm a clean restore and build:

```bash
dotnet restore
dotnet build --configuration Release
```

Ensure there are no warnings that could indicate deprecated APIs or packages that may cause runtime issues.

---

## 3. Check for Removed or Changed APIs

Review the code for any usage of APIs that existed in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` usages (not available in modern .NET; replaced by `Microsoft.AspNetCore`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` and related types (now under `Microsoft.AspNetCore.Http`)
- Any Windows-specific APIs (e.g., registry access, WCF server-side)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining compatibility issues.

---

## 4. Review NuGet Package Versions

Confirm all NuGet packages are updated to versions compatible with your target framework. Run:

```bash
dotnet list package --outdated
```

Update any outdated packages, paying particular attention to:
- Entity Framework or Entity Framework Core packages (used in `Bookstore.Data`)
- ASP.NET Core packages (used in `Bookstore.Web`)
- Any third-party libraries that may have .NET Framework-specific versions

---

## 5. Run Existing Tests

If the solution contains a test project, run the test suite to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET, or by legitimate regressions introduced during migration.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`) matches the target database.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:
- Application startup with no exceptions
- Navigation between pages
- Data retrieval and display from the database
- Any form submissions or write operations

Check the console output and application logs for runtime exceptions or warnings.

---

## 8. Review Application Configuration

Confirm that configuration files have been correctly migrated:

- `Web.config` settings should now reside in `appsettings.json` or `appsettings.{Environment}.json`.
- Environment-specific settings (connection strings, API keys) should be managed via environment variables or user secrets for local development:

```bash
dotnet user-secrets init --project app/Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your-connection-string"
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` folder and deploy to the target host environment.