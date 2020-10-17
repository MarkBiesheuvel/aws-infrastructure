#!/user/bin/env python3
from os import environ
from aws_cdk import (
    core,
    aws_codebuild as codebuild,
    aws_codecommit as codecommit,
    aws_codepipeline as codepipeline,
    aws_codepipeline_actions as codepipeline_actions,
    aws_s3 as s3
)


class WebsiteStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        website_bucket = s3.Bucket(self, 'Website')

        repo = codecommit.Repository(self, 'Repository',
            repository_name=id.lower() # TODO: convert name to snake_case
        )

        project = codebuild.PipelineProject(self, 'Builder',
            environment=codebuild.BuildEnvironment(
                build_image=codebuild.LinuxBuildImage.AMAZON_LINUX_2_3,
                compute_type=codebuild.ComputeType.LARGE
            ),
            cache=codebuild.Cache.local(
                codebuild.LocalCacheMode.CUSTOM,
            ),
            build_spec=codebuild.BuildSpec.from_object({
                'version': 0.2,
                'cache': {
                    'paths': [
                        'nodemodules/**/*'
                    ],
                },
                'phases': {
                    'install': {
                        'runtime-versions': {
                            'nodejs': 12
                        }
                    },
                    'pre_build': {
                        'commands': [
                            'echo Pre-build started on `date`',
                            'yarn install'
                        ]
                    },
                    'build': {
                        'commands': [
                            'echo Build started on `date`',
                            'yarn build'
                        ]
                    }
                },
                'artifacts': {
                    'files': ['**/*'],
                    'base-directory': 'dist'
                }
            }),
        )

        source_artifact = codepipeline.Artifact('SourceArtifact')

        build_artifact = codepipeline.Artifact('BuildArtifact')

        pipeline = codepipeline.Pipeline(self, 'Pipeline',
            cross_account_keys=False,
            restart_execution_on_update=True,
            stages=[
                codepipeline.StageProps(
                    stage_name='Source',
                    actions=[
                        codepipeline_actions.CodeCommitSourceAction(
                            action_name='Source',
                            repository=repo,
                            output=source_artifact,
                        )
                    ]
                ),
                codepipeline.StageProps(
                    stage_name='Build',
                    actions=[
                        codepipeline_actions.CodeBuildAction(
                            action_name='Build',
                            project=project,
                            input=source_artifact,
                            outputs=[build_artifact],
                        )
                    ]
                ),
                codepipeline.StageProps(
                    stage_name='Deploy',
                    actions=[
                        codepipeline_actions.S3DeployAction(
                            action_name='Deploy',
                            input=build_artifact,
                            bucket=website_bucket,
                            extract=True,
                        )
                    ]
                )
            ]
        )


app = core.App()
stack = WebsiteStack(
    app, 'PersonalWebsite'
)
app.synth()
