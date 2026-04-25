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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear related to missing or incompatible packages. Pay particular attention to any packages that may have been replaced with compatibility shims during transformation, as these may need to be updated to their modern cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, especially:
- Obsolete API usage
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Validate the Domain Layer (`Bookstore.Domain`)

Since `Bookstore.Domain` is the most independent project, start validation here:

- Confirm that all domain models, interfaces, and business logic compile and behave as expected.
- If unit tests exist for this layer, run them in isolation:

```bash
dotnet test --filter "Project=Bookstore.Domain"
```

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured for cross-platform use.
- Check that connection strings in configuration files (`appsettings.json`) are appropriate for the target environment.
- If Entity Framework Core is in use, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Apply migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally to confirm it starts without errors:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and verify that core pages and functionality load correctly.
- Check that static files, routing, and middleware are functioning as expected.
- Review `Program.cs` or `Startup.cs` to confirm that any previously Windows-specific middleware or configuration has been replaced with cross-platform equivalents.

---

## 6. Run All Tests

If a test project exists in the solution, run the full test suite:

```bash
dotnet test --configuration Release
```

Review results for any failing tests that may indicate behavioral differences introduced during migration.

---

## 7. Review Configuration Files

- Confirm that `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) contain correct and complete configuration values.
- Ensure no configuration was previously sourced from Windows-specific locations such as the registry or `Web.config` sections that are not supported in cross-platform .NET.

---

## 8. Deploy to Target Environment

Once all validation steps pass:

1. Publish the application using the appropriate runtime identifier for your target platform:

```bash
dotnet publish app/Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false
```

2. Copy the published output to the target server.
3. Confirm the runtime environment has the correct version of the .NET runtime installed:

```bash
dotnet --version
```

4. Start the application and verify it runs correctly in the target environment.