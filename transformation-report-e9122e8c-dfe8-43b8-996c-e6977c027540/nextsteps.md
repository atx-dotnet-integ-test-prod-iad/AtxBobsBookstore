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

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build. Pay particular attention to:

- Deprecation warnings related to APIs that may have changed between .NET Framework and modern .NET
- Nullable reference type warnings if the project has nullable context enabled
- Platform-specific API usage warnings

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any database connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible in the new environment. If Entity Framework is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of sync, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions
- Pages load and render correctly
- Data is read from and written to the database as expected
- Any authentication or authorization flows work correctly

### 6. Review Configuration Files

Ensure that settings previously held in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Common areas to check include:

- Connection strings
- Application-specific settings
- Logging configuration
- Any third-party library configuration sections

### 7. Check for Runtime-Only Issues

Some incompatibilities between .NET Framework and modern .NET do not surface as build errors but appear at runtime. Specifically review:

- Use of `System.Web` APIs, which are not available on modern .NET outside of Windows Compatibility Pack scenarios
- Reflection-based code that may behave differently
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET
- File path assumptions that may not hold on non-Windows operating systems

### 8. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

## Deployment

Once local validation is complete, publish the web application using the following command:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment. Ensure the target environment has the appropriate .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` value in the `.csproj` file.