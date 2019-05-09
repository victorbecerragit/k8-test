# Specify the provider (GCP, AWS, Azure)
provider "google" {
 credentials = "${file("challenge-lab.json")}"
 project = "challenge-lab"
 region = "us-central1"
}
