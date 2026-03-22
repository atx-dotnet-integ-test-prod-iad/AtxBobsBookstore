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

If any project still references `net48` or `netcoreapp3.1` or similar outdated frameworks, update them accordingly.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. Any remaining references should be replaced with `Microsoft.AspNetCore` equivalents.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration`.
- **`HttpContext`**: Ensure it is accessed via dependency injection rather than statically.
- **Entity Framework**: If the project uses Entity Framework 6, it should be migrated to Entity Framework Core. Verify the version in use within `Bookstore.Data`.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the domain and data layers before deploying.

---

## 6. Validate Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings are correctly defined in `appsettings.json` rather than `web.config` or `app.config`.
- If using Entity Framework Core, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and up to date.

---

## 7. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary workflows such as browsing, searching, and any data entry forms.

---

## 8. Review `web.config` vs `appsettings.json`

Cross-platform .NET does not use `web.config` for application configuration (though it may still exist for IIS hosting purposes). Confirm that:

- Application settings have been moved to `appsettings.json`.
- Environment-specific settings use `appsettings.Development.json` or `appsettings.Production.json`.
- No critical configuration remains only in `web.config`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 10. Deploy to Target Environment

Copy the published output to your target hosting environment. Supported hosting options for cross-platform .NET web applications include:

- **IIS on Windows**: Ensure the [ASP.NET Core Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) is installed on the server and the IIS site is configured to use an in-process or out-of-process hosting model.
- **Linux with Kestrel**: Run the application directly using `dotnet Bookstore.Web.dll` behind a reverse proxy such as Nginx or Apache.

Verify the application starts correctly in the target environment and that database connectivity is confirmed before going live.