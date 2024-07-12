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

#terraform {
#  backend "remote" {
#    organization = "***" ## provided by user
#    workspaces {
#      name = "***" ## provided by user
#    }
#  }
#}

data "archive_file" "archive_cloud_functions_submission_service" {
  type        = "zip"
  source_dir  = "../../services/submission_service"
  output_path = "submission_service.zip"
}

/******************************************
  Locals
*****************************************/
locals {
  org_project = {
    billing_account = "***"
    folder          = "folders/***"

    enable_apis = [
      "cloudbuild.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "compute.googleapis.com",
      "iamcredentials.googleapis.com",
      "iam.googleapis.com",
      "pubsub.googleapis.com",
      "storage.googleapis.com",
      "aiplatform.googleapis.com",
      "artifactregistry.googleapis.com",
      "cloudscheduler.googleapis.com",
      "cloudfunctions.googleapis.com",
      "logging.googleapis.com",
    ]

    pipeline_runner_service_account_iam_list = [
      "roles/aiplatform.user",
      "roles/artifactregistry.reader",
      "roles/cloudfunctions.admin",
      "roles/bigquery.user",
      "roles/bigquery.dataEditor",
      "roles/iam.serviceAccountUser",
      "roles/storage.admin",
    ]
  }
}