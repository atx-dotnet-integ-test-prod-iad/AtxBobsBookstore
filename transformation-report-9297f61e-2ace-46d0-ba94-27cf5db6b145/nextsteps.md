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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netstandard2.0` where a newer target is appropriate, update accordingly.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (not EF6) is being used. Check the `.csproj` for a reference to `Microsoft.EntityFrameworkCore`.
- Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models for any use of types or attributes that were specific to .NET Framework (e.g., `[Serializable]`, `BinaryFormatter`).
- Confirm that any data annotations or validation attributes reference `System.ComponentModel.DataAnnotations`, which is available in .NET.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Bookstore.Web` is using ASP.NET Core and not legacy ASP.NET (Web Forms or MVC 5).
- Check `Program.cs` and `Startup.cs` (if present) for correct middleware configuration.
- Verify that `appsettings.json` contains the necessary configuration values, including the database connection string, replacing any values that were previously in `Web.config`.
- Confirm that `Web.config` is no longer the primary configuration source. Any relevant settings should be migrated to `appsettings.json`.

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary user flows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions.

---

## 8. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate correctness:

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and .NET that need to be addressed in the application code.

---

## 9. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining Windows-specific API calls that may cause issues on Linux or macOS:

```bash
dotnet add package Microsoft.Windows.Compatibility
```

Only add this package if Windows-specific APIs are genuinely required. Otherwise, replace those APIs with cross-platform alternatives.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, views, and static files are present.