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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net472` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in modern .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Run any pending migrations and verify the database context configuration.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to ASP.NET Core. Check `Program.cs` and `Startup.cs` (or the combined `Program.cs` in .NET 6+) for correct middleware and service registration.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or configuration-related code is compatible with modern .NET behavior.

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover:

- Domain model logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Validate Runtime Behavior

Run the web application locally and manually verify key functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- Application starts without runtime exceptions
- Database connectivity is functional (check connection strings in `appsettings.json`)
- Core user-facing pages and features load and behave as expected
- Any authentication or authorization mechanisms function correctly

---

## 7. Review Configuration Files

.NET Framework applications used `Web.config` and `App.config`. These are replaced by `appsettings.json` in modern .NET. Confirm that:

- All connection strings have been moved to `appsettings.json`
- Any environment-specific settings use `appsettings.Development.json` or environment variables
- No residual `Web.config` entries are being relied upon at runtime

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.