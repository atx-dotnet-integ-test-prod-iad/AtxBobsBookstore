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

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Failures in tests that previously passed may indicate behavioral differences introduced during the migration, such as changes in dependency injection, middleware configuration, or Entity Framework behavior.

---

## 4. Verify Entity Framework Core Migrations

Since the solution includes a `Bookstore.Data` project, verify that any Entity Framework migrations are compatible with the new target framework.

Check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be applied or updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` is correctly configured for your target database environment.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without exceptions.
- Key pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.

---

## 6. Review `appsettings.json` and Environment Configuration

Confirm that all configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 7. Check for Platform-Specific API Usage

Even without build errors, there may be runtime issues caused by APIs that existed in .NET Framework but behave differently or are unavailable in cross-platform .NET. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows-specific APIs such as the registry or Windows identity impersonation
- Any third-party libraries that may not have cross-platform support

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling if a deeper audit is needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to your target environment.