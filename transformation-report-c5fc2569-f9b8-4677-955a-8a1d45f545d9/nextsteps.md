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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate modern .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid cross-framework compatibility issues.

---

## 4. Check for Windows-Specific APIs

Since this is a cross-platform migration, scan the codebase for any remaining Windows-specific dependencies such as:

- `System.Web` references
- Windows Registry access
- Windows-only file path assumptions (e.g., backslashes)
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify these issues systematically.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm that it has been migrated to **Entity Framework Core**.

```bash
dotnet ef dbcontext info --project app/Bookstore.Data
```

- Verify that all migrations are present and up to date.
- Run a test migration against a local or development database:

```bash
dotnet ef database update --project app/Bookstore.Data
```

- Confirm that connection strings in `appsettings.json` are correctly configured for the target database provider.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed in the application code.

---

## 8. Cross-Platform Validation

If cross-platform support is a requirement, run and test the application on each target operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear during a build.

---

## 9. Review `appsettings.json` and Configuration

Confirm that all configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.