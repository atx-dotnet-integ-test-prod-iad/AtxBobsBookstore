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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review all NuGet package references across the three projects for packages that are Windows-only. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web.*`
- `EntityFramework` (classic, non-EF Core)

If any such packages exist, they will need to be replaced with their cross-platform equivalents before the application can run on non-Windows environments.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm the application behaves correctly end to end.

---

## 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for your target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using classic Entity Framework (non-Core), confirm the migration to EF Core was completed and that all `DbContext` configurations are valid.

---

## 8. Review Application Logs

After running the application, review the console output and any log files for warnings or errors that do not surface as build errors but may indicate runtime issues, such as:

- Missing configuration values
- Unresolved service registrations in the dependency injection container
- Middleware ordering issues in `Program.cs` or `Startup.cs`

---

## 9. Test on a Non-Windows Environment (Optional but Recommended)

Since the goal of the transformation is cross-platform compatibility, consider running the application on a Linux or macOS machine to confirm there are no platform-specific runtime dependencies remaining:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Any `PlatformNotSupportedException` or similar runtime errors at this stage would indicate remaining platform-specific code that needs to be addressed.