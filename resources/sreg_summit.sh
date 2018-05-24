#!/bin/bash

ssh -o StrictHostKeyChecking=no holtat@scompile.rc.int.colorado.edu << "EOF"

echo "HERE"
echo $SREG_ESCAPED
echo "HERE2"

echo $SREG_ESCAPED > /home/holtat/sreg_tmp

# Sregistry environment
export SREGISTRY_CLIENT_SECRETS=/home/holtat/sreg_tmp
export SREGISTRY_CLIENT=registry
mkdir -p /scratch/summit/holtat/singularity
export SREGISTRY_STORAGE=/scratch/summit/holtat/singularity

mkdir -p /projects/holtat/CICD
cd /projects/holtat/CICD

# Modules
source /etc/profile.d/lmod.sh
module load python/3.5.1 intel/17.4 singularity/2.4.2

# Install sregistry-cli in venv if needed
if [ ! -d "sreg" ]; then 
  virtualenv sreg
  source sreg/bin/activate
  pip3 install requests_toolbelt sregistry sqlalchemy
  git clone https://www.github.com/singularityhub/sregistry-cli.git
  cd sregistry-cli
  python3 setup.py install
else
  source sreg/bin/activate
fi

sregistry pull holtat/mfix_full
deactivate

EOF
