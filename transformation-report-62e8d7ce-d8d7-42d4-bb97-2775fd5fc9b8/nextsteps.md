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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements targeting .NET.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Validate Data Access Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is correctly configured for the target database provider.
- If migrations are used, verify that existing migrations are compatible with the new runtime by running:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- Apply migrations to a development or staging database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data
```

---

## 5. Validate the Web Application (`Bookstore.Web`)

- Run the web application locally to confirm it starts without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application's key pages and features to confirm that routing, views, and data access are functioning correctly.
- Check that any configuration values previously stored in `Web.config` have been correctly migrated to `appsettings.json` or environment variables.

---

## 6. Review Platform-Specific Code

Even without build errors, certain APIs that were available in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Review the codebase for usage of the following:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 7. Review and Update Configuration

- Confirm that `appsettings.json` contains all necessary configuration entries previously found in `Web.config` or `App.config`.
- Verify connection strings are correct for the target environment.
- Ensure any environment-specific settings are separated using `appsettings.Development.json` and `appsettings.Production.json` as appropriate.

---

## 8. Prepare for Deployment

Once local validation is complete:

- Publish the application using the .NET CLI:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

- Verify the contents of the `./publish` directory to ensure all necessary files are present.
- Confirm the target server or hosting environment has the appropriate .NET runtime installed. You can check the required runtime version in the `Bookstore.Web.csproj` file under the `<TargetFramework>` property.