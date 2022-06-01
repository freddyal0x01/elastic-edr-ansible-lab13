## The inventory file
resource "local_file" "Inventory" {
    content = templatefile("inventory.tmpl",
        {
                                                                        elk-ip = linode_instance.elk.ip_address,
            elk-label = linode_instance.elk.label,
                                            }
    )
    filename = "../inventory/inventory"
}