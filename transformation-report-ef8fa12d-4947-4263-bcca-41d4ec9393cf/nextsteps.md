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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions have reached or are approaching end-of-life.

---

## 4. Validate Runtime Behavior

### 4.1 Run the Web Application Locally

Start the web application and verify it loads and functions as expected.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually exercise the primary features of the application.

### 4.2 Check Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that the database connection string in `appsettings.json` is correct for your environment and that migrations are up to date.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 is not fully supported on cross-platform .NET.

---

## 5. Run Automated Tests

If the solution contains test projects, run them to verify that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a framework migration.

---

## 6. Check for Windows-Specific APIs

Even when a project builds successfully, it may contain calls to Windows-specific APIs that will fail at runtime on Linux or macOS. Use the .NET Compatibility Analyzer or the following command to surface potential issues:

```bash
dotnet build /p:PlatformTarget=AnyCPU /p:EnableNETAnalyzers=true
```

Common areas to inspect:

- Registry access (`Microsoft.Win32.Registry`)
- Windows-only authentication providers
- `System.Drawing` (GDI+) usage — replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if present

---

## 7. Review Configuration and Middleware

In ASP.NET Core, configuration and middleware setup differs from ASP.NET (System.Web). Confirm the following in `Bookstore.Web`:

- `Program.cs` or `Startup.cs` correctly registers services and middleware
- Authentication, authorization, and session middleware are configured in the correct order
- Static file serving is configured if the application serves CSS, JS, or image assets
- `appsettings.json` contains all configuration values previously held in `Web.config`

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment artifact.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.