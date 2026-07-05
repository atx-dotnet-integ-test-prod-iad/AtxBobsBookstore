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

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` (or `appsettings.Development.json`) are valid and point to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load and basic functionality such as browsing, data retrieval, and form submissions work as expected.

### 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET. Common areas to review include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific registry or file path assumptions.
- Any use of `HttpContext` or `Session` that may require updated middleware configuration in ASP.NET Core.

### 8. Review Warnings in Build Output

Even with a clean build, review any compiler warnings. Warnings related to nullable reference types, obsolete APIs, or deprecated packages should be addressed to ensure long-term maintainability.