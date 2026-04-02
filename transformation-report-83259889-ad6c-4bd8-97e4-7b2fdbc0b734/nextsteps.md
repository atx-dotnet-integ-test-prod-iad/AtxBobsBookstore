# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since the solution builds without errors, the following steps focus on validating correctness and preparing for deployment.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` references accordingly.

---

## 2. Build the Solution in Release Mode

Confirm the solution builds cleanly in Release configuration:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, deprecated APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework runtime and the current .NET runtime, particularly around:

- Globalization and encoding defaults
- JSON serialization behavior
- Entity Framework query translation (if applicable)

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that database access is functioning correctly.

- Confirm that the connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- If Entity Framework Core is in use, check that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the application and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test key areas of the application, including:

- Page rendering and navigation
- Data retrieval and display
- Form submissions and data writes
- Authentication and authorization flows, if present

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for runtime configuration. Confirm the following:

- Application settings have been moved to `appsettings.json`.
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- No legacy `<system.web>` or `<system.webServer>` configuration blocks remain that could cause unexpected behavior.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET:

- `System.Web` references should no longer be present.
- Windows-specific APIs (e.g., registry access, Windows identity impersonation) may require alternative implementations or conditional compilation guards if cross-platform support is required.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to the target environment.