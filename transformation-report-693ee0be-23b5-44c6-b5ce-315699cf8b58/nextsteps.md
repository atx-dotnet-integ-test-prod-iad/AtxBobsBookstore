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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` all reference compatible framework versions.

---

## 4. Check for Windows-Specific Dependencies

Review the project files and source code for any APIs or packages that are Windows-only. Common areas to check include:

- Registry access (`Microsoft.Win32`)
- Windows Authentication
- `System.Drawing` (which has limited cross-platform support; consider replacing with `SkiaSharp` or `ImageSharp`)
- Any use of `[SupportedOSPlatform]` warnings in the build output

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test output carefully for any failures that may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core package is referenced (e.g., `Microsoft.EntityFrameworkCore`)
- The database provider package matches your database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application locally to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages that interact with `Bookstore.Data` and `Bookstore.Domain`.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains the correct configuration values, including connection strings and any environment-specific settings. Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Verify none were missed.

---

## 9. Test on Target Platform

If cross-platform support is a goal, run the application on the intended target operating system (Linux or macOS) to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```