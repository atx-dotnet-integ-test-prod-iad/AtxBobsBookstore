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

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete APIs or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failures that were passing before the migration should be investigated and resolved before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` or `appsettings.Development.json` to ensure they are valid for the target environment.
- **Domain logic**: Exercise key business logic paths to confirm `Bookstore.Domain` behaves correctly.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- All configuration values previously stored in `Web.config` have been migrated to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.{Environment}.json` files.
- Any configuration transforms that existed previously have been accounted for.

### 6. Check for Platform-Specific Code

Even without build errors, runtime issues can arise from code that relied on Windows-specific behavior. Review the codebase for:

- Use of `System.Web` APIs that may have been shimmed during transformation.
- Windows registry access or Windows-specific file paths.
- Any P/Invoke calls or native library dependencies.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the project targets a version that is approaching or has reached end of life, consider updating to a current supported version of .NET.

### 8. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy it to the target hosting environment. Ensure the target server has the correct .NET runtime version installed.