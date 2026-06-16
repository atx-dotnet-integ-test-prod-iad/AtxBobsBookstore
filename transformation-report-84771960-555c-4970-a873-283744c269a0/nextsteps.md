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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, update them using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with zero errors and zero warnings, or review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `net48`, `netcoreapp3.1`, or `net6.0`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that behave differently in modern .NET. Pay particular attention to:

- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it references `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` (EF6) package, unless EF6 cross-platform support is explicitly intended.
- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` where applicable.
- **HTTP and Web APIs**: Confirm that any `System.Web` references have been fully removed and replaced with ASP.NET Core equivalents in `Bookstore.Web`.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows such as browsing, searching, and any data-driven pages to confirm end-to-end functionality.

---

## 6. Verify Database Connectivity

If the application uses a database, confirm the connection string in `appsettings.json` is correctly configured for the target environment.

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=...;Database=...;User Id=...;Password=...;"
}
```

If Entity Framework Core migrations are used, apply them to confirm the schema is in sync:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

The contents of the `./publish` directory can then be deployed to the target hosting environment, such as IIS, Azure App Service, or a Linux server running the ASP.NET Core runtime.

For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed on the target server and that the `web.config` generated during publish is present in the deployment directory.