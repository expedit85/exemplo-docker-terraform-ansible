FROM mariadb:10.1.21
# FROM mysql:8.0.15

# Defaults for database name, user, passwords.
# Podem ser sobrescritas no docker-stack.yml
ENV MYSQL_ROOT_PASSWORD  123456
ENV MYSQL_DATABASE       notes
ENV MYSQL_USER           notes-api
ENV MYSQL_PASSWORD       notes-api

COPY database_schema.sql /docker-entrypoint-initdb.d

# RUN ls -lh /var/lib/mysql && find /var/lib/mysql
