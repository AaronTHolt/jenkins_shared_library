# Get VAULT sregistry secret
echo $SREGISTRY > sreg_tmp
export SREGISTRY_CLIENT_SECRETS=sreg_tmp
export SREGISTRY_CLIENT=registry

# Push image to sregistry
sregistry push --name holtat/mfix_full mfix_full.img

# Delete secret
shred sreg_tmp
