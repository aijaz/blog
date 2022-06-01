PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py


DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	find $(OUTPUTDIR) -type f  -name '*.html' -exec ./imageCaption.pl --file='{}' ';'

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

serve-global:
ifdef SERVER
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b $(SERVER)
else
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b 0.0.0.0
endif


devserver:
ifdef PORT
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

imageCaption:
	find $(OUTPUTDIR) -type f  -name '*.html' -exec ./imageCaption.pl '{}' ';'

publishGenerate:
	echo "make publishGenerate"
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)

publishFromScratch:
	make publishGenerate
	make postGenerate
	touch publishDone.txt
	make rsync

publishOnServer:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	find $(OUTPUTDIR) -type f  -name '*.html' -exec ./imageCaption.pl --publish --file='{}' ';'
	yuicompressor output/static/styles.css -o /tmp/styles.css
	/bin/cp /tmp/styles.css output/static/styles.css
	# Now everything is saved in output in the repo
	# Now rsync all files and only recompress the saved ones
	rsync --delete --exclude ".DS_Store" -pqthrv -c output output_stage
	cd output_stage
	for f in `find output -type f -not -name '*.gz' -not -name '*.gif' -not -name '*.jpg' -not -name '*.png' -not -name '.DS_Store' `; do [ "$f" -nt "$f.gz" ] && zopfli $f; done
# 	rsync --delete --exclude ".DS_Store" -pqthrvz -c output_stage/ aijaz@aijaz.net:/home/aijaz/blog

# postGenerate:
# 	echo "make postGenerate"
# 	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
# 	find $(OUTPUTDIR) -type f  -name '*.html' -exec ./imageCaption.pl --publish --file='{}' ';'
# 	yuicompressor output/static/styles.css -o /tmp/styles.css
# 	/bin/cp /tmp/styles.css output/static/styles.css
# 	find $(OUTPUTDIR) -type f -not -name '*.gz' -not -name '*.gif' -not -name '*.jpg' -not -name '*.png' -not -name '.DS_Store' -exec ./compressFile.sh {} \;

# publishUpdate:
# 	echo "make publishUpdate"
# 	find $(INPUTDIR) -type f -name '*.markdown' -newer publishDone.txt -exec ./generateFile.sh {} .markdown 	\;
# 	touch publishDone.txt
# 	make rsync

rsync:
	rsync --delete --exclude ".DS_Store" -pqthrvz -c output/ root@aijaz.net:/home/aijaz/blog

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish ssh_upload rsync_upload
