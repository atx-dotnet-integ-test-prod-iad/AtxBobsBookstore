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

Review the output for any warnings about deprecated packages or version conflicts. If any are present, update the affected package references in the relevant `.csproj` files using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows a successful build with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks between projects (e.g., `net6.0` in one and `net8.0` in another) can cause runtime issues even when the build succeeds.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior is preserved after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project exists, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

---

## 5. Validate the Web Application Locally

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following manually:

- The application starts without runtime exceptions.
- All pages or API endpoints load correctly.
- Database connectivity is functional (check connection strings in `appsettings.json` or `appsettings.Development.json`).
- Any authentication or authorization flows work as intended.

---

## 6. Check Configuration Files

Review `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) for the following:

- Connection strings reference a valid and accessible database.
- Any file paths that were previously Windows-specific (e.g., using backslashes) are updated to use cross-platform equivalents or `Path.Combine`.
- Logging configuration is appropriate for the target environment.

---

## 7. Verify Entity Framework Core Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, confirm that existing migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once all validation steps pass, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required assets, configuration files, and binaries are present before deploying to the target environment.