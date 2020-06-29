# Sart ssh-agent
eval $(ssh-agent -s)

# Check for running agents
ps -p $(pgrep ssh-agent)

# Add default key to the agent
ssh-add

# Add the key and store the passphrases
ssh-add -K ~/.ssh/id_rsa_custom

# Check loaded keys
ssh-add -l
