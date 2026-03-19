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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` for any remaining references to Windows-specific packages or APIs, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry APIs
- `System.Drawing` (without the `System.Drawing.Common` NuGet package)

If any are found, evaluate whether a cross-platform alternative exists.

### 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core business logic:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences in the new runtime.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas:

- Application startup and routing
- Database connectivity through `Bookstore.Data`
- Domain logic behavior through `Bookstore.Domain`
- Any authentication or session handling, as these areas commonly differ between ASP.NET and ASP.NET Core

### 7. Validate Database Migrations

If Entity Framework Core is in use, confirm that migrations are up to date and apply cleanly:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project migrated from EF 6 to EF Core, review the migration files carefully as there are known differences in behavior between the two.

### 8. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been properly moved to `appsettings.json`. Verify that connection strings, application settings, and environment-specific values are all present and correctly structured.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected assets, static files, and configuration files are present before deploying to the target environment.