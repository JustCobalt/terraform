variable "external_network_id" {
  description = "ID du réseau externe public (pour routeur)"
  type        = string
}

variable "floating_ip_pool" {
  description = "Nom du pool d'adresses IP flottantes"
  type        = string
}

variable "image_name" {
  description = "Nom de l’image à utiliser"
  type        = string
}

variable "flavor_name" {
  description = "Type de VM"
  type        = string
}