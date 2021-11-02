all: dependencies setup

# Content of `Shopist.local.xcconfig` used to send data to Demo org.
define DEMO_ORG_SECRETS
RUM_APPLICATION_ID=${DEMO_RUM_APPLICATION_ID}\n
DATADOG_CLIENT_TOKEN=${DEMO_DATADOG_CLIENT_TOKEN}\n
DSYM_UPLOAD_DATADOG_API_KEY=${DEMO_DSYM_UPLOAD_DATADOG_API_KEY}\n
SHOPIST_BASE_URL=${SHOPIST_BASE_URL}\n
endef
export DEMO_ORG_SECRETS

# Content of `Shopist.local.xcconfig` used to send data to 'Mobile - Integration' org.
define INTEGRATION_ORG_SECRETS
RUM_APPLICATION_ID=${RUM_APPLICATION_ID}\n
DATADOG_CLIENT_TOKEN=${DATADOG_CLIENT_TOKEN}\n
DSYM_UPLOAD_DATADOG_API_KEY=${DSYM_UPLOAD_DATADOG_API_KEY}\n
SHOPIST_BASE_URL=${SHOPIST_BASE_URL}\n
endef
export INTEGRATION_ORG_SECRETS

dependencies:
	@echo "⚙️  Installing datadog-ci..."
	@npm install -g @datadog/datadog-ci

setup:
ifeq (${IS_DEMO}, true)
	@echo "Creating Shopist.local.xcconfig for Demo org..."
	@echo $$DEMO_ORG_SECRETS > ./xcconfigs/Shopist.local.xcconfig;
else
	@echo "Creating Shopist.local.xcconfig for Mobile - Integration org..."
	@echo $$INTEGRATION_ORG_SECRETS > ./xcconfigs/Shopist.local.xcconfig;
endif
