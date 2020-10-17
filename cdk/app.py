#!/user/bin/env python3
from os import environ
from aws_cdk import (
    core,
    aws_codecommit as codecommit,
)


class WebsiteStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        repo = codecommit.Repository(self, 'Repository',
            repository_name=id.lower() # TODO: convert name to snake_case
        )


app = core.App()
stack = WebsiteStack(
    app, 'PersonalWebsite'
)
app.synth()
