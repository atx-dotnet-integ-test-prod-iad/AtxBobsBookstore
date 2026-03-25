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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, review the following areas for any remaining Windows-specific dependencies that may not surface as build errors but will cause runtime failures on non-Windows platforms:

- Usage of `System.Web` namespaces (should be replaced with ASP.NET Core equivalents)
- Windows Registry access
- COM interop or P/Invoke calls targeting Windows libraries
- `HttpContext.Current` usage (not available in ASP.NET Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify remaining platform-specific code.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)
- Connection strings in `appsettings.json` are correctly configured
- Run a migration check to ensure the schema is up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior. Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and `appsettings.Development.json` contain all required configuration values that may have previously been stored in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Authentication settings
- Any custom application settings

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.