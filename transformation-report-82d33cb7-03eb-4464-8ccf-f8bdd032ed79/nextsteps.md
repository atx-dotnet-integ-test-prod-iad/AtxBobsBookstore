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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported version and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-specific APIs or libraries remain that would break cross-platform compatibility. Common areas to check:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** configurations in `Bookstore.Web`
- **System.Drawing** (replaced by cross-platform alternatives like `SkiaSharp` or `ImageSharp`)
- Any P/Invoke calls targeting Windows-only DLLs

Run the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the correct version is referenced.

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations exist, verify they are compatible with the current EF Core version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm baseline functionality.

---

## 7. Run Existing Tests

If the solution contains test projects, execute them to validate that existing behavior has been preserved.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they represent regressions introduced during migration or pre-existing issues.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration values that may have previously been stored in `Web.config` or `App.config`.

Key areas to verify:
- Connection strings
- Logging configuration
- Authentication settings
- Any custom application settings previously under `<appSettings>`

---

## 9. Validate on a Non-Windows Environment (Optional)

If cross-platform support is a goal, test the application on Linux or macOS to surface any remaining platform-specific issues.

```bash
dotnet run --project Bookstore.Web
```

Address any runtime exceptions that appear only on non-Windows platforms.

---

## 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.