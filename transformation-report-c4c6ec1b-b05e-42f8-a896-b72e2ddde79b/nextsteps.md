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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` all reference compatible framework versions.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, review each project for any remaining Windows-specific dependencies that may not be cross-platform compatible:

- Check for any usage of `System.Web`, `HttpContext` (classic), or Windows registry APIs.
- Review `Bookstore.Data` for any database provider configurations that may need updating (e.g., replacing `System.Data.SqlClient` with `Microsoft.Data.SqlClient`).
- Confirm that any file path operations use `Path.Combine` rather than hardcoded backslashes.

---

## 5. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and verify the application loads correctly, including any pages that interact with the data layer.

---

## 6. Validate Database Connectivity

If the application uses Entity Framework Core or another ORM:

- Confirm the connection string in `appsettings.json` is correct for the target environment.
- If using Entity Framework Core, run any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Verify that data reads and writes function correctly through the application UI or via direct API calls.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 8. Review Application Logs

After running the application, review the console and any structured log output for runtime exceptions, deprecation warnings, or configuration issues that would not surface at build time.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.