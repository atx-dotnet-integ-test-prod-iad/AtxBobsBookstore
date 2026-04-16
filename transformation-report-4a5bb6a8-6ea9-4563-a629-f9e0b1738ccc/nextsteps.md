# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore and Build the Solution

Run the following commands from the root of the solution to confirm a clean restore and build:

```bash
dotnet restore
dotnet build --configuration Release
```

Verify that the output reports zero errors and zero warnings, or review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 2. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 3. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`System.Web` dependencies**: This namespace is not available in cross-platform .NET. If any code references it indirectly through third-party libraries, runtime errors may occur.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it references `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` (6.x) package, unless EF6 on .NET is intentional.
- **Configuration**: Ensure `Web.config` or `App.config` based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` stack.

---

## 4. Run Existing Tests

If the solution contains test projects, execute them to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by migration-related behavioral changes.

---

## 5. Manual Runtime Validation

Start the web application locally and exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Validate the following manually:

- Application starts without exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core pages and endpoints return expected responses.
- Any authentication or authorization flows behave correctly.

---

## 6. Review NuGet Package Compatibility

Run the following command to check for outdated or vulnerable packages:

```bash
dotnet list package --outdated
dotnet list package --vulnerable
```

Update packages where appropriate, particularly any that were carried over from the legacy project and may have .NET Framework-specific builds.

---

## 7. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.