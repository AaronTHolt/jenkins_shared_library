git clone https://gitlab-ci-token:${MFIX_EXA_TOKEN}@mfix.netl.doe.gov/gitlab/exa/mfix.git
cd mfix
git checkout develop
cd ..
sudo /usr/local/bin/singularity build mfix_full.img mfix_full.def
