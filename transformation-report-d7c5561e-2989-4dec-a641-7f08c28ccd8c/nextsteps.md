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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during restoration, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the error-free state holds under a clean build:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns that should be addressed before deployment.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to specifically verify include:

- **Database connectivity** – Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in your configuration files (`appsettings.json`) and ensure they are appropriate for the target environment.
- **Entity Framework migrations** – If the project uses Entity Framework, verify that migrations apply cleanly:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic** – Exercise the key business logic paths exposed through `Bookstore.Domain` to confirm correct behavior.
- **Web routes and pages** – Navigate through the application's pages and endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Compare the original `Web.config` or `App.config` files from the legacy project against the new `appsettings.json` and `appsettings.{Environment}.json` files. Confirm that all relevant settings have been carried over, including:

- Connection strings
- Application-specific settings
- Logging configuration
- Authentication or authorization settings, if applicable

### 6. Check for Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Run the .NET Upgrade Compatibility Analyzer to surface any runtime-level compatibility concerns that do not produce build errors:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
dotnet build
```

Review any analyzer diagnostics that are reported.

### 7. Validate Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

## Deployment

Once all validation steps above pass without issue, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.