#!/bin/sh

simulator="./bin/simulator.jar"
simulations_path="./simulations/"
model="./models/xyz.yml"

timestamp() {
    echo $(date +"%s")
}

simulate() {
    simulation=$(timestamp)
    echo "$simulation"

    echo "Running simulation for: $model"
    echo "Generating simulation file in ${simulations_path}${simulation}"
    mkdir ${simulations_path}${simulation}
    java -jar $simulator run $model >> ${simulations_path}${simulation}/simulation.txt
}

simulate
