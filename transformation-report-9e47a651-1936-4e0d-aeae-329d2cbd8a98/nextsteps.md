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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, verify that the correct EF Core version is referenced and that your `DbContext` and entity configurations are compatible with EF Core conventions.
- Run any existing **database migrations** to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration and review the output:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic for any use of APIs that are not available in cross-platform .NET (e.g., `System.Web`, Windows-specific types).
- Confirm that all interfaces, models, and services compile and behave as expected.

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm that the project targets the correct framework (e.g., `net8.0`) in its `.csproj` file.
- Check `Program.cs` and any `Startup.cs` for correct middleware registration and service configuration compatible with ASP.NET Core.
- Verify that configuration files such as `appsettings.json` are present and correctly structured, replacing any legacy `Web.config` values that may have been in use.
- Check that static files, views, and Razor pages (if applicable) are in the expected directory structure.

---

## 6. Run the Application Locally

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and test primary user flows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for runtime exceptions or warnings.

---

## 7. Run Existing Tests

If the solution contains test projects, execute them to validate correctness:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral changes introduced during migration or pre-existing issues.

---

## 8. Review Removed or Changed APIs

Cross-reference the migrated code against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [.NET API compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) to identify any subtle behavioral differences in APIs that exist in both frameworks but behave differently.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including configuration files and static assets.