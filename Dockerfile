# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.14.2
#Copy ci-dashboard-dist
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html
#Copy default nginx configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:latest as build

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Install all the dependencies
RUN npm ci

# Generate the build of the application
RUN npm run build && rm -rf node_modules


# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:1.14.2

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/local/app/dist/igera-web-ng /usr/share/nginx/html

# The following run statement is required to run nginx in Openshift and was borrowed from this article:
# https://torstenwalter.de/openshift/nginx/2017/08/04/nginx-on-openshift.html
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx /usr/share/nginx/html && \
    chgrp -R root /var/cache/nginx

RUN echo "nginx -g 'daemon off;'" > run.sh

EXPOSE 80

ENTRYPOINT ["sh", "run.sh"]

