/**
 *
 * # Infrastructure
 * This sets up per environment/VPC resources. This defines the basic infrastructure including things such as VPC, Subnets, Network Access Control Lists, Security Groups, Paramstore Secrets, DNS, Swimlanes etc. Nearly all of this is done via other modules that break things up in smaller bit sizes parts that each get documented independently.
 *
 * We make use of per environment config.json and secrets.json files in the configs directory to set runtime variables.tf.tpl
 *
 */



