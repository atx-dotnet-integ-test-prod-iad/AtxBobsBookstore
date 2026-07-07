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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Runtime Compatibility Issues

Some APIs that existed in .NET Framework may behave differently or may be absent in cross-platform .NET. Review the following areas manually:

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. If any references remain, they will need to be replaced with ASP.NET Core equivalents.
- **Windows-specific APIs**: Any calls to the Windows registry, `System.Drawing` (GDI+), or COM interop may require replacement or the addition of compatibility packages.
- **Configuration**: Ensure `Web.config` or `App.config` based configuration has been migrated to `appsettings.json` and the `Microsoft.Extensions.Configuration` pattern.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been updated to Entity Framework Core and that migrations are compatible.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify core logic is functioning correctly after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Database connectivity functions correctly (check connection strings in `appsettings.json`).
- Core application routes and pages load as expected.
- Any authentication or authorization middleware is functioning correctly.

---

## 7. Validate the Database Layer

If `Bookstore.Data` uses Entity Framework Core, confirm that the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations do not exist yet, generate an initial migration from the current model.

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Publish Output

Before deploying, publish the application and inspect the output directory for any missing files or unexpected content.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Confirm that:

- All static assets are present.
- The `appsettings.json` and `appsettings.Production.json` files are included.
- No `.pdb` or development-only files are included unintentionally.

---

## 9. Deploy the Published Output

Copy the contents of the `./publish` directory to your target hosting environment. Supported options include:

- **IIS on Windows**: Configure the site to use the ASP.NET Core Hosting Bundle and set the application pool to `No Managed Code`.
- **Linux with Kestrel**: Run the application directly using `dotnet Bookstore.Web.dll` or configure it as a `systemd` service.
- **Azure App Service**: Deploy using the Azure CLI or Visual Studio publish tooling, targeting a Linux or Windows App Service Plan.

Ensure the production environment has the correct .NET runtime version installed that matches the `<TargetFramework>` defined in the project.