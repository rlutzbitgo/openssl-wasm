# openssl-wasm
Cross compile openssl to wasm

Run build.sh

test with
```
 wasmer run openssl-3.1.0/apps/openssl.wasm -- prime -bits 1536 -generate -safe
```

We can utilize this in both the SDK and the UI

SDK tutorial: https://docs.wasmer.io/integrations/js/wasi/server/examples/hello-world

UI tutorial: https://docs.wasmer.io/integrations/js/wasi/browser/examples/hello-world
