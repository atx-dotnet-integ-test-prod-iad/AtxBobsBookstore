# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

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

Review the output for any warnings related to deprecated or incompatible package versions. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects so there are no framework mismatches.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any remaining dependencies on Windows-specific APIs or libraries, such as:

- `System.Web` (not available in cross-platform .NET)
- Windows Registry access
- COM interop components
- `Microsoft.Web.Infrastructure`

Replace or remove any such dependencies with cross-platform alternatives.

---

## 5. Database and Entity Framework Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The EF Core provider package is installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider).
- Any existing migrations are compatible with EF Core.
- Run the following to check pending migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral regressions introduced during the migration. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web
```

Manually test the following areas:

- Application startup and landing page rendering
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes

Check the console output and application logs for runtime exceptions or configuration errors.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains the correct configuration for the target environment, including:

- Connection strings
- Logging settings
- Any application-specific configuration previously stored in `Web.config`

If a `Web.config` was present in the original project, verify that all relevant settings have been migrated to `appsettings.json` or the appropriate .NET configuration mechanism.

---

## 9. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.