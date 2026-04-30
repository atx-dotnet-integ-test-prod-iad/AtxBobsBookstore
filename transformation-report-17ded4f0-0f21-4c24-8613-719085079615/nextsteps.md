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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `net4x` or older target frameworks, consider updating them to their latest cross-platform compatible versions.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net6.0`, `net7.0`, or `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another legacy framework, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific APIs

Search the codebase for any usage of Windows-specific APIs that may not be available cross-platform. Common areas to check include:

- `Microsoft.Win32` namespace usage
- `System.Windows.Forms` or `System.Drawing` references
- Registry access (`RegistryKey`, etc.)
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool to assist:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new runtime.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following:

- The application starts without runtime exceptions
- All routes and pages load as expected
- Database connectivity works if `Bookstore.Data` uses Entity Framework or another ORM
- Any authentication or authorization middleware functions correctly

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and can be applied to the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to a test database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) are present and correctly configured. Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Verify that connection strings, logging settings, and any custom configuration sections are intact.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.