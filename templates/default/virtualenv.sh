#!/bin/bash
# ----------------------------------------------------------------
# -- This profile script sets virtualenv settings.              --
# --                                                            --
# -- The contents of a this script are generated by Chef.       --
# -- Do not change them unless you are *sure* you know what     --
# -- you're doing.                                              --
# ----------------------------------------------------------------

# Use distribute rather than setuptools.
export VIRTUALENV_USE_DISTRIBUTE=1

# Set the default Python interpreter to use for virtualenvs.
export VIRTUALENV_PYTHON='<%= node['python']['virtualenv']['options']['python'] %>'

# Make it such that all new virtualenvs that are created
# get a yellow prompt with a trailing space, rather than the default.
export VIRTUALENV_PROMPT='<%= node['python']['virtualenv']['options']['prompt'] %>'

