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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid compatibility mismatches between assemblies.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- If Entity Framework is used, confirm the version is **Entity Framework Core** and not the legacy `System.Data.Entity` namespace.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist yet, generate an initial migration and inspect the output:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check Configuration and Middleware in Bookstore.Web

Legacy ASP.NET projects use `Web.config` and `Global.asax`, which are replaced in modern .NET with `appsettings.json` and `Program.cs`. Verify the following:

- Connection strings are present in `appsettings.json` and not in a `Web.config` file.
- Middleware previously configured in `Global.asax` (e.g., authentication, routing, error handling) has been moved to `Program.cs` or `Startup.cs`.
- Static files, routing, and any custom HTTP handlers have been replaced with their ASP.NET Core equivalents.

---

## 6. Run the Application Locally

Start the web application and confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout) to identify any runtime issues that would not appear at compile time.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy framework and modern .NET, particularly around dependency injection, middleware, or data access patterns.

---

## 8. Inspect Dependency Injection Configuration

Modern ASP.NET Core relies on built-in dependency injection. Confirm that all services from `Bookstore.Domain` and `Bookstore.Data` are registered correctly in `Program.cs`:

```csharp
builder.Services.AddScoped<IBookRepository, BookRepository>();
// Add other service registrations as needed
```

Missing registrations will typically surface as runtime exceptions rather than build errors.

---

## 9. Review Logging and Error Handling

Ensure that logging is configured using the built-in `ILogger<T>` abstraction or a compatible provider such as Serilog. Remove any references to legacy logging frameworks (e.g., `log4net` configured via `Web.config`) and replace them with their modern equivalents configured in `appsettings.json`.