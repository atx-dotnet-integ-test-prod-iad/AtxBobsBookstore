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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the chosen version is still under active support.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used without a compatibility guard. Use the .NET Compatibility Analyzer to assist:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to its .NET-compatible version (e.g., EF Core).
- Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, generate an initial migration and review it before applying:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic tests for the `Bookstore.Domain` layer to verify core business rules before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any runtime exceptions or unhandled errors.
- Verify that database connectivity is functioning as expected.

---

## 8. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Production.json`) contain the correct connection strings and application settings.
- Ensure that any configuration previously stored in `Web.config` or `App.config` has been migrated to the appropriate `appsettings.json` sections or environment variables.
- Validate that sensitive values (e.g., connection strings, API keys) are not hardcoded and are instead managed via environment variables or a secrets manager such as the .NET Secret Manager tool:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.