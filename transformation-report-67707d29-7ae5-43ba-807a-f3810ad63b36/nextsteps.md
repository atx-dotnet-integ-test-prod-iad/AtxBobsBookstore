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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since the solution includes a `Bookstore.Data` project, confirm that the data access layer functions correctly:

- Check the connection strings in `appsettings.json` or `appsettings.Development.json` to ensure they are valid for the target environment.
- If Entity Framework Core is in use, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality works as expected, including any pages or endpoints that interact with the `Bookstore.Domain` and `Bookstore.Data` layers.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Confirm the following:

- `Web.config` transformations are no longer in use; settings should be in `appsettings.json`.
- Any environment-specific configuration is handled via `appsettings.{Environment}.json` or environment variables.
- Static file handling and middleware configuration in `Program.cs` or `Startup.cs` are correctly set up for the target environment.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but may behave differently or require replacement in cross-platform .NET:

- `System.Web` references should have been removed; confirm no remnants exist.
- Windows-specific APIs (e.g., registry access, Windows identity) should be replaced or conditionally compiled if cross-platform support is required.
- File path handling should use `Path.Combine` and avoid hardcoded backslashes.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present before deploying to the target environment.