# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

Review the output for any warnings about deprecated packages or version conflicts. If any are present, update the affected package references in the relevant `.csproj` files using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests with:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, it is worth adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data layer project, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target database.
- If Entity Framework Core is used, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, apply them:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly in a local environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the following:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows behave as expected.

---

## 6. Review Target Framework and Platform Compatibility

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also check that no remaining references exist to Windows-only APIs or packages (e.g., `Microsoft.Web.*`, `System.Web`, or `System.Drawing` without the cross-platform alternative). If any are found, replace them with their cross-platform equivalents.

---

## 7. Check Runtime Configuration

Review the following files in `Bookstore.Web` to ensure they are correctly configured for the new runtime:

- `appsettings.json` — confirm environment-specific values are correct.
- `Program.cs` — confirm the application startup and middleware pipeline are properly defined for ASP.NET Core.
- `launchSettings.json` — confirm launch profiles reflect the correct URLs and environment variables.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.