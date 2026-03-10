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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or earlier, consider updating to `net8.0` (current LTS release).

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-only APIs are being used unintentionally. Run the .NET Compatibility Analyzer if it is not already included:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to `Bookstore.Data` for any database access code that may rely on Windows-specific libraries (e.g., `System.Data.OleDb`, MSMQ, or WCF).

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Walk through the core user-facing functionality: browsing books, searching, and any checkout or account flows if present.
- Check the console and browser developer tools for any runtime errors or unhandled exceptions.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection string in `appsettings.json` is correct for your target environment. Then verify migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm existing behavior is preserved:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced by the migration. Address failing tests before proceeding to deployment.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

The `./publish` directory will contain the self-contained or framework-dependent output, depending on your project settings. Verify the contents of this directory before copying it to the target server.

---

## 9. Confirm Runtime on the Target Server

Ensure the target server has the correct .NET runtime installed. You can check the available runtimes with:

```bash
dotnet --list-runtimes
```

If the required runtime is not present, download and install it from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).