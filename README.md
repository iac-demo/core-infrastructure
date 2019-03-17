# Prerequisites

To deploy core infrastructure, you will need to have AWS credentials for your account.

See https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html on how to set them up.

**Warning**: deploying this project will create AWS resources - you will be charged for their usage.

# Configuration

You need to set the following environment variables:
```
export TF_VAR_aws_region=<your_aws_region>
export TF_VAR_aws_account_id=<your_aws_account_id> 
export TF_VAR_s3_state_bucket=<s3_bucket_name_for_project_state>
```

# Provisioning Core Infrastructure
After setting up your configuration, you need to execute the following commands to provision your infrastructure and deploy your project.

Please note that terraform commands are executed through [Henka](https://github.com/roku-oss/henka) Gradle plugin.
It takes care of installing the right version of Terraform and initializing Terraform backends and plugins.

However, it prints out the actual Terraform commands into stdout, so if you're interested, you can inspect
their syntax and try them out directly.

1. `./gradlew terraform -P tfAction="plan -input=false"` - do a dry run and inspect resources to be created/modified.
2. `./gradlew terraform -P tfAction="apply -input=false -auto-approve"` - provision all infrastructure resources.

At this stage you can inspect the AWS console to make sure that VPC and other resources were provisioned correctly.

# What's Next

Then you can proceed with deploying `hello-world` microservice. Check out https://github.com/iac-demo/hello-world
for further instructions. 

# Cleaning Up

After you're done with the demo, you will want to destroy all resources,
so you don't have to pay for them while you're not using them.

You can do it with the following command:

```./gradlew terraform -P tfAction="destroy -input=false -auto-approve"```