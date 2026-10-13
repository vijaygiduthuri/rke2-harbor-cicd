# Small, production-ready web server
FROM nginx:alpine

# Values injected by the CI pipeline
ARG COMMIT_SHA=local-build
ARG BUILD_TIME=unknown

# Copy our page into nginx's web root
COPY index.html /usr/share/nginx/html/index.html

# Stamp the build metadata into the page so you can see
# exactly which commit is running
RUN sed -i "s|__COMMIT_SHA__|${COMMIT_SHA}|g" /usr/share/nginx/html/index.html && \
    sed -i "s|__BUILD_TIME__|${BUILD_TIME}|g" /usr/share/nginx/html/index.html

# Document the port nginx listens on
EXPOSE 80

# Basic health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1
