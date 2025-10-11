#!/bin/bash

#percorsi
schema=~/test-framework/schemas/test_schemas.xsd
test_dir=~/test-framework/tests
cpp_src=~/test-framework/src/main.cpp
exe=~/test-framework/bin/test_runner.exe
log=~/test-framework/log

time=$(date +%Y-%m-%d-%H-%M-%S)

# CREA PRIMA LE DIRECTORY DEI LOG!
mkdir -p "$log/err_log"
mkdir -p "$log/run_log" 
mkdir -p "$log/summar_log"

# ORA puoi creare i file
err_log="$log/err_log/err_$time.log"
run_log="$log/run_log/run_$time.log"
summary_log="$log/summar_log/sum_$time.log"

tot_tests=0
success_tests=0
fail_tests=0

if [ ! -f "$schema" ]; then
    echo "❌ Errore: lo schema $schema non esiste." > "$err_log"
    exit 1
fi

echo "🔧 Uso schema: $schema"

echo "compilazione programma C++..."
g++ -std=c++17 -o "$exe" "$cpp_src" -ltinyxml2
if [ $? -ne 0 ]; then
    echo "❌ Errore nella compilazione, uscita" >> "$err_log"
    exit 1
fi
echo "✅ Compilazione completata."

echo "-----------------------------------"

# Crea directory per l'eseguibile se non esiste
mkdir -p "$(dirname "$exe")"

#validazione dei files test.xml
for f in "$test_dir"/*.xml; do
    if [ -f "$f" ]; then  # Controlla che sia un file
        ((tot_tests++))
        echo "🔍 validazione $f..."
        xmllint --noout --schema "$schema" "$f" 2>> "$err_log"
        
        if [ $? -eq 0 ]; then
            echo "✅ $f valido, eseguo simulazione" >> "$run_log"
            
            # ESEGUI SIMULAZIONE E VERIFICA RISULTATO
            simulation_result=$("$exe" "$f" 2>> "$err_log")
            exit_code=$?
            
            echo "$simulation_result" >> "$run_log"
            
            # VERIFICA SE IL TEST È PASSATO O FALLITO
            if [ $exit_code -eq 0 ]; then
                echo "✅ TEST PASSATO: $f" >> "$run_log"
                ((success_tests++))
            else
                echo "❌ TEST FALLITO: $f (exit code: $exit_code)" >> "$run_log"
                ((fail_tests++))
            fi
            
        else
            echo "❌ $f non validato, salto simulazione" >> "$run_log"
            ((fail_tests++))
        fi
        echo "---" >> "$run_log"
    fi
done

# Riepilogo
echo "===================================" >> "$summary_log"
echo "📊 RIEPILOGO TEST COMPLETO" >> "$summary_log"
echo "Data: $(date)" >> "$summary_log"
echo "Numero totali di test: $tot_tests" >> "$summary_log"
echo "Numero test PASSATI: $success_tests" >> "$summary_log" 
echo "Numero test FALLITI: $fail_tests" >> "$summary_log"

if [ $tot_tests -gt 0 ]; then
    percentuale=$((success_tests * 100 / tot_tests))
    echo "Percentuale successo: ${percentuale}%" >> "$summary_log"
else
    echo "Nessun test eseguito" >> "$summary_log"
fi

# Mostra anche a schermo
echo "==================================="
echo "📊 RIEPILOGO TEST COMPLETO"
echo "Numero totali di test: $tot_tests"
echo "Numero test PASSATI: $success_tests"
echo "Numero test FALLITI: $fail_tests"

if [ $tot_tests -gt 0 ]; then
    percentuale=$((success_tests * 100 / tot_tests))
    echo "Percentuale successo: ${percentuale}%"
fi