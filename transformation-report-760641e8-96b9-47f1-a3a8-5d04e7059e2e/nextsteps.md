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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs that are Windows-only. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Look for `CA1416` analyzer warnings, which indicate platform-specific API usage. Common problem areas include:
- `System.Drawing` (requires `libgdiplus` on Linux/macOS)
- Registry access (`Microsoft.Win32.Registry`)
- Windows Authentication in `Bookstore.Web`

---

## 5. Database Migration Validation (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If you are switching database providers (e.g., from SQL Server LocalDB to a cross-platform provider), update the connection string in `appsettings.json` and the EF Core provider package in `Bookstore.Data.csproj` accordingly.

Apply pending migrations against a test database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it loads without runtime exceptions:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and exercise the core application flows, such as browsing, searching, and any authenticated routes, to confirm end-to-end functionality.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=normal"
```

Review any failing tests. Failures after migration often point to:
- Hardcoded Windows file paths (use `Path.Combine` and relative paths instead)
- Dependencies on `HttpContext` or legacy ASP.NET types that have changed in ASP.NET Core
- Configuration loading differences (`Web.config` vs `appsettings.json`)

---

## 8. Configuration File Review

Confirm that any settings previously held in `Web.config` or `App.config` have been correctly moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific keys
- Authentication settings

Verify that `Bookstore.Web` reads these values correctly at startup using `IConfiguration`.

---

## 9. Static Files and Web Assets

If `Bookstore.Web` serves static content (CSS, JavaScript, images), confirm that the files are located under the `wwwroot` folder and that the middleware is configured in `Program.cs` or `Startup.cs`:

```csharp
app.UseStaticFiles();
```

---

## 10. Publish the Application

Once all validation steps pass, produce a self-contained or framework-dependent publish artifact:

```bash
# Framework-dependent
dotnet publish app/Bookstore.Web --configuration Release --output ./publish

# Self-contained (example for Linux x64)
dotnet publish app/Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` folder and confirm the application starts correctly from that output directory before deploying to the target environment.