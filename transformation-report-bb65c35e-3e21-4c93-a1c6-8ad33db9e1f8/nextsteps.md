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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project is still referencing `net48` or any other .NET Framework moniker unless intentional.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in modern .NET. Review the following areas manually:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using `Microsoft.EntityFrameworkCore` and not the legacy `System.Data.Entity` namespace. Update any `DbContext` usage, connection string configuration, and migrations accordingly.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm it has been migrated to ASP.NET Core. Check `Startup.cs` or `Program.cs` for proper middleware registration, dependency injection setup, and routing configuration.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or configuration-related code is compatible with modern .NET behavior.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic tests for the domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Core application routes and pages load correctly.
- Any authentication or authorization middleware functions as expected.

---

## 7. Review Configuration Files

In .NET Framework projects, configuration was handled via `Web.config` or `App.config`. In modern .NET, this is typically handled via `appsettings.json`. Confirm:

- Connection strings have been moved to `appsettings.json`.
- Any environment-specific settings use `appsettings.{Environment}.json`.
- Secrets are not stored in source-controlled configuration files. Use `dotnet user-secrets` for local development.

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.