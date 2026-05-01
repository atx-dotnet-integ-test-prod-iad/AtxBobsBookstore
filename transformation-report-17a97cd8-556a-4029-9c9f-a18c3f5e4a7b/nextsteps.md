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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for their cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Domain Layer (`Bookstore.Domain`)

Since `Bookstore.Domain` is the most independent project, start validation here.

- Confirm all domain models, enums, and interfaces are intact and behaving as expected.
- If unit tests exist for this layer, run them in isolation:

```bash
dotnet test Bookstore.Domain.Tests
```

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Verify that the database context and entity configurations are correct.
- If the project uses Entity Framework Core, confirm the migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- If migrations are missing or outdated, create a new migration to reflect the current model state:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

- Run any data layer tests if available:

```bash
dotnet test Bookstore.Data.Tests
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Start the web application locally and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application in a browser and confirm that:
  - Pages render correctly.
  - Database reads and writes function as expected.
  - Authentication and authorization (if applicable) behave correctly.
- Check the application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or environment variables.
- Ensure environment-specific configuration files (e.g., `appsettings.Development.json`) are set up correctly.

---

## 7. Run the Full Test Suite

If the solution has a test project or multiple test projects, run all tests together:

```bash
dotnet test
```

Review the results and resolve any failing tests before proceeding to deployment.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.