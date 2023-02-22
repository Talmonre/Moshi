#!/usr/bin/env python
#
# Licensed under the Biostar Handbook license.
#
from __future__ import print_function, unicode_literals

import os, time
import re
import subprocess
import sys
from os.path import expanduser
from sys import platform

PY3 = True if (sys.version_info > (3, 0)) else False


def exists():
    return True


def regexp_check(pattern, text):
    return re.search(pattern, text, re.MULTILINE)


def more_recent(pattern, text):
    version = text.strip()
    return version >= pattern


# A list of tools to check.
TOOLS = [
    'bwa', 'datamash', 'fastqc -h', 'hisat2', 'seqret -h',
    'featureCounts', 'efetch', 'esearch', 'samtools', 'fastq-dump', 'bowtie2', 'bcftools',
    'seqtk', 'seqkit', 'bio', 'fastq-dump -X 1 -Z SRR1553591', 'pycirclize -h', 'mgcplotter -h', 'pymsaviz -', 'pygenomeviz -h', 'aniclustermap -h', 'cogclassifier -h', 'mmseqs2 -h',
]

def bash_check():
    bashrc = expanduser("~/.bashrc")
    bashprofile = expanduser("~/.bash_profile")


def path_check():
    errors = 0
    # The PATH variable
    paths = os.environ.get('PATH').split(':')
    bindir = expanduser("~/bin")

    #
    # We need ~/bin to be in the PATH
    #
    if bindir not in paths:
        errors += 1
        print("# The ~/bin folder is not in your PATH!")

    return errors


def tool_check(tools):
    errors = 0
    print("# Checking symptoms ...")
    time.sleep(1)  # sorry, it is for the cool effect ...
    for cmd in tools:
        args = cmd.split()
        print("# {} ... ".format(cmd), end="")
        sys.stdout.flush()



        res = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


        code = res.returncode

        if code not in (0, 1, 255):
            print("ERROR")
            errors += 1
        else:
            print("OK")

    return errors


FIXME = """
#
# Please see the installation at: https://www.biostarhandbook.com/
#
# If you are feeling adventurous, you can try the following:
#
# Uninstalls everything.
curl http://data.biostarhandbook.com/uninstall.sh | bash

# Installs everything.
curl http://data.biostarhandbook.com/install.sh | bash

"""


def fixme():
    print(FIXME)


def health_check():
    errors = 0
    errors += path_check()
    errors += tool_check(tools=TOOLS)

    if errors:
        print("#")
        if errors == 1:
            print("# Your system shows 1 error!")
        else:
            print("# Your system shows {} errors!".format(errors))
        print("#")
        print("# Run the command that has failed for more details.")
        print("#")
    else:
        print("# You are doing well!")


if __name__ == '__main__':
    if '--fixme' in sys.argv:
        fixme()
    else:
        print("# Doctor! Doctor! Give me the news.")
        health_check()
