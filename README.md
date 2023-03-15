# Moshi
Moshi install code for setting up the Conda environments needed.
Install files required for automatic system setup. The script is a modified version of the one provided by the Biostar's team. Check out their work https://www.biostarhandbook.com/.

# To run the script, run:
```
curl https://raw.githubusercontent.com/Talmonre/Moshi/main/install.sh | bash
```

# Setting the source.
```
~/.bash_profile" or restart your terminal. 
```

# Activate the Moshi environment.
```
conda activate moshi
```

# Check your install.
```
doctor.py
```

# If everything fails, hit this undo button.
```
curl https://raw.githubusercontent.com/Talmonre/Moshi/main/uninstall.sh | bash
```

# Mamba can be used to install other packages that could be needed for this workflow. 
```
mamba install progressiveMauve mummer
```
