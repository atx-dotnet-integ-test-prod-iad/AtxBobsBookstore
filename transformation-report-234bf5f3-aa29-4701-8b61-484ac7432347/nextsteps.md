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

Address any warnings that appear, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing framework versions between projects in the same solution can cause compatibility issues at runtime.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, review each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- Windows Registry access
- `Microsoft.Web.*` packages not compatible with cross-platform .NET

Replace or remove any such dependencies to ensure true cross-platform compatibility.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target .NET version.

---

## 7. Run the Web Application Locally

Start the web application to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load correctly, data is retrieved as expected, and no unhandled exceptions occur.

---

## 8. Review Application Configuration

Confirm that configuration previously handled by `Web.config` has been fully migrated to `appsettings.json` or environment variables. Key areas to check include:

- Connection strings
- Application settings
- Logging configuration
- Authentication settings

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.