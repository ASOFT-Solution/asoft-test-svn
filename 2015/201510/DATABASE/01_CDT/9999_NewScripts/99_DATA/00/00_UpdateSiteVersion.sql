use [CDT]

DECLARE  @DBVersion varchar(200)

Set @DBVersion =N'Asoft Accounting 2015 10.0.R1(12-05-2015)'

UPDATE [sysSite]
	SET DBVersion = @DBVersion
WHERE sysSiteID in  (select s.SysSiteID
                      FROM   sysPackage p,
                             sysSite s
                      WHERE  p.Package = 'CDT'
                             AND p.sysPackageID = s.sysPackageID)

-- Comment until new license completed
-- Delete lisences if upgrade from 8.0 to 9.0
--if exists (select 1 from sysPackage where Package = 'HTA' and Version = N'8.0')
--Update sysDatabase set CPUID = null, RegisterNumber = NULL
--where DbName <> 'CDT' and sysSiteID <> 1 and CPUID is not null and RegisterNumber is not null

-- Version Asoft Accounting 2015
Update sysPackage set PackageName = N'Asoft Accounting 2015', PackageName2 = N'Asoft Accounting 2015', Version = N'10.0'
where Package = N'HTA'

UPDATE [sysSite] SET SiteName = N'Asoft Accounting Professional 2015' where SiteCode = N'PRO'
UPDATE [sysSite] SET SiteName = N'Asoft Accounting Standard 2015' where SiteCode = N'STD'