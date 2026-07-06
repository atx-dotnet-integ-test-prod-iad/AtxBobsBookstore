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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. Pay close attention to tests that cover:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- Web layer routing, controllers, or middleware in `Bookstore.Web`

If no test projects currently exist, consider adding them to cover critical paths before deploying.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected (check connection strings in `appsettings.json`)
- Core pages and endpoints return expected responses
- Any authentication or authorization flows behave correctly

---

## 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are valid for the target environment
- Any settings previously stored in `Web.config` or `App.config` have been correctly migrated
- Environment variables or secrets are handled appropriately using the .NET configuration system

---

## 6. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that may have been available in .NET Framework but have limited or no support in cross-platform .NET. Common areas to check include:

- `System.Web` references (should be fully replaced by ASP.NET Core equivalents)
- Windows Registry access
- Windows Communication Foundation (WCF) client or server usage
- Any P/Invoke calls targeting Windows-specific native libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining issues.

---

## 7. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to the target server or hosting environment.