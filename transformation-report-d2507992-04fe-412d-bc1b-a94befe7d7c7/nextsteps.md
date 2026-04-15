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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.x`, `net5.0`, or `net6.0`, update it to `net8.0` and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in newer versions of .NET. Review the following areas:

- **Entity Framework Core**: If `Bookstore.Data` uses EF Core, confirm the version is compatible with the target framework. Run any pending migrations:
  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```
- **ASP.NET Core**: Confirm that middleware registration in `Program.cs` or `Startup.cs` follows the current conventions for the target framework version.
- **Configuration**: Verify that `appsettings.json` contains all required connection strings and configuration keys.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they are caused by behavioral differences in the new framework version or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Database connectivity is functional (if applicable).
- Core application routes and pages load correctly.
- Any authentication or authorization flows behave as expected.

---

## 7. Review Deprecated Package References

Run the following command to identify outdated NuGet packages:

```bash
dotnet list package --outdated
```

Update packages that are outdated, particularly those that were commonly associated with .NET Framework or older .NET Core versions, such as:

- `Microsoft.AspNetCore.*` packages that were previously distributed separately but are now included in the framework.
- Any `System.*` packages that are now part of the base SDK.

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.