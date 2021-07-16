FROM nginx:stable
COPY --chown=nginx:root build/web /usr/share/nginx/html/
