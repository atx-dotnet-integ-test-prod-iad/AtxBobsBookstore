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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values (connection strings, app settings, etc.) that were previously in `Web.config`.
- Environment-specific overrides are handled via `appsettings.Development.json`, `appsettings.Production.json`, or environment variables.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to `appsettings.json`.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the data access layer is functioning correctly:

- If using Entity Framework Core, ensure migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` points to the correct database instance.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the displayed local URL (e.g., `https://localhost:5001`) and confirm the application loads.
- Exercise the primary workflows (browsing, searching, and any data entry flows) to catch any runtime issues not surfaced at compile time.

---

## 6. Check for Runtime Compatibility Issues

Even with a clean build, certain areas require manual verification after a .NET Framework to .NET migration:

- **HTTP Modules and Handlers**: These do not exist in ASP.NET Core. Confirm they have been replaced with the equivalent middleware.
- **Session and Authentication**: Verify that session state and any authentication mechanisms (e.g., cookies, Identity) are configured correctly in `Program.cs` or `Startup.cs`.
- **Static Files**: Ensure static assets (CSS, JS, images) are served correctly via the static files middleware.
- **Global Error Handling**: Confirm that exception handling middleware is in place.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

The contents of the `./publish` folder can then be deployed to the target hosting environment, such as IIS, Azure App Service, or a Linux server running the .NET runtime.

- For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed on the server.
- For self-contained deployments (no runtime required on the server), add `--self-contained true` and specify a runtime identifier:

```bash
dotnet publish --project Bookstore.Web --configuration Release --self-contained true --runtime win-x64 --output ./publish
```