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

Address any warnings that appear, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that your database migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present and pending, apply them to your development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure that the connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for your environment.

---

## 5. Run the Application Locally

Start the web application locally to verify that it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration and Environment Settings

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Verify the following:

- `Web.config` transformations have been replaced with `appsettings.json` and `appsettings.{Environment}.json` where applicable
- Any settings previously stored in `Web.config` (such as connection strings, app settings, or custom configuration sections) have been moved to the appropriate `appsettings.json` file
- Environment-specific values are not hardcoded and are instead sourced from environment variables or user secrets during development

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or throw exceptions at runtime on non-Windows platforms. Review the codebase for usage of the following:

- `System.Drawing` (GDI+ is not fully supported cross-platform without additional packages such as `System.Drawing.Common`)
- Windows Registry access via `Microsoft.Win32.Registry`
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- COM interop or P/Invoke calls targeting Windows-only libraries

Replace or conditionally compile any such usages if cross-platform support is a requirement.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.