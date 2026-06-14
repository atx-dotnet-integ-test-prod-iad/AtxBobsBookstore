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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents via [NuGet](https://www.nuget.org/).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding to deployment.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- **Migrations**: If using Entity Framework Core, confirm that existing migrations are compatible. Run the following to check the current migration state:

  ```bash
  dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
  ```

- **Database Update**: Apply any pending migrations to a development database:

  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```

- **Connection Strings**: Confirm that connection strings in `appsettings.json` (or `appsettings.Development.json`) are correctly configured for your target environment.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually test the primary workflows, such as browsing, searching, and any data entry forms. Check the console and application logs for any runtime exceptions.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Verify the following:

- All configuration has been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.{Environment}.json`.
- Authentication, authorization, and middleware configurations are correctly set up in `Program.cs` or `Startup.cs`.

---

## 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to detect any remaining usage of Windows-specific or otherwise incompatible APIs:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review and resolve any reported diagnostics, particularly those prefixed with `CA1416` (platform compatibility).

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.