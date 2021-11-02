# Shopist iOS 🛒

> A demo application for showcasing Datadog iOS SDK features.

This is a bare version of Shopist iOS with no Datadog iOS SDK instrumentation.

To add Datadog SDK instrumentation, edit two files:
* `AppDelegate.swift`
	- import SDK (`import Datadog`),
	- add initialization and instrumentation code to start SDK on app launch;

Datadog.initialize(
                appContext: .init(),
                trackingConsent: .granted,
                configuration: Datadog.Configuration
                .builderUsing(
                    rumApplicationID: "",
                    clientToken: "",
                    environment: "prod"
                            )
                    .trackUIKitRUMActions()
                    .trackUIKitRUMViews()
                    .trackURLSession(firstPartyHosts: ["shopist.io", "api.shopist.io"])
		     .set(serviceName: "io.shopist.ios")
		      .enableCrashReporting(using: DDCrashReportingPlugin())
                    .build()
                       )

        Global.rum = RUMMonitor.initialize()
	Global.sharedTracer = Tracer.initialize(configuration: .init(serviceName: "io.shopist.ios"))

         Datadog.setUserInfo(id: "1234", name: "priyanshi", email: "priyanshi@datadoghq.com")
         Global.rum.addAttribute(forKey: "hasPurchased", value: false)
                Global.rum.addAttribute(
                    forKey: "network.override.client.ip",
                    value:  "127.0.0.1"
                )
		
		

* `API.swift` 
	- import SDK
	- assign our `DDURLSessionDelegate` to Shopist `NetworkClient` so we can track network requests.

* Build phases
if which datadog-ci >/dev/null; then
       export DATADOG_API_KEY=${DSYM_UPLOAD_DATADOG_API_KEY}
        datadog-ci dsyms upload "${DWARF_DSYM_FOLDER_PATH}"
fi

For simplicity, Datadog SDK dependency is already linked to the project with Swift Package Manager.
