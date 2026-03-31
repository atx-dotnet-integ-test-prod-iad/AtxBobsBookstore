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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net472` or another legacy framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or libraries. Common areas to check include:

- `System.Web` references (not available in .NET Core and later)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- Any P/Invoke calls targeting Windows-only system libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, such as changes in:

- JSON serialization defaults (`System.Text.Json` vs `Newtonsoft.Json`)
- Entity Framework Core query translation differences
- HTTP pipeline and middleware behavior in ASP.NET Core

---

## 6. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. Legacy EF 6 migrations are not directly portable.
- Run a migration check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or incompatible, consider generating a new initial migration against the existing schema.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- Routing behaves as expected.
- Authentication and authorization middleware is configured correctly if applicable.
- Static files, views, or Razor Pages render without errors.
- Any `web.config` settings that were previously relied upon have been migrated to `appsettings.json` or `Program.cs` configuration.

---

## 8. Configuration Migration Check

Verify that all configuration previously stored in `web.config` or `app.config` has been moved to the appropriate .NET configuration system.

- Connection strings should be in `appsettings.json` or environment variables.
- Application settings should use `IConfiguration` via dependency injection.
- Confirm that environment-specific settings use `appsettings.Development.json`, `appsettings.Production.json`, etc.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.