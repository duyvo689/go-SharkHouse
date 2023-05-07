-- name: CreateUser :one
INSERT INTO users (
    email,
    phone,
    avatar,
    full_name,
    hashed_password
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: UpdateUser :one
UPDATE users 
SET 
    email = $2,
    phone = $3,
    avatar = $4,
    full_name = $5,
    user_role = $6
WHERE id = $1
RETURNING *;