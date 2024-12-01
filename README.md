# README

I want to build a self-contained project and its test project, then take the output from the build and package that 
up, preferably as a single-file, without having to build it again.

Here is an example of the commands:

```powershell
$configuration = "Release"
$runtime = "win-x64"
$framework = "net9.0"

dotnet restore MustInstalDotNetSelfContainedNoBuild.sln --runtime $runtime

dotnet build MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--no-restore `
--property:PublishSingleFile=$true `
--property:IncludeNativeLibrariesForSelfExtract=$true

# build test project and run it

dotnet publish MustInstalDotNetSelfContainedNoBuild/MustInstalDotNetSelfContainedNoBuild.csproj `
--configuration $configuration `
--runtime $runtime `
--framework $framework `
--output "output/no-build-$framework-$runtime-singlefile" `
--no-restore `
--no-build `
--property:PublishSingleFile=$true `
--property:IncludeNativeLibrariesForSelfExtract=$true
```

And the csproj file:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">

    <PropertyGroup>
        <TargetFramework>net9.0</TargetFramework>
        <Nullable>enable</Nullable>
        <ImplicitUsings>enable</ImplicitUsings>
        <SelfContained>true</SelfContained>
    </PropertyGroup>

</Project>
```

However, it doesn't work. I get the error: "You must install .NET to run this application."

If I remove the `--no-build` option or the `--property:PublishSingleFile` option it works. (See `build.ps1` for the 
commands I used to generate the output I used for testing.)

| Output                             | Size (MB) |
|------------------------------------|-----------|
| build-net9.0-win-x64               | 107.1     |
| build-net9.0-win-x64-singlefile    | 100.2     |
| no-build-net9.0-win-x64            | 107.1     |
| no-build-net9.0-win-x64-singlefile | 90.4      |

Only no-build-net9.0-win-x64-singlefile does not work:

![Screenshot 2024-12-01 154722.png](Screenshot%202024-12-01%20154722.png)

It says .NET is missing, but it is a self-contained program - it doesn't need .NET to be installed.

no-build-net9.0-win-x64-singlefile is 10MB smaller than build-net9.0-win-x64-singlefile - what is missing?

Comparing the exe, using ilspy, revels the content to be exactly the same:

```powershell
ilspycmd --outputdir dump/build -d build-net9.0-win-x64-singlefile/MustInstalDotNetSelfContainedNoBuild.exe
ilspycmd --outputdir dump/no-build -d no-build-net9.0-win-x64-singlefile/MustInstalDotNetSelfContainedNoBuild.exe
```

Beyond Compare file compare report:

```text
File Compare
Produced: 01/12/2024 20:13:06

Left base folder: dump/build
Right base folder: dump/no-build

File: aspnetcorev2_inprocess.dll
373320 same byte(s)

File: Microsoft.AspNetCore.Antiforgery.dll
121128 same byte(s)

File: Microsoft.AspNetCore.Authentication.Abstractions.dll
67872 same byte(s)

File: Microsoft.AspNetCore.Authentication.BearerToken.dll
71984 same byte(s)

File: Microsoft.AspNetCore.Authentication.Cookies.dll
117032 same byte(s)

File: Microsoft.AspNetCore.Authentication.Core.dll
92440 same byte(s)

File: Microsoft.AspNetCore.Authentication.dll
157960 same byte(s)

File: Microsoft.AspNetCore.Authentication.OAuth.dll
104728 same byte(s)

File: Microsoft.AspNetCore.Authorization.dll
108840 same byte(s)

File: Microsoft.AspNetCore.Authorization.Policy.dll
80144 same byte(s)

File: Microsoft.AspNetCore.Components.Authorization.dll
63768 same byte(s)

File: Microsoft.AspNetCore.Components.dll
833800 same byte(s)

File: Microsoft.AspNetCore.Components.Endpoints.dll
850208 same byte(s)

