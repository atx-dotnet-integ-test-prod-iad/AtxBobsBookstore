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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.x` or `net5.0`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for use of APIs that were removed or significantly changed between the legacy .NET Framework and modern .NET. Common areas to check include:

- `System.Web` references — these are not available in modern .NET and must be replaced with `Microsoft.AspNetCore` equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage patterns.
- `ConfigurationManager` — replace with `Microsoft.Extensions.Configuration`.
- `BinaryFormatter` — removed in .NET 9 and deprecated earlier; replace with a supported serializer.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` compatibility tools if needed.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to behavioral differences in the new runtime or pre-existing issues.

If no test project exists, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Connection strings in `appsettings.json` are correctly configured.
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any data entry flows) to confirm runtime behavior is correct.

---

## 8. Review Middleware and Configuration (Bookstore.Web)

In the `Bookstore.Web` project, review `Program.cs` (and `Startup.cs` if still present) for the following:

- Middleware is registered in the correct order.
- Services such as dependency injection, logging, and authentication are configured using the modern `WebApplication` builder pattern.
- Static file handling, routing, and error handling middleware are present.

If the project still uses the older `Startup.cs` pattern, consider consolidating into the minimal hosting model in `Program.cs` as recommended for .NET 6 and later.

---

## 9. Address Nullable Reference Type Warnings

If `<Nullable>enable</Nullable>` is set in any `.csproj`, review and resolve nullable warnings throughout the codebase to improve code correctness and avoid potential null reference exceptions at runtime.

---

## 10. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.