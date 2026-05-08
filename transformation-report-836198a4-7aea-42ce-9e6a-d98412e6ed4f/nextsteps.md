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

Check the output for any warnings that, while non-blocking, may indicate areas of concern such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully, paying attention to any tests that were passing before the transformation but are now failing.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Walk through the primary user flows such as browsing books, managing inventory, and any data access operations to confirm that the application behaves as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version of .NET, for example `net8.0`. Ensure consistency across all three projects:

- `app/Bookstore.Domain/Bookstore.Domain.csproj`
- `app/Bookstore.Data/Bookstore.Data.csproj`
- `app/Bookstore.Web/Bookstore.Web.csproj`

### 6. Review Data Layer

Since `Bookstore.Data` handles data access, confirm that:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`) is compatible with the target framework version.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply pending migrations to the database if needed:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check Configuration Files

Review `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to the JSON-based configuration system.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is as expected:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.