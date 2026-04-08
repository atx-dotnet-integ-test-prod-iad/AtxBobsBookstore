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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Walk through the primary user flows (e.g., browsing books, data retrieval) to confirm the application behaves correctly end to end.

### 6. Verify Database Connectivity

Since `Bookstore.Data` handles data access, confirm that:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If you are using a different ORM or ADO.NET directly, verify that the data provider package used is compatible with the target .NET version.

### 7. Check for Windows-Specific API Usage

Even without build errors, the code may reference APIs that are Windows-only and will fail at runtime on Linux or macOS. Use the .NET Compatibility Analyzer to surface these issues:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review any `CA1416` platform compatibility warnings and replace Windows-specific calls with cross-platform alternatives where necessary.

### 8. Review `Bookstore.Domain` for Removed or Changed APIs

Inspect the domain layer for use of any types or namespaces that were available in .NET Framework but have been removed or relocated in modern .NET, such as:

- `System.Web` references (not available in modern .NET)
- `BinaryFormatter` (disabled by default in .NET 5+)
- `AppDomain` members with limited support

Address any such usages by substituting with supported cross-platform equivalents.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.

### 3. Test the Published Output

Run the published application directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Verify that the application starts without errors and that all routes and data access operations function correctly in this mode.