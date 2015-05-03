#!/bin/sh

timestamp=$(date +"%s")
simulator="./bin/simulator.jar"
simulations_path="./simulations/"
model_path="$1"
model_name=$(basename $1)
model_name=${model_name%.*}
output="${simulations_path}${model_name}_${timestamp}.txt"


simulate() {
    echo "Simulating model: $model_path"
    echo "          Output: ${output}"
    java -jar $simulator run $model_path >> ${output}
    ruby parser.rb ${output}
}

simulate
