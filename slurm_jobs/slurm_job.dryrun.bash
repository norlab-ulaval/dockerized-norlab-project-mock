#!/bin/bash
#SBATCH --gres=gpu:0
#SBATCH --cpus-per-task=2
#SBATCH --time=0-01:00
#SBATCH --output=out/%x-%j.out


# Note: Flag time format --time=D-HH:MM ->  D=day, HH=hours, MM=minutes

# =================================================================================================
# Execute slurm job
#
# Usage:
#   $ bash slurm_job.dryrun.bash [<any-dnp-argument>]
#
# =================================================================================================
declare -x SJOB_ID
declare -a dnp_run_slurm_flags=()
declare -a hydra_flags=()

# ====Setup========================================================================================
# ....Custom setup (optional)......................................................................
function dnp::job_setup_callback() {
  # Add any instruction that should be executed before 'dnp run slurm' command
  :
}

# ....Custom teardown (optional)...................................................................
function dnp::job_teardown_callback() {
  local exit_code=$?
  # Note: Command 'dnp run slurm' already handle stoping the container in case the slurm command

  # TODO: Add any instruction that should be executed after 'dnp run slurm' exit.
  #  `scancel` is issued.
  exit ${exit_code:1}
}

# ....Set job name.................................................................................
# TODO: Set SJOB_ID
SJOB_ID="default"
# Note: Recommend opening an issue tracker task (e.g., YouTrack, GitHub issue, Trello)
#  and use its issue ID as an SJOB_ID.

# ....Hydra app module.............................................................................
# TODO: Set python module to launch
hydra_flags+=("launcher/example_app_hparm_optim.py")
# Note: assume container workdir is `<super-project>/src/`

# ....Optional hydra flags.........................................................................
# --config-path,-cp : Overrides the config_path specified in hydra.main(). (absolute or relative)
# --config-name,-cn : Overrides the config_name specified in hydra.main()
# --config-dir,-cd : Adds an additional config dir to the config search path

#hydra_flags+=("--config-path=")
#hydra_flags+=("--config-dir=")
#hydra_flags+=("--config-name=")

# ....Debug flags..................................................................................
dnp_run_slurm_flags+=(--register-hydra-dry-run-flag "run_pytorch_check=true")

dnp_run_slurm_flags+=("--skip-core-force-rebuild")
dnp_run_slurm_flags+=("--dry-run")

# ====DNP internal=================================================================================
dnp_run_slurm_flags+=("--log-name" "$(basename -s .bash $0)")
dnp_run_slurm_flags+=("--log-path" "artifact/slurm_jobs_logs")
dnp_run_slurm_flags+=("$@")
export SJOB_ID
dnp::job_setup_callback
trap dnp::job_teardown_callback EXIT

# ====Launch slurm job=============================================================================
dnp run slurm "${SJOB_ID:?err}" "${dnp_run_slurm_flags[@]}" "${hydra_flags[@]}"

