# with-kpt

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] with-kpt`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree with-kpt`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init with-kpt
kpt live apply with-kpt --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
