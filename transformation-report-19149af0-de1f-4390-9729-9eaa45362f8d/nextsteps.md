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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still use Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:
- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions
- COM interop usage
- `System.Web` references that may have been shimmed

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` and `Bookstore.Data` projects to validate core business logic and data access behavior.

---

## 6. Validate Database Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations were generated under the old framework, consider running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm the schema is applied correctly against a development database instance.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:
- Pages load without exceptions
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)

---

## 8. Validate Configuration Files

Review `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to ensure:
- Connection strings are correct for the target environment
- Any configuration keys previously sourced from `Web.config` have been properly migrated
- No references to `System.Configuration.ConfigurationManager` remain unless the `System.Configuration.ConfigurationManager` NuGet package has been explicitly added

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.