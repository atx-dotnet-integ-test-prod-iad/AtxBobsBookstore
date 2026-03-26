# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues introduced during restore:

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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` namespace usage
- `System.Windows.Forms` or `System.Drawing` (without the cross-platform NuGet variants)
- Any P/Invoke calls targeting Windows-specific DLLs

Use the .NET Upgrade Assistant compatibility analyzer or the following command to check for platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is referencing the correct cross-platform NuGet packages.
- If the project previously used Entity Framework 6, verify it has been migrated to EF Core and that all migrations are intact and functional.
- Apply migrations against a test database to confirm schema generation works:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally to confirm it starts without errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the key pages and features of the application to perform basic smoke testing.
- Check that configuration files (`appsettings.json`) are properly structured and that any values previously stored in `Web.config` have been correctly migrated.

---

## 8. Review `Web.config` to `appsettings.json` Migration

If the original project used `Web.config`, confirm that all relevant settings have been moved to `appsettings.json` or `appsettings.{Environment}.json`. Key areas to check:

- Connection strings
- Application settings / feature flags
- Authentication and authorization configuration

---

## 9. Verify Runtime on Target Platforms

If cross-platform support is a requirement, test the application on each intended operating system (Windows, Linux, macOS) to surface any runtime issues that do not appear at compile time:

```bash
dotnet run --project Bookstore.Web
```

---

## 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.