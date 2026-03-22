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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows **0 Error(s)** and review any warnings that may indicate deprecated APIs or framework-specific code that could cause runtime issues.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding unit tests for critical logic in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core (or other ORM) setup is functioning correctly.

- Check that your connection strings in `appsettings.json` are updated for the target environment.
- If using Entity Framework Core migrations, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema matches expectations after migration.

---

## 5. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and verify that core pages load correctly.
- Check for any runtime exceptions that would not have been caught at compile time, such as missing configuration values, changed API behaviors, or platform-specific code paths.

---

## 6. Review Platform-Specific Code

Search the codebase for any APIs or patterns that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Web` references (these are not available in modern .NET)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns.

---

## 7. Review Configuration and Middleware

In ASP.NET Core, configuration and middleware setup differ significantly from ASP.NET Framework:

- Confirm that `Program.cs` and/or `Startup.cs` correctly registers all required services and middleware.
- Verify that authentication, authorization, session, and routing configurations have been correctly translated.
- Ensure `appsettings.json` contains all configuration values previously held in `Web.config` or `App.config`.

---

## 8. Validate Logging

Confirm that logging is configured correctly using the ASP.NET Core logging abstractions (`Microsoft.Extensions.Logging`). If the original project used a third-party logger such as log4net or NLog, verify that the appropriate provider package has been added and configured.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.