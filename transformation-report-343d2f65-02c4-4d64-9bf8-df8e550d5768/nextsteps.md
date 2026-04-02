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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless explicitly required.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- `System.Windows.Forms` or `System.Drawing` (without the cross-platform `System.Drawing.Common` alternative)
- Any P/Invoke calls targeting Windows-specific DLLs

If any are found, evaluate whether a cross-platform alternative exists or whether a runtime platform guard (`RuntimeInformation.IsOSPlatform`) is needed.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify functional correctness after migration.

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences introduced by the framework change.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the following:

- Entity Framework Core (or whichever ORM is in use) is correctly configured for the new framework.
- Database migrations are up to date. If using EF Core, run:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Connection strings in `appsettings.json` are correct for the target environment.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected on the local machine.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm runtime behavior is correct.

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration files (`appsettings.json`, `appsettings.Development.json`) are present and correctly structured. Pay particular attention to:

- Database connection strings
- Any environment-specific settings that may have previously been stored in `Web.config` or `App.config`

Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Verify this is the case.

---

## 9. Verify Static Files and Middleware (Web Project)

If the project uses ASP.NET Core, confirm the middleware pipeline in `Program.cs` or `Startup.cs` includes the necessary components:

- `app.UseStaticFiles()`
- `app.UseRouting()`
- `app.UseAuthentication()` / `app.UseAuthorization()` if applicable

Ensure static assets (CSS, JS, images) are located under the `wwwroot` folder.

---

## 10. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no remaining platform-specific issues.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

This can be done on a Linux or macOS machine, or within a Linux-based environment, without requiring any additional tooling beyond the .NET SDK.