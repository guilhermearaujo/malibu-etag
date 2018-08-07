# Malibu ETag bug

Malibu is configured, by default, to save ETAGs for GET requests. Calling `Malibu.clearStorages()`
should clear the tags and the response bodies of all cached requests:

```swift
public func clearStorages() {
  EtagStorage().clear()
  RequestStorage.clearAll()
}
```

Apparently, this is not happening, and new requests are still being requested **with** the ETag in
the header `If-None-Match`.

The iOS project in this repo is configured to call `Malibu.clearStorages()` at two points:
* Everytime the app is opened (`application(:didFinishLaunchingWithOptions)`)
* Before making each request

There is also a Rails API configured with a single endpoint that returns the static body:
```
GET /endpoint
```
```json
{
    "key1": "val1",
    "key2": "val2",
    "key3": "val3",
    "key4": "val4",
    "key5": "val5"
}
```

and the header `ETag: W/"4c5b6aab3c9443a5428f41eef261730b"` (hash may vary).

When the app sends a request for the very first time, it doesn't have any cached ETag, so the header
will be empty. All the following requests will have the header `If-None-Match` populated with the
ETag key provided by the server.

The only way to make the app send another request without the header is by uninstalling and
reinstalling it.

## Setup

**iOS**

Run `pod install` to install iOS dependencies. Build project and run on Simulator.

**API**

```bash
cd api
bundle install
rails s
# Server will start listening on 127.0.0.1:3000
```

# Verifying the bug
The first time you open the app and hit the "Send Request" button, read the API log. It should
output:

```
Started GET "/endpoint" for 127.0.0.1 at 2018-08-07 15:05:38 -0300
Processing by ApplicationController#endpoint as JSON

ETAG: NONE

Completed 200 OK in 0ms (Views: 0.3ms)
```

Hit "Send Request" over and over again, it will always output:
```
Started GET "/endpoint" for 127.0.0.1 at 2018-08-07 15:06:09 -0300
Processing by ApplicationController#endpoint as JSON

ETAG: W/"4c5b6aab3c9443a5428f41eef261730b"

Completed 200 OK in 0ms (Views: 0.2ms)
```

Note that the app is trying to clear the ETAG and storage cache before every request.