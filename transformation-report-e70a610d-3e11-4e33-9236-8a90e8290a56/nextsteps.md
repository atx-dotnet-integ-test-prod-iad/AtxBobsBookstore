# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Verify Target Framework

Confirm that each `.csproj` file is targeting the intended cross-platform .NET version (e.g., `net8.0`). Open each project file and check for the following:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Do this for:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 2. Restore NuGet Packages

Run the following command from the solution root to ensure all dependencies are properly restored:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older framework-specific libraries, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 3. Build the Solution

Perform a full solution build to confirm there are no residual issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently on cross-platform .NET.

---

## 4. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually navigate through the application and verify:
- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 5. Check for Windows-Specific API Usage

Even without build errors, certain APIs that compiled successfully may still cause runtime failures on non-Windows platforms. Use the .NET Compatibility Analyzer or search the codebase for common problem areas such as:

- `System.Drawing` (GDI+ is not fully supported cross-platform)
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop

Run the following to surface platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

---

## 6. Validate Database Connectivity (`Bookstore.Data`)

If the project uses Entity Framework Core, verify that:
- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql` for PostgreSQL)
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Run Automated Tests

If the solution contains test projects, execute them to confirm existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests carefully, as failures after migration often point to behavioral differences between .NET Framework and modern .NET.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration that may have previously existed in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.