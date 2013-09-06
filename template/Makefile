PREFIX			= /
HSPC_TEMPLATE	= $(PREFIX)/var/opt/hspc-root/template
PLUGIN_PATH	= $(HSPC_TEMPLATE)/HSPC/Plugin/PP/OP_Dummy/

MKDIR		= mkdir -p

all:

install:
	$(MKDIR) $(PLUGIN_PATH)
	
	for i in `find . -type f | grep -v svn`; do \
		install -Dm644 $$i $(PLUGIN_PATH)/$$i || exit $?; \
	done
	

clean:
