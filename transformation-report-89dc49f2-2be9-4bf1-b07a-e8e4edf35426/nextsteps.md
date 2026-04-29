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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Configuration Files

Check the following configuration files for any values that may still reference legacy .NET Framework-specific settings:

- `appsettings.json` and `appsettings.*.json` in `Bookstore.Web`
- Any connection strings that may reference legacy providers (e.g., `System.Data.SqlClient` should be replaced with `Microsoft.Data.SqlClient` if applicable)
- Ensure `Program.cs` and `Startup.cs` (if present) follow the expected structure for the target .NET version

---

## 4. Database Validation

If the project uses Entity Framework, verify the data layer is functioning correctly:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are used, confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate core functionality:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences in the new .NET runtime or by incomplete migration of specific components.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions
- Key pages and routes load correctly
- Database read and write operations function as expected
- Authentication and authorization flows work if applicable

---

## 7. Check for Runtime Compatibility Issues

Even with a clean build, certain areas may surface issues at runtime due to API changes between .NET Framework and modern .NET:

- **Reflection-based code**: Verify any dynamic type loading or reflection usage behaves as expected
- **HTTP modules and handlers**: These are not supported in modern .NET; confirm they have been replaced with equivalent middleware
- **`System.Web` dependencies**: Confirm no remaining references exist, as `System.Web` is not available in cross-platform .NET
- **Third-party libraries**: Confirm all NuGet dependencies have builds targeting .NET Standard 2.0 or the specific .NET target version in use

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets, configuration files, and runtime dependencies.