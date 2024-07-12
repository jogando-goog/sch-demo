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

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = [for api in local.org_project.enable_apis : api]
}

output "create_pipeline_job_runner_service_account_email" {
  description = "The pipeline job runner service account email."
  value       = google_service_account.pipeline_job_runner_service_account.email
}


output "create_artifact_registry" {
  description = "outputs for all google_artifact_registry_repositories created"
  value       = google_artifact_registry_repository.artifact_registry
}

output "create_storage_bucket" {
  description = "Bucket resource by name."
  value       = google_storage_bucket.storage_bucket
}

output "create_storage_bucket_names" {
  description = "Bucket names."
  value       = google_storage_bucket.storage_bucket.name
}

output "create_pubsub_topic" {
  description = "The created pub/sub topic."
  value       = google_pubsub_topic.pubsub_topic
}

output "create_cloud_function" {
  description = "All outputs of the created \"google_cloudfunctions_function\" resource."
  value       = google_cloudfunctions_function.pipeline_job_submission_service
}

output "create_cloud_scheduler_name" {
  description = "The name of the job created"
  value       = google_cloud_scheduler_job.scheduler_job.name
}

output "create_cloud_scheduler_job" {
  description = "The Cloud Scheduler job instance"
  value       = google_cloud_scheduler_job.scheduler_job
}
