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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs or NuGet packages may only function correctly on Windows. Review the following areas:

- Any usage of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes, drive letters)
- Packages that have a `[SupportedOSPlatform("windows")]` attribute on their APIs

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool if a deeper audit is needed.

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate that core logic has not been broken during migration.

```bash
dotnet test --configuration Release
```

Review test output carefully. Pay particular attention to tests covering data access (`Bookstore.Data`) and domain logic (`Bookstore.Domain`), as these layers are most likely to be affected by framework-level changes.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core or another ORM, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm end-to-end functionality.

Check the console output and application logs for any runtime exceptions or deprecation warnings.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) for any middleware or configuration patterns that may have been carried over from ASP.NET Framework and are not compatible with ASP.NET Core.

Common areas to check:

- Authentication and authorization middleware registration
- Static file serving configuration
- Custom HTTP handlers or modules that need to be converted to middleware

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.