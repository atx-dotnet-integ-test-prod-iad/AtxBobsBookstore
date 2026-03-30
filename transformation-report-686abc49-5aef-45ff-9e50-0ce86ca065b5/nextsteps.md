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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, even if they do not prevent a successful build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the chosen version is still under active support.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the tests to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output and investigate any failures before proceeding.

---

## 5. Validate the Web Application at Runtime

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data`
- Domain logic behavior from `Bookstore.Domain`
- Key pages and HTTP endpoints return expected responses

---

## 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) for the following:

- Connection strings are valid and point to the correct database instances
- Any configuration keys that were previously stored in `Web.config` have been migrated to the new configuration system
- Sensitive values are stored using environment variables or the .NET Secret Manager rather than in plain text

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Run the .NET Upgrade Assistant compatibility analyzer or the Platform Compatibility Analyzer to identify any runtime-level API usage that may not have surfaced as build errors:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
dotnet build
```

Pay particular attention to:

- `System.Web` namespace usage, which is not available in cross-platform .NET
- Windows-only APIs that may compile but fail at runtime on non-Windows platforms
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET

---

## 8. Database Migration Verification

If `Bookstore.Data` uses Entity Framework, confirm that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a development database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.