variable "library_movies_dir" {
  type        = string
  description = "Path on the host pointing to the movies library. This is the directory where Radarr will store the movies and where Plex will read them from."
}

variable "library_tv_dir" {
  type        = string
  description = "Path on the host pointing to the TV shows library. This is the directory where Sonarr will store the TV shows and where Plex will read them from."
}

variable "downloads_dir" {
  type        = string
  description = "Path on the host pointing to the downloads directory. This is where Transmission will download the torrents to. It is also where Radarr and Sonarr will read the files from after downloading."
}