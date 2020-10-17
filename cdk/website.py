#!/user/bin/env python3
from aws_cdk import (
    core,
    aws_cloudfront as cloudfront,
    aws_s3 as s3
)


class WebsiteConstruct(core.Construct):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        bucket = s3.Bucket(self, 'Storage')

        origin_identity = cloudfront.OriginAccessIdentity(self, 'Identity')

        bucket.grant_read(origin_identity.grant_principal)

        distribution = cloudfront.CloudFrontWebDistribution(
            self, 'CDN',
            price_class=cloudfront.PriceClass.PRICE_CLASS_ALL,
            origin_configs=[
                cloudfront.SourceConfiguration(
                    s3_origin_source=cloudfront.S3OriginConfig(
                        s3_bucket_source=bucket,
                        origin_access_identity=origin_identity,
                    ),
                    behaviors=[
                        cloudfront.Behavior(
                            default_ttl=core.Duration.days(1),
                            min_ttl=core.Duration.days(1),
                            max_ttl=core.Duration.days(365),
                            is_default_behavior=True,
                        )
                    ]
                )
            ]
        )

        self.bucket = bucket