File: Microsoft.AspNetCore.Components.Forms.dll
96536 same byte(s)

File: Microsoft.AspNetCore.Components.Server.dll
891176 same byte(s)

File: Microsoft.AspNetCore.Components.Web.dll
420144 same byte(s)

File: Microsoft.AspNetCore.Connections.Abstractions.dll
67872 same byte(s)

File: Microsoft.AspNetCore.CookiePolicy.dll
55560 same byte(s)

File: Microsoft.AspNetCore.Cors.dll
92440 same byte(s)

File: Microsoft.AspNetCore.Cryptography.Internal.dll
112936 same byte(s)

File: Microsoft.AspNetCore.Cryptography.KeyDerivation.dll
47384 same byte(s)

File: Microsoft.AspNetCore.DataProtection.Abstractions.dll
51480 same byte(s)

File: Microsoft.AspNetCore.DataProtection.dll
465168 same byte(s)

File: Microsoft.AspNetCore.DataProtection.Extensions.dll
47384 same byte(s)

File: Microsoft.AspNetCore.Diagnostics.Abstractions.dll
35112 same byte(s)

File: Microsoft.AspNetCore.Diagnostics.dll
461072 same byte(s)

File: Microsoft.AspNetCore.Diagnostics.HealthChecks.dll
51496 same byte(s)

File: Microsoft.AspNetCore.dll
112928 same byte(s)

File: Microsoft.AspNetCore.HostFiltering.dll
51496 same byte(s)

File: Microsoft.AspNetCore.Hosting.Abstractions.dll
43296 same byte(s)

File: Microsoft.AspNetCore.Hosting.dll
469256 same byte(s)

File: Microsoft.AspNetCore.Hosting.Server.Abstractions.dll
31008 same byte(s)

File: Microsoft.AspNetCore.Html.Abstractions.dll
43272 same byte(s)

File: Microsoft.AspNetCore.Http.Abstractions.dll
330024 same byte(s)

File: Microsoft.AspNetCore.Http.Connections.Common.dll
55592 same byte(s)

File: Microsoft.AspNetCore.Http.Connections.dll
330008 same byte(s)

File: Microsoft.AspNetCore.Http.dll
301344 same byte(s)

File: Microsoft.AspNetCore.Http.Extensions.dll
743696 same byte(s)

File: Microsoft.AspNetCore.Http.Features.dll
71992 same byte(s)

File: Microsoft.AspNetCore.Http.Results.dll
264472 same byte(s)

File: Microsoft.AspNetCore.HttpLogging.dll
203024 same byte(s)

File: Microsoft.AspNetCore.HttpOverrides.dll
80168 same byte(s)

File: Microsoft.AspNetCore.HttpsPolicy.dll
51480 same byte(s)

File: Microsoft.AspNetCore.Identity.dll
571688 same byte(s)

File: Microsoft.AspNetCore.Localization.dll
67864 same byte(s)

File: Microsoft.AspNetCore.Localization.Routing.dll
31000 same byte(s)

File: Microsoft.AspNetCore.Metadata.dll
31008 same byte(s)

File: Microsoft.AspNetCore.Mvc.Abstractions.dll
268568 same byte(s)

File: Microsoft.AspNetCore.Mvc.ApiExplorer.dll
137528 same byte(s)

File: Microsoft.AspNetCore.Mvc.Core.dll
1960232 same byte(s)

File: Microsoft.AspNetCore.Mvc.Cors.dll
51504 same byte(s)

File: Microsoft.AspNetCore.Mvc.DataAnnotations.dll
104712 same byte(s)

File: Microsoft.AspNetCore.Mvc.dll
43312 same byte(s)

File: Microsoft.AspNetCore.Mvc.Formatters.Json.dll
30992 same byte(s)

File: Microsoft.AspNetCore.Mvc.Formatters.Xml.dll
121096 same byte(s)

