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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` namespaces
- Windows Registry access
- COM interop references
- Any NuGet packages marked with the `windows` target platform suffix

Run the following to check for platform compatibility analyzer warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the test suite to validate business logic and data layer behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` at minimum, as it is the most independent layer.

---

## 6. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- Entity Framework Core (or whichever ORM is in use) has been updated to a version compatible with the target framework.
- Any database migrations are present and up to date. Run the following if using EF Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior. Check the console output for any runtime exceptions or middleware configuration issues.

---

## 8. Review `Program.cs` and Startup Configuration

If the project was migrated from .NET Framework, the application startup model may have changed. Confirm that:

- The `Program.cs` file uses the minimal hosting model or the `WebApplication.CreateBuilder` pattern appropriate for the target framework version.
- Middleware registration (authentication, routing, static files, etc.) is correctly ordered.
- Configuration sources such as `appsettings.json` are loading as expected.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, run the application on Linux or macOS if possible:

```bash
dotnet run --project Bookstore.Web
```

This will surface any remaining platform-specific issues that static analysis may not catch.

---

## 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.