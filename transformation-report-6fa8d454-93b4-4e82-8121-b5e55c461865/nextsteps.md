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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility. While warnings do not prevent a build from succeeding, they can indicate areas of the code that may behave unexpectedly at runtime.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output carefully. Any failing tests should be investigated to determine whether the failure is due to the migration itself or a pre-existing issue.

If there are no test projects currently in the solution, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration**: Ensure that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`, such as connection strings and application settings.
- **Static files and routing**: Navigate through the application's pages to confirm that routing, views, and static assets load correctly.
- **Authentication and authorization**: If the application uses authentication, verify that login, logout, and protected routes function as expected.

---

## 5. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not supported or behave differently in cross-platform .NET:

- `System.Web` references — these are not available in modern .NET and should have been replaced during transformation.
- Windows Registry access (`Microsoft.Win32.Registry`) — this will not function on Linux or macOS.
- `AppDomain.CurrentDomain.BaseDirectory` and file path assumptions — ensure paths use `Path.Combine` and are not hardcoded with backslashes.
- WCF service references — if present, these require additional packages such as `System.ServiceModel`.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

---

## 6. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the web project is an ASP.NET Core project, it should target `net8.0` or the version agreed upon for this migration. Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 7. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present, including configuration files and static assets.