File: Microsoft.AspNetCore.Mvc.Localization.dll
51464 same byte(s)

File: Microsoft.AspNetCore.Mvc.Razor.dll
244008 same byte(s)

File: Microsoft.AspNetCore.Mvc.RazorPages.dll
452872 same byte(s)

File: Microsoft.AspNetCore.Mvc.TagHelpers.dll
284952 same byte(s)

File: Microsoft.AspNetCore.Mvc.ViewFeatures.dll
731432 same byte(s)

File: Microsoft.AspNetCore.OutputCaching.dll
252184 same byte(s)

File: Microsoft.AspNetCore.RateLimiting.dll
104712 same byte(s)

File: Microsoft.AspNetCore.Razor.dll
67856 same byte(s)

File: Microsoft.AspNetCore.Razor.Runtime.dll
76064 same byte(s)

File: Microsoft.AspNetCore.RequestDecompression.dll
51480 same byte(s)

File: Microsoft.AspNetCore.ResponseCaching.Abstractions.dll
31000 same byte(s)

File: Microsoft.AspNetCore.ResponseCaching.dll
149768 same byte(s)

File: Microsoft.AspNetCore.ResponseCompression.dll
84272 same byte(s)

File: Microsoft.AspNetCore.Rewrite.dll
219400 same byte(s)

File: Microsoft.AspNetCore.Routing.Abstractions.dll
59688 same byte(s)

File: Microsoft.AspNetCore.Routing.dll
862488 same byte(s)

File: Microsoft.AspNetCore.Server.HttpSys.dll
620840 same byte(s)

File: Microsoft.AspNetCore.Server.IIS.dll
665896 same byte(s)

File: Microsoft.AspNetCore.Server.IISIntegration.dll
51480 same byte(s)

File: Microsoft.AspNetCore.Server.Kestrel.Core.dll
2324784 same byte(s)

File: Microsoft.AspNetCore.Server.Kestrel.dll
35112 same byte(s)

File: Microsoft.AspNetCore.Server.Kestrel.Transport.NamedPipes.dll
141576 same byte(s)

File: Microsoft.AspNetCore.Server.Kestrel.Transport.Quic.dll
235824 same byte(s)

File: Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.dll
166200 same byte(s)

File: Microsoft.AspNetCore.Session.dll
92424 same byte(s)

File: Microsoft.AspNetCore.SignalR.Common.dll
88344 same byte(s)

File: Microsoft.AspNetCore.SignalR.Core.dll
534824 same byte(s)

File: Microsoft.AspNetCore.SignalR.dll
39216 same byte(s)

File: Microsoft.AspNetCore.SignalR.Protocols.Json.dll
84232 same byte(s)

File: Microsoft.AspNetCore.StaticAssets.dll
198952 same byte(s)

File: Microsoft.AspNetCore.StaticFiles.dll
166176 same byte(s)

File: Microsoft.AspNetCore.WebSockets.dll
80168 same byte(s)

File: Microsoft.AspNetCore.WebUtilities.dll
256280 same byte(s)

File: Microsoft.CSharp.dll
993584 same byte(s)

File: Microsoft.Extensions.Caching.Abstractions.dll
71944 same byte(s)

File: Microsoft.Extensions.Caching.Memory.dll
100624 same byte(s)

File: Microsoft.Extensions.Configuration.Abstractions.dll
51472 same byte(s)

File: Microsoft.Extensions.Configuration.Binder.dll
92424 same byte(s)

File: Microsoft.Extensions.Configuration.CommandLine.dll
47416 same byte(s)

File: Microsoft.Extensions.Configuration.dll
92456 same byte(s)

File: Microsoft.Extensions.Configuration.EnvironmentVariables.dll
39216 same byte(s)

File: Microsoft.Extensions.Configuration.FileExtensions.dll
51480 same byte(s)

File: Microsoft.Extensions.Configuration.Ini.dll
47400 same byte(s)

