#!/usr/bin/env bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script first replaces variables in the input template files (or STDIN),
# then prints their contents.                                                       
#                                                                              
# Usage:                                                                       
# tcat.sh [template-file ...]                                                  

set -euo pipefail

function render_template() {
  # Read the template file.
  template_file="$1"
  template=$(cat "${template_file}")

  # Generate a wrapper script for the template file.
  generated_file=$(mktemp /tmp/generated_XXXXXX.sh)
  run_id=$(echo "${generated_file}" | sed 's#/tmp/generated_\(.*\)\.sh#\1#')

  cat >${generated_file} <<__${run_id}__
# This is a generated script which renders the template based on the properties.

set -eu

cat <<_${run_id}_
${template}
_${run_id}_
__${run_id}__

  # Run the generated script to render the template.
  bash ${generated_file}

  # Clean up.
  rm ${generated_file}
}

function main() {
  # Read from STDIN if no template files are specified.
  local template_files
  if [[ $# -gt 0 ]]; then
    template_files=("$@")
  else
    template_files=("/dev/stdin")
  fi 

  # Render template files in order.
  for template_file in "${template_files[@]}"; do 
    if [[ -r "${template_file}" ]]; then
      render_template "${template_file}"
    else
      echo "File not readable: ${template_file}" >&2
      exit 1
    fi
  done
}

main "$@"
