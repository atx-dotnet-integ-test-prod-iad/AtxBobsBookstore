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

Review the output for any warnings that, while not blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- Connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible in the new environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you are using a database provider that required a platform-specific driver (e.g., older SQL Server or Oracle drivers), confirm the NuGet package being used is compatible with cross-platform .NET.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at a minimum:

- The application starts without runtime exceptions.
- Pages load and return expected data.
- Any authentication or authorization flows work correctly.
- Static assets (CSS, JavaScript, images) are served properly.

### 6. Review Configuration Files

Compare the original `Web.config` (if present from the legacy project) with the new `appsettings.json` to ensure all settings were carried over, including:

- Connection strings
- Application-specific settings
- Logging configuration
- Any environment-specific values

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unavailable at runtime on non-Windows platforms. Search the codebase for usage of the following and test them explicitly:

- `System.Drawing` (GDI+ is not fully supported cross-platform without additional packages)
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- COM interop

### 8. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported .NET version.

### 9. Deploy to Target Environment

Once local validation is complete:

1. Publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

2. Copy the contents of the `./publish` folder to your target server or hosting environment.
3. Ensure the correct .NET runtime version is installed on the target machine.
4. Verify the application starts and functions correctly in the target environment using the same checks performed locally.