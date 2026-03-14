# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from Windows-specific APIs. Review the following:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET.
- References to the Windows Registry (`Microsoft.Win32.Registry`).
- Use of `System.Drawing` without the `System.Drawing.Common` NuGet package, which has platform restrictions as of .NET 6+.
- Any P/Invoke calls targeting Windows-only native libraries.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist in identifying these.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 6. Validate the Web Application Locally

Run the web application locally to confirm it starts and functions as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following manually:

- Application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core user-facing routes and pages load correctly.
- Any authentication or authorization flows behave as intended.

---

## 7. Review Configuration Files

Ensure that configuration has been properly migrated from `Web.config` or `App.config` to `appsettings.json`. Key areas to check:

- Database connection strings.
- Application-specific settings previously stored under `<appSettings>`.
- Any environment-specific configuration that should be split into `appsettings.Development.json` and `appsettings.Production.json`.

---

## 8. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core version is referenced (not EF 6, which has limited cross-platform support).
- Migrations are present and up to date. Run the following to verify:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply migrations to a local or staging database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.