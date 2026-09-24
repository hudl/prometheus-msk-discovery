FROM golang:1.23-alpine AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src
RUN apk --no-cache add git
COPY main.go go.mod go.sum ./
RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} go build -o /bin/prometheus-msk-discovery .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /bin/prometheus-msk-discovery /bin/
ENTRYPOINT ["prometheus-msk-discovery"]
