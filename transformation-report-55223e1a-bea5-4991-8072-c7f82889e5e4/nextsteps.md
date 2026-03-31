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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. Check connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or Windows Authentication, verify that these flows work correctly under the new runtime.
- **Static files and routing**: Confirm that pages, assets, and API routes resolve correctly.
- **Configuration**: Ensure that any settings previously stored in `Web.config` or `App.config` have been properly migrated to `appsettings.json` or environment variables.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another legacy moniker, it should be updated to a supported cross-platform TFM.

### 6. Check for Platform-Specific API Usage

Run the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining usage of Windows-only APIs within `Bookstore.Domain` or `Bookstore.Data`:

```bash
dotnet tool install -g dotnet-apicompat
```

This is particularly relevant if the data layer uses technologies such as `System.Data.OleDb` or other Windows-specific libraries.

### 7. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` rather than `EntityFramework` (the legacy package).
- Migrations are present and up to date. Run the following to verify:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) matches the target database.

### 8. Publish the Application

Once runtime behavior has been validated, publish the application to confirm the output is complete and self-contained:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.