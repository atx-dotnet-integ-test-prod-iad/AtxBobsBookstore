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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Configuration

Check the following configuration files for correctness:

- **`appsettings.json`** – Ensure connection strings, logging settings, and any environment-specific values are properly defined.
- **`Program.cs`** / **`Startup.cs`** – Confirm that middleware, dependency injection registrations, and service configurations are compatible with the target .NET version.
- **`Bookstore.Data`** – If Entity Framework Core is in use, verify that the `DbContext` configuration and database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are targeting compatible versions.

---

## 4. Run Database Migrations

If Entity Framework Core is used for data access, verify that existing migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be updated or recreated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by behavioral differences in the new runtime or by test configuration issues.

---

## 6. Run the Application Locally

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following areas:

- Application startup without exceptions
- Database connectivity and data retrieval
- Core user-facing features such as browsing, searching, and any transactional flows
- Proper error handling and logging output

---

## 7. Review Removed or Changed APIs

Cross-reference the migrated code against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/) or the [.NET API compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) to identify any APIs that behave differently between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` usages (not available in .NET Core/5+)
- `HttpContext` and related request/response APIs
- Configuration and dependency injection patterns
- Any Windows-specific APIs if cross-platform support is required

---

## 8. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, static assets, and configuration files are present before deploying to the target server or hosting environment.