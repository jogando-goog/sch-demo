#!/bin/bash
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
#
# DISCLAIMER: This code is generated as part of the AutoMLOps output.

# Submit terraform run creating all resources. 
# ./scripts/provision_resources.sh state_bucket to create the state bucket.
# ./scripts/provision_resources.sh environment to create the resources.
terraform -chdir=AutoMLOps/provision/$1 init
terraform -chdir=AutoMLOps/provision/$1 validate
terraform -chdir=AutoMLOps/provision/$1 apply -auto-approve