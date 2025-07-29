# DEDSEC AI - Neural Network Infiltration System
# Docker Container Configuration

FROM node:20-alpine AS base

# Install dependencies for better compatibility
RUN apk add --no-cache libc6-compat bash curl

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Development stage
FROM base AS dev
RUN npm ci
COPY . .
EXPOSE 7443
ENV PORT=7443
ENV NODE_ENV=development
CMD ["npm", "run", "dev"]

# Build stage
FROM base AS builder
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine AS production

# Install bash for our scripts
RUN apk add --no-cache bash curl

# Create app user for security
RUN addgroup -g 1001 -S dedsec && \
    adduser -S redactme -u 1001 -G dedsec

WORKDIR /app

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy built application
COPY --from=builder --chown=redactme:dedsec /app/.next ./.next
COPY --from=builder --chown=redactme:dedsec /app/public ./public
COPY --from=builder --chown=redactme:dedsec /app/app ./app
COPY --from=builder --chown=redactme:dedsec /app/next.config.ts ./
COPY --from=builder --chown=redactme:dedsec /app/postcss.config.mjs ./
COPY --from=builder --chown=redactme:dedsec /app/tsconfig.json ./

# Create startup script with Dedsec branding
COPY docker-start.sh /app/docker-start.sh

RUN chmod +x /app/docker-start.sh && chown redactme:dedsec /app/docker-start.sh

# Switch to non-root user
USER redactme

# Expose port
EXPOSE 7443

# Set environment variables
ENV NODE_ENV=production
ENV PORT=7443
ENV HOSTNAME=0.0.0.0

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:7443 || exit 1

# Start the application
CMD ["/app/docker-start.sh"] 