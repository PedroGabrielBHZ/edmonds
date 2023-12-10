#!/bin/bash

# Define o diretório onde os arquivos .wsoap estão localizados
DIRECTORY="./data/"

# Inicializa variáveis para acumular os totais de cada operação
total_load_graph=0
total_check_weights=0
total_add_supernode=0
total_construct_algo=0
total_run_algo=0
total_reconstruct=0
total_destroy=0
total_total=0
total_validate=0
file_count=0

# Armazena a lista de arquivos .wsoap num array
wsoap_files=($(find "$DIRECTORY" -name "*.wsoap"))
echo "Arquivos encontrados: ${#wsoap_files[@]}"

# Itera por cada arquivo .wsoap no diretório e subdiretórios
for wsoap_file in "${wsoap_files[@]}"
do
    # Verifica se o arquivo existe
    if [ -f "$wsoap_file" ]; then
        # Executa o comando e captura a saída
        output=$(./edmonds "$wsoap_file")

        # Extrai e soma os valores para cada operação (se a saída contém os tempos necessários)
        if echo "$output" | grep -q "finished in"; then
            total_load_graph=$((total_load_graph + $(echo "$output" | grep "load graph finished in" | grep -oP '\d+')))
            total_check_weights=$((total_check_weights + $(echo "$output" | grep "check weights finished in" | grep -oP '\d+')))
            total_add_supernode=$((total_add_supernode + $(echo "$output" | grep "add supernode finished in" | grep -oP '\d+')))
            total_construct_algo=$((total_construct_algo + $(echo "$output" | grep "construct algo DS finished in" | grep -oP '\d+')))
            total_run_algo=$((total_run_algo + $(echo "$output" | grep "run algo finished in" | grep -oP '\d+')))
            total_reconstruct=$((total_reconstruct + $(echo "$output" | grep "reconstruct finished in" | grep -oP '\d+')))
            total_destroy=$((total_destroy + $(echo "$output" | grep "destroy finished in" | grep -oP '\d+')))
            total_total=$((total_total + $(echo "$output" | grep "total finished in" | grep -oP '\d+')))
            total_validate=$((total_validate + $(echo "$output" | grep "validate finished in" | grep -oP '\d+')))

            file_count=$((file_count + 1))
        fi
    fi
done

# Verifica se algum arquivo foi processado
if [ $file_count -gt 0 ]; then
    # Calcula a média para cada tipo de operação
    average_load_graph=$(echo "scale=2; $total_load_graph / $file_count" | bc)
    average_check_weights=$(echo "scale=2; $total_check_weights / $file_count" | bc)
    average_add_supernode=$(echo "scale=2; $total_add_supernode / $file_count" | bc)
    average_construct_algo=$(echo "scale=2; $total_construct_algo / $file_count" | bc)
    average_run_algo=$(echo "scale=2; $total_run_algo / $file_count" | bc)
    average_reconstruct=$(echo "scale=2; $total_reconstruct / $file_count" | bc)
    average_destroy=$(echo "scale=2; $total_destroy / $file_count" | bc)
    average_total=$(echo "scale=2; $total_total / $file_count" | bc)
    average_validate=$(echo "scale=2; $total_validate / $file_count" | bc)

    # Exibe as médias
    echo "Média de 'load graph': $average_load_graph ms"
    echo "Média de 'check weights': $average_check_weights ms"
    echo "Média de 'add supernode': $average_add_supernode ms"
    echo "Média de 'construct algo DS': $average_construct_algo ms"
    echo "Média de 'run algo': $average_run_algo ms"
    echo "Média de 'reconstruct': $average_reconstruct ms"
    echo "Média de 'destroy': $average_destroy ms"
    echo "Média de 'total': $average_total ms"
    echo "Média de 'validate': $average_validate ms"
else
    echo "Nenhum arquivo .wsoap encontrado no diretório e subdiretórios especificados."
fi