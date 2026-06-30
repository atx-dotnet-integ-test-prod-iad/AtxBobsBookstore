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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or framework-specific members that may have been carried over from the legacy project.

---

## 3. Run Unit Tests

If the solution contains a test project, execute the test suite to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` and `Bookstore.Data` to verify core business logic and data access behavior.

---

## 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer connects and operates correctly against the target database:

- Check the connection string in `appsettings.json` (or `appsettings.Development.json`) within `Bookstore.Web` to ensure it is valid for the target environment.
- If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm that pages load correctly and data operations function as intended.

---

## 6. Review Configuration and Middleware

Cross-platform .NET may handle certain configuration and middleware differently than the legacy .NET Framework. Confirm the following:

- `Program.cs` and `Startup.cs` (if present) are using the current .NET hosting model correctly.
- Any Windows-specific middleware (e.g., Windows Authentication, MSMQ, WCF) has been replaced or removed.
- Static file paths use `Path.Combine` rather than hardcoded backslashes to ensure cross-platform compatibility.

---

## 7. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.