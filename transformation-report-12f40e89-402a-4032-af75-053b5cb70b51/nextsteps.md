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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely interacts with a database, verify the following:

- **Connection strings** in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- If Entity Framework is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If a different ORM or ADO.NET is used, manually verify that queries execute correctly against the target database.

---

## 5. Validate the Domain Layer

Review `Bookstore.Domain` for any logic that may have relied on Windows-specific APIs or .NET Framework-only types. Pay particular attention to:

- Any use of `System.Configuration.ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration` in cross-platform .NET)
- Serialization behavior differences between `Newtonsoft.Json` and `System.Text.Json` if applicable

---

## 6. Run the Web Application Locally

Start the web application and verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page load
- Database-driven pages (e.g., book listings, details)
- Any forms or POST operations
- Authentication and authorization flows, if present

Check the console output and application logs for runtime exceptions or warnings.

---

## 7. Review Configuration Files

Confirm that the following configuration concerns have been addressed:

- `web.config` handlers or modules from the legacy project are not being relied upon; ASP.NET Core uses middleware instead.
- Any environment-specific settings are correctly placed in `appsettings.json` or `appsettings.{Environment}.json`.
- HTTPS redirection and static file serving are correctly configured in `Program.cs` or `Startup.cs`.

---

## 8. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element references a current, supported version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to ensure the chosen version is within its support window.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.