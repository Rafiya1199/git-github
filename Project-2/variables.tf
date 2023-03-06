variable "source_branch" {
  description = "Source branch of the repository"
  default     = "test"
}

variable "destination_branch" {
  description = "Destination branch of the repository"
  type        = string
  default     = "main"
}

variable "merge_type" {
  description = "Merge type of the repository"
  type        = string
  default     = "SQUASH_MERGE"
}
