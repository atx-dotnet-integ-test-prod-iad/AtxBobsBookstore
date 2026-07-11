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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- **Nullable reference type warnings** — these may indicate areas where null safety was not previously enforced.
- **Obsolete API warnings** — some APIs used in .NET Framework may have been marked obsolete in modern .NET.

---

## 3. Review Project Target Frameworks

Open each `.csproj` file and verify the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET.

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project specifically, confirm it is using the appropriate web SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any database migrations are present and up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check Configuration Files

In .NET Framework projects, configuration was handled via `Web.config` or `App.config`. In modern .NET, this is replaced by `appsettings.json`.

- Confirm that `appsettings.json` exists in `Bookstore.Web` and contains the necessary connection strings and application settings.
- Verify that `Program.cs` or `Startup.cs` correctly reads from `appsettings.json` using the `IConfiguration` interface.

Example connection string format in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your_server;Database=Bookstore;Trusted_Connection=True;"
  }
}
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL indicated in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually exercise the primary workflows of the application, such as:

- Browsing books
- Adding or editing records
- Any authentication flows if present

---

## 7. Run Automated Tests (If Applicable)

If the solution contains a test project, execute the tests to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to:
- Legitimate regressions introduced during migration.
- Test infrastructure that itself needs to be updated for modern .NET (e.g., outdated mocking libraries).

---

## 8. Review Static Assets and Middleware

For the `Bookstore.Web` project, confirm that static file serving and middleware are configured correctly in `Program.cs`:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();
```

If the project uses Razor Pages or MVC, ensure the appropriate services are registered:

```csharp
builder.Services.AddControllersWithViews();
// or
builder.Services.AddRazorPages();
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Windows x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime win-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.