File: Microsoft.Extensions.Configuration.Json.dll
51472 same byte(s)

File: Microsoft.Extensions.Configuration.KeyPerFile.dll
43288 same byte(s)

File: Microsoft.Extensions.Configuration.UserSecrets.dll
47384 same byte(s)

File: Microsoft.Extensions.Configuration.Xml.dll
63752 same byte(s)

File: Microsoft.Extensions.DependencyInjection.Abstractions.dll
145688 same byte(s)

File: Microsoft.Extensions.DependencyInjection.dll
219416 same byte(s)

File: Microsoft.Extensions.Diagnostics.Abstractions.dll
51512 same byte(s)

File: Microsoft.Extensions.Diagnostics.dll
71976 same byte(s)

File: Microsoft.Extensions.Diagnostics.HealthChecks.Abstractions.dll
43304 same byte(s)

File: Microsoft.Extensions.Diagnostics.HealthChecks.dll
112904 same byte(s)

File: Microsoft.Extensions.Features.dll
47376 same byte(s)

File: Microsoft.Extensions.FileProviders.Abstractions.dll
39216 same byte(s)

File: Microsoft.Extensions.FileProviders.Composite.dll
35120 same byte(s)

File: Microsoft.Extensions.FileProviders.Embedded.dll
71968 same byte(s)

File: Microsoft.Extensions.FileProviders.Physical.dll
92464 same byte(s)

File: Microsoft.Extensions.FileSystemGlobbing.dll
100632 same byte(s)

File: Microsoft.Extensions.Hosting.Abstractions.dll
76040 same byte(s)

File: Microsoft.Extensions.Hosting.dll
153896 same byte(s)

File: Microsoft.Extensions.Http.dll
198952 same byte(s)

File: Microsoft.Extensions.Identity.Core.dll
448808 same byte(s)

File: Microsoft.Extensions.Identity.Stores.dll
88360 same byte(s)

File: Microsoft.Extensions.Localization.Abstractions.dll
35112 same byte(s)

File: Microsoft.Extensions.Localization.dll
59704 same byte(s)

File: Microsoft.Extensions.Logging.Abstractions.dll
153888 same byte(s)

File: Microsoft.Extensions.Logging.Configuration.dll
47400 same byte(s)

File: Microsoft.Extensions.Logging.Console.dll
162072 same byte(s)

File: Microsoft.Extensions.Logging.Debug.dll
35096 same byte(s)

File: Microsoft.Extensions.Logging.dll
100632 same byte(s)

File: Microsoft.Extensions.Logging.EventLog.dll
47384 same byte(s)

File: Microsoft.Extensions.Logging.EventSource.dll
67848 same byte(s)

File: Microsoft.Extensions.Logging.TraceSource.dll
39176 same byte(s)

File: Microsoft.Extensions.ObjectPool.dll
43312 same byte(s)

File: Microsoft.Extensions.Options.ConfigurationExtensions.dll
43288 same byte(s)

File: Microsoft.Extensions.Options.DataAnnotations.dll
39208 same byte(s)

File: Microsoft.Extensions.Options.dll
141576 same byte(s)

File: Microsoft.Extensions.Primitives.dll
84248 same byte(s)

File: Microsoft.Extensions.WebEncoders.dll
39224 same byte(s)

File: Microsoft.JSInterop.dll
141624 same byte(s)

File: Microsoft.Net.Http.Headers.dll
219400 same byte(s)

File: Microsoft.VisualBasic.Core.dll
1255720 same byte(s)

File: Microsoft.VisualBasic.dll
17704 same byte(s)

File: Microsoft.Win32.Primitives.dll
15664 same byte(s)

File: Microsoft.Win32.Registry.dll
121136 same byte(s)

File: mscorlib.dll
60216 same byte(s)

File: MustInstalDotNetSelfContainedNoBuild.deps.json
1294 same line(s)

