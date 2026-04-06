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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference old `net4x` target frameworks exclusively, consider finding cross-platform alternatives on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netcoreapp3.1`, update it to a current long-term support (LTS) release such as `net8.0`.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any APIs or packages that are Windows-only. Common areas to check:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If `System.Data.SqlClient` is referenced, consider replacing it with `Microsoft.Data.SqlClient`.
- **`Bookstore.Web`**: Check for any usage of `System.Web`, MSMQ, Windows Registry, or Windows-specific authentication mechanisms that may have been stubbed out during transformation.
- **`Bookstore.Domain`**: Verify no platform-specific types are used in domain logic.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific calls.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing tests that cover:

- Domain model validation in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Controller actions or middleware behavior in `Bookstore.Web`

---

## 6. Validate Application Configuration

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings are present in `appsettings.json` (or `appsettings.Production.json`).
- Any configuration values previously in `Web.config` have been migrated.
- Environment-specific settings are handled using the `IConfiguration` abstraction.

---

## 7. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application URL shown in the console output and manually verify core functionality such as browsing, searching, and any data-driven pages.

---

## 8. Test on a Non-Windows Platform (If Required)

If cross-platform support is a hard requirement, run the application on Linux or macOS to confirm there are no runtime platform-specific failures:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay attention to file path separators, case-sensitive file systems, and any native interop calls that may behave differently outside of Windows.

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

Review the contents of the `./publish` folder to confirm all required assets, configuration files, and static content are present before deploying to the target environment.