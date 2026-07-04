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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target where appropriate.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for APIs or packages that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or IIS-specific middleware
- **System.Drawing** (use `System.Drawing.Common` with caution, or migrate to a cross-platform alternative)

Run the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a compatible version (e.g., EF Core 8).
- Apply any pending migrations or verify the database schema is consistent:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If migrations from the old project were using `System.Data` or ADO.NET directly, verify connection strings and provider configurations in `appsettings.json`.

---

## 6. Validate the Domain Layer (`Bookstore.Domain`)

- Confirm that all domain models, interfaces, and business logic compile cleanly.
- Check for any use of `[Serializable]` attributes or `BinaryFormatter`, which is disabled by default in modern .NET. Replace with a supported serialization mechanism such as `System.Text.Json`.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (if present) follow the modern .NET hosting model. In .NET 6+, the minimal hosting model consolidates these into `Program.cs`.
- Verify middleware registration, routing, and dependency injection configurations are correct.
- Check that `appsettings.json` contains the correct configuration for the current environment.

Run the web application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and verify the application loads correctly.

---

## 8. Run Existing Tests

If the solution contains a test project, execute all tests to verify that behavior has not regressed during the migration.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 9. Manual Functional Validation

Perform manual testing of the core application workflows, including:

- Browsing and searching for books
- Adding, editing, and deleting records (if applicable)
- User authentication and authorization flows
- Any integrations with external services or APIs

---

## 10. Review Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider (e.g., Serilog, NLog). Remove any legacy logging frameworks that may have been carried over from the original project.

Check that global error handling middleware is in place in the web layer.

---

## 11. Publish the Application

Once validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all necessary files are present, including static assets, configuration files, and the compiled assemblies.