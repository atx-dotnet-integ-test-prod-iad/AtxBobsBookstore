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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `netcoreapp*` or `net4x*`, update it to a current target framework.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review each project for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` registry access
- Windows-only NuGet packages
- `[SupportedOSPlatform]` warnings in the build output

Replace or conditionally compile any Windows-specific code as needed.

---

## 5. Run the Data Layer

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Existing Tests

If the solution contains a test project, execute the tests to validate that existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- Database connectivity is functional.
- Core application routes and pages load correctly.
- Any authentication or session handling works as expected.

---

## 8. Review Configuration Files

Check `appsettings.json` and `appsettings.Production.json` for any configuration values that may have been tied to the legacy environment, such as:

- Connection strings referencing local or legacy database servers.
- Hardcoded file paths using Windows-style separators (`\`).
- Any legacy `web.config` transforms that are no longer applied.

Update these values to reflect the target deployment environment.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.