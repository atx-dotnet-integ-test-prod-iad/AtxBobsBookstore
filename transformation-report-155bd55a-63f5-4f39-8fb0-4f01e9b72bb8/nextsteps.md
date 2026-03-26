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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows a successful build for all three projects with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp*` or `net4*`, update it to a current supported version.

---

## 4. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by issues introduced during transformation.

---

## 5. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify that:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correct and accessible.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of sync, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application to verify it runs correctly in the new runtime environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm expected behavior.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Manually review the following areas if they were used in the original project:

- `System.Web` references — these are not available in cross-platform .NET and should have been replaced during transformation.
- `HttpContext` usage — ensure it is accessed via dependency injection rather than statically.
- `ConfigurationManager` — should be replaced with `Microsoft.Extensions.Configuration`.
- `BinaryFormatter` — removed in .NET 7+; replace with a supported serialization mechanism if used.

---

## 8. Check Runtime Behavior on Target OS

If the application is intended to run on Linux or macOS, verify the following:

- File path separators use `Path.Combine()` rather than hardcoded backslashes.
- File system operations account for case-sensitive paths.
- Any Windows-specific libraries or COM interop dependencies have been removed or replaced.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.