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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for cross-platform compatible versions and update the `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Configuration Files

### `appsettings.json`
- Confirm that connection strings and any environment-specific settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and `appsettings.{Environment}.json`.
- Ensure sensitive values are not hardcoded and are instead referenced via environment variables or a secrets manager.

### `Program.cs` / `Startup.cs`
- Verify that middleware, dependency injection registrations, and service configurations are complete and reflect what was previously configured in the legacy project.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- If the project uses Entity Framework, confirm the correct version of EF Core is referenced and that the `DbContext` configuration is valid.
- Run any existing migrations or generate a new migration to verify the model is consistent with the database schema:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations already exist, verify they apply cleanly against a local development database.

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test
```

- Review any failing tests and determine whether failures are due to migration issues or pre-existing problems.
- Pay particular attention to tests covering the domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

---

## 6. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application and exercise key workflows such as browsing, searching, and any data entry forms.
- Check the console output and application logs for runtime exceptions or warnings.
- Verify that database connectivity is functioning correctly by performing operations that read from and write to the database.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were specific to .NET Framework and may not behave identically on cross-platform .NET. Common areas to inspect include:

- `System.Web` references (these are not available in modern .NET)
- Windows Registry access
- Windows Communication Foundation (WCF) client or server usage
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify remaining compatibility concerns if needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.