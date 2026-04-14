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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for their cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

In `Bookstore.Data`, confirm the following:

- The database provider (e.g., Entity Framework Core, Dapper) is compatible with cross-platform .NET.
- Connection strings in configuration files (`appsettings.json`) are correct for the target environment.
- Any database migrations are up to date. If using Entity Framework Core, run:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 5. Validate the Web Layer

In `Bookstore.Web`, confirm the following:

- The application starts without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- All routes, controllers, and views (or Razor Pages) render correctly.
- Static assets are served properly.
- Any authentication or authorization middleware is functioning as expected.
- Configuration previously stored in `Web.config` has been correctly moved to `appsettings.json` or environment variables.

---

## 6. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or dependencies that may cause issues on non-Windows environments:

- `System.Web` references (should have been replaced with ASP.NET Core equivalents)
- Windows Registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- COM interop or P/Invoke calls targeting Windows libraries

---

## 7. Review Logging and Configuration

Ensure that:

- Logging is configured using `Microsoft.Extensions.Logging` or a compatible provider.
- Environment-specific configuration (development, staging, production) is handled via `appsettings.{Environment}.json` files or environment variables.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, then deploy to the target environment.