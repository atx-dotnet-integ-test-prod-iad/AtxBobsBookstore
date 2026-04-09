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
- If tests reference any Windows-specific APIs or legacy test frameworks (e.g., MSTest v1), those may need to be updated to a compatible version.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since the solution includes a `Bookstore.Data` project, confirm that:

- The connection string in `appsettings.json` (or equivalent configuration file) is correct for the target environment.
- If Entity Framework is used, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly on the new runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable).
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

Confirm that the following have been correctly migrated or recreated for .NET:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `Web.config` or `App.config`.
- Any environment-specific settings (e.g., connection strings, API keys) are present and correct.
- Middleware configuration in `Program.cs` or `Startup.cs` reflects the intended behavior of the original application.

---

## 7. Cross-Platform Validation

If the intent is to run the application on non-Windows platforms, test the application on the target OS (Linux or macOS) by repeating steps 1 through 5 in that environment. Pay particular attention to:

- File path separators (use `Path.Combine` rather than hardcoded separators).
- Any remaining references to Windows-specific libraries or registry access.
- Case-sensitive file system behavior on Linux.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a newer Long-Term Support (LTS) version of .NET is available and desired, update the target framework and re-run the build and test steps above.