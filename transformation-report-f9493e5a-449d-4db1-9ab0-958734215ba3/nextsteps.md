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

Address any warnings that surface, particularly those related to nullable reference types, deprecated APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` namespaces
- Windows Registry access
- COM interop references
- Any package with a `windows` target framework moniker (e.g., `net8.0-windows`)

If any are found, evaluate whether a cross-platform alternative exists or whether the dependency is strictly necessary.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target framework.
- Any migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be updated or recreated, run:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate functional correctness after the migration:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider creating one targeting the `Bookstore.Domain` project first, as it is the most independent layer.

---

## 7. Run the Web Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify core functionality such as data retrieval, form submissions, and page rendering.
- Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains valid configuration for the current environment, including:

- Connection strings
- Logging settings
- Any environment-specific values that may have previously been stored in `Web.config`

If the project was migrated from ASP.NET Framework, ensure that `Web.config` settings have been fully transferred to `appsettings.json` and that the application is reading them using `IConfiguration`.

---

## 9. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.