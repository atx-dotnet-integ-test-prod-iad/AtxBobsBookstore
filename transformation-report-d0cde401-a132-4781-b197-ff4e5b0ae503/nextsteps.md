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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all NuGet package references and code for APIs that are Windows-only. Common areas to inspect include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows DLLs
- Any package marked with the `windows` platform target in its NuGet metadata

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`)
- Connection strings in `appsettings.json` are correct for the target environment
- Run any pending migrations to verify the database schema is up to date

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify functional correctness after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality such as navigation, data access, and any authentication flows.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the console output and browser for any runtime errors, missing middleware registrations, or configuration issues.

---

## 8. Review Configuration and Middleware

Open `Program.cs` (or `Startup.cs` if still present) in `Bookstore.Web` and confirm:

- Middleware is registered in the correct order
- Services such as dependency injection, logging, and authentication are properly configured
- Any legacy `web.config` settings have been migrated to `appsettings.json` or environment variables

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.