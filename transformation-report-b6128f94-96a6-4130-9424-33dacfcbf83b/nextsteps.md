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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

- Review test output for any failures that may indicate behavioral regressions introduced during migration.
- If no test projects exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding.

---

## 4. Validate Data Access Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., Entity Framework Core, Dapper) is compatible with the target .NET version.
- If using Entity Framework Core, verify that any pending migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

- Test that database connections succeed in the target environment using the updated connection strings.

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally to confirm it starts without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application's key pages and features to check for runtime exceptions or broken functionality.
- Review `Program.cs` and any `Startup.cs` (if still present) to confirm middleware, dependency injection registrations, and configuration loading are correct for the new hosting model.
- Verify that static files, routing, and authentication (if applicable) behave as expected.

---

## 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.{Environment}.json` contain the correct values for the target environment.
- Check that any configuration keys previously stored in `Web.config` have been properly migrated to `appsettings.json` or environment variables.
- Ensure connection strings and any sensitive values are handled securely, using the .NET secrets manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 7. Check for Platform-Specific API Usage

- Review the codebase for any remaining usage of Windows-specific APIs (e.g., `System.Web`, registry access, Windows identity APIs) that may not function correctly on Linux or macOS if cross-platform support is required.
- The .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` package can assist in identifying these.

---

## 8. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all required files are present.
- Test the published output by running it directly:

```bash
dotnet ./publish/Bookstore.Web.dll
```