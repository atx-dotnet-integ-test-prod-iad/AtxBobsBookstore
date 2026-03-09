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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for their cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET.
- Pay particular attention to areas such as file I/O paths, database access in `Bookstore.Data`, and any HTTP-related functionality in `Bookstore.Web`.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- If Entity Framework is in use, confirm that the correct EF Core version is referenced and that any migrations are up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Verify that connection strings in configuration files (e.g., `appsettings.json`) are correct and that any references to `System.Data` or provider-specific libraries are compatible with .NET.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Confirm that all domain models, interfaces, and business logic compile and behave correctly.
- Check for any use of APIs that existed in .NET Framework but behave differently or are absent in cross-platform .NET, such as certain reflection APIs or serialization behaviors.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- If this is an ASP.NET Core project, run it locally and navigate through the application to verify that routing, middleware, and views or API endpoints function as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Check `Program.cs` and any startup configuration to ensure middleware is registered correctly.
- Verify that static files, configuration providers, and authentication/authorization mechanisms work as intended.
- If the project previously used `Web.config`, confirm that the relevant settings have been moved to `appsettings.json` or environment variables.

---

## 7. Review Configuration Files

- Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `Web.config` or `App.config`.
- Confirm that environment-specific settings (e.g., development vs. production connection strings) are handled correctly using the `IConfiguration` system.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration, are present before deploying to the target environment.