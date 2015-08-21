# Change route53 A records based on OpsWorks Information

This chef recipe demonstrates the change (creation and deletion) of an A
record based on information gathered from the EC2 OpsWorks instance which
is executing the recipe.

__The Problem__

Typically, if you start an EC2 instance and you do not use Elastic IPs,
the IP address of the instance will change whenever it is rebooted. A
more convenient way would be to create a DNS record for this instance
and update this record every time the instance gets provisioned.

__The Solution__

The two recipes provided by this chef cookbook provide exactly this
functionality (create and delete whereby create can be used to
update/overwrite existing records).

# Prerequisites

## Hosted-Zone
* A route53 Hosted-Zone which should be changed has to be created.

## IAM User and Policy
* An IAM User with the rights to change route53 entries for a specific
  Hosted-Zone has to be created.

The following policy describes the necessary rights. Be aware that
`"route53:*"` gives the user full access for the defined Hosted-Zone. If
you want to be more secure, the actions `["route53:ChangeResourceRecordSets"
, "route53:GetHostedZone", "route53:ListResourceRecordSets"]`
should be sufficient.

```json
{
  "Version": "2012-10-17",
    "Statement": [
    {
      "Sid": "Stmt1438457727000",
      "Effect": "Allow",
      "Action": [
        "route53:*"
        ],
      "Resource": [
        "arn:aws:route53:::hostedzone/<your-hosted-zone-id>"
        ]
    }
  ]
}
```

## OpsWorks Stack
* An OpsWorks Stack and at least one EC2 instance registered to this Stack
  have to be created.
* You can use this repository or a fork as __Use custom Chef cookbooks__
  value. It is important to set __Mangage Berkshelf__ to `yes`. This
  cookbook has a dependency to the
  [route53](https://supermarket.chef.io/cookbooks/route53) cookbook
  which is handled by Berkshelf.
* Custom Stack settings are used to define the Hosted-Zone and the domain
  you want to update. For authentication and authorization purposes you
  also have to provide your AWS access key and secret (see IAM User and
  Policy).

Custom JSON (example):

```json
{
  "dns_zone_id" : "M6WHR741EFWQ3",
  "custom_domain" : "example.com",
  "custom_access_key": "AKIAIOSFODNN7EXAMPLE",
  "custom_secret_key": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}
```

# Areas to improve

* The most important area to improve are tests. I skipped those because
  this is just a proof of concept. Any further use should include tests.
* The used schema for the DNS A record is fix but should implemented in a
  more flexible manner. It would be nice to have more control instead of
  `instance_name.stack_name.domain`. A possible solution to this problem
  would be to allow the access to `node[:opsworks]` values via to the custom
  JSON. So any desired combination of available OpsWorks values could be used.
  (This approach might introduce some new problems wiht edge cases, though.)
* There are some issues with values which have to be case sensitive.
  So a refactoring of the cases by wrapping variables with a downcase or
  similar method could make things more robust.
* Right now only A records are supported. That can be changed by the use
  of custom JSON or custom attributes for the `type` and `ttl`. Of course,
  the cookbook should be renamed after this enhancement.

# LightWeight Resource/Provider (LWRP)

The chef cookbook uses my implementation of the LWRP
[route53](https://github.com/kgalli/route53) which can be
found on github. It uses a simple ruby gem called
[route53_a_record](https://github.com/kgalli/route53_a_record)
which source code is also located at github. For more information
plesase visit the github repositories. You will find a `README.md` there.

