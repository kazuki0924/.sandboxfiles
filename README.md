- figure out azure credential issue with dynamic inventory azure_rm plugin

```
# required to install the following to work on linux, but doesn't work on macOS
# pip3 install azure-cli --user

plugin: azure_rm
include_vm_resource_groups:
  - sandbox-rg
auth_source: auto
plain_host_names: yes
conditional_groups:
  sandbox: "'sandbox' in tags.project"
```

# use portainer and port forward from azure vm without vs code

# otherwise use caddy
