$configuration = "Release"
$runtime = "win-x64"
#$runtime = "win-x86"
#$runtime = "osx-arm64"
$framework = "net9.0"

dotnet restore MustInstalDotNetSelfContainedNoBuild.sln --runtime $runtime --force

$singleFile = $true

dotnet build MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--no-restore `
--property:PublishSingleFile=$singleFile `
--property:IncludeNativeLibrariesForSelfExtract=$singleFile

dotnet publish MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--output "output/build-$framework-$runtime$($singlefile ?'-singlefile':'')" `
--no-restore `
--property:PublishSingleFile=$singleFile `
--property:IncludeNativeLibrariesForSelfExtract=$singleFile

dotnet publish MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--output "output/no-build-$framework-$runtime$($singlefile ?'-singlefile':'')" `
--no-restore `
--no-build `
--property:PublishSingleFile=$singleFile `
--property:IncludeNativeLibrariesForSelfExtract=$singleFile

$singleFile = $false

dotnet build MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--no-restore `
--property:PublishSingleFile=$singleFile `
--property:IncludeNativeLibrariesForSelfExtract=$singleFile

dotnet publish MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--output "output/build-$framework-$runtime$($singlefile ?'-singlefile':'')" `
--no-restore `
--property:PublishSingleFile=$singleFile `
--property:IncludeNativeLibrariesForSelfExtract=$singleFile

dotnet publish MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--output "output/no-build-$framework-$runtime$($singlefile ?'-singlefile':'')" `
--no-restore `
--no-build `
--property:PublishSingleFile=$singleFile `
--property:IncludeNativeLibrariesForSelfExtract=$singleFile

#--property:PublishSingleFile=true `
#--property:PublishReadyToRun=false `
#--property:PublishTrimmed=false `
#--property:IncludeNativeLibrariesForSelfExtract=true