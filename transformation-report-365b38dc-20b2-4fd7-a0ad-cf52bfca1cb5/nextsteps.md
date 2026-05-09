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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` references accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay attention to any nullable reference type warnings or obsolete API usage that may have been introduced during the transformation.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Data` and `Bookstore.Domain` are not targeting an older framework such as `net48` or `netstandard2.0` unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Windows Registry access
- COM interop

These will not function on Linux or macOS. Replace them with cross-platform equivalents where applicable.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly on the local development machine.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that the application loads and functions as expected.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and that the database connection works correctly.

Check that the connection string in `appsettings.json` is correct for the target environment:

```json
"ConnectionStrings": {
  "DefaultConnection": "your_connection_string_here"
}
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to verify that existing functionality has not regressed during the migration.

```bash
dotnet test
```

Review the test results and investigate any failures. Failures may indicate areas where behavior changed due to API differences between .NET Framework and modern .NET.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to ensure that:

- Middleware is registered in the correct order.
- Authentication and authorization configuration is valid.
- Any legacy `HttpModule` or `HttpHandler` logic has been replaced with the appropriate ASP.NET Core middleware.

---

## 9. Cross-Platform Validation

If cross-platform support is a goal, run the application on a non-Windows environment (Linux or macOS) to surface any remaining platform-specific issues that may not appear during local Windows development.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.