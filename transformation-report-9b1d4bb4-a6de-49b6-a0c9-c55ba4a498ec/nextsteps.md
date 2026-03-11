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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other .NET Framework moniker.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify Entity Framework usage. If the project was using Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.
- **`Bookstore.Web`**: If the project was previously ASP.NET (System.Web), confirm it has been migrated to ASP.NET Core. Any usage of `HttpContext`, `HttpRequest`, or similar types should reference the ASP.NET Core equivalents.
- **`Bookstore.Domain`**: Check for any usage of `AppDomain`, `BinaryFormatter`, or other types that are restricted or removed in modern .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the domain and data layers before proceeding to deployment.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application workflows (browsing, searching, and purchasing books) function correctly.

---

## 7. Validate Configuration Files

Cross-platform .NET uses `appsettings.json` for configuration rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- No sensitive values (passwords, API keys) are stored directly in configuration files that are committed to source control. Use environment variables or the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent (requires .NET runtime on the host):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (bundles the runtime with the application):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime win-x64 --self-contained true --output ./publish
```

Replace `win-x64` with the appropriate runtime identifier for your target environment (e.g., `linux-x64`, `osx-x64`).

---

## 9. Verify Published Output

Navigate to the `./publish` directory and confirm the expected files are present. Run the published output directly to perform a final sanity check before deploying to the target server:

```bash
cd ./publish
dotnet Bookstore.Web.dll
```