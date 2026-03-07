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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check for any APIs that were available in .NET Framework but behave differently or are absent in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Confirm that the Entity Framework or data access layer is using a compatible provider (e.g., `Microsoft.EntityFrameworkCore` instead of `System.Data.Entity`). Verify that database migrations, if any, are functional.
- **`Bookstore.Domain`**: Ensure that any serialization, reflection, or configuration code behaves as expected under the new runtime.
- **`Bookstore.Web`**: Confirm that the web layer has been migrated from ASP.NET (System.Web) to ASP.NET Core. Verify middleware, routing, authentication, and static file serving are configured correctly in `Program.cs` or `Startup.cs`.

---

## 4. Run the Application Locally

Start the application locally to validate basic runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and manually verify:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Authentication and authorization flows work as expected, if applicable.

---

## 5. Execute Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration:

```bash
dotnet test
```

Review the test results carefully. Failures may indicate behavioral differences between .NET Framework and cross-platform .NET that require code-level fixes.

If no tests currently exist, consider writing unit tests for critical paths in `Bookstore.Domain` and integration tests for `Bookstore.Data` to establish a baseline.

---

## 6. Review Configuration Files

Confirm that configuration has been correctly migrated:

- `Web.config` and `App.config` files are not used in cross-platform .NET. Ensure settings have been moved to `appsettings.json` or environment variables.
- Connection strings should be present in `appsettings.json` and accessible via `IConfiguration`.
- Any transforms or environment-specific config previously handled by `Web.config` transforms should now be handled through `appsettings.{Environment}.json` files.

---

## 7. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to an appropriate and supported version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid targeting `net6.0` or `net7.0` as these are out of support. Use `net8.0` or later.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.