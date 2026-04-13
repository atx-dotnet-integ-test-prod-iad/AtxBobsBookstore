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

Refer to the [.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still under active or LTS support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or packages. Common areas to check:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured with a cross-platform-compatible provider such as `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`.
- **`Bookstore.Web`**: Check that no Windows-specific middleware or authentication providers (e.g., Windows Authentication, MSMQ) are still referenced.
- **`Bookstore.Domain`**: This layer is typically framework-agnostic, but verify no platform-specific types are used.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate that existing behavior is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they reflect regressions introduced during migration or pre-existing issues.

If no tests currently exist, consider writing integration or smoke tests that cover the core data access and web request/response paths before proceeding further.

---

## 6. Validate Database Migrations (Bookstore.Data)

If Entity Framework Core is used, verify that existing migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data
```

If the migrations were generated under the old framework, consider running:

```bash
dotnet ef database update --project Bookstore.Data
```

Test this against a development or staging database before applying to any production environment.

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions.
- Key pages and routes load correctly.
- Database read and write operations function as expected.
- Any authentication or session management behaves correctly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) are correctly structured for the new .NET host. Confirm that:

- Connection strings are valid and accessible.
- Logging configuration is present.
- Any configuration previously stored in `Web.config` has been properly migrated to `appsettings.json`.

---

## 9. Publish the Application

Once local validation is complete, produce a published output:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output runs correctly in the target hosting environment.