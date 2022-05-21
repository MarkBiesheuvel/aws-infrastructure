#!/user/bin/env python3
from typing import List
from constructs import Construct
from aws_cdk import (
    Duration,
    aws_certificatemanager as acm,
    aws_cloudfront as cloudfront,
    aws_s3 as s3
)


class WebsiteConstruct(Construct):

    def __init__(self, scope: Construct, id: str, aliases: List[str], certificate_arn: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        bucket = s3.Bucket(self, 'Storage')

        origin_identity = cloudfront.OriginAccessIdentity(self, 'Identity')

        bucket.grant_read(origin_identity.grant_principal)

        certificate = acm.Certificate.from_certificate_arn(self, 'Certificate', certificate_arn=certificate_arn)

        distribution = cloudfront.CloudFrontWebDistribution(
            self, 'CDN',
            price_class=cloudfront.PriceClass.PRICE_CLASS_ALL,
            viewer_certificate=cloudfront.ViewerCertificate.from_acm_certificate(
                certificate=certificate,
                aliases=aliases,
                security_policy=cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
            ),
            origin_configs=[
                cloudfront.SourceConfiguration(
                    s3_origin_source=cloudfront.S3OriginConfig(
                        s3_bucket_source=bucket,
                        origin_access_identity=origin_identity,
                    ),
                    behaviors=[
                        cloudfront.Behavior(
                            default_ttl=Duration.days(1),
                            min_ttl=Duration.days(1),
                            max_ttl=Duration.days(365),
                            is_default_behavior=True,
                        )
                    ]
                )
            ]
        )

        self.bucket = bucket
        self.distribution = distribution
