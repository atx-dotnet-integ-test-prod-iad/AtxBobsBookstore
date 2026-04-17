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

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that your database connection strings in `appsettings.json` (or equivalent configuration files) are correctly configured for the target environment. If Entity Framework is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, consider running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, data retrieval, and form submissions work as expected.

### 6. Review Configuration Files

Check the following areas for any configuration values that may have been specific to the legacy .NET Framework and need updating:

- `web.config` references that may not apply to the new `appsettings.json` model
- Authentication and authorization middleware configuration in `Program.cs` or `Startup.cs`
- Any hardcoded file paths that may have used Windows-specific path separators

### 7. Check for Runtime Compatibility Issues

Some APIs behave differently or are unavailable in cross-platform .NET. Review the following:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET
- Any Windows-specific APIs such as the registry or COM interop
- Third-party libraries that may not have cross-platform compatible versions

If any such usages exist, they will need to be replaced with supported alternatives.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.