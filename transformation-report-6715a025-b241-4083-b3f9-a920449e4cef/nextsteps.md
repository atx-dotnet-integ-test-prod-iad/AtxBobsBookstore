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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured with a cross-platform-compatible database driver.
- **`Bookstore.Web`**: Confirm that no Windows-specific middleware or IIS-specific configurations are required for the application to run.
- **`Bookstore.Domain`**: Check for any use of `System.Drawing`, COM interop, or Windows registry access.

You can use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify platform-specific API usage.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing behavior has been preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they indicate a behavioral regression introduced during migration or a test that depends on a Windows-specific environment.

---

## 6. Validate the Web Application Locally

Run the web application locally using the .NET CLI:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- Application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application workflows such as browsing, searching, and managing books function correctly.
- Static assets (CSS, JavaScript, images) are served properly.

---

## 7. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are valid and not referencing Windows-specific paths or named instances.
- Any file system paths use `Path.Combine` or forward slashes to remain cross-platform compatible.
- Logging and other middleware configurations are appropriate for the new runtime.

---

## 8. Verify Entity Framework Core Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date and can be applied:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations against your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

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

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.