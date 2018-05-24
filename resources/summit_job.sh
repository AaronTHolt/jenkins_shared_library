cd /projects/holtat/CICD
if [ ! -d "mfix_singularity" ]; then 
  git clone https://github.com/ResearchComputing/mfix_singularity
  cd mfix_singularity
else
  cd mfix_singularity
  git pull
fi
sbatch sing_submit.sh
