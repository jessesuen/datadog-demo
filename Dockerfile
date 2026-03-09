FROM golang:1.26.0 AS build

WORKDIR /go/src/app
RUN go install github.com/DataDog/orchestrion@v1.8.0
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN make

FROM scratch
COPY *.html ./
COPY *.png ./
COPY *.js ./
COPY *.ico ./
COPY *.css ./
COPY --from=build /go/src/app/datadog-demo /datadog-demo

ARG COLOR
ENV COLOR=${COLOR}
ARG ERROR_RATE
ENV ERROR_RATE=${ERROR_RATE}
ARG LATENCY
ENV LATENCY=${LATENCY}

ENTRYPOINT [ "/datadog-demo" ]
