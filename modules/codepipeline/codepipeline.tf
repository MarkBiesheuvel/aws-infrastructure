data "aws_iam_policy_document" "codepipeline_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.name}-codepipeline-role"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline_role_policy_document.json}"
}

data "aws_iam_policy_document" "codepipeline_policy_document" {
  statement {
    resources = [
      "${aws_s3_bucket.artifact_store.arn}",
      "${aws_s3_bucket.artifact_store.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]
  }

  statement {
    resources = [
      "${aws_codecommit_repository.main.arn}",
    ]

    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]
  }

  statement {
    resources = [
      "${aws_codebuild_project.main.id}",
    ]

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.name}-codepipeline-policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = "${data.aws_iam_policy_document.codepipeline_policy_document.json}"
}

resource "aws_codepipeline" "main" {
  name     = "${var.name}-codepipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifact_store.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration {
        RepositoryName       = "${aws_codecommit_repository.main.repository_name}"
        BranchName           = "master"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.main.name}"
      }
    }
  }
}
