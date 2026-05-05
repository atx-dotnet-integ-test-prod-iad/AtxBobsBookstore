# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still under active support.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release
```

Pay close attention to any test failures related to:
- Entity Framework Core query behavior changes
- Serialization or deserialization differences
- ASP.NET Core middleware or routing changes

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- If Entity Framework is used, confirm that migrations are compatible with EF Core. Legacy EF 6 migrations are **not** compatible with EF Core and will need to be regenerated:

```bash
dotnet ef migrations add InitialMigration
dotnet ef database update
```

- Verify that your database connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 6. Validate the Domain Layer (`Bookstore.Domain`)

- Check that all domain models, interfaces, and business logic compile and behave as expected.
- If any `System.Web` or other Windows-specific namespaces were used, confirm they have been replaced with appropriate .NET alternatives.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Start the application locally and navigate through the key pages and endpoints:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Verify the following areas manually:
  - Routing and page rendering
  - Form submissions and model binding
  - Authentication and authorization (if applicable)
  - Static file serving (CSS, JS, images)

- If the project was migrated from ASP.NET Web Forms or ASP.NET MVC 5, confirm that the Razor views and controllers have been correctly adapted to ASP.NET Core conventions.

---

## 8. Check Configuration Migration

Ensure that `Web.config` settings have been properly moved to `appsettings.json` or `appsettings.{Environment}.json`. Common settings to verify include:

- Connection strings
- Application-specific keys
- Logging configuration
- Environment-specific overrides

---

## 9. Publish the Application

Once validation is complete, publish the application to a local folder to confirm the output is correct before deploying to a server:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to ensure all required files are present, then deploy the contents to your target hosting environment (IIS, self-hosted, or otherwise).