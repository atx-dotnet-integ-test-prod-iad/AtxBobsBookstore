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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for their current recommended replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.
- Pay particular attention to tests covering data access logic in `Bookstore.Data`, as Entity Framework or database provider behavior may differ between .NET Framework and modern .NET.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that the database layer is functioning correctly:

- Check that the connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- If Entity Framework Core is being used, verify that all migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application's key pages and features.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that data is being read from and written to the database correctly.

---

## 6. Review Platform-Specific Code

Even without build errors, some code patterns from .NET Framework may behave differently on cross-platform .NET. Manually review the following areas:

- **File system paths**: Ensure `Path.Combine` is used rather than hardcoded backslashes.
- **Configuration**: Confirm that `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` where applicable.
- **HTTP and networking**: Verify that any `HttpClient` usage follows the recommended `IHttpClientFactory` pattern.
- **Globalization**: Check for any culture-sensitive operations that may behave differently across operating systems.

---

## 7. Test on the Target Operating System

If the intent is to run this application on Linux or macOS, perform a test run on that operating system to catch any remaining platform-specific issues that would not surface on Windows.