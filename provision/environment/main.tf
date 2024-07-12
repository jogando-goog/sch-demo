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

# Enable Google Cloud APIs
module "google_project_service" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "14.1.0"
  project_id                  = var.project_id
  activate_apis               = local.org_project.enable_apis
  disable_services_on_destroy = false
}
resource "time_sleep" "wait_60_seconds" {
  depends_on = [module.google_project_service]
  create_duration = "60s"
}

# Create Artifact Registry
resource "google_artifact_registry_repository" "artifact_registry" {
  project       = var.project_id
  location      = var.artifact_repo_location
  repository_id = var.artifact_repo_name
  description   = "Docker artifact repository"
  format        = "DOCKER"

  depends_on = [module.google_project_service,time_sleep.wait_60_seconds]
}

# Create Storage Bucket
resource "google_storage_bucket" "storage_bucket" {
  project                 = var.project_id
  name                    = var.storage_bucket_name
  location                = var.storage_bucket_location
  force_destroy           = true
  storage_class           = "STANDARD"
  versioning {
    enabled               = true
  }
  depends_on              = [module.google_project_service,time_sleep.wait_60_seconds]
}



# Create Pub/Sub Topic
resource "google_pubsub_topic" "pubsub_topic" {
  name = var.pubsub_topic_name

  depends_on              = [module.google_project_service,time_sleep.wait_60_seconds]
}
# Upload Cloud Functions source code to storage bucket
resource "google_storage_bucket_object" "archive_submission_service_code" {
  name   = "submission_service_cf_index.zip"
  bucket = google_storage_bucket.storage_bucket.name
  source = data.archive_file.archive_cloud_functions_submission_service.output_path

  depends_on            = [google_storage_bucket.storage_bucket]
}

# Deploy Pipeline Job Submission Service (Cloud Functions)
resource "google_cloudfunctions_function" "pipeline_job_submission_service" {
  name                  = var.pipeline_job_submission_service_name
  region                = var.pipeline_job_submission_service_location
  docker_repository     = "projects/${var.project_id}/locations/${var.artifact_repo_location}/repositories/${var.artifact_repo_name}"
  service_account_email = google_service_account.pipeline_job_runner_service_account.email
  runtime               = "python39"
  entry_point           = "process_request"
  source_archive_bucket = google_storage_bucket.storage_bucket.name
  source_archive_object = google_storage_bucket_object.archive_submission_service_code.name
  available_memory_mb   = 512
  timeout               = 540
  
  event_trigger {
    event_type          = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource            = "projects/${var.project_id}/topics/${var.pubsub_topic_name}"
  }

  depends_on            = [google_artifact_registry_repository.artifact_registry, google_pubsub_topic.pubsub_topic]
}


# Create Cloud Scheduler Job
resource "google_cloud_scheduler_job" "scheduler_job" {
  project       = var.project_id
  region        = var.schedule_location
  name          = var.schedule_name
  schedule      = var.schedule_pattern
  pubsub_target {
    topic_name  = "projects/${var.project_id}/topics/${var.pubsub_topic_name}"
    data        = base64encode(file("../../pipelines/runtime_parameters/pipeline_parameter_values.json"))    
  }

  depends_on    = [google_pubsub_topic.pubsub_topic]
}
