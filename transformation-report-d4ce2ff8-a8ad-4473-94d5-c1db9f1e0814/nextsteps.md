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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are correct and point to the intended database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are pending or missing, generate and apply them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the URL shown in the console output (e.g., `https://localhost:5001`).
- Manually test core application flows such as browsing, searching, and any data entry features.
- Check the console and application logs for any runtime exceptions or warnings.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that were available in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Review the following areas manually:

- Any use of `System.Web` namespaces should have been fully replaced. Confirm no remnants exist.
- `HttpContext`, session handling, and authentication middleware should be using the ASP.NET Core equivalents.
- File path operations should use `Path.Combine` and avoid hardcoded backslashes to ensure cross-platform compatibility.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues between them.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files, static assets, and configuration files are present.