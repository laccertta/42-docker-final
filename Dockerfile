FROM golang:1.22-alpine AS builder
RUN apk add --no-cache gcc musl-dev git
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o app

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/app .
COPY --from=builder /app/*.db .
EXPOSE 8080
CMD ["./app"]
