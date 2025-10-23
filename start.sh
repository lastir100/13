#!/bin/bash
terraform apply && cat ssh_config > ~/.ssh/config && ansible-playbook -i hosts.ini playbooks/site.yml

