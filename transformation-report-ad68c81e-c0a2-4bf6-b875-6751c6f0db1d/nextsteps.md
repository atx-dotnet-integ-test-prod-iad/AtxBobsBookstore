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

Check the output for any warnings, particularly around nullable reference types, obsolete APIs, or platform compatibility annotations, as these can indicate areas that may cause runtime issues even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references an appropriate and supported version, for example `net8.0`. Avoid using end-of-life versions such as `net5.0` or `net6.0` unless there is a specific constraint.

### 5. Verify Runtime Behavior of the Web Project

Navigate to the `Bookstore.Web` project directory and run the application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following areas, which are commonly affected by migrations from legacy ASP.NET to ASP.NET Core:

- **Authentication and Authorization**: Middleware configuration and cookie behavior may differ.
- **Session and State Management**: `System.Web.SessionState` is not available in ASP.NET Core. Confirm that session handling has been migrated correctly.
- **HTTP Context Access**: Direct use of `HttpContext.Current` is not supported in ASP.NET Core. Verify that `IHttpContextAccessor` is used where needed.
- **Configuration**: Ensure `Web.config` settings have been migrated to `appsettings.json` and that the `IConfiguration` interface is used to access them.
- **Static Files**: Confirm that static file middleware is configured in `Program.cs` or `Startup.cs`.

### 6. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that the database connection string in `appsettings.json` is correct and that the data layer can connect successfully at runtime. If Entity Framework is used, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check for Windows-Specific API Usage

Run the .NET compatibility analyzer to identify any remaining usage of Windows-specific APIs that may not function correctly on Linux or macOS:

```bash
dotnet build /p:PlatformTarget=AnyCPU /p:Nullable=enable
```

Additionally, review the code for any references to `Microsoft.Win32`, `System.Drawing`, or registry access, which are either unavailable or require additional packages on non-Windows platforms.

### 8. Deployment

Once the application has been validated locally, publish the application using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm that all required assets, configuration files, and dependencies are present before deploying to the target environment.