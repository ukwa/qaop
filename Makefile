# this is GNU makefile (gmake)
# modify ROM variable (below)
# use 'make jar' to produce JAR file

NAME = qaop
VERSION = 1.4
PKG := $(NAME)-$(VERSION)
FILES = Makefile Qaop.java Spectrum.java Z80.java Audio.java \
	genops.awk mixops.awk manifest COPYING
OUT := www/
ROM := $(OUT)spectrum.rom
JARTMP := jar-tmp/

#JBIN := $(JAVA_HOME)/bin/
JC := $(JBIN)javac -O -source 1.4 -target 1.4 -classpath $(OUT)
#JC := jikes -q -O -target 1.4 -bootclasspath $(JAVA_HOME)/jre/lib/rt.jar -d $(OUT) +Punused-package-imports
#JC := gcj -O2 -C -Wno-deprecated
DEBUG := -g
NODEBUG := -g:none
#NODEBUG := -g0
JAR := $(JBIN)jar
#JAR := fastjar

CLASSES := $(addsuffix .class, $(basename $(filter %.java,$(FILES))) \
	Z80\$$Env Loader)
ARCHIVE := $(NAME).jar

all: genZ80 $(OUT)
	$(JC) $(DEBUG) -d $(OUT) $(filter %.java,$(FILES))

$(ROM):
	@echo 48K ROM should be at $(ROM)
	@false

ifneq ($(notdir $(ROM)),spectrum.rom)
ROMSRC := $(ROM)
ROM := $(JARTMP)spectrum.rom
$(ROM): $(ROMSRC) $(JARTMP)
	cp $< $@
endif

jar: $(ARCHIVE)

$(ARCHIVE): $(filter %.java,$(FILES)) $(ROM) $(JARTMP) genZ80
	$(JC) $(NODEBUG) -d $(JARTMP) $(filter %.java,$(FILES))
	@echo "X-Version: $(VERSION)" | cat manifest - >$(JARTMP)manifest
	$(JAR) -cfm $(ARCHIVE) $(JARTMP)manifest $(strip \
		$(addprefix -C $(JARTMP) ,$(CLASSES)) \
		-C $(dir $(ROM)) $(notdir $(ROM)))

$(OUT):
	@mkdir $(OUT)
	@echo 'Copy spectrum.rom into $(OUT)'

$(JARTMP):
	@mkdir -p $(JARTMP)

genZ80:
	@awk -f mixops.awk Z80.java > Z80.tmp
	@if cmp -s Z80.java Z80.tmp; then \
	 rm -f Z80.tmp; \
	 else \
	 VERSION_CONTROL=t mv -fb Z80.tmp Z80.java \
	 && echo Z80.java updated; fi

clean:
	rm -r $(addprefix $(OUT),$(CLASSES)) $(ARCHIVE)

dist:
	ln -s . $(PKG)
	tar czf $(PKG).tar.gz --group=root --owner=root $(addprefix $(PKG)/, $(FILES)); \
	rm $(PKG)

.PHONY: dist clean jar genZ80
