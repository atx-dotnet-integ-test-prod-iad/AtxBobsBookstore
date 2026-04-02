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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET (e.g., `net8.0`).

- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

If any project still targets `net4x` or `netstandard2.0`, update it to a current .NET version to take full advantage of cross-platform support.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, as these will cause runtime failures on Linux or macOS even if the build succeeds.

Common areas to check:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)** server-side APIs
- **System.Drawing** (GDI+) — replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp`
- **MSMQ** or other Windows-specific messaging

Run the .NET Compatibility Analyzer if you have not already:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the displayed local URL and exercise the primary workflows of the application (browsing, searching, and any data entry flows) to confirm basic functionality.

---

## 6. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, verify the database connection and schema are correct.

Check the connection string in `appsettings.json` or `appsettings.Development.json` and ensure it points to a reachable database instance.

If Entity Framework Core migrations are present, apply them:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project previously used Entity Framework 6 (non-Core), confirm it has been migrated to **Entity Framework Core**, as EF6 does not have full cross-platform support.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to verify that business logic and data access behave as expected after the migration.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET (e.g., changes in globalization, JSON serialization defaults, or HTTP client behavior).

---

## 8. Review Configuration and Middleware

In ASP.NET Core, configuration and middleware differ significantly from ASP.NET (classic). Verify the following in `Bookstore.Web`:

- `Program.cs` or `Startup.cs` correctly registers all required services.
- Authentication and authorization middleware is configured if the application uses it.
- Static files, routing, and error handling middleware are present.
- Any `web.config` settings that were relied upon have been moved to `appsettings.json` or the appropriate middleware configuration.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

To confirm the cross-platform goal has been met, run the application on Linux or macOS if possible.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Any platform-specific runtime errors that did not appear on Windows will surface here.