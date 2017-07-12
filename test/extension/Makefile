# Need this for pre 9.5
PGXNTOOL_NO_PGXS_INCLUDE = 1

include ../../pgxntool/base.mk

# Need to un-set DOCS
DOCS =#

DATA += $(wildcard *.sql)

ifdef DOCS
$(error DOCS is set)
endif

include $(PGXS)
