#!/bin/bash
# =================================================================================================
# Dockerized-NorLab container runtime entrypoint callback.
# Is executed only once on container initialisation, at the end of the project-deploy entrypoints.
#
# Usage:
#   Add only project-deploy specific logic that need to be executed only on startup.
#
# Globals:
#   Read/write all environment variable exposed in DN at runtime
#
# =================================================================================================

# ....DN-project internal logic....................................................................
source /dnp-lib-container-tools/project_entrypoints/entrypoint_helper.global.init.bash


# ====DN-project user defined logic================================================================
# Add your code here
