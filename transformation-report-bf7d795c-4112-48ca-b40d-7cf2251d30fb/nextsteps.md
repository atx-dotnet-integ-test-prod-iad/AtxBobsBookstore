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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify Entity Framework usage. If the project was using Entity Framework 6 (EF6), confirm whether it has been migrated to Entity Framework Core. Check connection strings and database provider configuration in `appsettings.json` or `Program.cs`.
- **`Bookstore.Web`**: Confirm that any HTTP modules, HTTP handlers, `Global.asax`, or `Web.config` configurations have been properly replaced with ASP.NET Core middleware, `Program.cs`, and `appsettings.json` equivalents.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading APIs still behave as expected.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify core functionality before deploying.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the displayed local URL and verify:

- Pages load without errors.
- Database connectivity is functional (if applicable).
- Authentication and authorization behave as expected.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json` if present) contains all necessary configuration values that were previously in `Web.config`, including:

- Connection strings
- Application settings
- Logging configuration

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.