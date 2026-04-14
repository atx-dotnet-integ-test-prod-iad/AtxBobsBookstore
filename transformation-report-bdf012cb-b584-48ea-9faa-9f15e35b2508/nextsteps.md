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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (CA1416)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- Connection strings and application settings have been moved to `appsettings.json` in `Bookstore.Web`.
- Any environment-specific configuration is handled via `appsettings.{Environment}.json` or environment variables.
- If `Web.config` transforms were previously used, confirm that equivalent configuration is now in place.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the data layer functions correctly:

- If Entity Framework is used, confirm the correct version of EF Core is referenced (not EF6, unless EF6 cross-platform support is explicitly intended).
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL shown in the console output.
- Exercise the primary user flows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console and application logs for any runtime exceptions.

---

## 6. Run Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that interact with the database or external services, as connection strings and service registrations may have changed during migration.

---

## 7. Validate Static Assets and Middleware

In `Bookstore.Web`, confirm the following:

- Static files (CSS, JS, images) are served correctly. These should be located under `wwwroot`.
- Middleware previously configured via `Global.asax` or `HttpModules` has been migrated to the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs`.
- Authentication and authorization configurations are functioning as expected.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including:
- The compiled assemblies
- `appsettings.json`
- Static assets under `wwwroot`

The published output can then be deployed to your target hosting environment, such as IIS, Azure App Service, or a Linux server running the ASP.NET Core runtime.

---

## 9. Configure the Hosting Environment

Depending on your deployment target:

**IIS:**
- Install the [.NET Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) on the server.
- Create a new IIS site pointing to the publish output directory.
- Set the application pool to use "No Managed Code".

**Linux / Direct Execution:**
- Ensure the correct .NET runtime version is installed on the target machine.
- Use a process manager such as `systemd` to manage the application process.
- Configure a reverse proxy (e.g., Nginx or Apache) to forward requests to the Kestrel server.