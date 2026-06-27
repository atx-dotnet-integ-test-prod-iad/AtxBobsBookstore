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

- Verify that all previously passing tests continue to pass.
- If tests were written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), review them for correctness under the new runtime.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) migrations are compatible with the target runtime.
- If using Entity Framework Core, run the following to verify the model against the database schema:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Check connection strings in `appsettings.json` to ensure they are correctly configured for the target environment, replacing any references to `Web.config` or `App.config` that may have existed in the legacy project.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review any domain logic that previously relied on .NET Framework-specific namespaces (e.g., `System.Web`, `System.Drawing`) and confirm replacements are functioning correctly.
- Check serialization logic, if present, as behavior may differ between `Newtonsoft.Json` and `System.Text.Json`.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Start the application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Manually verify the following:
  - Application starts without runtime exceptions.
  - Routing behaves as expected.
  - Authentication and authorization flows work correctly if applicable.
  - Static files (CSS, JavaScript, images) are served properly.
  - Any previously configured HTTP modules or HTTP handlers have been correctly replaced with ASP.NET Core middleware.

- Review `Program.cs` and `appsettings.json` to confirm that configuration, logging, and middleware are set up appropriately.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the project is targeting `net6.0` or `net7.0`, consider updating to `net8.0` (current LTS) for long-term support.

---

## 8. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including `appsettings.json` and static assets, are present before deploying to the target environment.