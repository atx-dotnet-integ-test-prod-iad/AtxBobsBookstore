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

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete APIs or nullable reference type mismatches.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Launch the `Bookstore.Web` application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` or equivalent configuration files, as the configuration system differs from the legacy `Web.config` / `App.config` approach.
- **Entity Framework**: If Entity Framework is used, verify that migrations are up to date and that queries execute without error. Run `dotnet ef database update` if applicable.
- **Authentication and Authorization**: If any authentication middleware was in use, confirm it has been correctly mapped to the ASP.NET Core middleware pipeline.
- **Static files and routing**: Verify that pages, routes, and static assets (CSS, JS, images) resolve correctly in the browser.

### 5. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay attention to:

- Connection strings
- Application-specific settings
- Logging configuration

### 6. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET. Common examples include:

- `System.Web` references (should no longer be present)
- Windows Registry access
- Windows-specific file path assumptions
- `ConfigurationManager` usage (should be replaced with `IConfiguration`)

### 7. Deployment

Once the application has been validated locally, publish the application using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required assets, configuration files, and binaries are present before deploying to the target environment.