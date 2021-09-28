# resource "aws_eip" "nat" {
#   count = var.enable_nat_gateway && false == var.reuse_nat_ips ? local.nat_gateway_count : 0

#   vpc = true

#   tags = merge(
#     {
#       "Name" = format(
#         "%s-%s",
#         var.name,
#         element(var.azs, var.single_nat_gateway ? 0 : count.index),
#       )
#     },
#     var.tags,
#     var.nat_eip_tags,
#   )
# }

# resource "aws_nat_gateway" "example" {
#   allocation_id = aws_eip.example.id
#   subnet_id     = aws_subnet.example.id

#   tags = {
#     Name = "Public_Nat_GW"
#   }

#   depends_on = [aws_internet_gateway.internet_gw]
# }