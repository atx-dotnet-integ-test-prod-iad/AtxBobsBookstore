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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause build failures.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Pay particular attention to:

- `Bookstore.Data`: Verify Entity Framework Core is being used in place of any legacy `System.Data.Entity` (EF6) references. Confirm database migrations are intact and connection strings are correctly configured.
- `Bookstore.Web`: If this was previously an ASP.NET MVC project, confirm it has been migrated to ASP.NET Core. Verify middleware configuration in `Program.cs`, and check that authentication, session, and routing are functioning as expected.
- `Bookstore.Domain`: Confirm domain models and any data annotations are compatible with the versions of EF Core and ASP.NET Core in use.

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no tests currently exist, consider writing basic tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before deploying.

### 6. Run the Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify:

- Pages render correctly
- Database reads and writes function as expected
- No runtime exceptions appear in the console or logs

### 7. Review Configuration Files

- Ensure `appsettings.json` contains the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, confirm those values have been moved to `appsettings.json` or environment variables.
- Confirm that any environment-specific settings (e.g., `appsettings.Development.json`) are properly set up.

### 8. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.