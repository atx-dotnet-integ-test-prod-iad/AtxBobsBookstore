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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding with any builds or tests.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any are found, update the affected packages in the relevant `.csproj` files using:

```bash
dotnet add <project-path> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, scan the projects for any APIs or packages that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured for cross-platform use. Avoid SQL Server LocalDB in production environments on non-Windows systems.
- **`Bookstore.Web`**: Confirm that no `System.Web` references remain. These are not supported in .NET Core or later.
- **`Bookstore.Domain`**: Check for any use of Windows registry, COM interop, or Windows-specific file path assumptions.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

If no test project exists, consider writing integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding to deployment.

---

## 6. Validate the Web Application Locally

Run the web application locally to confirm it starts and functions correctly.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connections are established successfully.
- Core application routes and pages load as expected.
- Any authentication or session management behaves correctly.

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are properly configured. Pay particular attention to:

- **Connection strings**: Confirm they are valid for the target environment and database provider.
- **Logging configuration**: Verify log levels are appropriate for production.
- **Any secrets**: Ensure sensitive values are not hardcoded and are instead managed via environment variables or a secrets manager such as the .NET Secret Manager or Azure Key Vault.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present.

---

## 9. Verify Runtime on Target Environment

Before final deployment, confirm that the target server or hosting environment has the correct .NET runtime installed.

```bash
dotnet --info
```

The runtime version on the target machine must match or be compatible with the `TargetFramework` specified in `Bookstore.Web.csproj`.