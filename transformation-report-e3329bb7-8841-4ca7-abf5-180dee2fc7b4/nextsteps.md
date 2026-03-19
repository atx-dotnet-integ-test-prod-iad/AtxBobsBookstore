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

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm it has been migrated from EF 6 to EF Core. Verify connection strings, `DbContext` configurations, and any migrations are compatible.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC or Web Forms project, confirm it has been correctly migrated to ASP.NET Core. Web Forms is **not supported** on cross-platform .NET and would require a rewrite of affected pages.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or configuration-related code functions as expected under the new runtime.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior.

```bash
dotnet test
```

If no tests exist, consider writing basic integration or unit tests for critical paths such as data access and core domain logic before proceeding.

---

## 6. Run the Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Static file serving and view rendering

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all configuration values that were previously in `Web.config` or `App.config`. The `System.Configuration.ConfigurationManager` approach is replaced by `Microsoft.Extensions.Configuration` in ASP.NET Core.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to your target environment.