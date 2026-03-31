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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the core features of the application, including:

- Browsing and searching for books
- Any data access operations driven by `Bookstore.Data`
- Any domain logic driven by `Bookstore.Domain`

### 5. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed Windows-Specific Dependencies

Check that no references to Windows-specific libraries or APIs remain. Common areas to inspect include:

- Any use of `System.Web` namespaces, which are not available on cross-platform .NET
- References to `Microsoft.AspNet.*` packages, which should have been replaced with `Microsoft.AspNetCore.*`
- Any P/Invoke calls or registry access that may only function on Windows

### 7. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- Migrations are present and up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply migrations to a local database and confirm the schema is correct:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Configuration and Environment Settings

Confirm that configuration files such as `appsettings.json` contain the correct values for connection strings and other environment-specific settings. Verify that any settings previously stored in `Web.config` have been migrated to `appsettings.json`.

### 9. Publish the Application

Once the above steps are completed without issue, publish the application to confirm the output is valid:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.