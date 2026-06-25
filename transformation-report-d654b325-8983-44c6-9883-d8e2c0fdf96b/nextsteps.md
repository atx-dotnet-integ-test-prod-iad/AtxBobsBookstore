# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference old `net4x` target frameworks, consider finding their `.NET` compatible equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, the project may still contain runtime dependencies that are Windows-only. Review the following areas:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or **NTLM**
- **COM interop** or `[DllImport]` calls targeting Windows DLLs
- **`System.Drawing`** (requires `libgdiplus` on Linux/macOS or replacement with a cross-platform library)

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify platform-specific API usage.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, verify the following:

- The database provider package is compatible with cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Pomelo.EntityFrameworkCore.MySql`).
- Any pending migrations are up to date.

Run the following to check migration status if using Entity Framework Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the console output and verify core functionality such as:

- Page rendering
- Database read/write operations
- Authentication (if applicable)

---

## 7. Execute Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new .NET runtime, such as changes in serialization, globalization, or HTTP handling.

---

## 8. Review `web.config` and `app.config` Migrations

ASP.NET Core does not use `web.config` for application configuration. Confirm that settings previously stored in `web.config` (connection strings, app settings) have been moved to `appsettings.json` or environment variables.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 9. Validate on Target Operating System

If the goal is Linux or macOS deployment, run the application on the target OS to catch any remaining platform-specific runtime issues that would not appear during a Windows build.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then transfer and run the published output on the target machine to confirm compatibility.