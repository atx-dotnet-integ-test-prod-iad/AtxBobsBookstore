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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all configuration values that were previously in `Web.config` or `App.config`.
- Verify that connection strings, logging settings, and any environment-specific values have been correctly migrated.
- If `Web.config` transforms were used previously, ensure equivalent logic is now handled through environment-specific `appsettings.{Environment}.json` files or environment variables.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify the correct version (EF Core) is referenced and that migrations are present and up to date.
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate core functionality:

```bash
dotnet test
```

If no tests currently exist, consider writing basic tests for the domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data` before proceeding to deployment.

---

## 6. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any transactional features).
- Check the console output and any log files for runtime exceptions or warnings.
- Validate that database reads and writes function correctly.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or libraries that may not be compatible with cross-platform .NET:

- Look for usages of `System.Web`, `HttpContext` (classic), or Windows Registry APIs.
- Check for any P/Invoke calls or COM interop that may not function outside of Windows.
- Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if further analysis is needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files, static assets, and configuration files are present before deploying to the target environment.