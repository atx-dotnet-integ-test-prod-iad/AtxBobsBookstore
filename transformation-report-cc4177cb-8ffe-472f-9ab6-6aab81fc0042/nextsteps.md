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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility concerns, such as obsolete API usage or nullable reference warnings, even if they do not prevent compilation.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still under active or LTS support.

---

## 4. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contain the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant configuration values have been migrated to the appropriate `appsettings.json` structure.
- Ensure any environment-specific settings are handled using the `IConfiguration` pattern rather than `ConfigurationManager`, which has limited support in cross-platform .NET.

---

## 5. Check Entity Framework or Data Access Layer

In `Bookstore.Data`, verify the following:

- If using Entity Framework Core, confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core logic:

```bash
dotnet test
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` and `Bookstore.Data` to verify business logic and data access behavior before deploying.

---

## 7. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application's key pages and features.
- Monitor the console output for any runtime exceptions or middleware configuration issues.
- Check that database connectivity is functioning as expected.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review the `Program.cs` file (or `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order.
- Authentication and authorization, if applicable, are configured correctly for ASP.NET Core.
- Static files, routing, and any legacy HTTP modules or handlers have been replaced with their ASP.NET Core equivalents.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present before deploying to the target environment.