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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Web` uses the appropriate web-specific target if applicable:

```xml
<TargetFramework>net8.0</TargetFramework>
```

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Registry access or Windows-only file path assumptions
- Any `[assembly: ...]` attributes that were previously in `AssemblyInfo.cs` and may now conflict with auto-generated assembly info

If `System.Web` references remain, they will need to be replaced with their ASP.NET Core equivalents.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, verify the following:

- If Entity Framework is used, confirm it has been migrated to **Entity Framework Core**.
- Check that the `DbContext` configuration uses the new `OnConfiguring` or `AddDbContext` patterns.
- Confirm connection strings are stored in `appsettings.json` rather than `web.config` or `app.config`.

Run any pending migrations if applicable:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 6. Validate Configuration Files

Ensure that `web.config` or `app.config` settings have been moved to `appsettings.json` and that the application reads configuration through `IConfiguration`. Check for:

- Connection strings
- Application settings
- Logging configuration

---

## 7. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and exercise the primary features, particularly any database interactions handled by `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 8. Run Existing Tests

If a test project exists in the solution, execute the test suite to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration-related changes or pre-existing issues.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.