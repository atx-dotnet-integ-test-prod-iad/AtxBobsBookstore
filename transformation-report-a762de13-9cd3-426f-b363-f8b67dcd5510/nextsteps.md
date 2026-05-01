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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests should be investigated before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves correctly end-to-end
- All primary routes and pages in `Bookstore.Web` load without errors

### 5. Review the Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET
- `HttpContext` and related types if they were used outside of ASP.NET Core conventions
- Configuration APIs that previously relied on `Web.config` or `App.config`
- Entity Framework 6 vs Entity Framework Core differences if `Bookstore.Data` uses an ORM

### 7. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

### 8. Database Migration Check

If Entity Framework Core is in use within `Bookstore.Data`, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, create a new migration and apply it to the target database:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected files are present, including:

- The main application assembly
- `appsettings.json` and any environment-specific variants such as `appsettings.Production.json`
- Static web assets if applicable

### 3. Configure the Target Environment

On the target server or hosting environment, ensure the correct .NET runtime version is installed. You can verify this with:

```bash
dotnet --list-runtimes
```

Install the matching runtime if it is not present before deploying the published output.