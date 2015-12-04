ARCH := $(shell uname -m)
SPEC = python27.spec

RPMBUILD = $(HOME)/rpmbuild
SOURCEDIR = $(RPMBUILD)/SOURCES
RPMDIR = $(RPMBUILD)/RPMS/$(ARCH)
DISTDIR = dist

SRC := $(SOURCEDIR)/Python-2.7.10.tgz

BUILDDEPS = tk-devel \
	tcl-devel \
	expat-devel \
	db4-devel \
	gdbm-devel \
	sqlite-devel \
	bzip2-devel \
	openssl-devel \
	ncurses-devel \
	readline-devel

all: $(DISTDIR) clean

$(DISTDIR): rpm
	mkdir dist
	cp $(RPMDIR)/*.rpm $(DISTDIR)

deps:
	sudo yum -y install rpmdevtools
	sudo yum -y install $(BUILDDEPS)

rpm: deps $(SRC)
	rpmdev-setuptree
	QA_RPATHS='$[ 0x0001|0x0010 ]' rpmbuild -bb $(SPEC)

$(SRC):
	curl -L -o $@ https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz

clean:
	rpmdev-wipetree
