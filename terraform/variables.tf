
variable "yandex_cloud_id" {
    type = string
    description = "Yandex cloud id"
}

variable "yandex_folder_id" {
    type = string
    description = "Yandex folder id"
}

variable "my_public_key" {
    type = string
    description = "My public key"
}

variable "lb" {
  type = object({
 prefix = list (string),
})
  default = {
       prefix = ["node1", "prometheus"]
      }
}


  
