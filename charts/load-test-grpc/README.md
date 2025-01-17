# Load test, benchmark, and validate gRPC

> This experiment generates requests for gRPC services, collects Iter8's built-in latency and error-related metrics, and validates service level objectives (SLOs).

***

**Use-cases:** 

- Load test
- Benchmark
- Validate service level objectives (SLOs)
- Safe rollout
- Continuous delivery (CD)

If the gRPC service satisfies SLOs, it may be safely rolled out, for example, from a test environment to production.  

***

## Basic example
Benchmark a [unary gRPC](https://grpc.io/docs/what-is-grpc/core-concepts/#unary-rpc) service by specifying its `host`, its fully-qualified method name (`call`), and the URL of Protocol Buffer file (`protoURL`) defining the service.

```shell
iter8 launch -c load-test-grpc \
          --set host="127.0.0.1:50051" \
          --set call="helloworld.Greeter.SayHello" \
          --set protoURL="https://raw.githubusercontent.com/grpc/grpc-go/master/examples/helloworld/helloworld/helloworld.proto"
```

***

## Metrics and SLOs
The following metrics are collected by default by this experiment:

- `grpc/request-count`: total number of requests sent
- `grpc/error-count`: number of error responses
- `grpc/error-rate`: fraction of error responses

In addition to default metrics mentioned above, the following latency metrics are also supported. Latency metrics have `msec` units.

- `grpc/latency/mean`: Mean latency
- `grpc/latency/stddev`: Standard deviation of latency
- `grpc/latency/min`: Min latency
- `grpc/latency/max`: Max latency
- `grpc/latency/pX`: X-th percentile latency, for any X in the range 0.0 to 100.0

Any metrics that are specified as part of SLOs are also collected. 

***

```shell
--set SLOs.grpc/error-rate=0 \
--set SLOs.grpc/latency/mean=50 \
--set SLOs.grpc/latency/p90=100 \
--set SLOs.grpc/latency/p'97\.5'=200
```

In the above setting, the following SLOs will be validated.

- error rate is 0
- mean latency is under 50 msec
- 90th percentile latency is under 100 msec
- 97.5th percentile latency is under 200 msec

***

## Load profile
Control the characteristics of the generated load generated by setting the number of requests (`total`), the number of requests per second (`rps`), number of connections to use (`connections`), and the number of concurrent request workers to use which will be distributed across the connections (`concurrency`).

```shell
--set total=500 \
--set rps=25 \
--set concurrency=50 \
--set connections=10
```

Refer to the `values.yaml` file which documents additional parameters related to the load profile such as `duration`, `maxDuration`, `connectTimeout`, and `keepalive`.

***

## Call data
gRPC calls may include data serialized as [Protocol Buffer messages](https://grpc.io/docs/what-is-grpc/introduction/#working-with-protocol-buffers).

### Data
Specify call data as values.
```shell
--set data.name="frodo"
```

Call data may be nested.

```shell
--set data.name="frodo" \
--set data.realm.planet="earth" \
--set data.realm.location="middle" 
```

### Data file
Use JSON data from a local file.

```shell
--set dataFile="/the/path/to/data.json" # "./data.json" also works
```

### Data URL
Supply a URL that hosts JSON data. Iter8 will download the data from this URL and use it in the requests.
```shell
--set dataURL="https://location.of/data.json"
```

### Binary data file
Use binary data from a local file serialized as a single binary message or multiple count-prefixed messages.

```shell
--set binaryDataFile="/the/path/to/data.bin" # "./data.bin" also works
```

### Binary data URL
Supply a URL that hosts binary data serialized as a single binary message or multiple count-prefixed messages. Iter8 will download the data from this URL and use it in the requests.

```shell
--set binaryDataURL="https://location.of/data.bin"
```

### Streaming

For client streaming or bi-directional calls, this experiment accepts an array of messages, each element representing a single message within the stream call.

```shell
--set data[0].name="Joe" \
--set data[1].name="Kate" \
--set data[2].name="Sara"
```
    
If a single object is given for data then it is automatically converted to an array with single element. In case of client streaming, this experiment sends all the data in the input array, and then closes and receives.

***

## Call metadata
gRPC calls may include [metadata](https://grpc.io/docs/what-is-grpc/core-concepts/#metadata) which is information about a particular call.

### Metadata
Supply metadata as values.
```shell
--set metadata.darth="vader" \
--set metadata.lord="sauron" \
--set metadata.volde="mort"
```

### Metadata file
Use JSON metadata from a local file.

```shell
--set metadataFile="/the/path/to/metadata.json" # "./metadata.json" also works
```

### Metadata URL
Supply a URL that hosts JSON metadata. Iter8 will download the metadata from this URL and use it in the requests.

```shell
--set metadataURL="https://location.of/metadata.json"
```

***

## Proto and reflection

The gRPC server method signatures and message formats are defined in a `.proto` source file, which may also be compiled to a `.protoset` file.

### Proto file
Use a local `.proto` source file.

```shell
--set protoURL="/path/to/helloworld.proto" # "./helloworld.proto" also works
```

### Proto URL
Use a URL that hosts a `.proto` source file. Iter8 will download the Protocol Buffer file and use it in the experiment.

```shell
--set protoURL="https://raw.githubusercontent.com/grpc/grpc-go/master/examples/helloworld/helloworld/helloworld.proto"
```

### Protoset file
Supply the name of a `.protoset` file that is compiled from `.proto` source files.

```shell
--set protoset="./myservice.protoset"
```

### Protoset URL
Supply a URL that hosts a `.protoset` file.

```shell
--set protosetURL="https://raw.githubusercontent.com/grpc/grpc-go/master/examples/helloworld/helloworld/helloworld.protoset"
```

### Reflection
In the absence of `.proto` and `.protoset` information, the experiment will attempt to use [server reflection](https://github.com/grpc/grpc/blob/master/doc/server-reflection.md). You can supply reflect metadata.

```shell
--set reflectMetadata.clientId="5hL64dd0" \
--set reflectMetadata.clientMood="delightful"
```

***

## Streaming gRPC

Refer to the `values.yaml` file which documents additional parameters related to streaming gRPC such as `streamInterval`, `streamCallDuration`, and `streamCallCount`.