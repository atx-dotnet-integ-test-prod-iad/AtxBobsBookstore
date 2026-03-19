# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated packages or version conflicts. If any are present, update the affected package references in the relevant `.csproj` files using:

```bash
dotnet add <project-path> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows a successful build for all three projects: `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or `net6.0`, update it accordingly and re-run `dotnet restore` and `dotnet build`.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs or packages remain. Search for the following in your `.csproj` files:

- `<RuntimeIdentifier>win-x64</RuntimeIdentifier>` — remove or generalize if cross-platform support is required.
- References to packages such as `Microsoft.Win32`, `System.Windows.Forms`, or `System.Drawing.Common` without the appropriate platform compatibility shims.

If `System.Drawing.Common` is used, note that it is Windows-only on .NET 6+. Consider replacing it with a cross-platform alternative such as [SkiaSharp](https://github.com/mono/SkiaSharp) or [ImageSharp](https://github.com/SixLabors/ImageSharp).

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider writing basic integration or unit tests covering the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

---

## 6. Validate the Web Application Locally

Run the web application locally to verify it starts and functions as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Confirm the application starts without runtime exceptions.
- Navigate through the primary user-facing pages.
- Verify that database connectivity works as expected (check connection strings in `appsettings.json` or `appsettings.Development.json`).

---

## 7. Review Configuration Files

Ensure that configuration previously stored in `Web.config` or `App.config` has been properly migrated to `appsettings.json`. Key areas to check:

- **Connection strings** — should be under `"ConnectionStrings"` in `appsettings.json`.
- **Application settings** — should be migrated to the appropriate `"AppSettings"` section or strongly-typed options classes.
- **Authentication/Authorization settings** — verify middleware is configured correctly in `Program.cs` or `Startup.cs`.

---

## 8. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.