File: MustInstalDotNetSelfContainedNoBuild.dll
5120 same byte(s)

File: MustInstalDotNetSelfContainedNoBuild.runtimeconfig.json
20 same line(s)

File: netstandard.dll
101176 same byte(s)

File: System.AppContext.dll
15664 same byte(s)

File: System.Buffers.dll
15672 same byte(s)

File: System.Collections.Concurrent.dll
293144 same byte(s)

File: System.Collections.dll
334136 same byte(s)

File: System.Collections.Immutable.dll
903472 same byte(s)

File: System.Collections.NonGeneric.dll
108840 same byte(s)

File: System.Collections.Specialized.dll
104744 same byte(s)

File: System.ComponentModel.Annotations.dll
198968 same byte(s)

File: System.ComponentModel.DataAnnotations.dll
17192 same byte(s)

File: System.ComponentModel.dll
31024 same byte(s)

File: System.ComponentModel.EventBasedAsync.dll
47400 same byte(s)

File: System.ComponentModel.Primitives.dll
80168 same byte(s)

File: System.ComponentModel.TypeConverter.dll
772400 same byte(s)

File: System.Configuration.dll
19752 same byte(s)

File: System.Console.dll
174392 same byte(s)

File: System.Core.dll
23856 same byte(s)

File: System.Data.Common.dll
2849032 same byte(s)

File: System.Data.DataSetExtensions.dll
16176 same byte(s)

File: System.Data.dll
25400 same byte(s)

File: System.Diagnostics.Contracts.dll
16168 same byte(s)

File: System.Diagnostics.Debug.dll
16168 same byte(s)

File: System.Diagnostics.DiagnosticSource.dll
452912 same byte(s)

File: System.Diagnostics.EventLog.dll
383256 same byte(s)

File: System.Diagnostics.EventLog.Messages.dll
813320 same byte(s)

File: System.Diagnostics.FileVersionInfo.dll
47408 same byte(s)

File: System.Diagnostics.Process.dll
338216 same byte(s)

File: System.Diagnostics.StackTrace.dll
47416 same byte(s)

File: System.Diagnostics.TextWriterTraceListener.dll
67880 same byte(s)

File: System.Diagnostics.Tools.dll
15656 same byte(s)

File: System.Diagnostics.TraceSource.dll
145720 same byte(s)

File: System.Diagnostics.Tracing.dll
16680 same byte(s)

File: System.dll
50992 same byte(s)

File: System.Drawing.dll
20776 same byte(s)

File: System.Drawing.Primitives.dll
137528 same byte(s)

File: System.Dynamic.Runtime.dll
16688 same byte(s)

File: System.Formats.Asn1.dll
239888 same byte(s)

File: System.Formats.Tar.dll
272688 same byte(s)

File: System.Globalization.Calendars.dll
16168 same byte(s)

File: System.Globalization.dll
16168 same byte(s)

File: System.Globalization.Extensions.dll
15632 same byte(s)

File: System.IO.Compression.Brotli.dll
84264 same byte(s)

File: System.IO.Compression.dll
268584 same byte(s)

File: System.IO.Compression.FileSystem.dll
15656 same byte(s)

File: System.IO.Compression.ZipFile.dll
55600 same byte(s)

File: System.IO.dll
16184 same byte(s)

File: System.IO.FileSystem.AccessControl.dll
104760 same byte(s)

File: System.IO.FileSystem.dll
16168 same byte(s)

File: System.IO.FileSystem.DriveInfo.dll
55576 same byte(s)

File: System.IO.FileSystem.Primitives.dll
15664 same byte(s)

File: System.IO.FileSystem.Watcher.dll
88376 same byte(s)

File: System.IO.IsolatedStorage.dll
92440 same byte(s)

File: System.IO.MemoryMappedFiles.dll
84264 same byte(s)

File: System.IO.Pipelines.dll
194872 same byte(s)

File: System.IO.Pipes.AccessControl.dll
16136 same byte(s)

