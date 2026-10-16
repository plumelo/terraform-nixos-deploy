# sops-deploy

Deploys sops-encrypted secrets to remote hosts over SSH.

## Example Usage

```hcl
module "sops" {
  source   = "plumelo/deploy/nixos//modules/sops-deploy"
  version  = "1.0.1"
  host     = "192.168.1.100"
  user     = "root"
  path     = "${path.module}/secrets.yaml"
  key      = "[\"age\"][\"key\"]"
  dest     = "/var/lib/sops-nix/key.txt"
  triggers = [var.some_trigger]
}
```

## Outputs

- `id` — Resource ID for use as trigger in dependent resources

## Behavior

The file's `sha256` is part of the replacement triggers: any content change re-extracts
and re-deploys the key. The re-extraction also MAC-verifies the file, so a hand-edited
(corrupted) sops file fails the apply instead of deploying silently.

## Known Issues

This module writes temporary files to `path.module` during apply. Do not re-run
`terraform init` between `terraform apply` and `terraform destroy`, as `init`
will wipe the module directory and break the cleanup. This will be addressed in
a future version.