# Kops in AWS

# Installing kops (Binaries)

## MacOS

From Homebrew:

```bash
brew update && brew install kops
```

Developers can also easily install [development releases](development/homebrew.md).

From Github:

```bash
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-darwin-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/
```

You can also [install from source](development/building.md).

## Linux

From Github:

```bash
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/
```

You can also [install from source](development/building.md).

# Installing Other Dependencies

## kubectl

`kubectl` is the CLI tool to manage and operate Kubernetes clusters.  You can install it as follows.

### MacOS

From Homebrew:
```
brew install kubernetes-cli
```

From the [official kubernetes kubectl release](https://kubernetes.io/docs/tasks/tools/install-kubectl/):

```
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

### Linux

From the [official kubernetes kubectl release](https://kubernetes.io/docs/tasks/tools/install-kubectl/):

```
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```
# Installing AWS CLI Tools

https://aws.amazon.com/cli/

 On MacOS, Windows and Linux OS:
 
 The officially supported way of installing the tool is with `pip`:
 
```bash
pip install awscli
```

##### _OR use these alternative methods for MacOS and Windows:_

### MacOS

You can grab the tool with homebrew, although this is not officially supported by AWS.
```bash
brew update && brew install awscli
```



# AWS Setup

### Setup the IAM user

```bash
create_user.sh
``` 


# Create your first Cluster


## Prepare local environment
We're ready to start creating our first cluster! Let's first set up a few environment variables to make this process easier.

```bash
export NAME=myfirstcluster.example.com
export KOPS_STATE_STORE=s3://prefix-example-com-state-store
```



### Create cluster configuration

We will need to note which availability zones are available to us. In this example we will be deploying our cluster to the us-east-1 region.

```bash 
aws ec2 describe-availability-zones --region us-east-1
```

Below is a create cluster command. We'll use the most basic example possible, with more verbose examples in high availability. The below command will generate a cluster configuration, but not start building it. Make sure that you have generated SSH key pair before creating the cluster.

```bash
kops create cluster \
    --zones us-east-1a \
    ${NAME}
```

All instances created by kops will be built within ASG (Auto Scaling Groups), which means each instance will be automatically monitored and rebuilt by AWS if it suffers any failure.


### Customize Cluster Configuration

Now we have a cluster configuration, we can look at every aspect that defines our cluster by editing the description.

```bash
kops edit cluster ${NAME}
```

This opens your editor (as defined by $EDITOR) and allows you to edit the configuration. The configuration is loaded from the S3 bucket we created earlier, and automatically updated when we save and exit the editor.

We'll leave everything set to the defaults for now, but the rest of the kops documentation covers additional settings and configuration you can enable.

### Build the Cluster

Now we take the final step of actually building the cluster. This'll take a while. Once it finishes you'll have to wait longer while the booted instances finish downloading Kubernetes components and reach a "ready" state.

```bash
kops update cluster ${NAME} --yes
```
