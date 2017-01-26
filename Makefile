#
# Template for building a lirc userspace driver out of tree.
# Requires that lirc is installed in system locations, in
# particular that the /usr/lib[64]/pkgconfig/lirc-driver.pc
# is in place (/usr/local/lib/pkgconfig/... is also OK).
#


driver          = iguanair

all:  $(driver).so

CFLAGS          += $(shell pkg-config --cflags lirc-driver)
LDFLAGS         += $(shell pkg-config --libs lirc-driver)
PLUGINDIR       ?= $(shell pkg-config --variable=plugindir lirc-driver)
CONFIGDIR       ?= $(shell pkg-config --variable=configdir lirc-driver)
PLUGINDOCS      ?= $(shell pkg-config --variable=plugindocs lirc-driver)

MODPROBE_CONF   = 60-blacklist-kernel-iguanair.conf

LDFLAGS         += -liguanaIR

$(driver).o: $(driver).c

$(driver).so: $(driver).o
	gcc --shared -fpic $(LDFLAGS) -o $@ $<

install: $(driver).so
	install -D $< $(DESTDIR)$(PLUGINDIR)/$<
	install -Dm 644 $(driver).conf $(DESTDIR)$(CONFIGDIR)/$(driver).conf
	install -Dm 644 $(driver).html $(DESTDIR)$(PLUGINDOCS)/$(driver).html
	install -Dm 644 $(MODPROBE_CONF) \
	    $(DESTDIR)/etc/modprobe.d/$(MODPROBE_CONF)

clean:
	rm -f *.o *.so
