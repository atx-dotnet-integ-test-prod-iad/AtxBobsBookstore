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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer Behavior

Since the solution includes a `Bookstore.Data` project, verify the following:

- Confirm the correct version of Entity Framework (Core) is referenced and compatible with the new target framework.
- If database migrations are used, run the following to ensure the migration state is valid:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to a test database and verify schema correctness:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary workflows such as browsing, searching, and any data entry forms.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains all necessary configuration values previously held in `Web.config` or `App.config`.
- Verify connection strings, logging configuration, and any environment-specific settings are correctly defined.
- Check that `appsettings.Development.json` and `appsettings.Production.json` are configured appropriately for each environment.

### 7. Check for Runtime-Only Issues

Some issues do not surface at build time and only appear at runtime. Pay attention to:

- Reflection-based code that may behave differently under .NET's updated type system.
- Any use of `System.Web` APIs that may have been replaced with ASP.NET Core equivalents during transformation — verify those replacements function correctly.
- Third-party libraries that may have platform-specific behavior.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.