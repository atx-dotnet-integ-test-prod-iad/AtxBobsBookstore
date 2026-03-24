# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was captured in the initial error report:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks (e.g., `net6.0` in one project and `net8.0` in another) can cause runtime compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check:

- `Bookstore.Data`: Verify that the database provider (e.g., Entity Framework Core) is configured for cross-platform use and does not rely on Windows Authentication or MSSQL-specific features that require additional setup.
- `Bookstore.Web`: Confirm that no `System.Web` references remain, as this namespace is not available in cross-platform .NET. Ensure middleware and configuration use the `Microsoft.AspNetCore` equivalents.
- `Bookstore.Domain`: Check for any use of `System.Drawing` or other Windows-only libraries.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify core functionality before deployment.

---

## 6. Test the Application Locally

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:
- Application starts without runtime exceptions.
- Database connections are established successfully.
- Core application routes and pages load correctly.
- Any authentication or authorization flows work as intended.

---

## 7. Review Configuration Files

Ensure `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) are properly set up. Legacy projects often stored configuration in `Web.config` or `App.config`, which should now be migrated to the `appsettings.json` format.

---

## 8. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assets, and dependencies are present before deploying to the target environment.