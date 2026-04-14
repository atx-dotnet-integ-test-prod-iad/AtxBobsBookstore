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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors are reported during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that queries return expected results. Pay attention to any Entity Framework or ADO.NET provider changes that may have been introduced.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` behave as expected.
- **Web layer**: Navigate through the application and confirm that pages render correctly, forms submit properly, and no runtime exceptions occur.

### 5. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (for example, `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues:

- **Configuration**: Confirm that `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` if applicable.
- **Database providers**: Ensure the correct NuGet package is referenced for your database (for example, `Microsoft.EntityFrameworkCore.SqlServer` instead of a legacy provider).
- **HTTP and session handling**: Verify that any `System.Web` dependencies have been fully replaced with `Microsoft.AspNetCore` equivalents.

### 7. Review Application Logs

After running the application, inspect the console output and any log files for exceptions or deprecation warnings that may not surface as build errors but could affect stability.

### 8. Publish the Application

Once the application has been validated locally, publish it to confirm the output is complete and self-contained:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files are present before deploying to the target environment.