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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently on cross-platform .NET compared to .NET Framework.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Pay close attention to any tests that interact with:
- File system paths (Windows-style paths such as `C:\` will not work on Linux/macOS)
- Database connections (verify connection strings are environment-appropriate)
- Windows-specific APIs or registry access

---

## 4. Verify Data Layer (`Bookstore.Data`)

- Confirm that the database provider configured in `Bookstore.Data` is compatible with cross-platform .NET. For example, if Entity Framework Core is in use, ensure the correct provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is referenced.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Verify Web Application Startup (`Bookstore.Web`)

Run the web application locally to confirm it starts without errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts and listens on the expected port.
- All routes resolve correctly.
- Static files are served as expected.
- Any authentication or session middleware is functioning correctly.

---

## 6. Review Configuration Files

- Ensure `appsettings.json` contains the correct configuration for the target environment.
- If the project previously used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or environment variables.
- Confirm that connection strings and any secrets are not hardcoded and are managed appropriately for the target environment.

---

## 7. Test Cross-Platform Behavior (If Applicable)

If the application will be deployed to a non-Windows host, test it on the target operating system. Specific areas to verify:

- File path separators (`/` vs `\`)
- Case sensitivity in file and directory names
- Any use of `System.Drawing` or other Windows-specific libraries, which may require additional packages such as `System.Drawing.Common` with native dependencies

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.