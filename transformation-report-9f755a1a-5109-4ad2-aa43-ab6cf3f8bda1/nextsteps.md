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

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, certain APIs may have been carried over from the legacy project that only function correctly on Windows. Review the code in each project for usage of:

- `System.Web` namespaces
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)
- Any P/Invoke calls targeting Windows-only libraries

### 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify runtime behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

### 6. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core or other data access configuration is correct:

- Verify the connection string in `appsettings.json` is valid for your target environment.
- If using Entity Framework Core, run the following to confirm migrations are in order:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functional correctness.

### 8. Test on a Non-Windows Platform

Since the goal of the transformation was cross-platform compatibility, validate the application runs correctly on Linux or macOS if those are target deployment environments. Pay particular attention to:

- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Case-sensitive file and directory references
- Any configuration or static file references that may be case-sensitive on Linux