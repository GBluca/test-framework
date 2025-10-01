# XML Test Framework
License: MITC++ VersionBuild Status

## 📖 Descrizione
Un framework di test data-driven che utilizza XML per descrivere scenari di test, validati tramite XSD e simulati da un programma in C++.
Include uno script Bash per automatizzare compilazione, validazione ed esecuzione.
Progettato per riflettere scenari reali in ambito embedded e automotive.

## 🎬 Demo
Esempio di file di test XML:

<TestCase id="M1">
  <Description>Controllo motore</Description>
  <Step id="1">
    <Action type="send">StartEngine</Action>
    <Expected>ACK</Expected>
  </Step>
  <Step id="2">
    <Action type="receive">RPM</Action>
    <Expected>1000</Expected>
  </Step>
  <Step id="3">
    <Action type="wait">2s</Action>
    <Expected>Idle</Expected>
  </Step>
</TestCase>

## ✨ Funzionalità
✅ Definizione standardizzata dei test tramite XML + XSD

⚡ Parsing veloce con TinyXML2 in C++

🛠️ Automazione completa via script Bash

📂 Gestione log (dettagli esecuzione, errori, riepilogo)

🔄 Scalabile: aggiungere un nuovo test significa solo scrivere un nuovo XML

🚀 Installazione
Prerequisiti
Linux/Unix environment

g++ con supporto C++17

TinyXML2

xmllint (libxml2-utils)

Setup
bash
Copia codice
git clone https://github.com/user/xml-test-framework.git
cd xml-test-framework
make   # oppure compilazione manuale via g++

## 💻 Utilizzo
1. Validare un file XML
bash
Copia codice
xmllint --noout --schema schemas/test_schemas.xsd tests/test_example.xml
2. Eseguire un singolo test
bash
Copia codice
bin/test_runner.exe tests/test_example.xml
3. Eseguire tutti i test
bash
Copia codice
./scripts/run_all_test.sh

## ⚙️ Configurazione
I test sono definiti in file .xml dentro la cartella tests/.
Lo schema di riferimento è schemas/test_schemas.xsd.

Per aggiungere un nuovo test:

Scrivi un file XML rispettando lo schema.

Salvalo in tests/.

Esegui ./scripts/run_all_test.sh.

## 📁 Struttura Progetto

<pre> ```text test-framework/ ├── bin/ # eseguibili compilati │ └── test_runner.exe ├── build/ # file oggetto (build intermedi) ├── logs/ # log di esecuzione e riepiloghi ├── Makefile # regole di build ├── README.md # documentazione ├── schemas/ # schema XSD │ └── test_schemas.xsd ├── scripts/ # script di automazione │ ├── pre-commit │ └── run_all_test.sh ├── src/ # sorgenti C++ │ └── main.cpp └── tests/ # file XML di test ├── test_example.xml └── test2_example.xml ``` </pre>
