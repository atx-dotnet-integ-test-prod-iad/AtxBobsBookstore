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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific APIs

Review the codebase for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS. Common areas to inspect include:

- `Microsoft.Win32` namespace usage
- `System.Windows.Forms` or `System.Drawing` references
- Registry access
- Windows file path assumptions (e.g., hardcoded backslashes)

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly on the local machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and verify the application loads and functions as expected, including:

- Page rendering
- Database connectivity (if applicable)
- Any domain logic exposed through the UI

---

## 6. Review Entity Framework or Data Layer Configuration

If `Bookstore.Data` uses Entity Framework, verify the following:

- The database provider package is compatible with the new target framework (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql` for PostgreSQL).
- Connection strings in `appsettings.json` are correct for the target environment.
- Run any pending migrations to confirm the schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review the test results and address any failures before proceeding.

---

## 8. Publish the Application

Once validation is complete, publish the application for the target runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is self-contained or framework-dependent based on your deployment requirements. You can control this with the `--self-contained` flag and the `-r` runtime identifier, for example:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --self-contained true -r linux-x64 --output ./publish
```