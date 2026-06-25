## Splitit Service

### Sections :
* [Project Goal](#project-goal-)
* [Tech Stacks](#tech-stacks-%EF%B8%8F)
* [Schema Diagram](#schema-diagram-)
* [How to run](#how-to-run-)
* [Accomplishments](#accomplishments)
* [Routes](#routes)

### Project Goal:

This is the API service layer for Splitit, which is an expense sharing application is where you can add your expenses and split it among different people. The app keeps balances between people as in who owes how much to whom.

### Tech Stack:

* This project is made with Django framework, with the standard architecture of urls, views and model, i.e. clients -> urls -> views -> models.

* Postgres is used as the database seeing to the use case which preferably requires a relational DB (due to transactional nature of the application) and also looking at the fact that Django has a great support for relational databases, postgres is a good option as it can very well scale

### Schema Diagram

For this application the schema diagram is a very core element as designing the schema perfectly here will save a lot of query cost.

![splitit-schema](./images/splitit_schema_dia.png)

### How to run (locally)

Requirements: Docker Desktop running.

* Clone the repository.

* From the project root, build and start everything:

```bash
docker compose up --build
```

This starts Postgres, waits for it to be healthy, automatically runs migrations
and `collectstatic`, then serves the app with Gunicorn.

* The API is now available at `http://localhost:8000`. A few things to try:

```bash
# Sign up a user
curl -X POST http://localhost:8000/api/sign-up/ \
  -H "Content-Type: application/json" \
  -d '{"first_name":"Abhi","email":"abhi@test.com","password":"Secret123!"}'

# Get a JWT access token
curl -X POST http://localhost:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username":"abhi@test.com","password":"Secret123!"}'

# Call an authenticated endpoint
curl -X POST http://localhost:8000/api/create-group/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <access-token>" \
  -d '{"name":"Trip","description":"Goa"}'
```

* To stop: `docker compose down` (add `-v` to also delete the database volume).

### Deploying publicly

The app is configured entirely through environment variables, so the same Docker
image runs anywhere:

| Variable        | Purpose                                              |
| --------------- | ---------------------------------------------------- |
| `SECRET_KEY`    | Django secret key (set a strong random value)        |
| `DEBUG`         | `False` in production (default)                      |
| `ALLOWED_HOSTS` | Comma-separated hostnames, e.g. `.onrender.com`      |
| `DATABASE_URL`  | Postgres connection string (e.g. `postgres://...`)   |
| `PORT`          | Port to bind (most hosts inject this automatically)  |

**Render (easiest, includes free Postgres):**

1. Push this repo to GitHub.
2. Go to the [Render dashboard](https://dashboard.render.com) → **New → Blueprint**
   and select the repo. Render reads `render.yaml`, provisions a Postgres database
   and the web service, and wires up `DATABASE_URL` / `SECRET_KEY` for you.
3. After the build finishes you get a public URL like
   `https://splitit-api.onrender.com`.

The same image also deploys cleanly on **Railway** or **Fly.io** — just provide a
Postgres `DATABASE_URL` and set `ALLOWED_HOSTS` to your public hostname.

### Accomplishments ✔️:
- Database models for storing user information, their bills, transactions and groups.
- APIs for
    * register a new user
    * authenticate a user based on username and password
    * create a group
    * add a user to a group (only for group creator)
    * remove member from a group (only for group creator)
    * add a bill to the group along with details of how to split and among whom to split the bill
    * list owe amount per user in total
    * list owe amount per user in a group
    * settle balance with another user in a group
    * Edit a bill and all its details
- Option to simplify owe amount in a group between members. For example there are 3 members in a group; A, B and C. If A owes B 100, B owes C 100 and C owes A 100. Then in total no one should owe anything to anyone. (simplifying in the same group
- Automatically settle all the balances in every group between two users if their overall owe amount is zero.
- Project Dockerization

### Routes

A postman collection of all the routes have been made, one may explore it from here :-

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/de285401f4f0243e3ee8)
