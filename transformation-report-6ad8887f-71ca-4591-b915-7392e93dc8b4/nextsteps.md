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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that no project is still referencing `net48` or any other legacy .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project's NuGet references and code for any APIs or packages that are Windows-only. Common areas to check include:

- `System.Drawing` (replaced by cross-platform alternatives such as `SkiaSharp` or `ImageSharp`)
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any use of `[SupportedOSPlatform("windows")]`-attributed APIs

Run the following to surface platform compatibility warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality is preserved after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests to determine whether failures are caused by migration-related behavioral changes or pre-existing issues.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- If Entity Framework Core is in use, confirm migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to EF Core and that all queries behave as expected.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed URL and manually verify core application flows such as browsing, searching, and any authenticated routes.

---

## 8. Verify Configuration and Middleware

Review `Program.cs` (and `Startup.cs` if still present) to confirm the middleware pipeline and service registrations are correct for the cross-platform .NET hosting model. Specifically:

- Confirm `WebApplication.CreateBuilder` is used if targeting .NET 6 or later.
- Verify that any legacy `HttpModule` or `HttpHandler` registrations from ASP.NET have been replaced with equivalent ASP.NET Core middleware.
- Check that static file serving, routing, and authentication middleware are registered in the correct order.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.