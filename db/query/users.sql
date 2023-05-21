-- name: CreateUser :one
INSERT INTO users (
    email,
    phone,
    full_name,
    hashed_password
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: GetUserByPhone :one
SELECT *
FROM users
WHERE phone = $1
LIMIT 1;

-- name: ListUser :many
SELECT * FROM users
ORDER BY created_at DESC
LIMIT $1
OFFSET $2;

-- name: UpdateUser :one
UPDATE users 
SET 
    email = COALESCE(sqlc.narg(email), email),
    phone = COALESCE(sqlc.narg(phone), phone),
    avatar = COALESCE(sqlc.narg(avatar), avatar),
    full_name = COALESCE(sqlc.narg(full_name), full_name),
    user_role = COALESCE(sqlc.narg(user_role), user_role)
WHERE id = sqlc.arg(id)
RETURNING *;