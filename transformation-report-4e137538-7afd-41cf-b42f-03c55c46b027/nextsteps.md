# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your database migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or missing, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify the following:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows function as expected
- Static assets (CSS, JavaScript, images) are served correctly

---

## 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Production.json`) to confirm the following:

- Connection strings are correct for the target environment
- Any configuration keys that were previously in `Web.config` have been properly migrated to the `appsettings.json` format
- Logging configuration is appropriate for the target environment

---

## 7. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including:

- The compiled application assemblies
- The `appsettings.json` file
- Static web assets under `wwwroot`

---

## 8. Deploy to the Target Environment

Copy the contents of the `./publish` directory to your target hosting environment. Depending on your hosting setup, additional steps may include:

- Configuring IIS with the ASP.NET Core Hosting Bundle if hosting on Windows
- Setting the `ASPNETCORE_ENVIRONMENT` environment variable appropriately (e.g., `Production`)
- Ensuring the application pool or service account has the necessary permissions to access the database and file system