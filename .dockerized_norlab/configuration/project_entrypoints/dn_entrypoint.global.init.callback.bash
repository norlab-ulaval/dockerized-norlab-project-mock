#!/bin/bash
# =================================================================================================
# Dockerized-NorLab container runtime entrypoint callback.
# Is executed only once on container initialisation, at the end of the project-develop or
# project-deploy entrypoints.
#
# Usage:
#   Add project wide logic that need to be executed only on startup.
#
# Globals:
#   Read/write all environment variable exposed in DN at runtime
#
# =================================================================================================

#DN_SHOW_DEBUG_INFO=true

# ....Runtime debug................................................................................
if [[ ${DN_SHOW_DEBUG_INFO} == true ]]; then
  MSG_WARNING_FORMAT="\033[1;33m"
  MSG_END_FORMAT="\033[0m"
  echo -e "${MSG_WARNING_FORMAT}[DN runtime debug]${MSG_END_FORMAT} Check container DN env var..."
  echo
  printenv | grep -e DN_ -e DNA_ -e PATH -e PYTHONPATH
  echo
  echo -e "${MSG_WARNING_FORMAT}[DN runtime debug]${MSG_END_FORMAT} Check container available files..."
  echo
  tree -aguL 3 /dna-lib-container-tools
  echo
  tree -aguL 3 /project_entrypoints
  echo
  tree -aguL 1  -I .git /
  echo
  tree -aguL 1  -I .git "${DN_PATH}"
  echo
  tree -aguL 1  -I .git "$HOME"
  echo
  tree -aguL 3 -I .git -I utilities /dockerized-norlab/
  echo
  echo -e "${MSG_WARNING_FORMAT}[DN runtime debug]${MSG_END_FORMAT} Users configuration sanity check..."
  echo
  echo "whoami: $(whoami)"
  echo "id ${DN_PROJECT_USER}: $(id "${DN_PROJECT_USER}")"
  if [[ -n ${DN_SSH_SERVER_USER}  ]]; then
    echo "id ${DN_SSH_SERVER_USER}: $(id "${DN_SSH_SERVER_USER}")"
    echo "DN_SSH_SERVER_USER: ${DN_SSH_SERVER_USER}"
  else
    echo "No DN_SSH_SERVER_USER"
  fi
  echo "DN_CONTAINER_TOOLS_LOADED: ${DN_CONTAINER_TOOLS_LOADED}"
  echo "DEBIAN_FRONTEND: ${DEBIAN_FRONTEND}"
  echo
  echo -e "${MSG_WARNING_FORMAT}[DN runtime debug]${MSG_END_FORMAT} Check users setup..."
  echo "getent passwd root: $(getent passwd root)"
  if [[ -n ${DN_SSH_SERVER_USER}  ]]; then
    echo "getent passwd ${DN_PROJECT_USER}: $(getent passwd "${DN_PROJECT_USER}")"
  fi
  echo "getent passwd ${DN_SSH_SERVER_USER}: $(getent passwd "${DN_SSH_SERVER_USER}")"
  echo
fi


# ....DNA-project internal logic...................................................................
source /dna-lib-container-tools/project_entrypoints/entrypoint_helper.global.common.bash || exit 1
source /dna-lib-container-tools/project_entrypoints/entrypoint_helper.global.init.bash || exit 1

# ====DNA-project user defined logic===============================================================
# Add your code here

# ....DNA-project optional logic...................................................................
source /dna-lib-container-tools/project_entrypoints/entrypoint_helper.show_info.bash || exit 1

# ....Examples: source ROS2 environment variables..................................................
#dn::source_ros2_underlay_only
#dn::source_ros2_overlay_only
dn::source_ros2

# ....Show N2ST and DN librairy available functions................................................
# To check available N2ST lib and DN lib functions, un-comment te following lines
n2st::print_msg "Show in container available N2ST functions...\n${MSG_DIMMED_FORMAT}"
for func in $(compgen -A function | grep -e n2st::); do
  # shellcheck disable=SC2163
  echo "   ${func}"
done
echo -e "${MSG_END_FORMAT}"
n2st::print_msg "Show in container available DN functions...\n${MSG_DIMMED_FORMAT}"
for func in $(compgen -A function | grep -e dn::); do
  # shellcheck disable=SC2163
  echo "   ${func}"
done
