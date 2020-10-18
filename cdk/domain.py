#!/user/bin/env python3
from typing import List
from website import WebsiteConstruct
from aws_cdk import (
    core,
    aws_route53 as route53,
    aws_route53_targets as route53_targets,
)


class DomainProps:

    def __init__(self, domain_name: str, txt_record_values: List[str], mx_record_values: List[route53.MxRecordValue]):
        self.domain_name = domain_name
        self.txt_record_values = txt_record_values
        self.mx_record_values = mx_record_values


class DomainConstruct(core.Construct):

    def __init__(self, scope: core.Construct, id: str, domain: DomainProps, website: WebsiteConstruct, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        zone = route53.HostedZone(
            self, 'Zone',
            zone_name=domain.domain_name,
            comment='Managed by CDK'
        )

        root_record_name = domain.domain_name
        wildcard_record_name = '*.{}'.format(root_record_name)

        website_target = route53.AddressRecordTarget.from_alias(
            alias_target=route53_targets.CloudFrontTarget(website.distribution)
        )

        route53.ARecord(
            self, 'RootIpv4',
            record_name=root_record_name,
            zone=zone,
            target=website_target,
        )

        route53.AaaaRecord(
            self, 'RootIpv6',
            record_name=root_record_name,
            zone=zone,
            target=website_target,
        )

        route53.ARecord(
            self, 'WildcardIpv4',
            record_name=wildcard_record_name,
            zone=zone,
            target=website_target,
        )

        route53.AaaaRecord(
            self, 'WildcardIpv6',
            record_name=wildcard_record_name,
            zone=zone,
            target=website_target,
        )

        route53.MxRecord(
            self, 'Email',
            record_name=root_record_name,
            zone=zone,
            values=domain.mx_record_values,
        )

        route53.TxtRecord(
            self, 'Text',
            record_name=root_record_name,
            zone=zone,
            values=domain.txt_record_values,
        )
