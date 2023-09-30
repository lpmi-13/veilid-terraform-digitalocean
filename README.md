# Veilid Terraform

Running veilid nodes is super cool, and I wanted an easy way to do it across multiple regions in Digital Ocean, so depending on your appetite, you can spawn a bunch of these all over the place if you want.

## Running the command

1. grab an access token at https://cloud.digitalocean.com/account/api/tokens, and then set it in your shell via

```
export DIGITALOCEAN_ACCESS_TOKEN=TOKEN_VALUE_HERE
```

2. Add your public SSH key to the cloud-init script, in `setup-veilid.yaml` inside the ` ssh_authorized_keys:` block

3. Decide which region(s) you want to run a veilid node in, and uncomment the relevant line(s) in the `locals.regions` block in `main.tf`

4. then you can run the terraform command and get a/some shiny new node(s)!

```
terraform init && terraform apply
```

> NOTE: the public IP address(es) will be an output from the action, though since the cloud init script takes a bit of time to run, if you SSH in immediately, you might not have access to the `veilid-cli` command for a few minutes.
