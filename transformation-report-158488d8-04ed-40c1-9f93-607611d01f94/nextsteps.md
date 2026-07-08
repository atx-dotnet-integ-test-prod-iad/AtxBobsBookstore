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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured correctly and does not rely on Windows-specific connection mechanisms.
- **`Bookstore.Web`**: Confirm that no `System.Web` references remain, as this namespace is not available in .NET Core or later.
- **`Bookstore.Domain`**: Check for any use of Windows registry, COM interop, or Windows-specific file path assumptions.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to surface platform-specific issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration or smoke tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a test database to confirm schema correctness:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application's key pages and features to confirm expected behavior. Pay particular attention to:

- Database connectivity
- Authentication and authorization, if present
- Any file system operations (ensure paths are cross-platform using `Path.Combine`)

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) contain valid configuration values, particularly connection strings. The old `Web.config` or `App.config` approach is replaced by `appsettings.json` in modern .NET.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to your target environment.