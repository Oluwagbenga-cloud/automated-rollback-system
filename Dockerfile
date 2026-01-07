#-------- build stage --------
FROM golang:1.25-alpine AS builder

WORKDIR /app

# RUN apk add --no-cache ca-certificates
RUN apk add --no-cache ca-certificates

COPY go.mod go.sum ./
RUN go mod download

COPY . . 

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

#-------- runtime stage --------
# FROM alpine:3.20 AS final
# I chose distroless for a smaller image size and improved security.
FROM gcr.io/distroless/static-debian12

WORKDIR /app

# RUN apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*

# RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/server .

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# USER appuser
USER nonroot:nonroot

EXPOSE 8080

#HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD wget --spider -q http://localhost:8080/health || exit 1

HEALTHCHECK --interval=30s --timeout=3s CMD ["server", "--healthcheck"]
CMD ["./server"]