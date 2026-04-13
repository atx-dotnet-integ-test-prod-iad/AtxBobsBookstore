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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages. If any packages target `net4x` or older frameworks, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by incomplete migration of dependencies.
- Pay particular attention to tests that cover database access in `Bookstore.Data`, as Entity Framework or other ORM configurations may behave differently across target frameworks.

---

## 4. Verify Runtime Behavior Manually

Start the web application locally and perform manual verification:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas:

- **Routing**: Confirm all existing routes resolve correctly.
- **Database connectivity**: Verify that `Bookstore.Data` connects to the database and performs reads and writes as expected. Check your connection strings in `appsettings.json` or `appsettings.Development.json`.
- **Domain logic**: Exercise key business logic paths exposed through `Bookstore.Domain` to confirm correctness.
- **Static assets**: Ensure CSS, JavaScript, and other static files are served correctly.
- **Authentication/Authorization**: If the application uses identity or authentication middleware, verify login and access control flows work as intended.

---

## 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- Any configuration previously held in `Web.config` transforms has been replicated appropriately.

---

## 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may compile successfully but fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to identify potential issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any diagnostics produced and replace Windows-specific APIs with cross-platform alternatives where applicable.

---

## 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, assemblies, and assets are present before deploying to your target environment.