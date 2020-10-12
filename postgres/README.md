# Docker Scripts - Postgre
Those scripts allow you to create many databases on the same postgres instance and restore dumps on them

## Installation
You have to mount `docker-scripts/postgres/initdb.d` to `docker-entrypoint-initdb.d` into your postgres image.

**Required environment variables are:**

| Environment variable | Description |
|---|---|
| POSTGRES_USER | Your postgres user, when creating the databases the script set your POSTGRES_USER as OWNER |
| SCRIPTS_POSTGRES_DATABASES | A coma separated list of your databases names |

Here's a `docker-compose.yml` example:

```yaml
version: '2'
service:
  postgres:
    image: postgres:11.2-alpine
    ports:
      - 5432:5432
    volumes:
    - "./docker-scripts/postgres/initdb.d:/docker-entrypoint-initdb.d"
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      SCRIPTS_POSTGRES_DATABASES: "mydb,test_mydb"
```

To restore dump to any of your databases just put your dump file into `postgres/dumps`.
The filename must be exactly the same as your database and suffixed by `.dump`.

Following the `docker-compose.yml` example, to restore `mydb` simply put your dump file to `postgres/dumps/mydb.dump` 

**Warning:** The PG restore script overwrite ACL / OWNER instructions and clean any existing object before recreating them.