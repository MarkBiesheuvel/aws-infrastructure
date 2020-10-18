#!/user/bin/env python3
from os import environ
from pipeline import PipelineConstruct
from website import WebsiteConstruct
from aws_cdk import (
    core
)


class WebsiteStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        website = WebsiteConstruct(self, 'Website')

        pipeline = PipelineConstruct(self, 'Pipeline',
            target_bucket=website.bucket
        )



app = core.App()
stack = WebsiteStack(
    app, 'PersonalWebsite'
)
stack = WebsiteStack(
    app, 'FarmWebsite'
)
app.synth()
