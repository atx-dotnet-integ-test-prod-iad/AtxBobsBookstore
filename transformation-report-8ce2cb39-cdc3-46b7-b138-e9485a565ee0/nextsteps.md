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

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core or data access configuration is functioning correctly:

- Check that connection strings in `appsettings.json` are valid and point to the correct database.
- If Entity Framework Core is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output and verify that the application loads and core functionality works correctly.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older or unsupported version is present, update it to a supported release and re-run the build and test steps above.

### 7. Review Platform-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific registry or file path assumptions.
- Any use of `AppDomain` or remoting APIs.

Address any identified usages by replacing them with the recommended cross-platform equivalents.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.