#
# MOSHI system bootstrap adapted from the Biostars Handbook.
#

# Bash strict mode.
set -ue

echo "#"
echo "# Bootstrapping MOSHI ..."
echo "#"

# Default environment name.
ENV=moshi

# Conda directory name.
CONDA_DIR=~/miniconda3

# Select the download based on the platform.
if [ "$(uname)" == "Darwin" ]; then
	CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
else
	CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

# Ensure the file exists.
touch ~/.bashrc
# Append to bashrc if necessary.
if ! grep -q "MOSHI_START" ~/.bashrc; then
  echo "#"
  echo "# Updating ~/.bashrc"
  echo "#"
	curl -s https://raw.githubusercontent.com/Talmonre/Moshi/main/bashrc.txt >> ~/.bashrc
fi

# Ensure the file exists
touch ~/.bash_profile
# Append to bash_profile if necessary.
if ! grep -q "MOSHI_START" ~/.bash_profile; then
  echo "#"
  echo "# Updating ~/.bash_profile"
	echo "#"
	curl -s https://raw.githubusercontent.com/Talmonre/Moshi/main/bash_profile.txt >> ~/.bash_profile
fi

# Install conda if necessary.
if [ ! -d "$CONDA_DIR" ]; then
	# Download the miniconda installer.
	echo "#"
	echo "# Downloading: ${CONDA_URL}"
	echo "#"
	curl -s -L ${CONDA_URL} > miniconda-installer.sh

	# Install miniconda.
	echo "#"
	echo "# Running: miniconda-installer.sh"
	echo "#"
	bash miniconda-installer.sh -b
	
	# Initialize bash.
	${CONDA_DIR}/condabin/conda init bash

	# Update conda.
	echo "#"
  echo "# Updating conda"
	echo "#"
	${CONDA_DIR}/condabin/conda update -q -y -n base conda

	# Activate conda bioconda channels.
	${CONDA_DIR}/condabin/conda config -q --add channels bioconda
	${CONDA_DIR}/condabin/conda config -q --add channels conda-forge

	# Install mamba
  echo "#"
  echo "# Installing mamba"
	echo "#"
	${CONDA_DIR}/condabin/conda install mamba -q -n base -c conda-forge -y
fi

# Check that the conda environment exists
if [ ! -d "$CONDA_DIR/envs/$ENV" ]; then
  echo "#"
  echo "# Creating the Moshi environment"
	echo "#"
	${CONDA_DIR}/condabin/conda create -q -n $ENV -y python=3.8
fi

# The conda shell cannot be run in strict mode.
set +ue

# Apply the environment.
source ${CONDA_DIR}/etc/profile.d/conda.sh

# Activate the environment.
conda activate ${ENV}

# Reenable strict error checking.
set -eu

# Install the software for the biostar handbook.
echo "#"
echo "# Installing Moshi software"
echo "#"
curl -s https://raw.githubusercontent.com/Talmonre/Moshi/main/conda.txt | xargs mamba install -q -y

# Install the doctor.py 
mkdir -p ~/bin
curl -s https://raw.githubusercontent.com/Talmonre/Moshi/main/doctor.py > ~/bin/doctor.py
chmod +x ~/bin/doctor.py


# Install the bio package.
echo "#"
echo "# Installing the bio package"
echo "#"
pip install bio -q --upgrade

echo "#"
echo "# Installing the Entrez Direct"
echo "#"
yes | sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)" > /dev/null

#
# Reporting success.
#
echo "#"
echo "#"
echo "# Moshi installation complete!"
echo "#"
echo "#"

# There is a "nagware" aspect to GNU parallel that interferes running it automatically.
# The commands below silences the warning by accepting the license.
set +ue
echo 'will cite' | parallel --citation 1> /dev/null  2> /dev/null
