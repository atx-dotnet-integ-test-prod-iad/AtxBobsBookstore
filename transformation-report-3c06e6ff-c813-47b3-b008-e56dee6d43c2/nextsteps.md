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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (Bookstore.Data)

- Confirm that your database provider (e.g., Entity Framework Core) is correctly configured in `Bookstore.Data`.
- If the project uses Entity Framework, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a local or development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Validate the Domain Layer (Bookstore.Domain)

- Review domain models and business logic classes to ensure no .NET Framework-specific types or APIs are in use.
- Check for any usage of `System.Web`, `System.Configuration`, or other namespaces that do not exist in cross-platform .NET and replace them with their modern equivalents (e.g., `Microsoft.Extensions.Configuration`).

---

## 5. Validate the Web Layer (Bookstore.Web)

- Confirm that `Program.cs` and `Startup.cs` (if present) follow the expected structure for ASP.NET Core.
- Verify that configuration previously stored in `Web.config` has been migrated to `appsettings.json`.
- Check that authentication, authorization, routing, and middleware are correctly configured for ASP.NET Core.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the locally running application and manually verify core functionality such as browsing, searching, and any data-driven pages.

---

## 6. Run Automated Tests

If the solution contains a test project, execute the test suite to validate correctness:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 7. Review Runtime Behavior

Even without build errors, certain issues may only surface at runtime. Pay attention to:

- **Connection strings**: Ensure they are correctly defined in `appsettings.json` and read via `IConfiguration`.
- **Static files**: Confirm that static assets (CSS, JS, images) are served correctly under `wwwroot`.
- **Logging**: Verify that logging is configured through `Microsoft.Extensions.Logging` and producing expected output.
- **Exception handling**: Test error paths to ensure middleware handles exceptions appropriately.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across all projects unless there is a specific reason for them to differ.