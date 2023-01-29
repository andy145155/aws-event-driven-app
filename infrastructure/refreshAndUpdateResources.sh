#!/bin/bash
terraform init
terraform apply
terraform output -json | jq "to_entries| map({(.key): .value.value}) | add" > config.json