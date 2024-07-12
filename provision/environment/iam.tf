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

##################################################################################
## IAMMember - Pipeline Job Runner Service Account
##################################################################################

resource "google_service_account" "pipeline_job_runner_service_account" {
  project                 = var.project_id
  account_id              = var.pipeline_job_runner_service_account_short
  display_name            = "Pipeline Runner Service Account"
  description             = "For submitting PipelineJobs"

  depends_on = [module.google_project_service,time_sleep.wait_60_seconds]
}

resource "google_project_iam_member" "pipeline_job_runner_service_account_iam" {
  for_each = toset(local.org_project.pipeline_runner_service_account_iam_list)
  project = var.project_id
  role = each.key
  member  = "serviceAccount:${google_service_account.pipeline_job_runner_service_account.email}"

  depends_on = [google_service_account.pipeline_job_runner_service_account]
}