File: System.IO.Pipes.dll
170288 same byte(s)

File: System.IO.UnmanagedMemoryStream.dll
15672 same byte(s)

File: System.Linq.dll
657720 same byte(s)

File: System.Linq.Expressions.dll
3668256 same byte(s)

File: System.Linq.Parallel.dll
801032 same byte(s)

File: System.Linq.Queryable.dll
178456 same byte(s)

File: System.Memory.dll
162088 same byte(s)

File: System.Net.dll
17712 same byte(s)

File: System.Net.Http.dll
1788200 same byte(s)

File: System.Net.Http.Json.dll
133432 same byte(s)

File: System.Net.HttpListener.dll
547112 same byte(s)

File: System.Net.Mail.dll
432440 same byte(s)

File: System.Net.NameResolution.dll
125200 same byte(s)

File: System.Net.NetworkInformation.dll
158008 same byte(s)

File: System.Net.Ping.dll
96560 same byte(s)

File: System.Net.Primitives.dll
227640 same byte(s)

File: System.Net.Quic.dll
371000 same byte(s)

File: System.Net.Requests.dll
383288 same byte(s)

File: System.Net.Security.dll
678184 same byte(s)

File: System.Net.ServicePoint.dll
15656 same byte(s)

File: System.Net.Sockets.dll
547120 same byte(s)

File: System.Net.WebClient.dll
170280 same byte(s)

File: System.Net.WebHeaderCollection.dll
63792 same byte(s)

File: System.Net.WebProxy.dll
43304 same byte(s)

File: System.Net.WebSockets.Client.dll
104752 same byte(s)

File: System.Net.WebSockets.dll
235832 same byte(s)

File: System.Numerics.dll
15656 same byte(s)

File: System.Numerics.Vectors.dll
16168 same byte(s)

File: System.ObjectModel.dll
84264 same byte(s)

File: System.Private.CoreLib.dll
15272200 same byte(s)

File: System.Private.DataContractSerialization.dll
2070840 same byte(s)

File: System.Private.Uri.dll
260400 same byte(s)

File: System.Private.Xml.dll
7915824 same byte(s)

File: System.Private.Xml.Linq.dll
399672 same byte(s)

File: System.Reflection.DispatchProxy.dll
76056 same byte(s)

File: System.Reflection.dll
16696 same byte(s)

File: System.Reflection.Emit.dll
301360 same byte(s)

File: System.Reflection.Emit.ILGeneration.dll
16160 same byte(s)

File: System.Reflection.Emit.Lightweight.dll
16136 same byte(s)

File: System.Reflection.Extensions.dll
15656 same byte(s)

File: System.Reflection.Metadata.dll
1173808 same byte(s)

File: System.Reflection.Primitives.dll
16184 same byte(s)

File: System.Reflection.TypeExtensions.dll
43304 same byte(s)

File: System.Resources.Reader.dll
15672 same byte(s)

File: System.Resources.ResourceManager.dll
16168 same byte(s)

File: System.Resources.Writer.dll
51504 same byte(s)

File: System.Runtime.CompilerServices.Unsafe.dll
15664 same byte(s)

File: System.Runtime.CompilerServices.VisualC.dll
31000 same byte(s)

File: System.Runtime.dll
44848 same byte(s)

File: System.Runtime.Extensions.dll
18224 same byte(s)

File: System.Runtime.Handles.dll
15656 same byte(s)

File: System.Runtime.InteropServices.dll
112952 same byte(s)

File: System.Runtime.InteropServices.JavaScript.dll
51496 same byte(s)

File: System.Runtime.InteropServices.RuntimeInformation.dll
15664 same byte(s)

File: System.Runtime.Intrinsics.dll
17704 same byte(s)

File: System.Runtime.Loader.dll
16168 same byte(s)

File: System.Runtime.Numerics.dll
354600 same byte(s)

