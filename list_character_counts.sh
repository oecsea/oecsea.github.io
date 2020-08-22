#!/bin/bash

#
# list_character_counts.sh
#

while read -r F ; do
	C="$(< "$F" perl -p0e 's/[\W\w]*<body>//g;s/\t|<[^<>]+>//g;s/\n/ /g' \
	| perl -pe 's/ +/ /g' \
	| wc -m)"
	echo -e "$C\t$F"
done < <(find . -iname '*.html' | grep -v 'index')

TMP="$(mktemp)"
while read -r URL ; do
	curl -sL "$URL" > "$TMP"	
	pdftotext -q -eol unix -enc UTF-8 "$TMP" "$TMP.2"
	C="$(< "$TMP.2" perl -pe 's/[\n\r\s]+/ /g' | wc -m)"
	echo -e "$C\t$URL"
done < <(grep -R "pdf\">" ./ | perl -pe 's/(pdf)".*/$1/g;s/.*"//g' | sort -u)
rm "$TMP"
rm "$TMP.2"
