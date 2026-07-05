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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify all previously passing tests continue to pass.
- If any tests fail, compare the behavior against the original .NET Framework version to determine if the failure is due to a behavioral difference in .NET or a migration issue.

---

## 4. Validate Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the new project.
- If Entity Framework is used, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a development database and confirm the schema is correct:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Domain Layer (`Bookstore.Domain`)

- Review domain models and ensure no types rely on APIs that were removed or changed between .NET Framework and modern .NET (e.g., `System.Runtime.Serialization`, `BinaryFormatter`).
- Check that any serialization, validation attributes, or data annotations behave as expected under the new runtime.

---

## 6. Validate Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (or the combined entry point) are correctly configured for ASP.NET Core.
- Check that all middleware, routing, authentication, and authorization configurations are in place.
- Verify `appsettings.json` contains the correct connection strings and configuration values for the target environment.
- Run the application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test core functionality such as browsing, searching, and any data entry workflows.

---

## 7. Review Removed or Changed APIs

Cross-reference the codebase against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [.NET API compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) to identify any runtime-level breaking changes that would not surface as build errors but could cause issues at runtime.

Common areas to check:

- `HttpContext` and `HttpRequest` usage differences in ASP.NET Core
- `ConfigurationManager` replaced by `IConfiguration`
- `System.Web` dependencies that may have been stubbed or removed
- `BinaryFormatter` which is disabled by default in modern .NET

---

## 8. Test Against a Staging Environment

Before deploying to production, deploy the application to a staging environment that mirrors production as closely as possible. Validate:

- Database connectivity and query behavior
- Authentication and session handling
- Any file system or network resource access
- Logging output and error handling

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required assets, configuration files, and dependencies are present before deploying to the target server.