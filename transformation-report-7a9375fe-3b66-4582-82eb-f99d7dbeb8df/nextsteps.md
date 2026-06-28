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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Make sure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review each project for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop components
- `HttpContext` usage tied to `System.Web` rather than `Microsoft.AspNetCore.Http`

Replace or remove any such dependencies to ensure true cross-platform compatibility.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` and `Bookstore.Data` to verify business logic and data access behavior.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are correct for the target environment.
- Run any pending migrations to confirm the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually verify:

- Pages load without errors
- Data is read from and written to the database correctly
- Authentication and authorization behave as expected, if applicable

---

## 8. Review Application Logs

While running locally, review the console output and any configured log sinks for runtime exceptions or warnings that would not appear at build time, such as:

- Missing configuration keys
- Unhandled middleware exceptions
- Incorrect service registrations in the dependency injection container

---

## 9. Cross-Platform Smoke Test

If cross-platform support is a requirement, run the application on a non-Windows environment (Linux or macOS) to confirm there are no platform-specific runtime failures:

```bash
dotnet run --project Bookstore.Web
```

Pay attention to file path separators, case-sensitive file systems, and any platform-specific API calls that may surface only at runtime.