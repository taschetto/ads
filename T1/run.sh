#!/bin/sh

simulator="./bin/simulator.jar"
simulations_path="./simulations/"
model="./models/xyz.yml"

timestamp() {
    echo $(date +"%s")
}

simulate() {
    simulation=$(timestamp)
    echo "Simulating model: $model"
    echo "          Output: ${simulations_path}${simulation}.txt."
    java -jar $simulator run $model >> ${simulations_path}${simulation}.txt
}

simulate
