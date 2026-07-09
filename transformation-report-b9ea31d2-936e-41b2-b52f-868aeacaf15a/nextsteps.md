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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`). Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 4. Check for Windows-Specific Dependencies

Review all NuGet package references and any direct API usage for components that are Windows-only. Common areas to inspect include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or NTLM-specific middleware
- **System.Drawing** (GDI+) — replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if used
- **Entity Framework** — confirm the database provider (e.g., SQL Server, SQLite) is compatible with the target OS

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior remain correct after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` and `Bookstore.Data` projects as a baseline for regression coverage.

---

## 6. Validate Runtime Behavior

Run the web application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to exercise during manual validation:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Static file serving and view rendering

---

## 7. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are updated for the target environment
- Any paths or file references use cross-platform path separators or `Path.Combine`
- Secrets are not stored in source-controlled configuration files; use `dotnet user-secrets` or environment variables instead

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets are present before deploying to the target environment.