File: System.Runtime.Serialization.dll
17208 same byte(s)

File: System.Runtime.Serialization.Formatters.dll
125216 same byte(s)

File: System.Runtime.Serialization.Json.dll
16184 same byte(s)

File: System.Runtime.Serialization.Primitives.dll
39216 same byte(s)

File: System.Runtime.Serialization.Xml.dll
17200 same byte(s)

File: System.Security.AccessControl.dll
231720 same byte(s)

File: System.Security.Claims.dll
100664 same byte(s)

File: System.Security.Cryptography.Algorithms.dll
17704 same byte(s)

File: System.Security.Cryptography.Cng.dll
16688 same byte(s)

File: System.Security.Cryptography.Csp.dll
16168 same byte(s)

File: System.Security.Cryptography.dll
2128168 same byte(s)

File: System.Security.Cryptography.Encoding.dll
16176 same byte(s)

File: System.Security.Cryptography.OpenSsl.dll
15656 same byte(s)

File: System.Security.Cryptography.Pkcs.dll
760088 same byte(s)

File: System.Security.Cryptography.Primitives.dll
16184 same byte(s)

File: System.Security.Cryptography.X509Certificates.dll
17200 same byte(s)

File: System.Security.Cryptography.Xml.dll
452872 same byte(s)

File: System.Security.dll
18736 same byte(s)

File: System.Security.Principal.dll
15664 same byte(s)

File: System.Security.Principal.Windows.dll
186664 same byte(s)

File: System.Security.SecureString.dll
15664 same byte(s)

File: System.ServiceModel.Web.dll
17208 same byte(s)

File: System.ServiceProcess.dll
16176 same byte(s)

File: System.Text.Encoding.CodePages.dll
862512 same byte(s)

File: System.Text.Encoding.dll
16144 same byte(s)

File: System.Text.Encoding.Extensions.dll
16168 same byte(s)

File: System.Text.Encodings.Web.dll
133432 same byte(s)

File: System.Text.Json.dll
1796392 same byte(s)

File: System.Text.RegularExpressions.dll
1022248 same byte(s)

File: System.Threading.Channels.dll
141624 same byte(s)

File: System.Threading.dll
84272 same byte(s)

File: System.Threading.Overlapped.dll
16168 same byte(s)

File: System.Threading.RateLimiting.dll
170264 same byte(s)

File: System.Threading.Tasks.Dataflow.dll
493880 same byte(s)

File: System.Threading.Tasks.dll
17192 same byte(s)

File: System.Threading.Tasks.Extensions.dll
16144 same byte(s)

File: System.Threading.Tasks.Parallel.dll
133416 same byte(s)

File: System.Threading.Thread.dll
16184 same byte(s)

File: System.Threading.ThreadPool.dll
16184 same byte(s)

File: System.Threading.Timer.dll
15664 same byte(s)

File: System.Transactions.dll
16688 same byte(s)

File: System.Transactions.Local.dll
653608 same byte(s)

File: System.ValueTuple.dll
15656 same byte(s)

File: System.Web.dll
15672 same byte(s)

File: System.Web.HttpUtility.dll
63784 same byte(s)

File: System.Windows.dll
16168 same byte(s)

File: System.Xml.dll
23856 same byte(s)

File: System.Xml.Linq.dll
16184 same byte(s)

File: System.Xml.ReaderWriter.dll
22320 same byte(s)

File: System.Xml.Serialization.dll
16680 same byte(s)

File: System.Xml.XDocument.dll
16184 same byte(s)

File: System.Xml.XmlDocument.dll
16184 same byte(s)

File: System.Xml.XmlSerializer.dll
18216 same byte(s)

File: System.Xml.XPath.dll
16168 same byte(s)

File: System.Xml.XPath.XDocument.dll
31032 same byte(s)

File: WindowsBase.dll
16680 same byte(s)


There are 314 files totaling 90.3MB
```