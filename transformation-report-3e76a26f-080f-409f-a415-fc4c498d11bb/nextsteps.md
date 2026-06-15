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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under cross-platform .NET compared to .NET Framework.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them now:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review all test results carefully.
- Pay particular attention to tests that cover data access logic in `Bookstore.Data`, as database providers and connection string formats can differ between .NET Framework and cross-platform .NET.
- If no tests exist, consider writing basic smoke tests for critical paths such as data retrieval and web endpoint responses before proceeding.

---

## 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that the database connection is functioning correctly:

- Check the connection string in `appsettings.json` (or equivalent configuration file) to ensure it is valid for the target environment.
- If Entity Framework Core is being used, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise the primary features.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that static assets, routing, and middleware are functioning as expected under the new hosting model (Kestrel/ASP.NET Core).

---

## 6. Review Configuration and Environment Settings

Cross-platform .NET handles configuration differently from .NET Framework:

- Confirm that `appsettings.json` and `appsettings.{Environment}.json` contain all necessary settings previously held in `Web.config` or `App.config`.
- Verify that any environment-specific values (connection strings, API keys) are correctly set for the target deployment environment.
- Check that the `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately (`Development`, `Staging`, or `Production`).

---

## 7. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all required files are present.
- Verify that no development-only files or sensitive configuration values are included in the publish output.

---

## 8. Deploy to Target Environment

Copy the published output to the target server or hosting environment and configure the web server accordingly:

- **IIS**: Install the [ASP.NET Core Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) on the server and configure the IIS site to use the ASP.NET Core Module.
- **Linux/Nginx or Apache**: Configure a reverse proxy to forward requests to the Kestrel process and set up a process manager such as `systemd` to keep the application running.

Confirm the application starts and responds correctly in the deployed environment before considering the migration complete.