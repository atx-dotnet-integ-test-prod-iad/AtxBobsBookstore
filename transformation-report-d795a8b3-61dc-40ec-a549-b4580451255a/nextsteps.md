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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for .NET-compatible replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or another outdated framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no remaining dependencies rely on Windows-only APIs (e.g., `System.Web`, `Microsoft.Web.Infrastructure`, or Windows Registry access). You can use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool for this.

```bash
dotnet tool install -g dotnet-compatibility
```

Address any platform-specific APIs by replacing them with cross-platform equivalents from the `Microsoft.Extensions.*` or `System.*` namespaces.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality has not regressed.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around areas such as:

- JSON serialization defaults (`System.Text.Json` vs `Newtonsoft.Json`)
- Entity Framework Core query translation differences
- HTTP pipeline and middleware behavior in ASP.NET Core

---

## 6. Validate the Data Layer (`Bookstore.Data`)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. If migrating from EF6, migrations may need to be regenerated.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or incompatible, create a new initial migration.

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality such as navigation, data retrieval, and form submissions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions, middleware configuration errors, or missing configuration values. Pay particular attention to:

- `appsettings.json` containing the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Authentication and authorization middleware being correctly configured in `Program.cs` or `Startup.cs`.

---

## 8. Verify Configuration Migration

Confirm that all settings from the legacy `Web.config` or `App.config` files have been correctly moved to `appsettings.json`. Key areas to check include:

- Database connection strings
- Application-specific keys and values
- Any custom configuration sections

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct before deploying to a target environment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all necessary files, static assets, and configuration files are present.