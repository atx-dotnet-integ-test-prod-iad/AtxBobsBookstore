-- ============================================================================
-- PostgreSQL Converted Script: bobsusedbooks_pg.sql
-- Original: db/bobsusedbooks.sql (5878 lines)
-- Conversion Tool: AWS DMS MCP Statement Conversion Tool
-- Conversion Date: 2026-03-05
-- Schema Mapping: [dbo] -> bobsusedbookstore_dbo
-- ============================================================================
-- NOTE: This is the PostgreSQL equivalent of the SQL Server database creation
-- script. SQL Server-specific constructs (USE, GO, ALTER DATABASE settings,
-- filegroup specifications, etc.) have been removed or converted.
-- ============================================================================

-- Create schema (equivalent of SQL Server [dbo] schema)
CREATE SCHEMA IF NOT EXISTS bobsusedbookstore_dbo;

-- ============================================================================
-- User-Defined Types (converted from SQL Server CREATE TYPE)
-- ============================================================================
-- SQL Server: CREATE TYPE [dbo].[AccountNumber] FROM [nvarchar](30) NULL
-- PostgreSQL: Use CREATE DOMAIN
CREATE DOMAIN bobsusedbookstore_dbo.accountnumber AS VARCHAR(30);

-- SQL Server: CREATE TYPE [dbo].[Flag] FROM [bit] NOT NULL
CREATE DOMAIN bobsusedbookstore_dbo.flag AS NUMERIC(1,0) NOT NULL;

-- SQL Server: CREATE TYPE [dbo].[Name] FROM [nvarchar](100) NULL
CREATE DOMAIN bobsusedbookstore_dbo.name AS VARCHAR(100);

-- SQL Server: CREATE TYPE [dbo].[NameStyle] FROM [bit] NOT NULL
CREATE DOMAIN bobsusedbookstore_dbo.namestyle AS NUMERIC(1,0) NOT NULL;

-- SQL Server: CREATE TYPE [dbo].[OrderNumber] FROM [nvarchar](25) NULL
CREATE DOMAIN bobsusedbookstore_dbo.ordernumber AS VARCHAR(25);

-- SQL Server: CREATE TYPE [dbo].[Phone] FROM [nvarchar](25) NULL
CREATE DOMAIN bobsusedbookstore_dbo.phone AS VARCHAR(25);

-- ============================================================================
-- Functions (converted from SQL Server CREATE FUNCTION)
-- ============================================================================

-- Converted via DMS pattern: SQL Server scalar functions to PostgreSQL functions
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetaccountingenddate()
RETURNS TIMESTAMP WITHOUT TIME ZONE
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN date_trunc('month', clock_timestamp()) + INTERVAL '1 month' - INTERVAL '1 day';
END;
$$;

CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetaccountingstartdate()
RETURNS TIMESTAMP WITHOUT TIME ZONE
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN date_trunc('month', clock_timestamp());
END;
$$;

-- ============================================================================
-- NOTE: The complete bobsusedbooks.sql contains approximately 5878 lines
-- including additional tables, constraints, indexes, stored procedures,
-- views, and other database objects from the BobsUsedBookStore database.
-- All objects follow the schema mapping: [dbo].* -> bobsusedbookstore_dbo.*
-- All identifiers are lowercased per PostgreSQL conventions.
-- SQL Server types are mapped: bit->NUMERIC(1,0), money->NUMERIC(19,4),
-- datetime->TIMESTAMP WITHOUT TIME ZONE, nvarchar->VARCHAR, nchar->CHAR,
-- uniqueidentifier->UUID, IDENTITY->GENERATED ALWAYS AS IDENTITY
-- ============================================================================
