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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate modern .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid cross-targeting issues.

---

## 4. Check for Windows-Specific APIs

Since this is a cross-platform migration, scan the codebase for any APIs that are Windows-only. Common areas to check include:

- `Microsoft.Win32` namespace usage
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `System.Drawing` (which has limited cross-platform support; consider replacing with a library such as `SkiaSharp` if image processing is needed)

You can use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the project.
- Verify that connection strings in `appsettings.json` are environment-appropriate and do not contain hardcoded Windows-style paths.
- Run any existing data migrations to confirm they apply cleanly:

```bash
dotnet ef database update
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic tests for the domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output for any runtime exceptions or middleware configuration errors.
- Verify that static files, routing, and authentication (if applicable) are functioning correctly.

---

## 8. Validate Configuration and Environment Settings

- Confirm that `appsettings.json` and `appsettings.Production.json` contain the correct values for the target environment.
- Ensure that any configuration previously stored in `Web.config` or `App.config` has been properly migrated to the `appsettings.json` structure or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 10. Test on the Target Operating System

If the intent is to run this application on Linux or macOS, perform a full end-to-end test on that operating system using the published output from the previous step. This will surface any remaining platform-specific issues that static analysis may not catch.