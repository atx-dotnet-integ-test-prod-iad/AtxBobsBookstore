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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior is preserved:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are valid and point to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, searching, and any data entry features behave as expected.

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may have been available in .NET Framework but behave differently or have reduced functionality in cross-platform .NET. Review the following areas:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, certain cryptography providers, or COM interop.
- Configuration patterns that relied on `Web.config` or `App.config` should now be handled via `appsettings.json` and the `Microsoft.Extensions.Configuration` stack.

### 8. Review Middleware and HTTP Pipeline

In `Bookstore.Web`, confirm that the HTTP pipeline configured in `Program.cs` or `Startup.cs` includes all necessary middleware in the correct order, including authentication, static files, routing, and error handling.