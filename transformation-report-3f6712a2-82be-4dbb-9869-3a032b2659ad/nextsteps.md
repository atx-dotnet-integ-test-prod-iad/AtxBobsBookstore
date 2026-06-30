# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully, as they may indicate behavioral differences between the old .NET Framework and the new cross-platform .NET runtime.
- Pay particular attention to tests covering data access logic in `Bookstore.Data`, as Entity Framework or database provider behavior may differ.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` handles persistence, verify the following:

- **Database provider**: Confirm the correct NuGet package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, etc.).
- **Connection strings**: Ensure connection strings in `appsettings.json` are correctly configured for the target environment.
- **Migrations**: If using Entity Framework Core, verify existing migrations are compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or inconsistent, consider generating a new initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Web Layer

Run the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Check that all routes resolve correctly.
- Verify that static files (CSS, JS, images) are served properly. In cross-platform .NET, static files must reside in the `wwwroot` folder and be configured via `UseStaticFiles()` in the middleware pipeline.
- If the project previously used `System.Web`, confirm that all references have been replaced with their `Microsoft.AspNetCore` equivalents.
- Review `Program.cs` and any `Startup.cs` to ensure middleware and service registrations are complete and correct.

---

## 6. Check Configuration

- Confirm that `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., development vs. production) are correctly separated.

---

## 7. Review Logging

Ensure logging is configured appropriately in `Program.cs` or `appsettings.json`. Cross-platform .NET uses `Microsoft.Extensions.Logging` by default:

```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft.AspNetCore": "Warning"
  }
}
```

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.