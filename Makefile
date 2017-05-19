include pgxntool/base.mk

#
# OTHER DEPS
#
.PHONY: deps
deps: cat_tools
install: deps

.PHONY: cat_tools
cat_tools: $(DESTDIR)$(datadir)/extension/cat_tools.control
$(DESTDIR)$(datadir)/extension/cat_tools.control:
	pgxn install cat_tools --sudo
