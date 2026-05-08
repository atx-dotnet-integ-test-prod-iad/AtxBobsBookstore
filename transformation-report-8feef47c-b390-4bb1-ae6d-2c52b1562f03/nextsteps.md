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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, consider replacing them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output reports zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and `appsettings.Development.json`) contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Confirm that any environment-specific settings are properly separated using the ASP.NET Core configuration system.
- Check that secrets (e.g., connection strings, API keys) are not hardcoded and are instead managed via environment variables or the .NET Secret Manager.

```bash
dotnet user-secrets list --project app/Bookstore.Web
```

---

## 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are present and up to date.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or outdated, create a new migration and apply it to the database.

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the core functionality of the application, including:

- Page rendering
- Database read and write operations
- Authentication and authorization, if applicable
- Any file upload or download features

---

## 6. Run Existing Tests

If the solution contains test projects, execute them to validate that existing behavior is preserved.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 7. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining Windows-specific API calls that may cause issues on Linux or macOS.

```bash
dotnet tool install -g dotnet-compatibility
```

Alternatively, review the code manually for usages of APIs such as:

- `System.Web.*`
- `Microsoft.Win32.*`
- Windows registry access
- COM interop

Replace any identified platform-specific code with cross-platform alternatives.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.