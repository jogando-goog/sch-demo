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

terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 5.0"
    }
  }
}

module "google_project_service" {
  source                  = "terraform-google-modules/project-factory/google//modules/project_services"
  version                 = "14.1.0"
  project_id              = var.project_id
  activate_apis           = ["storage.googleapis.com"]
}

# Create GCS bucket to hold state file
resource "google_storage_bucket" "gcs_statefile_bucket" {
  project                 = var.project_id
  name                    = var.storage_bucket_name
  location                = var.storage_bucket_location
  force_destroy           = false
  storage_class           = "STANDARD"
  versioning {
    enabled               = true
  }
  depends_on              = [module.google_project_service]
}