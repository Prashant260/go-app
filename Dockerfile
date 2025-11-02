# ---------- Build Stage ----------
FROM golang:1.23 AS builder

WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the binary
RUN go build -o main .

# ---------- Final Stage ----------
FROM gcr.io/distroless/base-debian12

WORKDIR /app

# Copy binary and static files from builder
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

# Run the Go binary directly
CMD ["./main"]







