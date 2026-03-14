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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference old `net4x` target frameworks, consider finding their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly:
- Nullable reference type warnings, which may indicate areas where null handling behavior has changed between .NET Framework and modern .NET.
- Obsolete API warnings, which may point to APIs that have been replaced in modern .NET.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- Connection strings and application settings have been moved to `appsettings.json` in `Bookstore.Web`.
- Any environment-specific settings are handled using `appsettings.{Environment}.json` files.
- Confirm that `Bookstore.Data` is reading connection strings from the correct configuration source, typically via dependency injection rather than `ConfigurationManager`.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is in use, ensure it has been migrated to **Entity Framework Core**. EF6 is supported on .NET but has limitations on non-Windows platforms.
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web/Program.cs` or `Startup.cs`.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Check the following:
- The application starts without exceptions in the console output.
- All pages and routes load as expected.
- Database read and write operations function correctly.
- Any authentication or authorization mechanisms behave as intended.

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

If no tests currently exist, consider writing tests that cover:
- Core domain logic in `Bookstore.Domain`.
- Data access operations in `Bookstore.Data`.
- Key HTTP endpoints in `Bookstore.Web` using `WebApplicationFactory<T>`.

---

## 7. Validate Cross-Platform Behavior

Since the goal of the migration is cross-platform support, verify the application runs correctly on the target non-Windows platform if applicable.

- Check for any remaining uses of Windows-specific APIs such as the registry, Windows identity impersonation, or Windows-only file path assumptions.
- Ensure file path separators use `Path.Combine` or `Path.DirectorySeparatorChar` rather than hardcoded backslashes.
- Verify that any cryptography or hashing code uses APIs available in .NET rather than Windows-specific `System.Security` classes.

---

## 8. Review Middleware and HTTP Pipeline

In `Bookstore.Web`, review `Program.cs` or `Startup.cs` to confirm:

- Middleware is registered in the correct order (e.g., authentication before authorization).
- Static file serving is configured if the application serves CSS, JavaScript, or image assets.
- Error handling middleware is in place for both development and production environments.