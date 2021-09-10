#!/bin/bash

#####   NOME:              start.sh
#####   VERSÃO:            1.0
#####   DESCRIÇÃO:         Lista todos os containers por imagens para a contagem de middleware.
#####   DATA DA CRIAÇÃO:   01/09/2021
#####   ESCRITO POR:       Germano Da Silva
#####   E-MAIL:            gedasilv@redhat.com
#####   DISTRO:            Fedora 34
#####   LICENÇA:           GPLv3
#####   PROJETO:           https://github.com/gedasilv/contagem-subs-middleware.git

LIST_NAMESPACE=()
COUNT=0
function list_projects() {
    local projetos=$(oc get projects)
    for i in $projetos
     do
        if [ $i != "NAME" ] && [ $i != "STATUS" ] && [ $i != "DISPLAY" ] && [ $i != "Active" ]
            then
            LIST_NAMESPACE[$COUNT]=$i
            COUNT=$((COUNT+1))
        fi
     done
}
list_projects

clear
echo -e " \033[1;33m Conectando ao cluster... \033[0m"
sleep 1
echo -e " \033[1;33m Foram encontrados ${#LIST_NAMESPACE[*]} namespaces. \033[0m"

echo "NAMESPACE;POD;CPU;MEMORY;LIMITE CPU;LIMITE MEMORIA;IMAGEM" >>testando.csv

for j in "${LIST_NAMESPACE[@]}"
do
   : 
   # do whatever on $i
   oc get pods -n $j -o jsonpath='{range .items[*]}{.metadata.namespace}{";"}{.metadata.name}{";"}{.spec.containers[*].resources.requests.cpu}{";"}{.spec.containers[*].resources.requests.memory}{";"}{.spec.containers[*].resources.limits.cpu}{";"}{.spec.containers[*].resources.limits.memory}{";"}{.status.containerStatuses[*].imageID}{"\n"}{end}'
   oc get pods -n $j -o jsonpath='{range .items[*]}{.metadata.namespace}{";"}{.metadata.name}{";"}{.spec.containers[*].resources.requests.cpu}{";"}{.spec.containers[*].resources.requests.memory}{";"}{.spec.containers[*].resources.limits.cpu}{";"}{.spec.containers[*].resources.limits.memory}{";"}{.status.containerStatuses[*].imageID}{"\n"}{end}' >>testando.csv
done