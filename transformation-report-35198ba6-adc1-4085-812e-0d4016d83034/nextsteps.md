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

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review each project for any remaining Windows-specific APIs or packages. Common areas to check:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore.*`)
- Registry access (`Microsoft.Win32.Registry`)
- Windows-only NuGet packages

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if platform-specific branching is needed.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
cd app/Bookstore.Web
dotnet run
```

- Navigate to the displayed local URL in a browser.
- Test core functionality such as browsing, searching, and any data-driven pages.
- Check the console output for runtime exceptions or middleware configuration errors.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the database connection string in `appsettings.json` is correct and that migrations are up to date:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 7. Run Existing Tests

If the solution contains a test project, execute all tests to confirm existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by behavioral differences in the new framework or by test configuration issues.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to ensure the middleware pipeline is correctly configured for ASP.NET Core. Key areas to verify:

- Authentication and authorization middleware order
- Static file serving
- Routing configuration
- Any custom HTTP modules or handlers that may have been carried over from the legacy project and need to be converted to middleware

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.