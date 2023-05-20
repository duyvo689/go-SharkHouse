package api

import (
	"database/sql"
	"net/http"

	db "github.com/duyvo689/sharkhome/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/lib/pq"
)

type createUserRequest struct {
	Email          string         `json:"email" binding:"required,email"`
	Phone          string         `json:"phone" binding:"required,len=10,startswith=0"`
	Avatar         sql.NullString `json:"avatar" binding:"url,startswith=http"`
	FullName       string         `json:"full_name" binding:"required"`
	HashedPassword string         `json:"hashed_password" binding:"required"`
	UserRole       string         `json:"user_role" binding:"oneof: user admin"`
}

func (server *Server) createUser(ctx *gin.Context) {

	var req createUserRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	if req.UserRole == "" {
		req.UserRole = "user"
	}
	arg := db.CreateUserParams{
		Email:          req.Email,
		Phone:          req.Phone,
		Avatar:         req.Avatar,
		FullName:       req.FullName,
		HashedPassword: req.HashedPassword,
		UserRole:       req.UserRole,
	}
	account, err := server.store.CreateUser(ctx, arg)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			switch pqErr.Code.Name() {
			case "foreign_key_violation", "unique_violation":
				ctx.JSON(http.StatusForbidden, errorResponse(err))
				return
			}
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, account)
}

type getUserRequest struct {
	ID int64 `uri:"id" binding:"required,min=1"`
}

func (server *Server) getUser(ctx *gin.Context) {

	var req getUserRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	user, err := server.store.GetUser(ctx, req.ID)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, user)
}

type updateUserRequest struct {
	ID       int64          `json:"id" binding:"required,min=1"`
	Email    sql.NullString `json:"email"`
	Phone    sql.NullString `json:"phone"`
	Avatar   sql.NullString `json:"avatar"`
	FullName sql.NullString `json:"full_name"`
	UserRole sql.NullString `json:"user_role"`
}

func (server *Server) updateUser(ctx *gin.Context) {

	var req updateUserRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := db.UpdateUserParams{
		ID:       req.ID,
		Email:    req.Email,
		Phone:    req.Phone,
		Avatar:   req.Avatar,
		UserRole: req.UserRole,
		FullName: req.FullName,
	}

	user, err := server.store.UpdateUser(ctx, arg)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, user)
}

type listUserRequest struct {
	PageID   int32 `from:"page_id" binding:"required,min=1"`
	PageSize int32 `from:"page_size" binding:"required,min=10,max=100"`
}

func (server *Server) listUser(ctx *gin.Context) {
	var req listUserRequest

	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	arg := db.ListUserParams{
		Limit:  req.PageSize,
		Offset: (req.PageID - 1) * req.PageSize,
	}

	users, err := server.store.ListUser(ctx, arg)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, users)
}
