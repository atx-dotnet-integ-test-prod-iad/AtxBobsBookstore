# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Verify that all three projects build without warnings or errors. Address any warnings that may indicate compatibility concerns with the target framework.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project is still referencing `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages and code in each project for any remaining Windows-specific APIs or libraries, such as:

- `Microsoft.Win32` namespace usage
- `System.Windows.Forms` or `System.Drawing` (non-cross-platform versions)
- COM interop dependencies
- Windows registry access

Replace or abstract any such dependencies with cross-platform alternatives where applicable.

---

## 5. Run the Existing Test Suite

If the solution contains test projects, execute them to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failures may indicate behavioral differences introduced during the migration.

---

## 6. Manual Functional Testing

Start the `Bookstore.Web` project locally and perform manual testing of core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically validate:

- Database connectivity through `Bookstore.Data`
- Domain logic behavior in `Bookstore.Domain`
- All major web routes and pages render correctly
- Any authentication or authorization flows function as expected

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that migrations are up to date and apply correctly against the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

Confirm the schema matches expectations after migration.

---

## 8. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are correct for the target environment
- Any paths or file references use cross-platform path separators
- Secrets are not hardcoded and are managed through environment variables or a secrets manager

---

## 9. Publish the Application

Once validation is complete, publish the application for the target runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.