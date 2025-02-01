ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i inventory.ini main.yml \
    --limit 'all' --skip-tags "none" --tags "all"