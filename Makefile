.PHONY: dist

C_OS      ?= linux
C_ARCH    ?= amd64
C_VERSION ?= unstable

RELESES_BASEURL = https://releases.cortezaproject.org/files/
RELEASE_PKG_URL = ${RELESES_BASEURL}$*.tar.gz

SERVERS         = $(addprefix server-,api corredor)
SERVER_DIRS     = $(addprefix dist/, $(SERVERS))

WEBAPP_BASEDIR  = dist/webapp
WEBAPPS         = admin auth compose messaging
WEBAPP_DIRS     = $(WEBAPP_BASEDIR) $(addprefix $(WEBAPP_BASEDIR)/, $(WEBAPPS))
WEBAPP_CONFIGS  = $(addsuffix /config.js, $(WEBAPP_DIRS))


dist: $(SERVER_DIRS) $(WEBAPP_DIRS) dist/extensions

dist-config: \
	dist/server-api/.env \
	dist/server-corredor/.env \
	dist-webapp-configs

dist/server-api: dist/corteza-server-monolith-$(C_VERSION)-$(C_OS)-$(C_ARCH).tar.gz
	mkdir -p "$(@)"
	tar -xzf "$(<)" --strip-components=1 -C "$(@)"

dist/server-api/.env: dist/server-api
	cp setup/dist.server-api.env "$(@)"

dist/server-corredor: dist/corteza-server-corredor-$(C_VERSION).tar.gz
	mkdir -p "$(@)"
	tar -xzf "$(<)" --strip-components=1 -C "$(@)"
	cd "$(@)" && npm rebuild

dist/server-corredor/.env: dist/server-corredor
	cp setup/dist.server-corredor.env "$(@)"

# webapps are packed w/o parent root
dist/webapp: dist/corteza-webapp-one-$(C_VERSION).tar.gz
	mkdir -p "$(@)"
	tar -xzf "$(<)" -C "$(@)"

# webapps are packed w/o parent root
dist/webapp/%: dist/corteza-webapp-%-$(C_VERSION).tar.gz dist/webapp
	mkdir -p "$(@)"
	tar -xzf "$(<)" -C "$(@)"

dist/%.tar.gz:
	curl --silent --location "$(RELEASE_PKG_URL)" > "$(@)"

dist-webapp-configs: $(WEBAPP_CONFIGS)

$(WEBAPP_CONFIGS):
	@ cp -fv setup/dist.webapp-config.js $(@)

dist/extensions: dist/extensions.tar.gz
	mkdir -p "$(@)"
	tar -xzf "$(<)" --strip-components=1 -C "$(@)" corteza-ext-develop/crm corteza-ext-develop/service-cloud

dist/extensions.tar.gz:
	curl --silent --location "https://github.com/cortezaproject/corteza-ext/archive/develop.tar.gz" > "$(@)"

clean-dist:
	rm -rf $(SERVER_DIRS) $(WEBAPP_DIRS) dist/extensions dist/*.tar.gz

clean-dist-webapp-configs:
	rm -f $(WEBAPP_CONFIGS)
