resource "matchbox_group" "flatcar-worker" {
  name    = "flatcar-worker"
  profile = matchbox_profile.flatcar-worker.name
}
