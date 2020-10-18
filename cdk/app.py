#!/user/bin/env python3
from os import environ
from typing import List
from pipeline import PipelineConstruct
from website import WebsiteConstruct
from domain import DomainConstruct, DomainProps
from aws_cdk import (
    core,
    aws_route53 as route53,
)


class WebsiteStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, certificate_arn: str, aliases: List[str], domains: List[DomainProps], **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        website = WebsiteConstruct(
            self, 'Website',
            aliases=aliases,
            certificate_arn=certificate_arn
        )

        pipeline = PipelineConstruct(
            self, 'Pipeline',
            website=website
        )

        for domain in domains:
            DomainConstruct(
                self, domain.domain_name,
                domain=domain,
                website=website,
            )


gmail_mx_records = [
    route53.MxRecordValue(host_name='ASPMX.L.GOOGLE.COM.', priority=1),
    route53.MxRecordValue(host_name='ALT1.ASPMX.L.GOOGLE.COM.', priority=5),
    route53.MxRecordValue(host_name='ALT2.ASPMX.L.GOOGLE.COM.', priority=5),
    route53.MxRecordValue(host_name='ALT3.ASPMX.L.GOOGLE.COM.', priority=10),
    route53.MxRecordValue(host_name='ALT4.ASPMX.L.GOOGLE.COM.', priority=10),
]

environment = core.Environment(
    account=environ['CDK_DEFAULT_ACCOUNT'],
    region=environ['CDK_DEFAULT_REGION'],
)

app = core.App()
stack = WebsiteStack(
    app, 'PersonalWebsite',
    env=environment,
    certificate_arn='arn:aws:acm:us-east-1:312701731826:certificate/054196d8-6cfb-4442-96f5-9fdea2f1dd4a',
    aliases=[
        'markbiesheuvel.nl',
        '*.markbiesheuvel.nl',
        'markbiesheuvel.com',
        '*.markbiesheuvel.com',
        'biesheuvel.amsterdam',
        '*.biesheuvel.amsterdam'
    ],
    domains=[
        DomainProps(
            domain_name='markbiesheuvel.nl',
            mx_record_values=gmail_mx_records,
            txt_record_values=[
                'keybase-site-verification=MQdMI-5HCeqM2qtBfIFvp-KuOuuzcF4jpRKyXPC_qRU',
                'google-site-verification=rBnoBw43CdjL9C3UW1iALgugU9U0f-rS34eUyJqhPto',
            ]
        ),
        DomainProps(
            domain_name='markbiesheuvel.com',
            mx_record_values=gmail_mx_records,
            txt_record_values=[
                'keybase-site-verification=JjNLbpnupl7R4zaUm1NjR4oRXwmPhdycaEPSymTkubw',
                'google-site-verification=7OH7Rf5fCzg14NHsRxipcSP2aD567R19I4bJ6xYmsJA',
            ]
        ),
        DomainProps(
            domain_name='biesheuvel.amsterdam',
            mx_record_values=gmail_mx_records,
            txt_record_values=[
                'keybase-site-verification=AMT2VAindI6tVHJoxzgiBW1f6rgUxTPD40axiEZBSHw',
                'google-site-verification=OaXlu04o8ph-lAlzgCxuNUYkpec4asEOHqJB0VBtL_s',
            ]
        )
    ]
)
stack = WebsiteStack(
    app, 'FarmWebsite',
    env=environment,
    certificate_arn='arn:aws:acm:us-east-1:312701731826:certificate/5eb0c930-352a-4233-844b-a00a99a78bc1',
    aliases=[
        'biesheuvel.farm',
        '*.biesheuvel.farm'
    ],
    domains=[
        # Currently this is managed manualy
    ]
)
app.synth()
