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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer connects and operates correctly:

- Verify that the connection string in `appsettings.json` (or equivalent configuration) is correct for the target environment.
- If Entity Framework is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that scaffolded or existing migrations are compatible with the current EF Core version.

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and test key user flows such as browsing, searching, and any CRUD operations.
- Check the console output and application logs for any runtime exceptions that would not have surfaced at build time.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json` or environment variables.
- Any `<system.web>` or `<httpModules>` configuration has been replaced with the appropriate ASP.NET Core middleware in `Program.cs` or `Startup.cs`.
- Authentication, authorization, and session configuration has been updated to use ASP.NET Core equivalents.

### 7. Check for Windows-Specific API Usage

Even without build errors, certain APIs may compile but fail at runtime on non-Windows platforms. Search the codebase for usage of the following:

- `System.Web` types that may have been shimmed during transformation
- Windows registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext.Current` usage, which is not directly supported in ASP.NET Core

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET.