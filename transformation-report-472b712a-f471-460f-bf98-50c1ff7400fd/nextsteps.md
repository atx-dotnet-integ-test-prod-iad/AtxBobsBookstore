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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if the code uses Windows-specific APIs such as the registry, `System.Drawing`, or COM interop. Search the codebase for usages of these APIs and verify they are either replaced with cross-platform alternatives or guarded with runtime OS checks using `OperatingSystem.IsWindows()`.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

Review any failing tests, as they may surface runtime incompatibilities that were not caught at compile time.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the main application workflows, particularly those that interact with the data layer in `Bookstore.Data` and the domain logic in `Bookstore.Domain`.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database provider package is compatible with the target framework. Run any pending migrations against a test database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to confirm that connection strings, service endpoints, and other settings are correctly configured for the new runtime environment.

### 9. Address Remaining Warnings

After the steps above, re-run the build and collect any remaining warnings:

```bash
dotnet build --configuration Release 2>&1 | grep -i warning
```

Prioritize warnings related to obsolete APIs, nullable reference types, and platform compatibility analyzers, as these can become errors in future .NET versions.