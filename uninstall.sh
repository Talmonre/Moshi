#
# Uninstalls conda and undoes changes made by install.sh
#
# It should be run only if no other customizations were made beyond what install.sh has applied.
#
set -uex

# Delete all files.
rm -rf ~/miniconda3 ~/minicond*.sh ~/.condarc ~/.conda ~/.parallel

# This is necessary since the default sed works differently on MacOS vs Linux
FUNKY=~/.tmp-sed-file

cp ~/.bashrc ${FUNKY}
cat ${FUNKY} | sed -n '/MOSHI_START/q;p' > ~/.bashrc

cp ~/.bash_profile ${FUNKY}
cat ${FUNKY} | sed -n '/MOSHI_START/q;p' > ~/.bash_profile

rm -f ${FUNKY}
