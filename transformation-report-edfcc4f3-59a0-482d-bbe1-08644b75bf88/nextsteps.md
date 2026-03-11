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

Review the output for any warnings related to package compatibility or version conflicts. Address any flagged packages by updating or replacing them with cross-platform compatible alternatives.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the build output for any warnings, particularly those related to deprecated APIs or platform-specific code paths that may have been carried over from the legacy project.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review test results and investigate any failures. Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

### 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in your configuration file (e.g., `appsettings.json`) is correct for your target environment.
- Any database migrations are up to date by running:

```bash
dotnet ef database update
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
```

### 5. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and manually verify that core application functionality works as expected, including any pages or endpoints that interact with the database.

### 6. Review Configuration Files

Check `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) to ensure:

- Connection strings are correct.
- Any legacy `Web.config` or `App.config` settings have been properly migrated to the new configuration system.
- Logging, authentication, and middleware settings are configured appropriately for .NET.

### 7. Check for Platform-Specific Code

Search the codebase for any remaining platform-specific APIs that may not be available on non-Windows environments, such as:

- `System.Web` references
- Windows Registry access
- Windows-specific file path assumptions

Replace any such code with cross-platform equivalents where necessary.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assets, and dependencies are present before deploying to the target environment.