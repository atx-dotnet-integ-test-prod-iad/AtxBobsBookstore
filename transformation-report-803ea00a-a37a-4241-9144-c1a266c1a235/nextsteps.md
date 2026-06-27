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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.
- Pay particular attention to tests that cover data access logic in `Bookstore.Data`, as Entity Framework or database provider changes are a common source of runtime issues after migration.

---

## 4. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, verify that your database migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` is correctly configured for your target environment.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise the primary workflows (e.g., browsing books, placing orders).
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that static assets, routing, and middleware are functioning as expected under the new framework.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Confirm the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all settings previously held in `Web.config` or `App.config`.
- Any environment-specific settings (connection strings, API keys) are correctly set using environment variables or user secrets for local development:

```bash
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string" --project Bookstore.Web
```

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or throw at runtime on non-Windows platforms. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 8. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and assets are present before deploying to the target environment.