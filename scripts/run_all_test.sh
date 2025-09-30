#!/bin/bash

#percorsi
schema=~/test-framework/schemas/test_schemas.xsd
test_dir=~/test-framework/tests
cpp_src=~/test-framework/src/main.cpp
exe=~/test-framework/bin/test_runner.exe

if [ ! -f "$schema" ]; then
    echo "❌ Errore: lo schema $schema non esiste."
    exit 1
fi

echo "🔧 Uso schema: $schema"

echo "compilazione programma C++..."
g++ -std=c++17 -o $exe $cpp_src -ltinyxml2
if [ ! $? ];then 7
    echo "❌ Errore nella compilazione, uscita"
    exit 1
fi
echo "✅ Compilazione completata."

echo "-----------------------------------"

#validazione dei files test.xml
for f in $test_dir/*.xml;do
    echo "🔍 validazione $f..."
    xmllint --noout --schema $schema $f

    if [ $? -eq 0 ];then
        echo "✅ $f valido, eseguo simulazione"
        $exe $f
    else
        echo "⚠️ $f non validato,salto simulazione"
    fi

    echo "-----------------------------------"

done 

#simulazione dei files test.xml

