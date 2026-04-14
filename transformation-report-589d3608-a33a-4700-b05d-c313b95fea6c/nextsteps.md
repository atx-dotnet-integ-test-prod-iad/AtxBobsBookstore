# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since there are no build errors, the focus should shift to validating correctness and ensuring the application runs as expected on the new cross-platform .NET runtime.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting `net48` or other legacy frameworks are still present, consider updating them to versions that support the current target framework (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no warnings that could indicate runtime issues:

```bash
dotnet build --configuration Release
```

Review any warnings in the output, particularly:
- `CS0618` (obsolete API usage)
- `NETSDK` warnings about target framework compatibility
- Any warnings from `Bookstore.Data` related to Entity Framework or database providers

---

## 3. Run Unit Tests (If Applicable)

If the solution contains test projects, execute them to verify business logic remains intact after the migration:

```bash
dotnet test --configuration Release
```

If no test projects exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` to establish a baseline for correctness.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

The data layer is the most likely area to encounter runtime issues after migration, especially if Entity Framework was used.

- Confirm the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, etc.)
- If the project previously used **Entity Framework 6 (EF6)**, verify it has been migrated to **EF Core**, as EF6 has limited cross-platform support.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without exceptions in the console output.
- All routes resolve correctly.
- Pages that interact with the database return expected data.
- Any authentication or session handling works as expected, since middleware configuration changed between ASP.NET (legacy) and ASP.NET Core.

---

## 6. Review `Bookstore.Web` Configuration

Legacy ASP.NET projects used `Web.config` for configuration. ASP.NET Core uses `appsettings.json`. Confirm the following have been migrated:

- **Connection strings** are present in `appsettings.json` or environment variables.
- **Application settings** (e.g., API keys, feature flags) have been moved from `Web.config` to `appsettings.json`.
- The `Program.cs` or `Startup.cs` correctly registers all required services (e.g., database context, identity, logging).

---

## 7. Test on a Non-Windows Platform (If Cross-Platform is a Goal)

If the intent of the migration is to run on Linux or macOS, test the application on the target OS:

```bash
dotnet run --project Bookstore.Web
```

Pay attention to:
- **File path separators**: Ensure no hardcoded Windows-style paths (`\`) exist in the code.
- **Case sensitivity**: Linux file systems are case-sensitive; verify all file references (views, static files, etc.) use the correct casing.
- **Windows-specific APIs**: Check for any remaining usage of Windows registry, `System.Windows`, or COM interop.

---

## 8. Review and Update Target Framework (If Needed)

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting an older version such as `net6.0` or `net7.0`, consider upgrading to `net8.0` (LTS) for long-term support.