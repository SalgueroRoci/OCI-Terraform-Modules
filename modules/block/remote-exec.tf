variable "public_ip" {}
variable "ssh_private_key" {}

resource "null_resource" "remote-exec" {
  depends_on = ["oci_core_volume_attachment.TFBlockAttach"]

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${var.public_ip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "touch ~/IMadeAFile.Right.Here",
      "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.TFBlockAttach.*.iqn[0]} -p ${oci_core_volume_attachment.TFBlockAttach.*.ipv4[0]}:${oci_core_volume_attachment.TFBlockAttach.*.port[0]}",
      "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.TFBlockAttach.*.iqn[0]} -n node.startup -v automatic",
      "echo sudo iscsiadm -m node -T ${oci_core_volume_attachment.TFBlockAttach.*.iqn[0]} -p ${oci_core_volume_attachment.TFBlockAttach.*.ipv4[0]}:${oci_core_volume_attachment.TFBlockAttach.*.port[0]} -l >> ~/.bashrc",
    ]
  }
}
