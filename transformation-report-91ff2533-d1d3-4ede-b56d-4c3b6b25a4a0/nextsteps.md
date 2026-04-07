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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, the code may still contain Windows-specific API calls that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings that appear after rebuilding.

### 5. Database and Data Layer Validation

Since `Bookstore.Data` is present, verify the following:

- If Entity Framework Core is in use, confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations to confirm the data model is consistent:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If EF Core is not yet in use and the project was migrated from classic ADO.NET or EF 6, consider whether a migration to EF Core is appropriate for your use case.

### 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

Address any test failures before proceeding to deployment.

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm that:

- The application starts without runtime exceptions.
- Routing and page rendering function as expected.
- Database connectivity is established and data is returned correctly.

### 8. Review `web.config` and `appsettings.json`

If the original project used `web.config` for configuration, confirm that all relevant settings (connection strings, app settings) have been moved to `appsettings.json` or environment variables, as `web.config` is not used by Kestrel-based ASP.NET Core applications in the same way.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets are present before deploying to the target environment.