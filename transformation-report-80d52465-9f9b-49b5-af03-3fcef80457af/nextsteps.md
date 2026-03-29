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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider writing tests that cover:

- Domain model logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data` (e.g., repository methods, database queries)
- Key HTTP endpoints in `Bookstore.Web` (e.g., using `WebApplicationFactory<T>`)

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that your migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Check that the connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for your target environment.

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually verify:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 6. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the following areas manually:

- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usages have been replaced with `Microsoft.Extensions.Configuration`.
- **HTTP Context**: Confirm `HttpContext` access patterns are compatible with ASP.NET Core.
- **Global.asax / Web.config**: Verify that any logic previously in these files has been moved to `Program.cs` or `Startup.cs`.
- **Static files and bundling**: Confirm that static asset handling is configured correctly in the ASP.NET Core middleware pipeline.

---

## 7. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same major version to avoid cross-framework compatibility issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.