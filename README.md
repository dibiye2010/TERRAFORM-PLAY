LESSON 2:

TERRAFORM STATE: what configuration file we currently have(state of ressources).
terraform plan compare the current state and what has been in our configuration files. 
#keep track of the state of the ressources that we have deployed. 
TERRAFORM STATE COMMANDS:
terraform state list: to list all the managed ressources
$ terraform state list
data.aws_ami.amazon
aws_instance.terra-ec2
aws_instance.terra-instance
aws_internet_gateway.terra_igw
aws_route_table.priv_rt
aws_route_table.pub_rt
aws_route_table_association.priv_sub_rt
aws_route_table_association.pub_sub_rt
aws_security_group.allow_shhweb
aws_subnet.terra_priv_sub1
aws_subnet.terra_pub_sub1
aws_vpc.terra_vpc
terraform state show identifier: to check the details state information of a ressource.
$ terraform state show aws_instance.terra-ec2
aws_instance.terra-ec2:
resource "aws_instance" "terra-ec2" {
    ami                                  = "ami-05c13eab67c5d8861"
    arn                                  = "arn:aws:ec2:us-east-1:175364008455:instance/i-096dd188cdaac575c"
    associate_public_ip_address          = true
    availability_zone                    = "us-east-1a"
    cpu_core_count                       = 1
    cpu_threads_per_core                 = 1
    disable_api_stop                     = false

OUTPUT VARIABLES: provide a convenient way to get useful information about your infrastructure.
extracting ip addresses. unlike cloudformation, terraform Outputs is just for desplaying information.
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.
Outputs:
instance_terra-ec2_public_dns = "ec2-34-234-73-188.compute-1.amazonaws.com"
instance_terra-ec2_public_ip = "34.234.73.188"

VARIABLE LISTS and MAPS
list of multiple variables allowing you to choose from a pool of values. each value can be called using
INDEX in the list.

eg:
variable "users" {
  type = list(string)
  default = ["root", "user1", "user2"] #in programming a list starts with index 0
}

# referencing it
username = var.users[0]

VARIABLE MAPS:
they work much like dictionnaries. each value can be called by their corresponding KEY.

eg:
variable "plans" {
  type    = map(string)
  default = {
    "5USD"  = "1xCPU-1GB"
    "10USD" = "1xCPU-2GB"
    "20USD" = "1xCPU-3GB" 
    }
}
# you can access the right value by using the metching KEY

plan = var.plans["5USD"]

STRING INTERPOLATION: replacing values of variables into a placeholder of string.

variable "instance_rename" {
  description = "renaming the instance"
  type        = string
  default     = "Hello_Dicha"
}

tags = {
    Name = "terra-ec2-${var.instance_rename}" 
  }
# string interpolation to subtitute the value of a variable inside the string whe the code run
the instance rename will be terra-ec2-Hello_Dicha

META-ARGUMENTS
terraform object that can be use with any ressource block to change the behavior of the ressource.
DEPENDS-ON:
how terraform handles dependency is IMPLICIT DEPENDENCY eg: a SG will be referenced to an ec2, terraform will handle the order. DEPENDS-ON will allow you to create an EXPLICIT DEPENDENCY if a ressource needs more time to be created. eg: a database and an ec2. a role and ec2
 tags = {
    Name = "terra-ec2-${var.instance_rename}" #string interpolation
  }
  depends_on = [ aws_security_group.allow_shhweb ] # dependency even though implicit

COUNT:
allows you to duplicate the same ressource 
synthax: count = <whole number> accessing index by ${count.index}
eg: add the count
security_groups = [aws_security_group.allow_shhweb.id]
count           = 3
add it to the rename string interpolation
tags = {
    Name = "terra-ec2-${var.instance_rename}-${count.index}" so ec2 1 will terra-ec2-Hello_Dicha-0
THERE WAS AN ERROR: on the output file because we ask for 3 instances and the output was only returning us 1 public ip and 1 public dns

│ Error: Missing resource instance key
│
│   on output.tf line 2, in output "instance_terra-ec2_public_ip":
│    2:   value = aws_instance.terra-ec2.public_ip
│
│ Because aws_instance.terra-ec2 has "count" set, its attributes must be accessed on specific instances.
│
│ For example, to correlate with indices of a referring resource, use:
│     aws_instance.terra-ec2[count.index]
╵
╷
│ Error: Missing resource instance key
│
│   on output.tf line 6, in output "instance_terra-ec2_public_dns":
│    6:   value = aws_instance.terra-ec2.public_dns
│
│ Because aws_instance.terra-ec2 has "count" set, its attributes must be accessed on specific instances.
│
│ For example, to correlate with indices of a referring resource, use:
│     aws_instance.terra-ec2[count.index]

TROUBLESHOOT
we add the SPLAT OPERATOR [*] 

output "instance_terra-ec2_public_ip" {
  value = aws_instance.terra-ec2[*].public_ip
}

output "instance_terra-ec2_public_dns" {
  value = aws_instance.terra-ec2[*].public_dns
}

Outputs:

instance_terra-ec2_public_dns = [
  "ec2-34-228-168-148.compute-1.amazonaws.com",
  "ec2-3-91-81-58.compute-1.amazonaws.com",
  "ec2-3-85-208-40.compute-1.amazonaws.com",
]
instance_terra-ec2_public_ip = [
  "34.228.168.148",
  "3.91.81.58",
  "3.85.208.40",
]

ADDING APACHE SHELL SCRIPT

We add it to our configuration "install_apache.sh"
# to pass it to our code
adding user_date = flie() function in terraform that allows us to reference a file in the same configuration folder. or we can provide a path. it is called FILE FUNCTION
 user_data       = file("install_apache.sh")
