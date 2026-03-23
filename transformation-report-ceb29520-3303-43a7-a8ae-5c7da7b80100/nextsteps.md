# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore and Build the Solution

Run the following commands from the root of the solution to confirm a clean restore and build:

```bash
dotnet restore
dotnet build
```

Ensure both commands complete with no errors or warnings that could indicate runtime issues.

---

## 2. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify this is consistent across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.

---

## 3. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`System.Web` dependencies**: These are not available in cross-platform .NET. Confirm `Bookstore.Web` has fully migrated away from `System.Web` to ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, and **`HttpResponse`**: Confirm these are accessed via ASP.NET Core's `IHttpContextAccessor` or controller base classes.
- **Configuration**: Ensure `Web.config` has been replaced with `appsettings.json` and that `IConfiguration` is used throughout.

---

## 4. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the application in a browser and manually verify:

- Pages load without errors
- Data is retrieved and displayed correctly from `Bookstore.Data`
- Any forms or user interactions function as expected

---

## 5. Check Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for your environment.
- Migrations exist and are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Execute Automated Tests

If test projects exist in the solution, run them to validate business logic and data access:

```bash
dotnet test
```

Review the output for any failing tests that may indicate behavioral regressions introduced during the migration.

---

## 7. Validate Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order (e.g., `UseRouting`, `UseAuthentication`, `UseAuthorization`, `UseEndpoints`).
- Services such as dependency injection registrations for `Bookstore.Data` and `Bookstore.Domain` are present and correct.

---

## 8. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, configuration files, and binaries are present before deploying to your target environment.