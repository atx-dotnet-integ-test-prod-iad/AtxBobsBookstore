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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify all existing tests pass.
- Pay particular attention to tests covering data access logic in `Bookstore.Data`, as Entity Framework or database provider changes are common sources of runtime issues after migration.

---

## 4. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that your migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm the connection string in `appsettings.json` (or `appsettings.Development.json`) is correctly configured for your target environment.

---

## 5. Run the Application Locally

Start the web application locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise the primary workflows (e.g., browsing books, managing inventory).
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that static assets, routing, and middleware are functioning as expected under the new ASP.NET Core pipeline.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.{Environment}.json`.
- Secrets such as connection strings are handled via `dotnet user-secrets` for local development rather than being stored in plain text.

---

## 7. Validate Logging

Confirm that the logging configuration in `appsettings.json` is appropriate and that logs are being written as expected. The default ASP.NET Core logging providers (Console, Debug) should be sufficient for initial validation.

---

## 8. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.