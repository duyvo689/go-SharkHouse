// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.18.0
// source: users.sql

package db

import (
	"context"
	"database/sql"
)

const createUser = `-- name: CreateUser :one
INSERT INTO users (
    email,
    phone,
    avatar,
    full_name,
    hashed_password,
    user_role
) VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING id, full_name, avatar, email, phone, hashed_password, user_role, password_changed_at, created_at
`

type CreateUserParams struct {
	Email          string         `json:"email"`
	Phone          string         `json:"phone"`
	Avatar         sql.NullString `json:"avatar"`
	FullName       string         `json:"full_name"`
	HashedPassword string         `json:"hashed_password"`
	UserRole       string         `json:"user_role"`
}

func (q *Queries) CreateUser(ctx context.Context, arg CreateUserParams) (User, error) {
	row := q.db.QueryRowContext(ctx, createUser,
		arg.Email,
		arg.Phone,
		arg.Avatar,
		arg.FullName,
		arg.HashedPassword,
		arg.UserRole,
	)
	var i User
	err := row.Scan(
		&i.ID,
		&i.FullName,
		&i.Avatar,
		&i.Email,
		&i.Phone,
		&i.HashedPassword,
		&i.UserRole,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}

const getUser = `-- name: GetUser :one
SELECT id, full_name, avatar, email, phone, hashed_password, user_role, password_changed_at, created_at FROM users
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetUser(ctx context.Context, id int64) (User, error) {
	row := q.db.QueryRowContext(ctx, getUser, id)
	var i User
	err := row.Scan(
		&i.ID,
		&i.FullName,
		&i.Avatar,
		&i.Email,
		&i.Phone,
		&i.HashedPassword,
		&i.UserRole,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}

const listUser = `-- name: ListUser :many
SELECT id, full_name, avatar, email, phone, hashed_password, user_role, password_changed_at, created_at FROM users
ORDER BY created_at DESC
LIMIT $1
OFFSET $2
`

type ListUserParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) ListUser(ctx context.Context, arg ListUserParams) ([]User, error) {
	rows, err := q.db.QueryContext(ctx, listUser, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []User{}
	for rows.Next() {
		var i User
		if err := rows.Scan(
			&i.ID,
			&i.FullName,
			&i.Avatar,
			&i.Email,
			&i.Phone,
			&i.HashedPassword,
			&i.UserRole,
			&i.PasswordChangedAt,
			&i.CreatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const updateUser = `-- name: UpdateUser :one
UPDATE users 
SET 
    email = COALESCE($1, email),
    phone = COALESCE($2, phone),
    avatar = COALESCE($3, avatar),
    full_name = COALESCE($4, full_name),
    user_role = COALESCE($5, user_role)
WHERE id = $6
RETURNING id, full_name, avatar, email, phone, hashed_password, user_role, password_changed_at, created_at
`

type UpdateUserParams struct {
	Email    sql.NullString `json:"email"`
	Phone    sql.NullString `json:"phone"`
	Avatar   sql.NullString `json:"avatar"`
	FullName sql.NullString `json:"full_name"`
	UserRole sql.NullString `json:"user_role"`
	ID       int64          `json:"id"`
}

func (q *Queries) UpdateUser(ctx context.Context, arg UpdateUserParams) (User, error) {
	row := q.db.QueryRowContext(ctx, updateUser,
		arg.Email,
		arg.Phone,
		arg.Avatar,
		arg.FullName,
		arg.UserRole,
		arg.ID,
	)
	var i User
	err := row.Scan(
		&i.ID,
		&i.FullName,
		&i.Avatar,
		&i.Email,
		&i.Phone,
		&i.HashedPassword,
		&i.UserRole,
		&i.PasswordChangedAt,
		&i.CreatedAt,
	)
	return i, err
}
