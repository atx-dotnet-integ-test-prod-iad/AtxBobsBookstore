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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported release.

---

## 4. Verify Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json` if present) in `Bookstore.Web` contains all necessary configuration values, including:

- Database connection strings
- Any application-specific settings previously stored in `Web.config` or `App.config`

Legacy `Web.config` or `App.config` files are not used in cross-platform .NET. Confirm all relevant settings have been migrated to the `appsettings.json` format.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider matching your database).
- Any database migrations are present and up to date.

Apply pending migrations against your development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the terminal output and manually verify that core functionality works as expected, including:

- Page rendering
- Database read and write operations
- Any authentication or authorization flows

---

## 7. Run Automated Tests

If the solution contains a test project, execute the test suite to confirm no regressions were introduced during the migration.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 8. Check for Windows-Specific API Usage

If the application is intended to run on Linux or macOS, use the .NET Compatibility Analyzer to identify any remaining Windows-specific API calls.

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Look for `CA1416` analyzer warnings, which flag platform-specific API usage. Common areas to check include:

- Registry access
- Windows Authentication
- `System.Drawing` (GDI+), which requires the `System.Drawing.Common` package and has platform restrictions in .NET 6+

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to your target environment.