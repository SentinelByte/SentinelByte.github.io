resource "github_team" "security" {
  name        = "security"
  description = "Security team"
}

resource "github_team_repository" "security_repo_access" {
  team_id    = github_team.security.id
  repository = "critical-service"
  permission = "admin"
}
