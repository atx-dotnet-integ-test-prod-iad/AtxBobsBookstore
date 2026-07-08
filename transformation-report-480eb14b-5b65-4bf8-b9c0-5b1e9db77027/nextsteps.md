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

Check the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Launch the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, confirm the following areas are functioning correctly:

- **Database connectivity**: Ensure `Bookstore.Data` connects to the database without issues. Check that Entity Framework migrations, if any, are compatible with the new runtime.
- **Domain logic**: Verify that business logic in `Bookstore.Domain` produces expected results.
- **Web layer**: Navigate through the application and confirm that pages render correctly, forms submit properly, and no runtime exceptions are thrown.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review the code for any use of APIs that have been removed or significantly changed between the legacy .NET Framework and modern .NET. Common areas to inspect include:

- `System.Web` references, which are not available in modern .NET and should have been replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage patterns.
- Configuration APIs (`ConfigurationManager` vs. `Microsoft.Extensions.Configuration`).
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.

### 7. Review Database Migrations

If the project uses Entity Framework, verify that all existing migrations are compatible:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Inspect Application Logs

After running the application, review the console output and any configured log sinks for exceptions or warnings that may not surface during a build but indicate runtime issues.