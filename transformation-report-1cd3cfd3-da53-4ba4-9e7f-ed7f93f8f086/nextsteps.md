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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently on cross-platform .NET compared to .NET Framework.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, it is worth adding them to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`, such as data access logic and domain model behavior.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection string in `appsettings.json` within `Bookstore.Web` points to the correct database instance for your environment.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output and manually verify the following:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows behave as expected.

---

## 6. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but may behave differently or be unavailable in cross-platform .NET. Common areas to inspect include:

- `System.Web` references — these are not available in modern .NET and should have been replaced during transformation.
- Windows Registry access (`Microsoft.Win32.Registry`).
- `AppDomain` usage beyond what is supported in .NET Core and later.
- File path separators — use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes.

---

## 7. Review `appsettings.json` and Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings.
- Application-specific settings.
- Logging configuration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy it to your target hosting environment, such as IIS, Azure App Service, or a Linux server running the ASP.NET Core runtime.

For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed on the server and that the application pool is set to **No Managed Code**.