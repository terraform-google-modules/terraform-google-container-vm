# Upgrading to v2.0

The v2.0 release of *container-vm* is a backwards incompatible release.

As part of PR [#57](https://github.com/terraform-google-modules/terraform-google-container-vm/pull/57) the dependency on Ruby was removed and introduced the following backwards incompatible changes.

## Migration Instructions

### Container Spec Booleans

If your container definition contained any string quoted bools (eg `"false"`) they need to be converted to terraform `0.12` bools.

For example in previous `examples` - `volumeMounts` had a `readOnly` string value of `"false"`.

```hcl
volumeMounts = [
  {
    mountPath = "/cache"
    name      = "tempfs-0"
    readOnly  = "false"
  },
```

They need to be converted to bools without quotes `false`

```hcl
volumeMounts = [
  {
    mountPath = "/cache"
    name      = "tempfs-0"
    readOnly  = false
  },
```

Without this change the container declaration will be invalid and the COS image will fail to startup the container when your instance boots.

### Yaml Metadata Changes

After upgrading you may notice that a `terraform plan|apply` will show that the metadata `gce-container-declaration` value has changed

```diff
 ~ metadata  = {
    ~ "gce-container-declaration" = <<~EOT
        - ---
        - spec:
        -   containers:
        -   - env:
        -     - name: TEST_VAR
        -       value: Hello World!
        -     image: gcr.io/google-samples/hello-app:1.0
        -     volumeMounts:
        -     - mountPath: "/cache"
        -       name: tempfs-0
        -       readOnly: false
        -   restartPolicy: Always
        -   volumes:
        -   - emptyDir:
        -       medium: Memory
        -     name: tempfs-0
        + "spec":
        +   "containers":
        +   - "env":
        +     - "name": "TEST_VAR"
        +       "value": "Hello World!"
        +     "image": "gcr.io/google-samples/hello-app:1.0"
        +     "volumeMounts":
        +     - "mountPath": "/cache"
        +       "name": "tempfs-0"
        +       "readOnly": false
        +   "restartPolicy": "Always"
        +   "volumes":
        +   - "emptyDir":
        +       "medium": "Memory"
        +     "name": "tempfs-0"
      EOT
  }

```

This is due to the fact that the terraform function [`yamlencode`](https://www.terraform.io/docs/configuration/functions/yamlencode.html) quotes all string values, including keys.

The resulting yaml is valid and functionally the same as the previous format. However, terraform will see it as a change and request the instance be `updated in-place`.

This can be applied without requiring a restart as GCP can update metadata in place and the COS image won't read the new container declaration until a subsequent restart [docs](https://cloud.google.com/compute/docs/containers/deploying-containers#updating_a_container_on_a_vm_instance).
