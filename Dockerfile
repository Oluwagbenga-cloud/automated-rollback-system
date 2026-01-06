FROM golang:1.22-alpine AS builder

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o server ./app

FROM alpine:3.21 AS final

COPY --from=builder /build/server /app/server
EXPOSE 8080

CMD ["/app/server"]