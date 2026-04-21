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

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while not blocking the build, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If test projects exist in the solution, execute them to verify that business logic and data access behavior remain correct after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated before proceeding.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that the data layer connects correctly to the target database. Check the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are correct for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application and verify it functions as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows to confirm that behavior matches the legacy version.

### 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Verify the following:

- `web.config` transforms or IIS-specific settings have been replaced or are no longer relied upon for core configuration.
- Environment-specific settings are handled via `appsettings.{Environment}.json` files.
- Any file paths hardcoded in configuration use `Path.Combine` or forward-slash-compatible formats to ensure cross-platform compatibility.

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently across operating systems. Search the codebase for usage of:

- `Registry` access (`Microsoft.Win32`)
- Windows-specific file path assumptions
- `System.Drawing` (GDI+), which has limited support outside Windows without additional packages

Address any findings by replacing them with cross-platform alternatives.

### 8. Publish the Application

Once validation is complete, publish the application to the desired target:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target hosting environment.