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

## Validation Steps

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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`. Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.1`, `net5.0`, or `net6.0`, consider updating to `net8.0` as those versions are out of support.

### 4. Run Unit Tests

If the solution contains test projects, execute the test suite to verify that runtime behavior is consistent with the original project:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they reflect regressions introduced during migration or pre-existing issues.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry flows, to confirm expected behavior.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- `HttpContext` usage patterns, which may have changed.
- Any Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` without the appropriate compatibility package.

If any of these are present and were not caught at build time, they may surface as runtime exceptions.

### 8. Check for Nullable Reference Type Warnings

If the projects have nullable reference types enabled (`<Nullable>enable</Nullable>`), review any compiler warnings related to nullability. These are not errors by default but can indicate potential null reference exceptions at runtime.