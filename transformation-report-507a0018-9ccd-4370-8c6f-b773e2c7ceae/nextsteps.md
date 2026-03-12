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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1`, update it to a current supported version.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any APIs or packages that are Windows-only. Common areas to check:

- `Bookstore.Data`: Confirm the database provider (e.g., Entity Framework Core) is configured correctly and connection strings are environment-agnostic.
- `Bookstore.Web`: Check for any usage of `System.Web`, MSMQ, or Windows Registry APIs, which are not available on cross-platform .NET.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing integration tests that cover:

- Data access layer operations in `Bookstore.Data`
- Domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without runtime exceptions
- Database connectivity is functional
- Core pages and features load correctly
- Static assets (CSS, JavaScript, images) are served properly

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain the correct values for:

- Connection strings
- Logging configuration
- Any environment-specific feature flags

Confirm that no sensitive values are hardcoded and that the configuration system uses `IConfiguration` appropriately.

---

## 8. Validate Entity Framework Core Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the schema has changed during migration, generate a new migration:

```bash
dotnet ef migrations add PostMigrationValidation --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.