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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the target framework is set to `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions are either end-of-life or approaching it.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs are being used without a compatibility guard. Look for usages of:

- `System.Web` (not available on cross-platform .NET)
- Windows Registry APIs
- COM interop components
- `HttpContext` from `System.Web` (should be replaced with `Microsoft.AspNetCore.Http.HttpContext`)

Run the .NET Upgrade Analyzer or the compatibility analyzer to assist:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior matches expectations:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm that pages load correctly and data access functions as expected.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration that may have previously lived in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Authentication settings
- Any custom application settings

Legacy `Web.config` or `App.config` values are not automatically read by .NET applications and must be migrated to `appsettings.json` or environment variables.

---

## 9. Validate Authentication and Authorization

If the application uses authentication, confirm the middleware is correctly configured in `Program.cs` or `Startup.cs`:

```csharp
app.UseAuthentication();
app.UseAuthorization();
```

Test login, logout, and any role-based or claims-based access control scenarios manually.

---

## 10. Publish the Application

Once the above validations pass, publish the application to verify the output is complete:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.